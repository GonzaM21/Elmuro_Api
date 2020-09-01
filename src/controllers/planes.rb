require 'json'
require_relative '../exceptions/plan_repetido_error'
require_relative '../exceptions/plan_no_existe'
HealthApi::App.controllers :planes do
  RESTRICCION_CONYUGE = 'RestriccionConyuge'.freeze
  RESTRICCION_EDAD = 'RestriccionEdad'.freeze
  RESTRICCION_HIJOS = 'RestriccionHijos'.freeze

  JSON_ERROR = 'El body de la request invalido'.freeze
  PLAN_YA_EXISTE = 'El plan con ese nombre ya existe'.freeze
  get :index do
    status 200
    content_type 'application/json'
    if params[:nombre]
      plan = Plan.existe?(PlanRepository.new.buscar_por_nombre(params[:nombre]))
      plan.mappear.to_json
    else
      planes = PlanRepository.new.buscar_todos.map(&:mappear)
      { planes: planes }.to_json
    end
  rescue PlanNoExiste
    status 404
  end

  post :index do #rubocop: disable all
    content_type 'application/json'
    body = request.body.read
    json_data = JSON.parse body
    restricciones = []
    unless json_data['restricciones'].nil?
      factory = RestriccionFactory.new
      edad_min = json_data['restricciones']['edad_min']
      edad_max = json_data['restricciones']['edad_max']
      hijos_max = json_data['restricciones']['hijos_max']
      conyuge = json_data['restricciones']['conyuge']
      restricciones.append(factory.crear_restriccion(RESTRICCION_CONYUGE, edad_min, edad_max, hijos_max, conyuge))  #rubocop: disable all
      restricciones.append(factory.crear_restriccion(RESTRICCION_EDAD, edad_min, edad_max, hijos_max, conyuge))  #rubocop: disable all
      restricciones.append(factory.crear_restriccion(RESTRICCION_HIJOS, edad_min, edad_max, hijos_max, conyuge))  #rubocop: disable all
    end
    coberturas = []
    unless json_data['cobertura_visitas'].nil?
      copago = json_data['cobertura_visitas']['copago']
      infinito = json_data['cobertura_visitas']['limite'] == 'infinito'
      limite = json_data['cobertura_visitas']['limite'] unless infinito
    end
    cobertura_medicamentos = CoberturaMedicamentos.new json_data['cobertura_medicamentos']
    coberturas.append cobertura_medicamentos
    cobertura_visitas = CoberturaVisitas.new(limite, copago)
    coberturas.append cobertura_visitas
    repository = PlanRepository.new
    Plan.puede_crearse?(repository.buscar_por_nombre(json_data['nombre']))
    plan = Plan.new(json_data['nombre'], json_data['costo'], restricciones, coberturas,
                    nil, nil, nil)
    repository.save(plan)
    status 201
    plan.mappear.to_json
  rescue NombreVacioError
    status 400
  rescue JSON::ParserError
    status 400
    { message: JSON_ERROR }.to_json
  rescue PlanRepetidoError
    status 400
    { message: PLAN_YA_EXISTE }.to_json
  end
end
