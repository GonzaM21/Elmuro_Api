require_relative '../exceptions/plan_no_existe'
require_relative '../../src/exceptions/no_afiliado_error'
require_relative '../exceptions/plan_no_acepta_conyuge'
require_relative '../exceptions/plan_requiere_conyuge'
require_relative '../exceptions/no_alcanza_minimo_de_hijos'
require_relative '../exceptions/supera_maximo_de_hijos'
require_relative '../exceptions/supera_edad_maxima'
require_relative '../exceptions/no_alcanza_edad_minima'
require_relative '../exceptions/plan_no_admite_hijos'
require_relative '../exceptions/costo_medicamento_negativo_error'
require_relative '../exceptions/costo_medicamento_no_especificado_error'
require_relative '../exceptions/costo_medicamento_cero_error'
require_relative '../../src/exceptions/prestacion_inexistente'
require_relative '../../src/exceptions/centro_inexistente'
require_relative '../exceptions/prestacion_inexistente_centro'
require_relative '../repositories/centro_repository'
require_relative '../models/resumen'

HealthApi::App.controllers :afiliados do
  JSON_ERROR = 'El body de la request invalido'.freeze
  NO_AFILIADO_ERROR = 'El id no corresponde a un afilliado'.freeze
  COSTO_NEGATIVO = 'El costo del medicamento no puede ser negativo'.freeze
  COSTO_NO_ESPECIFICADO = 'El costo del medicamento no fue especificado'.freeze
  MEDICAMENTO_SIN_COSTO = 'El costo del medicamento debe ser un numero positivo'.freeze
  PRESTACION_INEXISTENTE = 'La prestacion no existe'.freeze
  CENTRO_INEXISTENTE = 'El centro no existe'.freeze
  PRESTACION_NO_EXISTE_EN_CENTRO = 'La prestacion no existe en el centro'.freeze

  post :index do # rubocop: disable Metrics/BlockLength
    content_type 'application/json'
    body = request.body.read
    begin
      json_data = JSON.parse body
      status 400
      plan = Plan.existe?(PlanRepository.new.find_by_id(json_data['id_plan']))
      afiliado = Afiliado.new(
        json_data['nombre'], json_data['edad'], plan,
        json_data['conyuge'], json_data['hijos'], json_data['usuario'],
        nil, nil, nil
      )
      repository = AfiliadoRepository.new
      repository.save(afiliado)
      status 201
      afiliado.to_json
    rescue PlanNoExiste
      { message: 'El plan no existe', codigo: '1' }.to_json
    rescue PlanNoAceptaConyugeError
      { message: 'El Plan no acepta conyuge', codigo: '2' }.to_json
    rescue PlanRequiereConyugeError
      { message: 'El Plan requiere conyuge', codigo: '3' }.to_json
    rescue SuperaMaximoDeHijosError
      { message: 'La persona supera la cantidad maxima de hijos', codigo: '4' }.to_json
    rescue NoAlcanzaMinimoDeHijosError
      { message: 'La persona no alcanza la cantidad minima de hijos', codigo: '5' }.to_json
    rescue NoAlcanzaEdadMinimaError
      { message: 'La persona no alcanza la edad minima para el plan', codigo: '6' }.to_json
    rescue SuperaEdadMaximaError
      { message: 'La persona supera la edad maxima para el plan', codigo: '7' }.to_json
    rescue PlanNoAdmiteHijosError
      { message: 'El plan no admite tener hijos', codigo: '8' }.to_json
    rescue JSON::ParserError
      { message: JSON_ERROR }.to_json
    end
  end

  get :index do
    status 200
    content_type 'application/json'
    afiliados = AfiliadoRepository.new.buscar_todos
    { afiliados: afiliados }.to_json
  end

  get '/:id/resumen' do
    status 200
    content_type 'application/json'
    afiliado = Afiliado.existe?(AfiliadoRepository.new.find_by_id(params[:id].to_i))

    compras_medicamentos = AfiliadoRepository.new.buscar_compras_del_mes(afiliado)
    atenciones = AfiliadoRepository.new.buscar_atenciones_del_mes(afiliado)
    resumen = Resumen.new(afiliado, compras: compras_medicamentos, atenciones: atenciones)
    resumen.to_json

  rescue NoAfiliadoError
    status 400
    { message: NO_AFILIADO_ERROR }.to_json
  end

  post '/:id/compras' do
    status 201
    content_type 'application/json'
    afiliado = Afiliado.existe?(AfiliadoRepository.new.find_by_id(params[:id].to_i))

    json_data = JSON.parse(request.body.read)
    compra = Compra.new(afiliado, json_data['costo'], nil, nil, nil)

    AfiliadoRepository.new.agregar_compra(compra)
    { compra: compra }.to_json
  rescue NoAfiliadoError
    status 400
    { message: NO_AFILIADO_ERROR }.to_json
  rescue CostoNoEspecificadoError
    status 400
    { message: COSTO_NO_ESPECIFICADO }.to_json
  rescue CostoMedicamentoCeroError
    status 400
    { message: MEDICAMENTO_SIN_COSTO }.to_json
  rescue CostoMedicamentoNegativoError
    status 400
    { message: COSTO_NEGATIVO }.to_json
  rescue JSON::ParserError
    status 400
    { message: JSON_ERROR }.to_json
  end

  post '/:id/atenciones' do
    status 201
    content_type 'application/json'
    afiliado = Afiliado.existe?(AfiliadoRepository.new.find_by_id(params[:id].to_i))
    json_data = JSON.parse(request.body.read)
    centro = Centro.existe?(CentroRepository.new.find_by_id(json_data['id_centro']))
    prestacion = Prestacion.existe?(PrestacionRepository.new.find_by_id(json_data['id_prestacion']))

    centro.verificar_no_existencia prestacion

    atencion = Atencion.new(afiliado, prestacion, centro, nil, nil, nil)
    AfiliadoRepository.new.agregar_atencion(atencion)
    atencion = AfiliadoRepository.new.buscar_atencion_por_id(atencion.id)
    { atencion: atencion }.to_json
  rescue NoAfiliadoError
    status 400
    { message: NO_AFILIADO_ERROR }.to_json
  rescue PrestacionInexistente
    status 400
    { message: PRESTACION_INEXISTENTE }.to_json
  rescue CentroInexistente
    status 400
    { message: CENTRO_INEXISTENTE }.to_json
  rescue PrestacionInexistenteCentroError
    status 400
    { message: PRESTACION_NO_EXISTE_EN_CENTRO }.to_json
  rescue JSON::ParserError
    status 400
    { message: JSON_ERROR }.to_json
  end

  post '/:id/diagnosticos_covid' do
    status 201
    content_type 'application/json'
    afiliado = Afiliado.existe?(AfiliadoRepository.new.find_by_id(params[:id].to_i))
    AfiliadoRepository.new.guardar_diagnostico_covid(afiliado)
    afiliado.to_json
  rescue NoAfiliadoError
    status 400
    { message: NO_AFILIADO_ERROR }.to_json
  end

  get '/diagnosticos_covid' do
    status 200
    content_type 'application/json'
    diagnosticos = AfiliadoRepository.new.buscar_todos_diagnosticos_covid

    { diagnosticos_covid: diagnosticos }.to_json
  end
end
