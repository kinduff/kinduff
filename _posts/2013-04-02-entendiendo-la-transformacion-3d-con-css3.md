---
image: https://dimg.kinduff.com/Entendiendo la transformación 3D con CSS3.jpeg
title: Entendiendo la transformación 3D con CSS3
date: 2013-04-02
description: ¿Te gustaría aprender transformaciones 3D en CSS3? Entonces tendrás que aprender lo básico. En este ejercicio vamos a hacer un cubo animado en 3D.
---

La propiedad `transform` de CSS3 nos da la habilidad de transformar elementos en 2D o en 3D. Nos permite rotar, escalar, mover, torcer, etc, elementos. En este ejercicio haremos un cubo animado que rota con 6 diferentes caras con CSS3.

## HTML

Necesitaremos un contenedor y las 6 diferentes caras del cubo. El markup HTML quedará de la siguiente manera:

```html
<div class="cubo">
  <div class="cara" id="superior"></div>
  <div class="cara" id="frente"></div>
  <div class="cara" id="derecha"></div>
  <div class="cara" id="izquierda"></div>
  <div class="cara" id="atras"></div>
  <div class="cara" id="inferior"></div>
</div>
```

Cada `.cara` tiene un id diferente para poder apuntarlas de manera individual y una clase en común para generalizar.

## CSS básico

Una vez listo nuestro markup HTML pasaremos a darle estilos básicos, antes de pasar a las transformaciones 3D.

Tanto el cubo, como cada cara, tendrán un ancho y alto igual, así como cada cara tendrá una posición absoluta (para poder transformarlo con libertad). Y alinearemos también el cubo al centro para este demo.

```css
.cubo,
.cubo .cara {
  width: 200px;
  height: 200px;
}
.cubo .cara {
  position: absolute;
}
.cubo {
  margin: 100px auto;
}
```

Y le daremos un fondo diferente a cada cara para notar los cambios en la transformación 3D.

```css
.cubo .cara#superior {
  background-color: orange;
}
.cubo .cara#frente {
  background-color: red;
}
.cubo .cara#atras {
  background-color: green;
}
.cubo .cara#derecha {
  background-color: blue;
}
.cubo .cara#izquierda {
  background-color: yellow;
}
.cubo .cara#inferior {
  background-color: fuchsia;
}
```

Ahora ya podemos comenzar a aplicar CSS3 Transform para hacer nuestro cubo 3D.

![](/assets/images/posts/3d1.png)

## CSS3 3D

Ahora, antes de comenzar con el movimiento de caras para formar el cubo, es importante aplicar le propiedad `transform-style` con el valor `preserve-3d` al padre de nuestras caras, esto para mantener las transformaciones 3D de los hijos (`.cara`) en relación al padre (`.cubo`).

```css
.cubo {
  transform-style: preserve-3d;
}
```

El siguiente paso será dar una transformación al `.cubo` para darle un poco de perspectiva y facilitarnos el camino del movimiento de cara `.cara`.

```css
.cubo {
  transform-style: preserve-3d;
  transform: perspective(700px) rotateX(-30deg) rotateY(-30deg);
}
```

![](/assets/images/posts/3d2.png)

Ahora es tiempo de mover y rotar cada una de las caras para que queden alineadas para formar el cubo que estamos buscando hacer.

Rotaremos la cara de la derecha con la propiedad `rotateY` de `transform` a 90°.

```css
.cubo .cara#derecha {
  transform: rotateY(90deg);
}
```

![](/assets/images/posts/3d3.png)

Para después mover la cara en el plano 3D (sobre el eje Z) con `translateZ` para posicionarlo. Lo moveremos 100px que es la mitad del ancho de nuestro cubo.

```css
.cubo .cara#derecha {
  transform: rotateY(90deg) translateZ(100px);
}
```

![](/assets/images/posts/3d4.png)

Y haremos lo mismo con cada una de las caras del cubo.

```css
.cubo .cara#superior {
  background-color: orange;
  transform: rotateX(90deg) translateZ(100px);
}
.cubo .cara#frente {
  background-color: red;
  transform: translateZ(100px);
}
.cubo .cara#atras {
  background-color: green;
  transform: translateZ(-100px);
}
.cubo .cara#derecha {
  background-color: blue;
  transform: rotateY(90deg) translateZ(100px);
}
.cubo .cara#izquierda {
  background-color: yellow;
  transform: rotateY(-90deg) translateZ(100px);
}
.cubo .cara#inferior {
  background-color: fuchsia;
  transform: rotateX(-90deg) translateZ(100px);
}
```

![](/assets/images/posts/3d5.png)

## CSS3 Animación

Ahora que ya tenemos nuestras caras 100% transformadas y rotadas, dándo el efecto que forma un cubo, es hora de animarlo.

Gracias a la propiedad `preserve-3d` de `transform-style` aplicada al `.cubo`, nos será posible rotar las caras con mucha facilidad. Solo hace falta realizar una vuelta de 360° en X y Y con `rotateX` y `rotateY` respectivamente con `transform` de la siguiente manera:

```css
.cubo {
  animation: rotate 2s infinite linear;
}
@keyframes rotate {
  0% {
    transform: rotateX(0deg) rotateY(0deg);
  }
  100% {
    transform: rotateX(360deg) rotateY(360deg);
  }
}
```

Lo que nos dará el efecto visual que estabamos buscando.

## Ejemplo

<div class="cubo">
  <div class="cara" id="superior"></div>
  <div class="cara" id="frente"></div>
  <div class="cara" id="derecha"></div>
  <div class="cara" id="izquierda"></div>
  <div class="cara" id="atras"></div>
  <div class="cara" id="inferior"></div>
