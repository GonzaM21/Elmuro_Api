require_relative '../exceptions/costo_medicamento_no_especificado_error'
require_relative '../exceptions/costo_medicamento_negativo_error'
require_relative '../exceptions/costo_medicamento_cero_error'

class Compra
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  attr_accessor :id, :costo, :afiliado,
                :updated_on, :created_on

  validates :afiliado, presence: true
  validates :costo, presence: true
  def initialize(afiliado, costo, id, updated_on, created_on)
    @id = id
    @afiliado = afiliado
    @costo = costo
    @updated_on = updated_on
    @created_on = created_on

    raise CostoNoEspecificadoError if costo.nil?
    raise CostoMedicamentoCeroError if costo.zero?
    raise CostoMedicamentoNegativoError if costo.negative?
  end

  def attributes
    { id: @id,
      id_afiliado: id_afiliado,
      costo: @costo }
  end

  def fecha
    @updated_on
  end

  def id_afiliado
    @afiliado.id
  end
end
