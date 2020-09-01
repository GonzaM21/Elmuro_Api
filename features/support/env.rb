require 'faraday'
require 'json'
require 'rspec/expectations'
require 'rspec'
require 'rack/test'
require File.expand_path(File.dirname(__FILE__) + '/../../config/boot')

BASE_URL = 'http://localhost:3000'.freeze
API_KEY = ENV['API_KEY'] || 'secret'

if ENV['BASE_URL']
  BASE_URL = ENV['BASE_URL']
else
  include Rack::Test::Methods # rubocop:disable all

  def app
    Rack::Builder.new do
      map '/' do
        run HealthApi::App
      end
    end
  end
end

Around do |_scenario, block|
  DB.transaction(rollback: :always, auto_savepoint: true) { block.call }
end

def header
  { 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY }
end

AFILIADOS_URL = BASE_URL + '/afiliados'
PLANES_URL = BASE_URL + '/planes'
PRESTACIONES_URL = BASE_URL + '/prestaciones'
CENTROS_URL = BASE_URL + '/centros'

COORDENADAS_NO_ESPECIFICADAS = 'Coordenadas no especificadas'.freeze
MENSAJE_ERROR_SIN_COSTO = 'No se indica costo'.freeze
CENTRO_REPETIDO = 'Centro ya existente'.freeze
NOMBRE_NO_ESPECIFICADO = 'Nombre no especificado'.freeze
NO_AFILIADO_ERROR = 'El id no corresponde a un afilliado'.freeze
PRESTACION_INEXISTENTE = 'La prestacion no existe'.freeze
CENTRO_INEXISTENTE = 'El centro no existe'.freeze
CENTRO_PRESTACION_EXISTENTE = 'El centro ya tiene asociada esa prestacion'.freeze
COSTO_NEGATIVO = 'El costo del medicamento no puede ser negativo'.freeze
COSTO_NO_ESPECIFICADO = 'El costo del medicamento no fue especificado'.freeze
MEDICAMENTO_SIN_COSTO = 'El costo del medicamento debe ser un numero positivo'.freeze
PRESTACION_NO_EXISTE_EN_CENTRO = 'La prestacion no existe en el centro'.freeze
PLAN_YA_EXISTEN = 'El plan con ese nombre ya existe'.freeze

RESTRICCION_CONYUGE = 'RestriccionConyuge'.freeze
RESTRICCION_EDAD = 'RestriccionEdad'.freeze
RESTRICCION_HIJOS = 'RestriccionHijos'.freeze
