require_relative '../exceptions/plan_no_existe'

class Afiliado
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  attr_accessor :nombre, :id,
                :updated_on, :created_on,
                :conyuge, :hijos,
                :edad, :plan,
                :usuario

  validates :nombre, presence: true
  def initialize(nombre, edad, plan, conyuge, hijos, usuario, id, updated_on, created_on) #rubocop: disable all
    @id = id
    @nombre = nombre
    @updated_on = updated_on
    @created_on = created_on
    @conyuge = conyuge
    @hijos = hijos
    @edad = edad
    @plan = plan
    @usuario = usuario

    @plan&.error_al_afiliar_persona?(self)
  end

  def attributes
    {
      id: @id,
      nombre: @nombre,
      edad: @edad,
      id_plan: id_plan,
      conyuge: @conyuge,
      hijos: @hijos,
      usuario: @usuario
    }
  end

  def id_plan
    plan.id
  end

  def self.existe?(afiliado)
    raise NoAfiliadoError if afiliado.nil?

    afiliado
  end
end
