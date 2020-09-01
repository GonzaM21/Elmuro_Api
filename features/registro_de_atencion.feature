# language: es

Característica: Registro de atenciones médicas

    Antecedentes:
        Dado el centro "Enfermeria del Castillo Negro"
        Y la prestación "Traumatología" y costo $1000
        Y el plan con "PlanCuervo" con costo unitario $500
        Y cobertura visitas 2, copago 0 y medicamentos 20%
        Y el plan con "PlanOso" con costo unitario $7000
        Y cobertura visitas 3, copago 10 y medicamentos 800%

    Escenario: REGAM1 - Registro exitoso
        Dado el afiliado "JonSnow"
        Cuando se atiende por "Traumatología" en el centro "Enfermeria del Castillo Negro"
        Entonces se registra la prestación con un identificador único

    Escenario: REGAM2 - Registro fallido por usuario no afiliado
        Dado que el usuario "tirion" no está afiliado
        Cuando se atiende por "Traumatología" en el centro "Enfermeria del Castillo Negro"
        Entonces obtiene un error por no estar afiliado

    Escenario: REGAM3 - Registro fallido por prestación no existente
        Dado el afiliado "JonSnow"
        Cuando se atiende por "Pediatría" en el centro "Enfermeria del Castillo Negro"
        Entonces obtiene un error por prestación no existente

    Escenario: REGAM4 - Registro fallido por centro no existente
        Dado el afiliado "JonSnow"
        Cuando se atiende por "Traumatología" en el centro "Enfermeria de La Roca"
        Entonces obtiene un error por centro no existen

    Escenario: REGAM5 - Registro fallido por prestación no ofrecida en el centro
        Dado el afiliado "JonSnow"
        Y existe la prestacion "Pediatría"
        Cuando se atiende por "Pediatría" en el centro "Enfermeria del Castillo Negro"
        Entonces obtiene un error por prestacion no ofrecida en el centro

    Escenario: REGAM6 - Registro de compra de medicamentos
        Dado el afiliado "JonSnow"
        Cuando compra medicamentos por $1000
        Entonces se registra la compra con un identificador único

    Escenario: REGAM7 - Registro de compra de medicamentos invalido
        Dado el afiliado "JonSnow"
        Cuando compra medicamentos por $-1000
        Entonces se envía un mensaje de compra invalida, costo negativo

    Escenario: REGAM8 - Registro de compra de medicamentos invalido
        Dado el afiliado "JonSnow"
        Cuando compra medicamentos sin costo
        Entonces se envía un mensaje de compra invalida, costo no especificado

    Escenario: REGAM9 - Registro de compra de medicamentos invalido
        Dado el afiliado "JonSnow"
        Cuando compra medicamentos por $0
        Entonces se envía un mensaje de compra invalida, costo no puede ser cero

