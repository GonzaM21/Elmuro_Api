require_relative '../../exceptions/plan_no_acepta_conyuge'
require_relative '../../exceptions/plan_requiere_conyuge'
class RestriccionConyuge < Restriccion
  RESTRICCION_CONYUGE = 'RestriccionConyuge'.freeze
  attr_accessor :conyuge
  def initialize(conyuge)
    @nombre = RESTRICCION_CONYUGE
    @conyuge = conyuge
  end

  def validar(afiliado)
    raise PlanNoAceptaConyugeError if @conyuge == false && afiliado.conyuge
    raise PlanRequiereConyugeError if @conyuge && !afiliado.conyuge

    true
  end
end
