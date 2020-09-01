require_relative '../exceptions/latitud_longitud_no_especificada'
require_relative '../exceptions/nombre_no_especificado'
require_relative '../exceptions/prestacion_repetida_error'
require_relative '../exceptions/centro_repetido_error'
require_relative '../exceptions/centro_inexistente'
require_relative '../exceptions/prestacion_inexistente_centro'
class Centro
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  attr_accessor :nombre, :id,
                :latitud, :longitud, :prestaciones,
                :updated_on, :created_on

  validates :nombre, presence: true
  validates :longitud, presence: true
  validates :latitud, presence: true
  def initialize(nombre, longitud, latitud, id, updated_on, created_on) #rubocop: disable all
    @id = id
    @nombre = nombre
    @latitud = latitud
    @longitud = longitud
    @prestaciones = []
    @updated_on = updated_on
    @created_on = created_on
    raise NombreNoEspecificado if !valid? && nombre.nil?
    raise LatitudLongitudNoEspecificada unless valid?
  end

  def agregar_prestacion(prestacion)
    verificar_existencia(prestacion)
    @prestaciones.append(prestacion)
  end

  def attributes
    {
      id: @id,
      nombre: @nombre,
      latitud: @latitud,
      longitud: @longitud
    }
  end

  def self.puede_crearse?(centro)
    raise CentroRepetidoError unless centro.nil?
  end

  def self.existe?(centro)
    raise CentroInexistente if centro.nil?

    centro
  end

  def verificar_no_existencia(prestacion)
    raise PrestacionInexistenteCentroError unless buscar_prestacion prestacion
  end

  private

  def verificar_existencia(nueva_prastacion)
    raise PrestacionRepetidaError if buscar_prestacion nueva_prastacion
  end

  def buscar_prestacion(prestacion_buscada)
    @prestaciones.each do |prestacion|
      return true if prestacion.id.eql?(prestacion_buscada.id)
    end
    false
  end
end
