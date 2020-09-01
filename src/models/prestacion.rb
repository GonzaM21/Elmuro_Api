require_relative '../exceptions/sin_costo_error'
class Prestacion
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON
  attr_accessor :nombre, :costo, :id,
                :updated_on, :created_on

  validates :costo, presence: true
  def initialize(nombre, costo, id = nil, updated_on = nil, created_on = nil)
    @nombre = nombre
    @costo = costo
    @id = id
    @updated_on = updated_on
    @created_on = created_on
    raise SinCostoError unless valid?
  end

  def attributes
    {
      id: @id,
      nombre: @nombre,
      costo: @costo
    }
  end

  def self.existe?(prestacion)
    raise PrestacionInexistente if prestacion.nil?

    prestacion
  end
end