</div>

## Soporte

<iframe src="https://caniuse.com/transforms3d/embed/"></iframe>

<style>
.cubo,.cubo .cara {
  width: 200px;
  height: 200px;
}
.cubo .cara {
  position: absolute;
}
.cubo {
  margin: 100px auto;
  -webkit-transform-style: preserve-3d;
  -moz-transform-style: preserve-3d;
  -ms-transform-style: preserve-3d;
  transform-style: preserve-3d;
  -webkit-transform: perspective(700px) rotateX(-30deg) rotateY(-30deg);
  -moz-transform: perspective(700px) rotateX(-30deg) rotateY(-30deg);
  -o-transform: perspective(700px) rotateX(-30deg) rotateY(-30deg);
  -ms-transform: perspective(700px) rotateX(-30deg) rotateY(-30deg);
  transform: perspective(700px) rotateX(-30deg) rotateY(-30deg);
}
.cubo .cara#superior {
  background-color: orange;
  -webkit-transform: rotateX(90deg) translateZ(100px);
  -moz-transform: rotateX(90deg) translateZ(100px);
  -o-transform: rotateX(90deg) translateZ(100px);
  -ms-transform: rotateX(90deg) translateZ(100px);
  transform: rotateX(90deg) translateZ(100px);
}
.cubo .cara#frente {
  background-color: red;
  -webkit-transform: translateZ(100px);
  -moz-transform: translateZ(100px);
  -o-transform: translateZ(100px);
  -ms-transform: translateZ(100px);
  transform: translateZ(100px);
}
.cubo .cara#atras {
  background-color: green;
  -webkit-transform: translateZ(-100px);
  -moz-transform: translateZ(-100px);
  -o-transform: translateZ(-100px);
  -ms-transform: translateZ(-100px);
  transform: translateZ(-100px);
}
.cubo .cara#derecha {
  background-color: blue;
  -webkit-transform: rotateY(90deg) translateZ(100px);
  -moz-transform: rotateY(90deg) translateZ(100px);
  -o-transform: rotateY(90deg) translateZ(100px);
  -ms-transform: rotateY(90deg) translateZ(100px);
  transform: rotateY(90deg) translateZ(100px);
}
.cubo .cara#izquierda {
  background-color: yellow;
  -webkit-transform: rotateY(-90deg) translateZ(100px);
  -moz-transform: rotateY(-90deg) translateZ(100px);
  -o-transform: rotateY(-90deg) translateZ(100px);
  -ms-transform: rotateY(-90deg) translateZ(100px);
  transform: rotateY(-90deg) translateZ(100px);
}
.cubo .cara#inferior {
  background-color: fuchsia;
  -webkit-transform: rotateX(-90deg) translateZ(100px);
  -moz-transform: rotateX(-90deg) translateZ(100px);
  -o-transform: rotateX(-90deg) translateZ(100px);
  -ms-transform: rotateX(-90deg) translateZ(100px);
  transform: rotateX(-90deg) translateZ(100px);
}
.cubo {
  -webkit-animation: rotate 2s infinite linear;
  -moz-animation: rotate 2s infinite linear;
  -ms-animation: rotate 2s infinite linear;
  -o-animation: rotate 2s infinite linear;
  animation: rotate 2s infinite linear;
}
@keyframes "rotate" {
 0% {
    -webkit-transform: rotateX( 0deg ) rotateY( 0deg );
    -moz-transform: rotateX( 0deg ) rotateY( 0deg );
    -o-transform: rotateX( 0deg ) rotateY( 0deg );
    -ms-transform: rotateX( 0deg ) rotateY( 0deg );
    transform: rotateX( 0deg ) rotateY( 0deg );
 }
 100% {
    -webkit-transform: rotateX( 360deg ) rotateY( 360deg );
    -moz-transform: rotateX( 360deg ) rotateY( 360deg );
    -o-transform: rotateX( 360deg ) rotateY( 360deg );
    -ms-transform: rotateX( 360deg ) rotateY( 360deg );
    transform: rotateX( 360deg ) rotateY( 360deg );
 }
}
@-moz-keyframes rotate {
 0% {
   -moz-transform: rotateX( 0deg ) rotateY( 0deg );
   transform: rotateX( 0deg ) rotateY( 0deg );
 }
 100% {
   -moz-transform: rotateX( 360deg ) rotateY( 360deg );
   transform: rotateX( 360deg ) rotateY( 360deg );
 }
}
@-webkit-keyframes "rotate" {
 0% {
   -webkit-transform: rotateX( 0deg ) rotateY( 0deg );
   transform: rotateX( 0deg ) rotateY( 0deg );
 }
 100% {
   -webkit-transform: rotateX( 360deg ) rotateY( 360deg );
   transform: rotateX( 360deg ) rotateY( 360deg );
 }
}
@-ms-keyframes "rotate" {
 0% {
   -ms-transform: rotateX( 0deg ) rotateY( 0deg );
   transform: rotateX( 0deg ) rotateY( 0deg );
 }
 100% {
   -ms-transform: rotateX( 360deg ) rotateY( 360deg );
   transform: rotateX( 360deg ) rotateY( 360deg );
 }
}
@-o-keyframes "rotate" {
 0% {
   -o-transform: rotateX( 0deg ) rotateY( 0deg );
   transform: rotateX( 0deg ) rotateY( 0deg );
 }
 100% {
   -o-transform: rotateX( 360deg ) rotateY( 360deg );
   transform: rotateX( 360deg ) rotateY( 360deg );
 }
}
iframe {
  width: 100%;
  height: 380px;
  border: none;
}
</style>
