# language: es

Característica: Características de infraestructura

    """
    Esta feature es un requerimiento no funcional, por eso el gherking habla de cuestiones de técnicas de implementacion
    """
    Antecedentes:
        Dado el plan con nombre "PlanJuventud" con costo unitario $500
        Y se registra el plan

    Escenario: INFRA1 - Seguridad: los requests sin api-key deben ser rechazados
        Dado el afiliado "pepeinseguro"
        Cuando se registra pero no envia api-key
        Entonces obtiene error 403

    Escenario: INFRA2 - Trazabilidad de arfactos: el endpoint /version no requiere api-key
        Cuando se se ejecuta GET "/version"
        Entonces obtiene una version semántica de 3 números        