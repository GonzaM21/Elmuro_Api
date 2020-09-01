require_relative '../../exceptions/no_alcanza_edad_minima'
require_relative '../../exceptions/supera_edad_maxima'
class RestriccionEdad < Restriccion
  RESTRICCION_EDAD = 'RestriccionEdad'.freeze
  attr_accessor :edad_min, :edad_max
  def initialize(edad_min, edad_max)
    @nombre = RESTRICCION_EDAD
    @edad_min = edad_min
    @edad_max = edad_max
  end

  def validar(afiliado)
    raise NoAlcanzaEdadMinimaError if @edad_min && @edad_min > afiliado.edad
    raise SuperaEdadMaximaError if @edad_max && @edad_max < afiliado.edad

    true
  end
end
