# language: es

Característica: Registracion de afiliado

  Antecedentes:
    Dado el plan con nombre "PlanJuventud" con costo unitario $500
    Y restricciones edad min 15, edad max 20, hijos max 0, conyuge "no"
    Y cobertura de visitas con copago $0 y con límite 2
    Y cobertura de medicamentos 20%
    Y se registra el plan

  Escenario: RA1 - Registracion exitosa
    Dado el afiliado "hansolo" de 18 años, conyuge "no", hijos 0
    Cuando se registra al plan "PlanJuventud"
    Entonces obtiene un numero unico de afiliado

  Escenario: RA2 - Registracion fallida por edad incorrecta
    Dado el afiliado "hansolo" de 25 años, conyuge "no", hijos 0
    Cuando se registra al plan "PlanJuventud"
    Entonces obtiene un mensaje de error por edad incorrecta

  Escenario: RA4 - Registracion fallida por tener hijos
    Dado el afiliado "hansolo" de 19 años, conyuge "no", hijos 1
    Cuando se registra al plan "PlanJuventud"
    Entonces obtiene un mensaje de error por tener hijos

  Escenario: RA3 - Registracion fallida por tener conyuge
    Dado el afiliado "hansolo" de 19 años, conyuge "si", hijos 0
    Cuando se registra al plan "PlanJuventud"
    Entonces obtiene un mensaje de error por tener conyuge
