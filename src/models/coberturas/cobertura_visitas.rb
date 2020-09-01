class CoberturaVisitas
  attr_accessor :limite, :copago, :nombre
  COBERTURA_VISITAS = 'CoberturaVisitas'.freeze
  def initialize(limite, copago = 0)
    @nombre = COBERTURA_VISITAS
    @limite = limite
    @copago = copago
  end
end
