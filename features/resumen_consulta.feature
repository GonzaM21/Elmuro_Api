# language: es

Característica: Consulta de resumen

  Antecedentes:
    Dado el centro "Enfermeria del Castillo Negro"
    Y la prestación "Traumatología" y costo $1000
    Y la prestación "Clínica general" y costo $500
    Y el plan con "PlanCuervo" con costo unitario $500
    Y cobertura visitas 2, copago 0 y medicamentos 20%
    Y el plan con "PlanOso" con costo unitario $700
    Y cobertura visitas 2, copago 10 y medicamentos 80%
    Y el plan con "PlanMalo" con costo unitario $300
    Y cobertura visitas 2, copago 100 y medicamentos 0%

  Escenario: RES0.5 - Consulta de resumen con solo costo de plan
    Dado el afiliado "JonSnow" afiliado a "PlanCuervo"
    Cuando consulta el resumen
    Entonces el resumen no regista consumos

  Escenario: RES2 - Consulta de resumen fallido por persona no afiliada
    Dado el usuario "Tirion" que no esta afiliado
    Cuando consulta el resumen
    Entonces obtiene un error

  Escenario: RES3 - Consulta de resumen con todas las prestaciones cubiertas
    Dado el afiliado "JonSnow" afiliado a "PlanCuervo"
    Y que registró una atención por la prestación "Traumatología" en "Enfermeria del Castillo Negro"
    Y que registró una atención por la prestación "Clínica general" en "Enfermeria del Castillo Negro"
    Cuando consulta el resumen
    Entonces su saldo adicional es $0
    Y total a pagar es $500

  Escenario: RES4 - Consulta de resumen con dos prestaciones cubiertas y una no cubierta
    Dado el afiliado "JonSnow" afiliado a "PlanCuervo"
    Y que registró una atención por la prestación "Traumatología" en "Enfermeria del Castillo Negro"
    Y que registró una atención por la prestación "Clínica general" en "Enfermeria del Castillo Negro"
    Y que registró una atención por la prestación "Traumatología" en "Enfermeria del Castillo Negro"
    Cuando consulta el resumen
    Entonces su saldo adicional es $1000
    Y total a pagar es $1500

  Escenario: RES5 - Consulta de resumen con todas las prestaciones cubiertas con copago
    Dado el afiliado "Jorah" afiliado a "PlanOso"
    Y que registró una atención por la prestación "Traumatología" en "Enfermeria del Castillo Negro"
    Y que registró una atención por la prestación "Clínica general" en "Enfermeria del Castillo Negro"
    Cuando consulta el resumen
    Entonces su saldo adicional es $20
    Y total a pagar es $720

  Escenario: RES6 - Consulta de resumen con dos prestaciones cubiertas con copago y una prestación no cubierta
    Dado el afiliado "Jorah" afiliado a "PlanOso"
    Y que registró una atención por la prestación "Traumatología" en "Enfermeria del Castillo Negro"
    Y que registró una atención por la prestación "Clínica general" en "Enfermeria del Castillo Negro"
    Y que registró una atención por la prestación "Clínica general" en "Enfermeria del Castillo Negro"
    Cuando consulta el resumen
    Entonces su saldo adicional es $520
    Y total a pagar es $1220

  Escenario: RES7 - Consulta de resumen con compra de medicamentos
    Dado el afiliado "Jorah" afiliado a "PlanOso"
    Y que registró una compra de medicamentos por $1000
    Cuando consulta el resumen
    Entonces su saldo adicional es $200
    Y total a pagar es $900

  Escenario: RES7.5 - Consulta de resumen con compras varias de medicamentos
    Dado el afiliado "Jorah" afiliado a "PlanOso"
    Y que registró una compra de medicamentos por $1000
    Y que registró una compra de medicamentos por $500
    Y que registró una compra de medicamentos por $300
    Y que registró una compra de medicamentos por $700
    Cuando consulta el resumen
    Entonces su saldo adicional es $500
    Y total a pagar es $1200

  Escenario: RES7.6 - Consulta de resumen sin cobertura de medicamentos
    Dado el afiliado "Jorah" afiliado a "PlanMalo"
    Y que registró una compra de medicamentos por $1000
    Cuando consulta el resumen
    Entonces su saldo adicional es $1000
    Y total a pagar es $1300

  Escenario: RES8 - Consulta de resumen con compra de medicamentos y atenciones
    Dado el afiliado "Jorah" afiliado a "PlanOso"
    Y que registró una compra de medicamentos por $1000
    Y que registró una atención por la prestación "Traumatología" en "Enfermeria del Castillo Negro"
    Cuando consulta el resumen
    Entonces su saldo adicional es $210
    Y total a pagar es $910