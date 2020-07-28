---
image: https://dimg.kinduff.com/Jugando con el portapapeles con javascript.jpeg
title: Jugando con el portapapeles con javascript
date: 2013-02-28
description: Es posible realizar modificaciones al portapapeles del usuario cuando ejecuta la función de copiar algún texto. Te explico cómo se hace.
---

Seguramente en varios sitios de música o artículos haz notado cómo tu portapapeles es modificado para agregar una nota publicitaria promocionando el sitio. Esto es posible gracias a la función `oncopy`.

## ¿Cómo funciona?

Es posible ejecutar una función cuando se detecta el copiado, cortado o pegado en un documento de la siguiente manera:

```javascript
document.addEventListener('copy', function(e) {
  console.log('copiado activado')
  e.clipboardData.setData('text/plain', 'Hola mundo!')
  e.preventDefault()
})
```

Solo hay que recordar que es muy molesto meterse con el portapapeles de alguien, ya sea modificandolo o agregandole publicidad o un mensaje de copyright.

Las posibilidades son infinitas: podrías enviar una consulta con Ajax a un contador de "copy" para medir cuantas veces o qué parte del documento se está copiando, o bien, mostrar un mensaje de algún tipo como experiencia de usuario, etc.

Cuentame: **¿Cómo lo usarías tu?**
