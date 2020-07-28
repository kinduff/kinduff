---
image: https://dimg.kinduff.com/5 tips para escribir CSS mantenible.jpeg
title: 5 tips para escribir CSS mantenible
date: 2012-09-20
description: No te pongas el pie tu solo y escribe CSS que puedas mantener en un futuro; consta en organización y disciplina para lograr escribir arte en CSS
---

Más de alguna ocasión me he enfrentado a mi propia ineptitud y falta de respeto hacia las lineas mágicas que escribo, al no estructurar bien mis estilos en CSS. Escribo este artículo para orientar y hacer exámenes de conciencia para resaltar la importancia de lo que es escribir CSS que después podrás mantener de manera fácil y rápida.

## 1\. Escribe un área a la vez

Si vas a utilizar un layout base para toda tu web: Sepáralo. Si vas a escribir un estilo base para múltiples secciones: Sepáralo. Maquetea el estilo de un área a la vez para que tengas orden; así te pidan o quieras hacer múltiples cambios, hazlos al final; ya que ahí es cuándo todo se destruye y pierde el orden que le querías dar.

## 2\. Utiliza un pre-procesador

Existen varios pre-procesadores que te ayudarán a ser más organizado, uno de ellos es [SASS](http://sass-lang.com), el cuál te ayudará a realizar acciones estilo _nesting_ de clases, _mixins_ de estilos completos o el simple hecho de utilizar variables para controlar tu paleta de colores.

## 3\. Regla de las tres erres

¿No te la sabes? Entonces eres alguien que no recicla. La regla de las tres erres consta en tres simples principios: Reducir, Reutilizar y Reciclar. Curiosamente cuando uno escribe CSS debe de ser al revés:

- Reciclar: Utiliza clases dentro de clases, es decir, haz _nesting_.
- Reutilizar: Utiliza los _mixins_ para ser más eficiente al momento de escribir.
- Reducir: Pre-procesa, comprime y minifica tu CSS.

## 4\. Estiliza tus estilos para darles estilo

Mantén un orden al momento de escribir, es decir, comienza definiendo ancho, alto, margenes, después paddings, etc. Esto te dará una idea más clara al momento de leer y de querer modificar algo.

Muchos maquetadores lo organizan por tamaño de renglón, de chico a grande, o bien, por orden alfabético. Elige la que más te guste, pero entiende lo que estás haciendo.

## 5\. Utiliza varias hojas de estilo

El peor consejo o tip que alguien te puede dar, ya que le estás cargando la mano al usuario al solicitarle cargar más de una hoja de estilo, pero sigue leyendo.

Este tip es bueno para organizarte, pero sólo es bueno si estás utilizando un pre-procesador que te "una" estas hojas es una sola, y claro, siguiendo el tip número 3.

¿Tienes algún tip que te gustaría compartir? Escribe un comentario.
