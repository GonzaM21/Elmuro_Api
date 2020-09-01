class RestriccionFactory
  RESTRICCION_CONYUGE = 'RestriccionConyuge'.freeze
  RESTRICCION_EDAD = 'RestriccionEdad'.freeze
  RESTRICCION_HIJOS = 'RestriccionHijos'.freeze
  def crear_restriccion(nombre, edad_min, edad_max, hijos_max, conyuge)
    case nombre
    when RESTRICCION_CONYUGE
      RestriccionConyuge.new(conyuge)
    when RESTRICCION_EDAD
      RestriccionEdad.new(edad_min, edad_max)
    when RESTRICCION_HIJOS
      RestriccionHijos.new(hijos_max)
    end
  end
end
