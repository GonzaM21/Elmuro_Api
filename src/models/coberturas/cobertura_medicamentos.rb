class CoberturaMedicamentos
  attr_accessor :porcentaje, :nombre
  COBERTURA_MEDICAMENTOS = 'CoberturaMedicamentos'.freeze
  def initialize(porcentaje = 0)
    @porcentaje = porcentaje
    @nombre = COBERTURA_MEDICAMENTOS
  end
end
