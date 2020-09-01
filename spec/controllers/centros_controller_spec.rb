require 'spec_helper'
API_KEY = ENV['API_KEY'] || 'secret'

describe 'CentrosController' do
  it 'debe retornar 200 de status' do
    get '/centros', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY
    expect(last_response).to be_ok
  end

  it 'debe retornar 200 de status al obtener las prestaciones del centro' do
    centro = Centro.new('test', -10, -10, nil, nil, nil)
    CentroRepository.new.save(centro)

    get '/centros/' + centro.id.to_s + '/prestaciones', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY

    expect(last_response.status).to eq 200
    body = JSON.parse(last_response.body)
    expect(body['prestaciones']).to eq []
  end

  it 'debe retornar 400 de status al obtener las prestaciones del centro' do
    get '/centros/0/prestaciones', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY
    expect(last_response.status).to eq 400
  end

  it 'debe retornar 200 si quiero obtener los centros de una prestacion' do
    centro = Centro.new('test', -10, -10, nil, nil, nil)
    prestacion = Prestacion.new('Prestacion', 100, nil, nil, nil)
    PrestacionRepository.new.save(prestacion)
    centro.agregar_prestacion(prestacion)
    CentroRepository.new.save(centro)
    CentroRepository.new.actualizar_prestaciones(centro)

    get '/centros?prestacion=Prestacion', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY

    expect(last_response.status).to eq 200
    body = JSON.parse(last_response.body)
    expect(body['centros'][0]['id']).to eq centro.id
  end

  it 'debe retornar 400 si quiero obtener los centros de una prestacion que no existe' do
    get '/centros?prestacion=flasa', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY
    expect(last_response.status).to eq 400
  end
end
