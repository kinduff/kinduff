---
image: https://dimg.kinduff.com/Crear imágenes dinámicas con Javascript, Lambda y Netlify.jpeg
title: Crear imágenes dinámicas con Javascript, Lambda y Netlify
date: 2019-05-23
description: Creando y sirviendo imágenes dinámicas en una función de AWS Lambda a través de Netlify.
---

Cuando abrí este blog y comencé a configurar las meta etiquetas para redes sociales, me di cuenta que si quería tener una buena presentación al compartir el post en Facebook, Twitter, Slack, etc, iba a tener que crear una imagen para cada blog post. Y claro, podría usar la experiencia que tengo para editar imágenes pero, ¿por qué mejor no automatizarlo?

Este es el resultado final, una imagen con un título dinámico, un fondo dinámico, una marca de agua, un borde negro y un efecto en blanco y negro.

![](/assets/images/posts/dynamic-image.jpeg)

El fondo es diferente para cada imagen y para cada vez que se hace una solicitud no cacheada, a lo que me refiero es que el fondo de esta imagen viene de una API de Unsplash llamada [Unsplash Source](https://source.unsplash.com/), la cual devuelve una imagen aleatoria, es gratuita y permite acceder a colecciones.

La imagen es servida a través de [Netlify Functions](https://www.netlify.com/docs/functions/), una manera de hacer deploy a funciones de AWS Lambda con un buen par de ventajas, incluyendo la habilidad de hacer deploy de la web, así como sus funciones. Esto es necesario porque este blog fue creado y es servido de modo estático con [GatsbyJS](https://gatsbyjs.org).

Les dejo un playground en Glitch para que puedan editar y jugar con los módulos. El resto del artículo explica cada uno de los pasos para la creación dinámica de la imagen.

<div class="glitch-embed-wrap" style="height: 420px; width: 100%;">
  <iframe
    allow="geolocation; microphone; camera; midi; vr; encrypted-media"
    src="https://glitch.com/embed/#!/embed/social-image?path=server.js&previewSize=0"
    alt="social-image on Glitch"
    style="height: 100%; width: 100%; border: 0;">
  </iframe>
</div>

Puedes visitar el resultado de la imágen dinámica en el siguiente enlance: [Social Image: Hello World!](https://social-image.glitch.me/Hello%20World!.jpeg)

## Dependencias

El `package.json` se ve así, cabe destacar que estoy utilizando la versión `v8.10.0` de NodeJS para asegurar compatibilidad.

```json
{
  "name": "social-image",
  "version": "1.0.0",
  "description": "Creates a dynamic social image for Kinduff's blog posts",
  "main": "social-image.js",
  "scripts": {
    "test": "echo \"What a shame! No test specified\" && exit 1"
  },
  "author": "Alejandro AR <kinduff>",
  "license": "MIT",
  "dependencies": {
    "canvas": "^2.5.0",
    "express": "^4.17.0",
    "pixl-request": "^1.0.25",
    "serverless-http": "^1.10.1"
  }
}
```

Cada una de estas dependencias tiene su función y su razón.

- `canvas`: En Github [Automattic/node-canvas](https://github.com/Automattic/node-canvas/), es una implementación de la API de Canvas usando [Cairo](https://www.cairographics.org/) como back end. Para poder crear y modificar imágenes usando una API parecida a HTML5 Canvas.
- `express`: En Github [expressjs/express](https://github.com/expressjs/express), es un framework web minimalista para NodeJS. Porque me encantan sus middlewares y porque quiero usarlo en el futuro como una aplicación independiente y no sólo una función de AWS Lambda.
- `pixl-request`: En Github [jhuckaby/pixl-request](https://github.com/jhuckaby/pixl-request), es un wrapper de la librería http de NodeJS, funciona para hacer llamadas HTTP de manera sencilla. Me gustó su tamaño y simpleza.
- `serverless-http`: En Github [dougmoscrop/serverless-http](https://github.com/dougmoscrop/serverless-http), permite utilizar frameworks web en modo serverless. Esto lo utilizo para poder usar Express como base y poderlo utilizar también como una función de AWS Lambda.

## Creando la imagen

Separé la creación de la imagen en su totalidad en varios modulos o middlewares de Express. Cada una de las siguientes subsecciones es un módulo.

### Dependencias requeridas

```javascript
const express = require('express')
const canvas = require('canvas')
const createCanvas = canvas.createCanvas
const loadImage = canvas.loadImage
const Image = canvas.Image
const Request = require('pixl-request')
const serverless = require('serverless-http')
const app = express()
```

### Punto de Entrada

Este modulo se encarga de recibir y regresar una imagen con un request GET de HTTP para Netlify Functions pueda servir nuestra función.

```javascript
app.get(
  '/.netlify/functions/social-image/:title.jpeg',
  validation,
  setup,
  background,
  border,
  title,
  watermark,
  postProcessing,
  render,
)
```

La URL final a la que tendremos que hacer un request, será parecida a lo siguiente:

```
https://kinduff.com/.netlify/functions/social-image/Mi%20Título.jpeg
```

### Validation

Se requiere hacer una validación de que exista el parámetro `:title`. Es una función simple que regresará un JSON en caso de no encontrarlo.

```javascript
// ----------
// Validation
// ----------
function validation(req, res, next) {
  console.log(req.params)
  if (!req.params.title) {
    res.status(400)
    return res.json({
      message: 'Missing title, fam',
      error: 'Validation error',
    })
  }
  res.locals.title = req.params.title
  next()
}
```

### Setup

![](/assets/images/posts/setup.jpeg)

El setup de canvas, tiene establecidos algunos parámetros como el tamaño de la imagen, tamaño del borde y el padding para el texto. Estos son propagados a través de `locals` de Express.

```javascript
// ----------
// Canvas setup
// ----------
function setup(req, { locals }, next) {
  locals.canvas = createCanvas(800, 400)
  locals.ctx = locals.canvas.getContext('2d')
  locals.canvasBorder = 15
  locals.canvasPadding = 50
  next()
}
```

### Background

![](/assets/images/posts/background.jpeg)

Descargará una imagen aleatoria de [Unsplash Source](https://source.unsplash.com/) en un tamaño en específico y la dibujará en el canvas.

```javascript
// ----------
// Background Image
// ----------
function background(req, { locals }, next) {
  const request = new Request()
  request.setFollow(1)
  const randomImageURL = 'https://source.unsplash.com/collection/573009/800x400'
  request.get(randomImageURL, (err, resp, data) => {
    if (err) {
      res.status(500)
      return res.json({
        message: 'Something went wrong with the fetcher',
        error: err,
      })
    }

    let image = new Image()
    image.onload = () => {
      locals.ctx.drawImage(image, 0, 0)
      next()
    }
    image.src = data
  })
}
```

### Border

![](/assets/images/posts/border.jpeg)

Se encarga de añadir un borde al canvas del tamaño que deseamos, esto es para enmarcar la imagen y poder mantener el look & feel de este blog.

```javascript
// ----------
// Image border
// ----------
function border(req, { locals }, next) {
  const canvas = locals.canvas
  const ctx = locals.ctx
  ctx.fillStyle = '#000000'
  ctx.rect(0, 0, canvas.width, canvas.height)
  ctx.rect(
    locals.canvasBorder,
    locals.canvasBorder,
    canvas.width - locals.canvasBorder * 2,
    canvas.height - locals.canvasBorder * 2,
  )
  ctx.fill('evenodd')
  next()
}
```

### Title

![](/assets/images/posts/title.jpeg)

La función más complicada. Una de las desventajas que tiene HTML Canvas es su pésimo manejo de dibujar textos, pues para centrarlo horizontal y verticalmente, se tiene que calcular a mano, también considerando que si el texto es más largo que ancho del canvas, ignorará por completo y se saldrá del recuadro.

Esta función se encarga de eso: de centrar horizontalmente el texto, habilitando saltos de lineas centradas, centrarlo verticalmente de acuerdo a la altura final y añadiendo 3 sombras para darle un efecto genial.

```javascript
// ----------
// Title drawer
// ----------
function title(req, { locals }, next) {
  const canvas = locals.canvas
  const ctx = locals.ctx
  const text = locals.title
  const textWidth = canvas.width - locals.canvasPadding
  const fontSize = 54

  let lines = []
  let line = ''
  let lineTest = ''
  let words = text.split(' ')
  let currentY = 0
  let paddingTop = canvas.height / 2

  ctx.save()

  ctx.font = `bold ${fontSize}px Arial`
  ctx.textAlign = 'center'
  ctx.textBaseline = 'middle'

  for (var i = 0, len = words.length; i < len; i++) {
    lineTest = `${line + words[i]} `
    if (ctx.measureText(lineTest).width > textWidth) {
      currentY = lines.length * fontSize + fontSize
      lines.push({
        text: line,
        height: currentY,
      })
      line = `${words[i]} `
    } else {
      line = lineTest
    }
  }

  if (line.length > 0) {
    currentY = lines.length * fontSize + fontSize
    lines.push({
      text: line.trim(),
      height: currentY,
    })
  }

  paddingTop -= (lines.length * fontSize + fontSize) / 2

  for (var i = 0, len = lines.length; i < len; i++) {
    ctx.fillStyle = '#FFFFFF'
    ctx.shadowOffsetX = 0
    ctx.shadowOffsetY = 4
    ctx.shadowBlur = 3
    ctx.shadowColor = 'rgba(0,0,0,0.4)'
    ctx.fillText(lines[i].text, canvas.width / 2, lines[i].height + paddingTop)

    ctx.fillStyle = 'transparent'
    ctx.shadowOffsetX = 0
    ctx.shadowOffsetY = 8
    ctx.shadowBlur = 13
    ctx.shadowColor = 'rgba(0,0,0,0.1)'
    ctx.fillText(lines[i].text, canvas.width / 2, lines[i].height + paddingTop)

    ctx.fillStyle = 'transparent'
    ctx.shadowOffsetX = 0
    ctx.shadowOffsetY = 18
    ctx.shadowBlur = 23
    ctx.shadowColor = 'rgba(0,0,0,0.1)'
    ctx.fillText(lines[i].text, canvas.width / 2, lines[i].height + paddingTop)
  }

  ctx.restore()

  next()
}
```

### Watermark

![](/assets/images/posts/watermark.jpeg)

Se encarga de poner el texto pequeño `kinduff.com` abajo a la izquierda considerando el borde y añadiendo sombras.

```javascript
// ----------
// Watermark drawer
// ----------
function watermark(req, { locals }, next) {
  locals.ctx.save()

  locals.ctx.textBaseline = 'bottom'
  locals.ctx.font = '14px Arial'
  locals.ctx.textAlign = 'right'
  locals.ctx.fillStyle = '#FFFFFF'
  locals.ctx.shadowOffsetX = 2
  locals.ctx.shadowOffsetY = 4
  locals.ctx.shadowBlur = 3
  locals.ctx.shadowColor = 'rgba(0,0,0,0.4)'

  locals.ctx.fillText(
    'kinduff.com',
    locals.canvas.width - locals.canvasBorder - 5,
    locals.canvas.height - locals.canvasBorder - 5,
  )

  locals.ctx.restore()

  next()
}
```

### Post-processing

![](/assets/images/posts/post-processing.jpeg)

Se encarga de convertir toda la imagen a blanco y negro.

```javascript
// ----------
// Post Processing:
// - Black & White
// ----------
function postProcessing(req, { locals }, next) {
  const canvas = locals.canvas
  const ctx = locals.ctx
  const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height)
  const arraylength = canvas.width * canvas.height * 4
  let data = imageData.data

  for (let i = arraylength - 1; i > 0; i -= 4) {
    const gray = 0.3 * data[i - 3] + 0.59 * data[i - 2] + 0.11 * data[i - 1]
    data[i - 3] = gray
    data[i - 2] = gray
    data[i - 1] = gray
  }

  ctx.putImageData(imageData, 0, 0)
  next()
}
```

### Render

Función que se encarga de transformar lo que hemos construido en nuestro canvas a Base64 en un buffer. También proporciona los headers necesarios para servir el resultado como si fuese una imagen cualquiera.

```javascript
// ----------
// Canvas to Image Render
// ----------
function render(req, res, next) {
  const canvasData = res.locals.canvas.toDataURL('image/jpeg', 1)
  const base64Image = canvasData.split(';base64,').pop()
  const canvasBuffer = new Buffer(base64Image, 'base64')
  res.writeHead(200, {
    'Content-Type': 'image/jpeg',
    'Content-Length': canvasBuffer.length,
  })
  res.end(canvasBuffer)
}
```

Este es el output de una llamada con `curl`, ojo en los headers.

```shell
> GET /.netlify/functions/social-image/Hello%20World!.jpeg HTTP/2
> Host: kinduff.com
> User-Agent: curl/7.64.1
> Accept: */*
>
< HTTP/2 200
< cache-control: no-cache
< content-length: 187798
< content-type: image/jpeg
< x-powered-by: Express
```

### Serverless

Para poder ser utilizado en AWS Lambda como una función serverless y poder especificar los tipos de datos que podemos transmitir, en este caso `application/json` y `image/*` (cualquier formato de imagen).

```javascript
exports.handler = serverless(app, {
  binary: ['application/json', 'image/*'],
})
```

## Empujando a producción

Como estoy utilizando Netlify como servicio de páginas estáticas y en este caso, esta función de AWS Lambda, tuve que crear un directorio en mi proyecto llamado `lambda`. La estructura de este directorio se ve así.

```shell
lambda
├── dist
└── src
    └── social-image
        ├── package.json
        ├── social-image.js
        └── yarn.lock
```

Esta estructura permite poder tener más de una función lambda en su propio directorio y con sus propias dependencias, por lo que cree un shell script para compilarlos.

```bash
#!/usr/bin/env bash

LAMBDA_SRC=$(cd "$(dirname "lambda/src")"; pwd)/$(basename "lambda/src")
LAMBDA_DIST=$(cd "$(dirname "lambda/dist")"; pwd)/$(basename "lambda/dist")

mkdir -p $LAMBDA_DIST

for d in $LAMBDA_SRC/*/; do
  function_name=$(basename $d)
  yarn install --cwd $d
  cd $d && zip -rq $LAMBDA_DIST/$function_name * && cd -
done
```

Y parte de mis funciones de `build` en mi proyecto principal, llamará a este script para compilar en un ZIP file mis funciones lambda.

```json
"scripts": {
  "build": "npm-run-all build:*",
  "build:clean": "rm -rf .cache public lambda/dist",
  "build:lambda": "bin/build-lambda.sh",
  "build:client": "gatsby build",
}
```

## Conclusión

El resultado es bastante bueno, sin embargo, la flexibilidad que tiene la librería `node-canvas` hace que tareas fáciles como centrar textos se vuelva complicada. Existen alternativas a la generación de imágenes dinámicas, sin embargo, esta solución en particular para el problema que quería resolver, es más que suficiente.
