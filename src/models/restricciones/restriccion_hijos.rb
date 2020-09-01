require_relative '../../exceptions/supera_maximo_de_hijos'
require_relative '../../exceptions/plan_no_admite_hijos'
require_relative '../../exceptions/no_alcanza_minimo_de_hijos'
class RestriccionHijos < Restriccion
  RESTRICCION_HIJOS = 'RestriccionHijos'.freeze
  attr_accessor :hijos_max
  def initialize(cantidad_maxima)
    @nombre = RESTRICCION_HIJOS
    @hijos_max = cantidad_maxima
  end
  def validar(afiliado) # rubocop: disable all
    raise PlanNoAdmiteHijosError if !@hijos_max.nil? && @hijos_max.zero? && afiliado.hijos.positive?
    raise SuperaMaximoDeHijosError if @hijos_max && @hijos_max < afiliado.hijos
    raise NoAlcanzaMinimoDeHijosError if @hijos_max&.positive? && afiliado.hijos.zero?

    true
  end
end
