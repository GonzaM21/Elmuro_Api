require 'spec_helper'
API_KEY = ENV['API_KEY'] || 'secret'

describe 'PlanesController' do
  it 'should return a 200 status' do
    get '/planes', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY
    expect(last_response).to be_ok
  end

  it 'debe devolver 400 de status si no existe la plan' do
    get '/planes?nombre=noexiste', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY
    expect(last_response.status).to eq 404
  end

  it 'debe devolver 200 de status si existe la plan' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 0
    coberturas.append cobertura_medicamentos
    cobertura_visitas = CoberturaVisitas.new(0, 0)
    coberturas.append cobertura_visitas

    plan = Plan.new('nombre', 1000, nil, coberturas, nil, nil, nil)
    PlanRepository.new.save(plan)
    get '/planes?nombre=nombre', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY

    expect(last_response.status).to eq 200
    body = JSON.parse(last_response.body)
    expect(body['id']).to eq plan.id
  end
end
