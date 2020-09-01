# language: es

Característica: Alta de Prestación para centro

    Antecedentes:
        Dado el centro con nombre "Hospital Alemán"
        Y coordenadas geográficas latitud "-34.617670" y longitud "-58.368360"
        Y se registra el centro correctamente
        Y la prestación con nombre "Traumatología"
        Y el costo unitario de prestación $1200
        Y se registra la prestación correctamente

    Escenario: ACENPRES1 - Alta exitosa traumatología para Hospital Alemán
        Dado el centro con nombre "Hospital Alemán"
        Cuando se agrega la prestación "Traumatología" al centro
        Entonces se actualiza exitosamente

    Escenario: ACENPRES2 - Alta fallida por prestación inexistente
        Dado el centro con nombre "Hospital Alemán"
        Cuando se agrega la prestación "Cirugía" al centro
        Entonces se obtiene un error por prestación inexistente

    Escenario: ACENPRES3 - Alta fallida por prestación repetida
        Dado el centro con nombre "Hospital Alemán"
        Y se agrega la prestación "Traumatología"
        Y se actualiza el centro exitosamente
        Cuando se agrega la prestación "Traumatología" al centro
        Entonces se obtiene un error por prestación repetida

    Escenario: ACENPRES4 - Alta fallida por centro inexistente
        Dado el centro con nombre "Hospital Italiano" no almacenado
        Y se agrega la prestación "Traumatología" al centro
        Entonces se obtiene un error por centro inexistente
