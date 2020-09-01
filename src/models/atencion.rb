class Atencion
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  attr_accessor :afiliado, :prestacion, :centro,
                :id, :updated_on, :created_on

  validates :afiliado, presence: true
  validates :prestacion, presence: true
  validates :centro, presence: true
  def initialize(afiliado, prestacion, centro, id, updated_on, created_on) # rubocop: disable all
    @afiliado = afiliado
    @prestacion = prestacion
    @centro = centro
    @id = id
    @updated_on = updated_on
    @created_on = created_on
  end

  def costo
    @prestacion.costo
  end

  def fecha
    @created_on
  end

  def nombre_prestacion
    @prestacion.nombre
  end

  def nombre_centro
    @centro.nombre
  end

  def attributes
    { id: @id,
      afiliado: @afiliado,
      id_centro: id_centro,
      id_prestacion: id_prestacion,
      fecha: @created_on }
  end

  def id_centro
    @centro.id
  end

  def id_prestacion
    @prestacion.id
  end
end
