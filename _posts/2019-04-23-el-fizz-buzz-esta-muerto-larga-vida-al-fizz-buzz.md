---
title: El Fizz Buzz está muerto, larga vida al Fizz Buzz
date: 2019-04-22
description: Revisitando el ejercicio del Fizz Buzz en tiempos modernos.
---

Ya hace un par de años que me involucro y lidero procesos para la contratación de talentos. Al ser programador, también me he visto involucrado en procesos ajenos que me han ayudado a encontrar maneras óptimas de crear procesos de selección para cualquier área.

Hace tiempo que he estado colaborando con una agencia de reclutamiento llamada Multiplica Talent. En comparación con otras agencias de reclutamiento, su diferencial está en probar de manera técnica a los candidatos antes de presentarlos a los clientes. Mi rol en esta empresa está enfocado en tener un proceso de selección moderno y efectivo para los talentos que buscamos.

Dado que el proceso de selección para posiciones de programación era relativamente nuevo, me encontré con uno no muy óptimo: consistía en enviar una prueba regular al candidato en donde se medían conocimientos de ciertos lenguajes. El tiempo que el candidato tenía que invertir era de alrededor de 5 horas. Muchos de estos candidatos no enviaban su prueba a tiempo o simplemente no respondían.

Lo primero que identifiqué fue que el tipo de prueba no era para nada atractiva. Las pruebas de programación pueden ser tan aburridas, que al final del día, también son un reflejo de la cultura que tiene la empresa. Si una prueba es tediosa, no requiere creatividad y tiene una dificultad sospechosa, la motivación e interés del candidato quedarán por los suelos.

También hablemos del tiempo; a menos de que un candidato esté en búsqueda activa, es decir, que pueda invertir mucho tiempo en todos los procesos de diferentes empresas a las que se está postulando, le será difícil encontrar 5 horas (libres) entre semana e incluso fines de semana.

Con esta información comencé a diseñar un proceso de selección para candidatos de programación. Este consta de 3 filtros que aseguran que podamos conocer y evaluar al candidato de manera óptima, pero manteniendo un equilibrio con el tiempo que se invierte. El nuevo proceso tiene una duración total de 2 horas: 15 minutos para una prueba de filtrado rápido, 1 hora para la prueba de programación especializada y 45 minutos de entrevistas.

En este artículo hablaré acerca del primer filtro, el de filtrado rápido que dura 15 minutos. Este consiste en una prueba que nos ayuda a filtrar candidatos que estén interesados en la posición que ofrecemos, pero que también tengan habilidades de programación y resolución de problemas.

## El Fizz Buzz

