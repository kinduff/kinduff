---
title: Mis notas de Golang
date: 2022-08-01
description: >-
  Algunas notas que tomé cuando estaba aprendiendo Golang.
---

> Estas son notas que tomé cuando aprendía Golang. Me parece interesante compartirlas. No son muchas y están mezcladas conforme aprendía. Estaré actualizando este post conforme tenga mas.

- La documentación de Go se puede encontrar aquí [https://golang.org/ref/spec](https://golang.org/ref/spec).
- Hay un plugin para VSCode buenísimo que ayuda a escribir programas compatibles. Muy útil. [Go for VSCode](https://marketplace.visualstudio.com/items?itemName=golang.go).
- Está el playground oficial de Go [https://play.golang.org](https://play.golang.org), pero también esta este que me gusta mas [https://goplay.tools](https://goplay.tools).
- Las variables, dependiendo del tipo, se inicializan con un valor inicial, por ejemplo:
  - `var x int` donde `x == 0`
  - `var f float32` donde `x == 0`
  - `var s string` donde `s == ""`
  - Lo mismo aplica para structs
- La longitud de una cadena puede ser calculada con `len`:
  - `len("abc") == 3`
-  Si se quiere tomar cierto caracter de un string, no podemos hacer esto: `"hello"[0]` porque nos regresará la secuencia en bytes. Podemos hacer lo siguiente: `string("hello"[0])` que lo convertirá en ASCII.
- Se puede usar slicing, por ejemplo:

```go
"smith"[2:] == "ith"
"smith"[:4] == "smit"
"smith"[2:4] == "it"
"smith"[:] == "smith"
```

-  Una comparación interesante: `"abc" < "abcd" == true`.
-  Los string so inmutables, pero las secuencias de bytes no.

```go
bytes := []byte{'a', 'b', 'c'}
string(bytes) == "abc"
bytes[0] = 'z'
string(bytes) == "zbc"
```

- La interpolación funciona a través de [fmt](https://golang.org/pkg/fmt) el cual es un paquete opcional que hay que incluir si lo queremos utilizar. Se interpola a utilizando `fmt.Sprintf` en donde hay que especificar el tipo a interpolar.

```go
fmt.Sprintf("hello %s", "world")
fmt.Sprintf("hello %q", "world") == "hello \"world\""
fmt.Sprintf("%d and %0.2f", 3, 4.5589) == "3 and 4.56"
```

- Para compilar se puede hacer de forma sencilla, esto creará un binario llamado `example`.

```go
$ go build main.go -o example
```

- Hay mucha documentación de cómo optimizar tus binarios, acá hay una documentación excelente sobre esto: [Reduce binary size](https://github.com/xaionaro/documentation/blob/master/golang/reduce-binary-size.md).
- Para parseo y generación de JSON, los `Structs` son muy útiles, aquí una utilidad para generarlos automáticamente: [JSON-to-Go](https://mholt.github.io/json-to-go/).
- En un _hash_ como el de Ruby o Javascript, se tiene que definir el tipo de la llave y del valor, si se tienen anidaciones, también se tiene que definir.
- `interface{}` es un tipo que da flexibilidad, vale la pena verlo con profundidad.
- Las funciones pueden modificar variables si utilizamos el ampersand `&` para enviar la dirección de una variable y un asterisco `*` para utilizar un puntero.
- Las funciones deben de especificar el tipo de variable que van a regresar, estas pueden ser nombradas y omitidas al final de la función si así lo queremos.
- Podemos omitir el typeado de una variable de forma manual utilizando el shorthand `:=`, por ejemplo:

```go
var i int = 1
var x := 1
```

- Tiene un concepto de dependencias muy interesante. Tu propio proyecto, si quieres tener trackeo de dependencias, se convierte en una dependencia para si mismo. Por ejemplo, mi proyecto en GitHub `github.com/kinduff/my_package` requerirá llamar a sus propias dependencias.

```go
import "github.com/kinduff/my_package/config"
```
