---
title: Google Authorship, Facebook OpenGraph y Twitter Cards
date: 2012-09-20
description: Las etiquetas sociales son un elemento importante la promoción correcta en redes sociales y buscadores, esto para posicionar la página web o blog de manera correcta. ¿Cuáles son y cómo se usan estas etiquetas?
---

Una de las técnicas sociales que debes desarrollar en tu sitio son las meta etiquetas, las cuales indican qué información vas a pasar a una aplicación en linea para ser mostrada en los campos disponibles en esta misma. Estas aplicaciones que mantienen una importancia relativa actualmente son:

- **Google Authorship:** Muestra el nombre del autor en los resultados de Google enlazado a Google+.
- **Facebook Open Graph:** Muestra información, ya sea el título, descripción, thumbnail, o bien, el reproductor de video o video que estás mostrando en tu sitio.
- **Twitter Cards:** Muestra información, ya sea texto, imágenes y video, en la versión extendida de un tuit, es decir, al hacer clic a este.

![Muestra de etiquetas sociales](/assets/images/posts/social.png)

Para agregar estas etiquetas a nuestro sitio web deberemos ser capaces de modificar y agregar etiquetas a nuestro `<head></head>`, si tienes un theme que llama al `header.php`, o un layout donde se hagan parciales, deberás agregarlo para que surta efecto en todas.

Dependiendo de como adminstres tu sitio, ya sea con PHP o con RoR, las etiquetas deberán cambiar dependiendo de cada vista; esto para asegurar una buena práctica SEO.

## Google Authorship

Para mostrar y linkear tu perfil de Google+ directamente a los resultados de Google cuando aparezca en un resultado tu blog o página web, deberás hacer lo siguiente.

### Opción uno

Con esta opción se es capáz de agregar la autoría a los resultados de manera automática, pero necesitarás tener un correo electrónico con el mismo dominio de tu página o blog; si no lo tienes, revisa el paso número dos.

Primero que nada, comprueba tu correo electrónico coincida con tu dominio.

En cada página, deberá existir una firma de autor que te identifique, es decir, un campo que diga por ejemplo: "De Alejandro AR" o "Autor: Alejandro AR".

Deberás de ingresar a [este enlance](https://plus.google.com/authorship 'Servicio de autoría en Google'), ingresar y comprobar tu correo electrónico.

Una vez realizado esto, te tocará esperar, si quieres comprobar que Google está haciendo su trabajo, puedes utilizar la [herramienta de pruebas de fragmentos enriquecidos](http://www.google.com/webmasters/tools/richsnippets 'Webmaster Tools - Rich Snippets Testing Tool').

### Opción dos

Esta agrega la autoría de Google de manera manual en conjunto con un enlace a tu perfil. Deberás agregar el siguiente link en alguna parte de tu página web o blog:

```html
<a href="[url_de_perfil]?rel=author">Google</a>
```

Dónde `[url_de_perfil]` debe de ser reemplazado por tu perfil de Google+, para que quede de la siguiente manera.

```html
<a href="https://plus.google.com/101785269533784724692?rel=author">Google</a>
```

Revisa bien tu enlace antes de subirlo a tu servidor, ya que la parte final de tu url deberá ser `?rel=author`, de lo contrario Google no podrá leer ni asociar el enlace.

El siguiente paso es agregar el sitio a tu perfil de Google+ en la parte de tu perfil de [Colaborador en](http://plus.google.com/me/about/edit/co 'Google+ Colaborador en').

Igualmente si quieres comprobar que Google está leyendo el enlace, accede a la [herramienta de pruebas de fragmentos enriquecidos](http://www.google.com/webmasters/tools/richsnippets 'Webmaster Tools - Rich Snippets Testing Tool').

Puedes ver más información consulta este [este enlace](http://support.google.com/webmasters/bin/answer.py?hl=es&answer=1408986 'Información sobre autor incluida en los resultados de búsqueda').

## Facebook OpenGraph

OpenGraph es un protocolo que utiliza Facebook para poder leer información sobre páginas web que son ingresadas a la red social de manera apuntada y controlada. Esta información puede contener desde título, descripción, un thumbnail o bien, un video.

Los protocolos más comunes son los siguientes:

- **og:title:** Asigna el campo de título.
- **og:description:** Asigna el campo de descripción.
- **og:type:** Asigna el tipo de contenido.
- **og:url:** Asigna la URL del sitio.
- **og:image:** Asigna una imagen para el thumbnail.

Estos protocolos deben de ser agregados entre las etiquetas `<head></head>`, con el campo `<meta ... />`. Esto es logrado de la siguiente manera; el siguiente ejemplo es sobre mi artículo anterior [Google Authorship, Facebook OpenGraph y Twitter Cards](http://abarcarodriguez.com/blog/google-authorship-facebook-opengraph-y-twitter-cards 'Google Authorship, Facebook OpenGraph y Twitter Cards'):

```html
<meta
  property="og:title"
  content="Google Authorship, Facebook OpenGraph y Twitter Cards"
/>
<meta property="og:type" content="blog" />
<meta
  property="og:description"
  content="Las etiquetas sociales son un elemento importante la promoción correcta en redes sociales y buscadores, esto para posicionar la página web o blog de manera correcta. ¿Cuáles son y cómo se usan estas etiquetas?"
/>
<meta
  property="og:url"
  content="http://abarcarodriguez.com/blog/google-authorship-facebook-opengraph-y-twitter-cards"
/>
<meta property="og:image" content="http://abarcarodriguez.com/blog/logo2.png" />
```

Para agregar un reproductor de video, deberás agregar la siguiente meta etiqueta:

```html
<meta property="og:video" content="http://ejemplo.com/video.swf" />
```

Para ver más información consulta [este enlace](http://ogp.me/ 'The Open Graph protocol').

## Twitter Cards

Este método no está abierto para todos los sitios web, por lo pronto, deberás solicitar acceso con la [siguiente solicitud](https://dev.twitter.com/form/participate-twitter-cards 'Participate in Twitter Cards'), una vez aceptada, tus meta etiquetas funcionarán desde Twitter.

Los protocolos que utiliza Twitter son los siguientes.

- **twitter:card:** Ya sea con el valor de _summary_, _photo_ o _player_, dependiendo de tu contenido.
- **twitter:url:** La URL del sitio al que apuntará.
- **twitter:title:** El título que aparecerá.
- **twitter:description:** La descripción de tu sitio.
- **twitter:image:** La imagen que se mostrará.
- **twitter:site:** La cuenta de Twitter de tu sitio.
- **twitter:creator:** La cuenta de Twitter del creador del contenido.

Deberás agregar la siguientes meta etiquetas dentro de tu `<head></head>` para que sean leídas por Twitter:

```html
<meta name="twitter:card" value="summary" />
<meta name="twitter:url" value="http://concierti.co" />
<meta name="twitter:title" value="Conciertico" />
<meta
  name="twitter:description"
  value="Todos los conciertos en un mismo lugar."
/>
<meta name="twitter:image" value="http://concierti.co/assets/social.png" />
<meta name="twitter:site" value="@conciertico" />
<meta name="twitter:creator" value="@kinduff" />
```

Una vez agregadas las etiquetas, seremos capaces de ver el contenido en los tuits expandidos. Para ver más información consulta [este enlace](https://dev.twitter.com/docs/cards 'Twitter Cards').
