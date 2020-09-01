require_relative '../../src/exceptions/centro_repetido_error'
require_relative '../../src/exceptions/prestacion_inexistente'
require_relative '../../src/exceptions/centro_inexistente'
require_relative '../../src/exceptions/prestacion_repetida_error'
require_relative '../../src/models/centro'

HealthApi::App.controllers :centros do
  COORDENADAS_NO_ESPECIFICADAS = 'Coordenadas no especificadas'.freeze
  CENTRO_REPETIDO = 'Centro ya existente'.freeze
  NOMBRE_NO_ESPECIFICADO = 'Nombre no especificado'.freeze
  JSON_ERROR = 'El body de la request invalido'.freeze
  PRESTACION_INEXISTENTE = 'La prestacion no existe'.freeze
  CENTRO_INEXISTENTE = 'El centro no existe'.freeze
  CENTRO_PRESTACION_EXISTENTE = 'El centro ya tiene asociada esa prestacion'.freeze

  post :index do
    content_type 'application/json'
    body = request.body.read
    json_data = JSON.parse body
    repositorio = CentroRepository.new
    Centro.puede_crearse?(repositorio.buscar_por_nombre(json_data['nombre']))
    Centro.puede_crearse?(repositorio.buscar_por_coordenadas(json_data['longitud'], json_data['latitud']))
    centro = Centro.new(json_data['nombre'],
                        json_data['longitud'],
                        json_data['latitud'],
                        nil, nil, nil)
    repositorio.save(centro)
    status 201
    centro.to_json
  rescue LatitudLongitudNoEspecificada
    status 400
    { message: COORDENADAS_NO_ESPECIFICADAS }.to_json
  rescue CentroRepetidoError
    status 400
    { message: CENTRO_REPETIDO }.to_json
  rescue NombreNoEspecificado
    status 400
    { message: NOMBRE_NO_ESPECIFICADO }.to_json
  rescue JSON::ParserError
    status 400
    { message: JSON_ERROR }.to_json
  end

  get :index do
    status 200
    content_type 'application/json'

    if params[:prestacion]
      prestacion = Prestacion.existe?(PrestacionRepository.new.find_by_nombre(params['prestacion']))
      centros = PrestacionRepository.new.obtener_centros(prestacion)
    else
      centros = CentroRepository.new.buscar_todos
    end
    { centros: centros }.to_json
  rescue PrestacionInexistente
    status 400
    { message: PRESTACION_INEXISTENTE }.to_json
  end

  get '/:id/prestaciones' do
    status 200
    content_type 'application/json'
    centro = Centro.existe?(CentroRepository.new.find_by_id(params[:id]))

    { prestaciones: centro.prestaciones }.to_json
  rescue CentroInexistente
    status 400
    { message: CENTRO_INEXISTENTE }.to_json
  end

  post '/:id/prestaciones' do #rubocop: disable all
    content_type 'application/json'
    json_data = JSON.parse(request.body.read)
    centro = Centro.existe?(CentroRepository.new.find_by_id(params[:id]))

    prestacion = Prestacion.existe?(PrestacionRepository.new.find_by_id(json_data['prestacion']))
    centro.agregar_prestacion(prestacion)
    CentroRepository.new.actualizar_prestaciones(centro)
    status 201
    centro.to_json
  rescue PrestacionInexistente
    status 400
    { message: PRESTACION_INEXISTENTE }.to_json
  rescue CentroInexistente
    status 400
    { message: CENTRO_INEXISTENTE }.to_json
  rescue PrestacionRepetidaError
    status 400
    { message: CENTRO_PRESTACION_EXISTENTE }.to_json
  rescue JSON::ParserError
    status 400
    { message: JSON_ERROR }.to_json
  end
end