Muchos programadores, si no es que la mayoría, saben que existe una prueba de filtrado llamada [Fizz Buzz](http://wiki.c2.com/?FizzBuzzTest). Esta prueba consiste en escribir un pequeño programa que imprima los números del 1 al 100, pero que cuando el número sea múltiplo de 3, imprima la palabra "Fizz"; para múltiplos de 5 deberá imprimir "Buzz", finalmente cuando el número sea múltiplo de 3 y de 5, deberá imprimir "FizzBuzz".

Esta prueba se ha aplicado en muchas empresas como una puerta para poder comenzar el proceso de selección, porque pone a prueba las habilidades de escritura de código y resolución de problemas. También muestra que se sabe programar porque, increíblemente, muchos de los candidatos que comienzan un proceso de selección, no lo saben hacer. Finalmente, da cabida a mostrar otras habilidades del candidato referentes a estructuras de código, buenas prácticas, entre otras cosas.

Este ejercicio de programación se ha vuelto muy famoso, y en mi opinión, ya ha sido utilizado demasiadas veces; incluso ya es enseñado durante la escuela. Personalmente, me resulta anticuado aplicar esta prueba en estos tiempos modernos.

## ¿Algoritmos? Solo si se requiere

Muchas empresas aplican ejercicios en herramientas de automatización y aplicación de pruebas de código; sin embargo, he visto que colocan problemas altamente complejos, no relacionados al tipo de tareas que tendría un candidato en el trabajo, y que también lo llegan a utilizar como única prueba para "medir" las habilidades del candidato.

Soy creyente de que los procesos de selección de en una empresa deben ser humanos, considerando al candidato como tal. Que el postulante no es un [code monkey](https://en.wikipedia.org/wiki/Code_monkey), y que tampoco una prueba de algoritmos validará sus habilidades de producción de código. Si el trabajo requiere creación de algoritmos, entonces que se ponga a prueba; de lo contrario, se está perdiendo tiempo.

Pensé que el ejercicio no necesariamente tendría que estar alineado al tipo de trabajo —me refiero al lenguaje o tipo de aplicación— y que tampoco tuviera la innecesaria complejidad de demostrar capacidad para escribir algoritmos complicados que rara vez son utilizados.

## La alternativa

Decidí implementar un primer ejercicio de filtrado al estilo Fizz Buzz; pero sin el Fizz, ni el Buzz. Un primer paso en el proceso de selección que permitiera al candidato demostrar sus habilidades de programación de una manera natural, sin ponerlos contra la pared, y que a su vez fuera divertido.

Pensé que el ejercicio no necesariamente tuviera que estar alineado al tipo de trabajo - me refiero al lenguaje o tipo de aplicación, y que tampoco tuviera la innecesaria complejidad de demostrar capacidad para escribir algoritmos complicados que rara vez son utilizados.

Para la creación de este primer filtro, establecí las siguientes reglas para la elaboración de los ejercicios.

1. Debían tener la simpleza y peculiaridad del Fizz Buzz, pero a su vez, una marca innovadora y divertida.
2. Tenían que ser cortos y sencillos. Ejercicios que pudieran ser resueltos en un lapso no mayor a 15 minutos.
3. Tenían que contar una historia que los envolviera, para darle ese toque peculiar, como de resolver un misterio para obtener una respuesta a través de código. Muy a la _CSI_.
4. Tenían que permitir escribir el código que fuera necesario. Que fueran flexibles a la hora de resolverlos.
5. Los ejercicios debían de tener una respuesta final para automatizar la verificación de la respuesta. Si el talento había podido entender y escribir el código necesario, iba a ser capaz de llegar a la respuesta final y por lo tanto era un talento que sabía programar y que estaba interesado.

Con base en las reglas anteriores pude crear dos ejercicios; son dos para poder asignarlos aleatoriamente y a su vez poder medir el éxito de cada uno, por si era necesario modificarlo.

1. **Ejercicio 1: Ganando la lotería**
   Existe una leyenda urbana acerca de una frecuencia especial, que al sintonizarse, uno puede escuchar los números de la lotería del mes.
   Tu curiosidad y habilidades para hallar secretos te llevan a encontrar una lista en internet con ajustes de frecuencia (incrementando o decrementando), que probablemente, te harán llegar a la frecuencia secreta.
2. **Ejercicio 2: La caja fuerte**
   El antiguo dueño de la casa que acabas de adquirir, dejó su caja fuerte cerrada. Te comentó que hay un jugoso premio dentro de ella para la persona que logre adivinar la contraseña.
   Sin embargo, solo te dió una pista para poder adivinar la contraseña: "Toma este documento y suma el número total de repeticiones de letras", después te entregó un documento lleno de letras y números por los dos lados.

Cada ejercicio viene acompañado de un _input_, que son los datos del ejercicio. Estos datos deben de ser utilizados para poder procesarlos según el problema y obtener una respuesta final. La respuesta final es un número, así que no importa si el código creado para llegar a la respuesta es "bonito" o "feo", lo importante es que se llegue a esta respuesta final.

Cabe señalar que estos dos ejercicios ya fueron aplicados a más de 100 candidatos alrededor del mundo.

## Datos y respuestas dinámicas

El input del ejercicio puede ser generado de manera dinámica, es decir, cada vez que se crea un ejercicio, este tiene una respuesta correcta única.

El siguiente bloque de código es el generador de los datos que necesita el primer ejercicio "Ganando la lotería".

```ruby
input = (0..1000).map do |i|
  "#{["+", "-"].sample}#{rand(1...100)}"
end.join("\n")
```

Y el código para obtener la respuesta podría ser escrito de la siguiente manera.

```ruby
input.split("\n").map(&:to_i).sum
```

Para el segundo ejercicio "La caja fuerte", el generador luce así.

```ruby
input = (0..10000).map do |i|
  [*('a'..'z'), *(1..100)].sample
end.join
```

Y el código para obtener la respuesta, puede ser así de simple.

```ruby
input.delete("^a-zA-Z").size
```

El código para generar la respuesta luce bastante simple, pues es parte de la flexibilidad y la simpleza que tienen estos dos ejercicios. Para los programadores, esto puede ser contra-intuitivo. Estamos acostumbrados a realizar ejercicios más complicados o que representan un reto aún más grande.

Esto es totalmente intencional, la idea es que exista espacio para la creatividad en forma de código.

## ¿Cómo respondieron?

Los candidatos han respondido de muchas formas. Me he encontrado con respuestas completas y óptimas, otras muy complejas, y otras innecesariamente complejas. Cualquier desarrollador que haya podido enviar su ejercicio es porque encontró la respuesta correcta.

Los siguientes scripts son una muestra de lo que los candidatos nos contestaron.

"La caja fuerte" en Javascript:

```javascript
var totalLetters = 0
inputArr.forEach(function(element) {
  var letters = /^[a-zA-Z]+$/
  if (letters.test(element)) {
    totalLetters++
  }
})
console.log(totalLetters)
```

En PHP:

```php
$input = str_replace('1', '', $input);
$input = str_replace('2', '', $input);
$input = str_replace('3', '', $input);
$input = str_replace('4', '', $input);
$input = str_replace('5', '', $input);
$input = str_replace('6', '', $input);
$input = str_replace('7', '', $input);
$input = str_replace('8', '', $input);
$input = str_replace('9', '', $input);
$total = 0;
foreach (count_chars($input, 1) as $i => $val) {
  echo "<p>hubo $val instancias(s) de \"" , chr($i) , "\" en la palabra.</p>";
  $total+=$val;
}
echo "<p>valor final = $total</p>";
```

Y finalmente en Python:

```python
clave = 0
for caracter in mensaje:
    if caracter.isalpha():
        clave=clave+1
print("La suma total de los caracteres es: ", clave)
```

Después, "Ganando la lotería" en Javascript:

```javascript
AdjustFrequency (array) {
  let lotteryNumber = 0;

  array.forEach( (element) => {
    lotteryNumber += element;
  });

  return lotteryNumber;
}
```

En PHP:

```php
foreach($lista as $string){
  if($string[0]=='+'){
    $frecuencia=$frecuencia+(int)(str_replace(['+','-'],'',$string));
  } else {
    $frecuencia=$frecuencia-(int)(str_replace(['+','-'],'',$string));
  }
}
echo $frecuencia;
```

Y finalmente en Python:

```python
def frecuencia(input):
    resultado = 0
    with open(input) as frec:
        for linea in frec:
            if linea[:1] == '+':
                resultado += int(linea[1:])
            elif linea[:1] == '-':
                resultado -= int(linea[1:])
    return resultado

print(frecuencia('input.txt'))
```

Cada uno de estos scripts tiene su lado curioso, algo que revela quién es el talento, de qué manera leyó el ejercicio y cómo lo resolvió a través de código. También revela qué es lo que quiso demostrar; si quiso demostrar la simpleza de su solución o las habilidades que tiene para resolverlo de una forma más elegante. En algunos casos nos revela qué sabe el talento acerca del lenguaje que eligió para resolverlo.

Al fin y al cabo, lo que queremos es conocer al candidato: cómo se mueve, cómo piensa, sus intenciones y sus ambiciones. Esta prueba de 15 minutos permitió a los programadores demostrar sus habilidades a su manera y al ser la puerta de entrada al resto de proceso, pudimos demostrar iba a ser divertido, diferente y moderno.

## Conclusión

Esto sin duda ayudó mucho a identificar talentos con enfoque más completo que el Fizz Buzz. Nos dio una herramienta para filtrar a candidatos con habilidades para poder resolver problemas y para demostrar el interés en el resto del proceso de selección, pero lo más importante, nos mostró una parte de la personalidad y quizás el nivel de los talentos.

La conclusión de esta historia que les quise contar, es que, a pesar de que el Fizz Buzz ya haya sido utilizado demasiadas veces y que los talentos lo aprendan en sus pasos básicos, este tipo de ejercicios son herramientas que ayudan a identificar talentos en procesos de selección y contratación. Que no es necesario que sean aburridos o complejos para poder darle la oportunidad al programador de expresar sus ideas, permitiendo comprensión y creatividad a la hora de desarrollar soluciones.

Y es que este último punto para mí es el más importante. ¿Por qué la programación tiene que dejar de ser divertida y creativa? Al final del día, la mayoría de los programadores programan con pasión y corazón. Pero también, ¿será que se puede tener una prueba similar para otras disciplinas profesionales?
