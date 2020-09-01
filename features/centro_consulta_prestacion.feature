# language: es

Característica: Consulta de centro por prestacion

    Antecedentes:
        Dada la prestación "Traumatología"
        Dada la prestación "Neurología"
        Dado el centro "Enfermeria del Castillo Negro"
        Y que ofrece la prestación "Traumatología"
        Dado el centro "Hospital Alemán"
        Y que ofrece la prestación "Traumatología"
        Y que ofrece la prestación "Neurología"

    Escenario: CCP1 - Consulta por prestación que tiene solo un centro
        Cuando consulto por centros de "Neurología"
        Entonces obtengo los centros
        | Hospital Alemán |

    Escenario: CCP2 - Consulta por prestación que no tiene ningun centro
        Dada la prestación "Odontología"
        Cuando consulto por centros de "Odontología"
        Entonces obtengo una respuesta vacía

    Escenario: CCP3 - Consulta por prestacion inexistente
        Cuando consulto por centros de "chatajería"
        Entonces obtengo un error por prestación inexistente

    Escenario: CCP4 - Consulta por prestación que tienen varios centro
        Cuando consulto por centros de "Traumatología"
        Entonces obtengo los centros
            | Enfermeria del Castillo Negro |
            | Hospital Alemán               |