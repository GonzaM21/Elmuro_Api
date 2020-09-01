# language: es

Característica: Alta de Centro

    Escenario: ACEN1 - Alta exitosa de centro
        Dado el centro con nombre "Hospital Alemán"
        Y coordenadas geográficas latitud "-34.617670" y longitud "-58.368360"
        Cuando se registra el centro
        Entonces se registra existosamente

    Escenario: ACEN2 - Alta fallida de centro
        Dado el centro con nombre "Hospital Alemán"
        Cuando se registra el centro
        Entonces se obtiene un mensaje de error por falta de coordenadas

    Escenario: ACEN3 - Alta fallida por nombre de centro repetido
        Dado el centro con nombre "Hospital Alemán" con coordenadas geográficas latitud "-34.617670" y longitud "-58.368360"
        Y otro el centro con nombre "Hospital Alemán"
        Cuando se registra el centro
        Entonces se obtiene un mensaje de error centro ya existente

    Escenario: ACEN6 - Alta fallida de centro sin nombre
        Dado que quiero crear el centro
        Y coordenadas geográficas latitud "-34.617670" y longitud "-58.368360"
        Cuando se registra el centro
        Entonces se obtiene un mensaje de error por falta de nombre

    Escenario: ACEN4 - Alta fallida por nombre de centro repetido
        Dado el centro con nombre "Hospital Alemán" con coordenadas geográficas latitud "-34.617670" y longitud "-58.368360"
        Y otro el centro con nombre "hospital aleman"
        Cuando se registra el centro
        Entonces se obtiene un mensaje de error centro ya existente

    Escenario: ACEN5 - Alta fallida por colision de coodeandas
        Dado el centro con nombre "Hospital Alemán" con coordenadas geográficas latitud "-34.617670" y longitud "-58.368360"
        Y otro el centro con nombre "Hospital Sirio" con coordenadas geográficas latitud "-34.111111" y longitud "-58.222222"
        Cuando se registra el centro
        Entonces se obtiene un mensaje de error centro ya existente
