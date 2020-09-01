Dada('la prestación {string}') do |nombre|
  @request = {
    "nombre": nombre,
    "costo": 10
  }
  @response = Faraday.post(PRESTACIONES_URL, @request.to_json, header)
  expect(@response.status).to eq 201
  body = JSON.parse(@response.body)
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
end

Dado('el centro {string}') do |nombre|
  prng = Random.new
  @request = {
    "nombre": nombre,
    "latitud": prng.rand(100.0),
    "longitud": prng.rand(100.0)
  }
  @response = Faraday.post(CENTROS_URL, @request.to_json, header)
  expect(@response.status).to eq 201
  body = JSON.parse(@response.body)
  @id_centro = body['id'].to_s
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
end

Dado('que ofrece la prestación {string}') do |nombre|
  @response = Faraday.get(PRESTACIONES_URL, {}, header)
  body = (JSON.parse @response.body)['prestaciones']
  id_prestacion = 0
  body.each do |prestacion|
    id_prestacion = prestacion['id'] if prestacion['nombre'].eql?(nombre)
  end
  @request = {
    "prestacion": id_prestacion
  }
  path = CENTROS_URL + '/' + @id_centro + '/prestaciones'
  @response = Faraday.post(path, @request.to_json, header)
  expect(@response.status).to eq 201
  body = JSON.parse @response.body
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
end

Cuando('consulto por centros de {string}') do |nombre|
  path = CENTROS_URL + "?prestacion=#{CGI.escape(nombre)}"
  @response = Faraday.get(path, {}, header)
end

Entonces('obtengo los centros') do |table|
  centros_api = JSON.parse(@response.body)['centros']
  centros_esperados = table.raw
  centros_api.each do |centro|
    lista = [centro['nombre']]
    expect(centros_esperados).to include(lista)
  end
end

Entonces('obtengo una respuesta vacía') do
  centros_api = JSON.parse(@response.body)['centros']
  expect(centros_api).to eq([])
end

Entonces('obtengo un error por prestación inexistente') do
  expect(@response.status).to eq 400
  expect(@response.body).to include(PRESTACION_INEXISTENTE)
end
