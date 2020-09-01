require 'json'
require_relative '../exceptions/prestacion_inexistente'

HealthApi::App.controllers :prestaciones do
  PRESTACION_INEXISTENTE = 'La prestacion no existe'.freeze
  MENSAJE_ERROR_SIN_COSTO = 'No se indica costo'.freeze
  JSON_ERROR = 'El body de la request invalido'.freeze
  post :index do
    content_type 'application/json'
    body = request.body.read
    json_data = JSON.parse body
    @prestacion = Prestacion.new(json_data['nombre'], json_data['costo'])
    @repository = PrestacionRepository.new
    @repository.save(@prestacion)
    status 201
    @prestacion.to_json
  rescue SinCostoError
    status 400
    { message: MENSAJE_ERROR_SIN_COSTO }.to_json
  rescue JSON::ParserError
    status 400
    { message: JSON_ERROR }.to_json
  end

  get :index do
    content_type 'application/json'
    prestaciones = PrestacionRepository.new.buscar_todos
    status 200
    { prestaciones: prestaciones }.to_json
  end
end
