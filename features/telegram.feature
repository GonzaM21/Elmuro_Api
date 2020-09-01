# language: es

@wip
Característica: Flujo completo via telegram

    Escenario: TELE4 - Registración exitosa de afiliado de 18 años, sin hijos, sin conyuge
        Dado el plan con nombre "PlanJuventud" con costo unitario $500
        Y restricciones edad min 15, edad max 20, hijos max 0, conyuge "no"
        Cuando envio "/registracion PlanJuventud, Miriam Perez, 18"
        Entonces recibo "Registración exitosa"


