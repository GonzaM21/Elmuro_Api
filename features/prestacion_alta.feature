# language: es

Característica: Alta de Prestacion

    Escenario: APRE1 - Alta exitosa de prestacion traumatología
        Dado la prestación con nombre "Traumatología"
        Y el costo unitario de prestación $1200
        Cuando se registra la prestación
        Entonces se registra exitosamente la prestacion

    Escenario: APRE2 - Alta fallida de prestacion odontología
        Dado la prestación con nombre "Odontología"
        Cuando se registra la prestación
        Entonces se obtiene un mensaje de error por no indicar costo

