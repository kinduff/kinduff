---
title: ¿Que es tu logo? ¿Un h1 o una imagen?
date: 2012-08-16
description: Existen varias malas prácticas de las cuales podemos aprender al plantearnos el cómo mostrar un logo en nuestra página web. En este artículo se clarifica la manera correcta de hacerlo.
---

Desde que comencé en el desarrollo web siempre me había preguntado el cómo mostrar el logo. ¿Qué es bueno para el SEO? ¿Quién lo hace bien? ¿Quién lo hace mal?

Sitios web como Meneame.net, aNieto2k, Wordpress, New York Times, Reddit, etc, lo hacen de forma diferente. En este artículo daré mi punto de vista acerca de cómo debe de mostrarse a base de mi experiencia y de lo que he visto en la www.

Existen varias malas prácticas de las cuales podemos aprender al plantearnos el cómo mostrar un logo en nuestra página web; sin embargo las prácticas más comunes de hacerlo son las siguientes:

La primera opción siempre es una imagen de manera inline:

```html
<img src="logo.png" alt="Mi página web" />
```

La segunda opción, es la que la mayoría de los sitios utiliza:

```css
h1 {
  width: 300px;
  height: 50px;
  background: url('logo.png');
}
```

```html
<a href="URL" title="Mi página web">
  <h1 class="logo"></h1>
</a>
```

O bien, como tercera opción (cuidado, pueden sangrar los ojos):

```html
<a href="URL" title="Mi página web">
  <h1 class="logo">
    <img src="logo.png" alt="Mi página web" />
  </h1>
</a>
```

Pero si estamos hablando de SEO, es evidente que deberíamos pensar en qué debe ser leído por el motor de búsqueda.

Por ejemplo, Google penalizará sitios web que abusen de la etiqueta `h1`, las palabras claves y los que no tienen una buena estructura de contenido utilizando las etiquetas. Actualmente, es aceptado tener varias `h1` etiquetas porque a veces es realmente necesario.

Una de las principales razones por las que las etiquetas `h#` existen, es para la estructura de contenido. El caracter `h` en la etiqueta significa _encabezado_ y el número es la prioridad que tiene en el contenido completo del documento.

Por eso es importante que el contenido se debe presentar con la importancia que tiene, me refiero a que si el título de tu página es: _Mi página web_, pero se muestra un artículo con el título: _Cómo estar vivo_, el título de tu página debe de tener baja prioridad. La parte más importante del contenido es el artículo, no el título de la página web.

Hay un debate en curso sobre este tema en [The H1 Debate](https://web.archive.org/web/20101219090951/http://h1debate.com/) en el que hay una encuesta de acerca de si debería utilizar la etiqueta H o el logo o el tema principal. Adivina quién va ganando.

La recomendación que tengo es la siguiente: utiliza las etiquetas H para prioritar el contenido individual, pero en la página principal, intente mostrar el logo como un `h1`. Para el resto de las paginas, utiliza una imagen regular.
