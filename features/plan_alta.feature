# language: es

Característica: Alta de Plan

  Escenario: APLA0.1 - Alta exitosa de PlanJuventud
    Dado el plan con nombre "PlanJuventud" con costo unitario $500
    Cuando se registra el plan
    Entonces se registra exitosamente

  Escenario: APLA0.5 - Alta exitosa de PlanJuventud con restricciones
    Dado el plan con nombre "PlanJuventud" con costo unitario $500
    Y restricciones edad min 15, edad max 20, hijos max 0, conyuge "no"
    Cuando se registra el plan
    Entonces se registra exitosamente
    Y la restriccion de edad minima para "PlanJuventud" es 15
    Y la restriccion de edad máxima para "PlanJuventud" es 20
    Y la restriccion de cantidad maxima de hijos para "PlanJuventud" es 0
    Y "PlanJuventud" no acepta conyuge

  Escenario: APLA0.6 - Alta exitosa de PlanFamiliar con restricciones
    Dado el plan con nombre "PlanJuventud" con costo unitario $500
    Y restricciones edad min 30, edad max 65, hijos max 3, conyuge "si"
    Cuando se registra el plan
    Entonces se registra exitosamente
    Y la restriccion de edad minima para "PlanJuventud" es 30
    Y la restriccion de edad máxima para "PlanJuventud" es 65
    Y la restriccion de cantidad maxima de hijos para "PlanJuventud" es 3
    Y "PlanJuventud" acepta conyuge


  Escenario: APLA1 - Alta exitosa de PlanJuventud
    Dado el plan con nombre "PlanJuventud" con costo unitario $500
    Y restricciones edad min 15, edad max 20, hijos max 0, admite conyuge "no"
    Y cobertura de visitas con copago $0 y con límite 2
    Y cobertura de medicamentos 20%
    Cuando se registra el plan
    Entonces se registra exitosamente


  Escenario: APLA2 - Alta exitosa de plan 310
    Dado el plan con nombre "Plan310" con costo unitario $1000
    Y restricciones edad min 21, edad max 99, hijos max 0, admite conyuge "no"
    Y cobertura de visitas con copago $100 y con límite 4
    Y cobertura de medicamentos 30%
    Cuando se registra el plan
    Entonces se registra exitosamente


  Escenario: APLA3 - Alta exitosa de plan familiar
    Dado el plan con nombre "PlanFamiliar" con costo unitario $2000
    Y restricciones edad min 15, edad max 99, hijos max 6, admite conyuge "si"
    Y cobertura de visitas con copago $50 y con límite infinito
    Y cobertura de medicamentos 50%
    Cuando se registra el plan
    Entonces se registra exitosamente

  Escenario: APLA4 - Alta exitosa de plan pareja
    Dado el plan con nombre "PlanPareja" con costo unitario $1700
    Y restricciones edad min 20, edad max 99, hijos max 0, requiere conyuge "si"
    Y cobertura de visitas con copago $250 y con límite infinito
    Y cobertura de medicamentos 10%
    Cuando se registra el plan
    Entonces se registra exitosamente

  Escenario: APL5 - Plan repetido
    Dado que existe el plan con nombre "Plan Salud"
    Cuando se agrega el plan con nombre "Plan Salud"
    Entonces se me informa que el plan ya existe
