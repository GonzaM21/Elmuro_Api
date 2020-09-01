require 'spec_helper'
API_KEY = ENV['API_KEY'] || 'secret'

describe 'AfiliadosController' do
  it 'debe retornar 200 de status' do
    get '/afiliados', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY
    expect(last_response).to be_ok
  end

  it 'debe retornar 201 de status al guardar un diagnostico' do
    PlanRepository.new.save(Plan.new('Gran Plan', 100, [], nil, nil, nil, nil))
    plan = PlanRepository.new.find_by_nombre('Gran Plan')
    afiliado = Afiliado.new('Hugo', 25, plan, false, 0, nil, nil, nil, nil)
    AfiliadoRepository.new.save(afiliado)

    post '/afiliados/' + afiliado.id.to_s + '/diagnosticos_covid', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY

    expect(last_response.status).to eq 201
    body = JSON.parse(last_response.body)
    expect(body['id']).to eq afiliado.id
  end

  it 'Si existen 2 diagnosticos de covid al buscar todo me deberia traer ambos ' do
    PlanRepository.new.save(Plan.new('Gran Plan', 100, [], nil, nil, nil, nil))
    plan = PlanRepository.new.find_by_nombre('Gran Plan')
    afiliado_h = Afiliado.new('Hugo', 25, plan, false, 0, nil, nil, nil, nil)
    AfiliadoRepository.new.save(afiliado_h)

    afiliado_p = Afiliado.new('Pepe', 25, plan, false, 0, nil, nil, nil, nil)
    AfiliadoRepository.new.save(afiliado_p)

    post '/afiliados/' + afiliado_h.id.to_s + '/diagnosticos_covid', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY
    post '/afiliados/' + afiliado_p.id.to_s + '/diagnosticos_covid', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY

    get '/afiliados/diagnosticos_covid', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY
    expect(last_response.status).to eq 200
    diagnosticos = JSON.parse(last_response.body)['diagnosticos_covid']
    expect(diagnosticos.length).to eq 2
  end

  it 'debe retornar 400 de status al no exitir el afiliado' do
    post '/afiliados/0/diagnosticos_covid', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY
    expect(last_response.status).to eq 400
  end

  it 'Si devolver si existe el afiliado y pide su resumen' do
    PlanRepository.new.save(Plan.new('Gran Plan', 100, [], nil, nil, nil, nil))
    plan = PlanRepository.new.find_by_nombre('Gran Plan')
    afiliado = Afiliado.new('Hugo', 25, plan, false, 0, nil, nil, nil, nil)
    AfiliadoRepository.new.save(afiliado)

    get '/afiliados/' + afiliado.id.to_s + '/resumen', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY

    expect(last_response.status).to eq 200
  end

  it 'Si devolver un 400 si no existe afiliado y pide su resumen' do
    get '/afiliados/0/resumen', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY
    expect(last_response.status).to eq 400
  end
end
