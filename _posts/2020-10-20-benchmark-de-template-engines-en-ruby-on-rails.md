---
image: https://dimg.kinduff.com/Benchmark de template engines en Ruby on Rails.jpeg
title: Benchmark de template engines en Ruby on Rails
date: 2020-10-20
description: >-
  ¿Qué template engine tiene mejor performance? ¿ERB, HAML o Slim? Te cuento cómo hice benchmark para probar estos tres y qué resultados obtuve.
---

Dicen por ahí, en estos lares programadores de internet, que si tus esfuerzos de optimización se concentran en las vistas, algo estarás haciendo mal.

Personalmente difiero, ya que nunca sabemos qué tamaño tendrá la aplicación, cuánta deuda técnica existe y cuál es la métrica particular que nos está comiendo milisegundos en un proyecto.

En este artículo exploro qué template engine tiene mejor performance, incluyendo ERB, HAML y Slim.

> Puedes ir directamente a los [Resultados del benchmark](#resultados-del-benchmark) en caso de que quieras ir directamente a los resultados.

## ¿A qué le haremos benchmark?

El setup es una aplicación fresca de Rails utilizando ==Ruby 2.7.1p83== con ==Rails 6.0.3.4== generada con el siguiente comando:

```shell
$ rails new app_name
```

Este benchmark está enfocado al tiempo de renderizado de las vistas de los siguientes template engines:

- [ERB - Ruby Templating](https://apidock.com/ruby/ERB)
- [HAML - Beautifully DRY, well-indented, clear markup: templating haiku](https://haml.info)
- [Slim - A lightweight templating engine for Ruby](http://slim-lang.com)

Por lo que utilizarán las siguientes gemas, esto para replicar lo más cercano a un setup común.

```ruby
gem 'slim-rails', '~> 3.2.0'
gem 'haml-rails', '~> 2.0.1'
```

ERB viene por default en Ruby, por lo que no es necesario agregarlo.

Por otro lado, dentro de la aplicación tenemos 3 modelos: usuarios, skills y skills de usuario, que conecta al usuario con varios skills.

![Diagrama de modelos en Rails](/assets/images/posts/benchmark_diagram.png)
_Diagrama de modelos en Rails_

Para rellenar esta data utilicé la gema [`ffaker`](https://github.com/ffaker/ffaker).

```ruby
gem 'ffaker', '~> 2.17.0'
```

Y escribí un archivo de seeds para llenar mi base de datos.

```ruby
require 'ffaker'

skills = []
30.times do
  skills << { name: FFaker::Skill.tech_skill }
end
Skill.create!(skills)

users = []
1000.times do
  users << {
    first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name,
    bio: FFaker::DizzleIpsum.paragraph,
    skill_ids: Skill.order('RANDOM()').limit(5).pluck(:id)
  }
end
User.create!(users)
```

En donde los 1000 usuarios que genero tiene 5 skills random asignados de los 30 existentes.

Después tenemos una ruta para cada engine, así como un layout y un set de vistas, que renderean todos los usuarios y sus skills son 3 parciales de profundidad. Por ejemplo, para ERB:

```erb
<%= render partial: 'shared/erb/user', collection: @users %>

<!-- shared/erb/user -->
<h3><%= user.first_name %> <%= user.last_name %></h3>
<p><%= user.bio %></p>
<h4>Skills</h4>
<ul>
  <%= render partial: 'shared/erb/skill', collection: user.skills %>
</ul>
<hr />

<!-- shared/erb/skill -->
<li><%= skill.name %></li>
```

Limitamos el rendering a 50 elementos desde el controlador para evitar tanto tiempo de render.

```ruby
class PagesController < ApplicationController
  layout :erb, only: :erb
  layout :haml, only: :haml
  layout :slim, only: :slim

  before_action :set_data

  # GET /erb
  def erb; end

  # GET /haml
  def haml; end

  # GET /slim
  def slim; end

  private

  def set_data
    @users = User.includes(:skills).limit(50)
  end
end
```

Dándonos como resultado la siguiente anidación de parciales en cada vista de cada tipo de engine.

![Diagrama de vistas en Rails](/assets/images/posts/benchmark_views.png)
_Diagrama de vistas en Rails_

## ¿Con qué haremos benchmark?

Lo haremos con [ApacheBench](https://httpd.apache.org/docs/2.4/programs/ab.html), o ==ab== para los amigos.

El contexto del benchmark es el siguiente:

- **OS**: Manjaro Linux x86_64
- **Kernel**: 5.8.11-1-MANJARO
- **CPU**: Intel i5-6500 (4) @ 3.600GHz
- **GPU**: Intel HD Graphics 530
- **GPU**: NVIDIA GeForce GTX 1060 6GB
- **RAM**: 5853MiB / 23794MiB

Correremos `ab` en cada una de las rutas que creamos, en un sólo thread, con un máximo de 500 requests.

```shell
$ ab -n 500 -c 1 http://localhost:3000/erb
$ ab -n 500 -c 1 http://localhost:3000/haml
$ ab -n 500 -c 1 http://localhost:3000/slim
```

Pero ojo, estos benchmark estarán evaluando ==el request completo==, no el ==rendereado de vistas== que es lo que nos interesa.

Afortunadamente en Rails podemos suscribirnos a eventos a través de `ActiveSupport::Notification` para obtener la duración de cada uno de los parciales y de las vistas. Esto nos ayudará a tener métricas aún mas realistas que las anteriores.

Agregué un initializer para esto, que simplemente escribirá en un CSV con información relevante. Quizás no sea la manera más óptima de hacerlo, pero en base a las pruebas que hice, la escritura del CSV no afecta en la métrica de renderización.

```ruby
ActiveSupport::Notifications.subscribe /^render_.+.action_view$/ do |event|
  CSV.open('render_data.csv', 'a') do |row|
    view_engine = event.payload[:identifier].split('.').last
    row << [
      view_engine,
      event.payload[:identifier],
      event.time,
      event.end,
      event.duration
    ]
  end
end
```

Esto, combinado con `ab`, nos dará por cada request la siguiente data:

- El tipo de template, en este caso: ERB, HAML, o Slim
- El identificador, que es la vista o parcial que se está rendereando
- El tiempo cuando inició el evento
- El tiempo cuando terminó el evento
- La duración de evento total

Aquí podríamos hacer algo muy chic y graficar automáticamente, pero lo que terminé haciendo fue importar el CSV a un Google Sheets y hacerlo a partir de ahí.

## Resultados del benchmark

La siguiente información fue recabada dado el setup mencionado anteriormente.

El resultado de cada ejecución que se hizo con la herramienta `ab`.

```
Document Path:          /erb
Document Length:        28932 bytes

Concurrency Level:      1
Time taken for tests:   14.898 seconds
Complete requests:      500
Failed requests:        0
Total transferred:      14687000 bytes
HTML transferred:       14466000 bytes
Requests per second:    33.56 [#/sec] (mean)
Time per request:       29.796 [ms] (mean)
Time per request:       29.796 [ms] (mean, across all concurrent requests)
Transfer rate:          962.72 [Kbytes/sec] received
```

```
Document Path:          /haml
Document Length:        28832 bytes

Concurrency Level:      1
Time taken for tests:   15.821 seconds
Complete requests:      500
Failed requests:        0
Total transferred:      14637000 bytes
HTML transferred:       14416000 bytes
Requests per second:    31.60 [#/sec] (mean)
Time per request:       31.642 [ms] (mean)
Time per request:       31.642 [ms] (mean, across all concurrent requests)
Transfer rate:          903.48 [Kbytes/sec] received
```

```
Document Path:          /slim
Document Length:        28180 bytes

Concurrency Level:      1
Time taken for tests:   14.628 seconds
Complete requests:      500
Failed requests:        0
Total transferred:      14311000 bytes
HTML transferred:       14090000 bytes
Requests per second:    34.18 [#/sec] (mean)
Time per request:       29.256 [ms] (mean)
Time per request:       29.256 [ms] (mean, across all concurrent requests)
Transfer rate:          955.40 [Kbytes/sec] received
```

A partir de estos requests, se generó un set de resultados que en total sumaron 78,000 puntos. De estos se condensó el tiempo de render de los parciales y se concentró la data en el punto de render de la vista completa.

| Tipo  | Promedio      | Media         |
|-------|---------------|---------------|
| ERB   | 30.44760273   | 27.824637     |
| HAML  | 32.38679421   | 29.7028665    |
| Slim  | 30.39951217   | 27.8748165    |

Finalmente, la misma información de la tabla anterior pero en un gráfico.

![Gráfico de duración de render promedio y media](/assets/images/posts/benchmark_am.png)

## Conclusiones

Me ha impresionado el performance que tiene Slim. Por mi experiencia sabía que HAML no era tan rápido como ERB, pero no había pensando que hasta el día de hoy, Slim tuviera un performance muy parecido, y hasta a veces superior a mismísimo ERB.

Sin duda hay mucho que explorar aún, pero si tuviera que elegir un template engine para mi próximo proyecto, lo haría con Slim. Además de ser muy natural - o a la CSS, se comporta bastante bien.

Y como pie de nota, este benchmark lo hice a partir de una necesidad de performance que surgió en [Domestika.org](https://domestika.org), el cual por el volumen que tenemos, cada milisegundo es oro.

## Enlaces

Este artículo no me lo saqué del zapato, aquí les dejo un par de enlaces que me ayudaron a encaminar este test. Muchas gracias a sus autores.

- [Rails Template engines performance](https://medium.com/@mario_chavez/rails-template-engines-performance-9ba18446895d), por [@mario_chavez](https://twitter.com/mario_chavez)
- [hamlerbslim](https://github.com/scalp42/hamlerbslim), por [@scalp42](https://github.com/scalp42)
- [Rails 6 reports object allocations while rendering](https://blog.bigbinary.com/2019/07/23/rails-6-reports-object-allocations-made-while-rendering-view-templates.html), por [@vishaltelangre](https://github.com/vishaltelangre)
- [Excalidraw](https://excalidraw.com/) para los diagramas, por [todos su contribuidores](https://github.com/excalidraw/excalidraw/graphs/contributors).

Finalmente, puedes ver el repositorio del proyecto generado para este artículo aquí: [kinduff/rails_template_engine_benchmark](https://github.com/kinduff/rails_template_engine_benchmark).
