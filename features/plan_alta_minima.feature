# language: es

Característica: Alta de plan minima


  Escenario: Alta de plan solo con nombre
    Cuando creo el plan "Jovenes 310"
    Entonces si consulto los planes existentes veo "Jovenes 310"

  Escenario: Alta de plan solo sin nombre
    Cuando creo un plan sin nombre
    Entonces se me informa que el nombre es requerido para dar de alta el plan
