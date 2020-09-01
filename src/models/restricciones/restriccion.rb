class Restriccion
  attr_accessor :nombre
  def initialize
    @nombre = 'RestriccionAbstracta'
  end

  def validar(_afiliado)
    raise 'Sub clase debe implmentarlo'
  end
end
