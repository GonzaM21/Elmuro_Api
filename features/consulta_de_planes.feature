# language: es
Característica: Consulta de planes

  Escenario: No hay planes disponibles
    Dado que no existen planes
    Cuando pido todos los planes
    Entonces no deberia haber planes en la respuesta

  Escenario: Existen planes
    Dado el plan con nombre "PlanJuventud"
    Dado el plan con nombre "PlanCaro"
    Cuando pido todos los planes
    Entonces la respuesta deberia tener el plan "PlanJuventud"
    Y la respuesta deberia tener el plan "PlanCaro"

  Escenario: Quiero consultar un plan en particular
    Dado el plan con nombre "PlanJuventud" y id 3
    Dado el plan con nombre "PlanCaro" y id 10
    Cuando pido información sobre el plan del "PLANJUVENTUD"
    Entonces la respuesta deberia tener la informacion del "PlanJuventud"

  Escenario: Deberia haber un error si se consulta un plan que no existe
    Cuando pido información sobre el plan del "PLANNOEXISTE"
    Entonces la respuesta deberia ser que no encontro el plan