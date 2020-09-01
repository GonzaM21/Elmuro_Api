require_relative '../exceptions/nombre_vacio_error'
require_relative '../exceptions/plan_no_acepta_conyuge'
require_relative '../exceptions/plan_requiere_conyuge'
require_relative '../exceptions/no_alcanza_minimo_de_hijos'
require_relative '../exceptions/supera_maximo_de_hijos'
require_relative '../exceptions/no_alcanza_edad_minima'
require_relative '../exceptions/plan_no_admite_hijos'
require_relative '../exceptions/supera_edad_maxima'
require_relative '../exceptions/plan_repetido_error'
class Plan
  COBERTURA_MEDICAMENTOS = 'CoberturaMedicamentos'.freeze
  COBERTURA_VISITAS = 'CoberturaVisitas'.freeze
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  attr_accessor :nombre, :id,
                :updated_on, :created_on,
                :costo, :restricciones,
                :coberturas

  validates :nombre, presence: true
  def initialize(nombre, costo, restricciones , coberturas, id, updated_on, created_on) #rubocop: disable all
    @id = id
    @nombre = nombre
    @costo = costo
    @updated_on = updated_on
    @created_on = created_on
    @restricciones = restricciones
    @coberturas = coberturas
    raise NombreVacioError unless valid?
  end

  def mappear
    {
      nombre: @nombre,
      costo: @costo,
      id: @id,
      cobertura_visitas: cobertura_visitas_map,
      cobertura_medicamentos: cobertura_medicamentos_porcentaje,
      restricciones: restricciones_json
    }
  end

  def cobertura_medicamentos
    buscar_cobertura(COBERTURA_MEDICAMENTOS)
  end

  def cobertura_medicamentos_porcentaje
    cobertura_medicamentos.porcentaje
  end

  def cobertura_visitas
    buscar_cobertura(COBERTURA_VISITAS)
  end

  def cobertura_visitas_limite
    cobertura_visitas.limite
  end

  def cobertura_visitas_copago
    cobertura_visitas.copago
  end

  def error_al_afiliar_persona?(afiliado)
    return if @restricciones.nil?
    return if @restricciones.length.zero?

    @restricciones.each do |restriccion|
      restriccion.validar(afiliado)
    end
  end

  def tiene_restricciones?
    return false if @restricciones.nil?

    true
  end

  def self.existe?(plan)
    raise PlanNoExiste if plan.nil?

    plan
  end

  def self.puede_crearse?(plan)
    raise PlanRepetidoError unless plan.nil?
  end

  private

  def buscar_cobertura(nombre)
    @coberturas.each do |cobertura|
      return cobertura if cobertura.nombre.equal?(nombre)
    end
  end

  def agregar_restricciones(restricciones)
    @restricciones.each do |restriccion|
      case restriccion.nombre
      when RESTRICCION_EDAD
        restricciones['edad_min'] =  restriccion.edad_min
        restricciones['edad_max'] =  restriccion.edad_max
      when RESTRICCION_CONYUGE
        restricciones['conyuge'] = restriccion.conyuge
      when RESTRICCION_HIJOS
        restricciones['hijos_max'] = restriccion.hijos_max
      end
    end
  end

  def restricciones_json
    restricciones = {
      edad_min: nil,
      edad_max: nil,
      hijos_max: nil,
      conyuge: nil
    }
    agregar_restricciones(restricciones)
    restricciones
  end

  def cobertura_visitas_map
    {
      copago: cobertura_visitas_copago,
      limite: cobertura_visitas_limite
    }
  end
end
