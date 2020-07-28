---
image: https://dimg.kinduff.com/10 secretos de CSS3 que tal vez no conocias.jpeg
title: 10 secretos de CSS3 que tal vez no conocias
date: 2011-11-23
description: Artículo sobre la platica de Lea Verou sobre 10 secretos acerca de CSS3 que quizás no conozcas
---

[Lea Verou](http://lea.verou.me) ([@LeaVerou](http://twitter.com/leaverou)) es una popular desarrolladora web con varios años de experiencia. En su conferencia **"10 cosas de CSS3 que tal vez no conocías"** nos explica el uso de algunas propiedades, efectos, transiciones y animaciones en CSS3, así como también un moderado uso de javascript y su respectiva compatibilidad en diferentes navegadores.

![](/assets/images/posts/lea.jpg)

Esta conferencia la dió en Pathé Tuschinski en Amsterdam el 7 de Octubre 2011 la cual me he encargado de recopilar y traducir.

## Bouncing transitions

Seguramente conocerás diversas maneras de realizar animaciones con la **propiedad transition** de CSS3. La manera regular de hacerlo es utilizando ease-out, ease-in, etc. Pero ¿Qué tan bien conoces **cubic-bezier**?

**Cubic-Bezier** es, por así decirlo, la propiedad madre de los efectos de transición de los estilos antes mencionados. Es totalmente personalizable y se es capaz de marcar tiempos para la animación que queramos.

Se utiliza de la siguiente manera:

```css
/* transition: Ts cubic-bezier(x, y, z, w) *\
transition: 1.5s cubic-bezier(.17, .87, .50, 1.2)
```

Lea Verou es tan cool que nos regala un sistema de modificación de este tipo de animación de manera gráfica con un excelente diseño y tiene el mejor dominio: [Cubic-Bezier.com](http://Cubic-Bezier.com)

## Flexible ellipses

La manera en la que generalmente hacemos un **border-radius** es con medidas fijas, pero ¿Qué pasa si nuestro es contenido dinámico? Se distorsiona.

```css
border-radius: 150px / 300px;
```

Para que esto no suceda se recomienda utilizar porcentajes para realizar el mismo efecto pero sin llegar a una distorción.

```css
border-radius: 50%;
```

Con esto siempre se mantendrá la forma de un elipse.

## Multiple outlines

Existen maneras complicadas de realizar el efecto de tener varios bordes en un contenedor, pero existe una manera mucho más fácil.

```css
box-shadow: 0 0 0 5px black, 0 0 0 10px red;
```

Los primeros 3 ceros dentro de las propiedades de nuestro box-shadow indican que no tendrá ningún tipo de posición en x o y, igualmente ningún blur. El cuarto elemento define el spread o el ancho de nuestro box-shadow, esto nos ayudará a generar el efecto.

```css
box-shadow: x y blur spread color;
```

Con esto, simplemente vamos haciendo un borde más grande que otro dándonos el efecto de múltiples bordes.

## Bonus: One Side Shadow

Siguiendo las reglas de box-shadow es bastante fácil realizar una sombra de un sólo lado de algún elemento.

```css
box-shadow: 0 11px 5px -5px black;
```

## Make pointer events pass through

Si tenemos un elemento encima de otro modificado con z-index y queremos realizar un clic en el elemento que está debajo, esta acción nos resulta imposible. Para poder habilitar un "click through" o un "clic a través" es necesario agregar la siguiente propiedad a nuestro elemento superior.

```css
pointer-events: none;
```

### Detección

Está es la manera recomendada de detectar si existe la propiedad pointer-events.

```javascript
var supportsPointerEvents = (function() {
  var dummy = document.createElement('_')
  if (!('pointerEvents' in dummy.style)) return false
  dummy.style.pointerEvents = 'auto'
  dummy.style.pointerEvents = 'x'
  document.body.appendChild(dummy)
  var r = getComputedStyle(dummy).pointerEvents === 'auto'
  document.body.removeChild(dummy)
  return r
})()
```

Y un workaround en javascript es el siguiente.

```javascript
function noPointerEvents(element) {
  $(element).bind('click mouseover', function(evt) {
    this.style.display = 'none'
    var x = evt.pageX,
      y = evt.pageY,
      under = document.elementFromPoint(x, y)
    this.style.display = ''
    evt.stopPropagation()
    evt.preventDefault()
    $(under).trigger(evt.type)
  })
}
```

## Adjusting tab size

Si quieres modificar el tamaño de la sangría o el tamaño del tab en un texto, la propiedad tab-size te ayudará bastante.

```css
tab-size: 4;
```

## Styling based on sibling count

Eso de estar seleccionando cada elemento de un menú, de una lista, de una galería, etc, para asignarle una propiedad diferente es una lata. Resulta que existen unas propiedades llamadas first-child, only-child, nth-child y nth-last-child, que nos ayudarán bastante para realizar una serie de efectos interesantes.

### First-child

Se selecciona unicamente el primer elemento dentro de un parent (ya se del body, algún contenedor o de una lista).

```css
#elemento:first-child {
    propiedad: unica;
}
```

### Only-child

Se selecciona únicamente un elementro que esté sólo dentro de un parent.

```css
#elemento:only-child {
    propiedad: unica;
}
```

### nth-child

Esta es la que más me gusta. Con esta propiedad podremos seleccionar varios elementos cada determinado numero de elementos.

```css
#elemento:nth-child(3n + 1) {
    propiedad: unica;
}
```

Con esto se seleccionarán el primer elemento y a partir de ahí, cada tres elementos se le aplicará nuestra propiedad.

### nth-last-child

Si queremos hacerlo al revés, es decir, contar desde el último al primero lo podemos hacer con esta propiedad.

```css
#elemento:nth-last-child(3n + 1) {
    propiedad: unica;
}
```

### Bonus

**Lea Verou** nos regala las siguientes propiedades para facilitarnos la vida.

```css
:first-child: nth-last-child(2);
```

Se selecciona el primer elemento si sólo son 2 en total.

```css
:first-child:nth-last-child(2), :first-child:nth-last-child(2) ~ b
```

Se seleccionan todos los elementos si son solo 2 en total.

```css
:first-child:nth-last-child(n+5), :first-child:nth-last-child(n+5) ~ b
```

Se seleccionan todos los elementos a partir de 5 en total.

## Custom checkboxes & radio buttons

La idea principal es atribuída a [Ryan Seddon](http://www.thecssninja.com/css/custom-inputs-using-css), con esto podremos tener checkboxes y radio buttons personalizados.

Primero escondemos nuestro elemento.

```css
:root input#custom-checkbox {
    position: absolute;
  clip: rect(0, 0, 0, 0);
}
```

Después personalizamos nuestro nuevo elemento, agregándole contenido personalizado:

```css
:root input#custom-checkbox + label:before {
    content: '\\20E0';
    padding-right: 0.3em;
  color: red;
}
```

Y por último personalizamos y retocamos el efecto de nuestro elemento:

```css
:root input#custom-checkbox:focus + label:before {
    color: white;
}
:root input#custom-checkbox:checked + label:before {
    color: red;
}
```

## More cursors for better UX

Seguramente sabes que con CSS2 se pueden asignar diferentes cursores, aquí una lista de nuestras opciones nuevas en CSS3.

- none
- context-menu
- cell
- vertical-text
- alias
- copy
- no-drop
- not-allowed
- col-resize
- raw-resize
- all-scroll
- zoom-in
- zoom-out

Se utiliza de la siguiente manera:

```css
cursor: opcion;
```

## Background patterns with pure CSS

Si quieres ser original y realizar tus propios patrones en CSS3, puedes comenzar por aprender como funciona el sistema de linear-gradient.

```css
background: linear-gradient(70deg, black 20%, gray 80%);
```

Nuestro fondo de pantalla tendrá un degradado con un ángulo de 70°, 20% negro y 80% gris. Fácil ¿no?
Algo que probablemente no sabías es que se pueden incluir varias opciones dentro del linear-gradient, para realizar un patrón inclinado podemos utilizar lo siguiente:

```css
background: linear-gradient(
  45deg,
  silver 25%,
  gray 25%,
  gray 50%,
  silver 50%,
  silver 75%,
  gray 75%,
  gray
);
background-size: 200px 200px;
```

Ajustando el **background-size** se puede hacer magia. Con esto ajustamos el tamaño de nuestro patrón, para así realizar un bonito efecto.

Se puede realizar el mismo efecto con la propiedad **repeating-linear-gradient**, nos dará el mismo efecto anterior. Se están utilizando ahora, en lugar de porcentajes, medidas fijas. Con esto podremos personalizar aún más nuestro efecto a desear.

```css
background: repeating-linear-gradient(
  45deg,
  silver,
  silver 30px,
  gray 30px,
  gray 60px
);
```

## Background positioning tricks

¿Cuántas veces has querido darle padding a un background dentro de un contenedor en una locación específica? Como sabrás lo siguiente no funciona.

```css
padding: 40px;
background: url(imagen.png) no-repeat;
background-position: bottom right;
```

Para poder lograr el padding se puede utilizar la siguiente forma:

```css
background-position: bottom 100px right 100px;
```

### Workaround para Firefox y Webkit

Para realizar el efecto, que increíblemente únicamente funciona en IE (si, IE) y Opera, podemos utilizar lo siguiente:

```css
padding: 100px;
backgroun-position: bottom right;
background-origin: content-box;
```

La propiedad **background-origin** es compatible en todos los navegadores.

Y con esto finaliza la genial presentación de [Lea Verou](http://lea.verou.me).

En lo personal aprendí bastante, pero sobretodo, aprendí que hay que innovar, pensar out of the box afuera de la caja y sacarle el mayor provecho a las tecnologías actuales. **No hay que ser perezosos**.

- [Video de la presentación](http://vimeo.com/31719130)
- [Slides de la presentación](http://lea.verou.me/css3-secrets)
- [Framework de Lea Verou para hacer la presentación](http://github.com/LeaVerou/CSSS)
