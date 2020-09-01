Dado('el centro con nombre {string}') do |nombre|
  @request = {
    "nombre": nombre
  }
end

Dado('coordenadas geográficas latitud {string} y longitud {string}') do |latitud, longitud|
  @request[:latitud] = latitud
  @request[:longitud] = longitud
end

Cuando('se registra el centro') do
  @response = Faraday.post(CENTROS_URL, @request.to_json, header)
end

Entonces('se registra existosamente') do
  expect(@response.status).to eq 201
  body = JSON.parse(@response.body)
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
end

Entonces('se obtiene un mensaje de error por falta de coordenadas') do
  expect(@response.status).to eq 400
  expect(@response.body).to include(COORDENADAS_NO_ESPECIFICADAS)
end

Entonces('se obtiene un mensaje de error centro ya existente') do
  expect(@response.status).to eq 400
  expect(@response.body).to include(CENTRO_REPETIDO)
end

Dado('el centro con nombre {string} con coordenadas geográficas latitud {string} y longitud {string}') do |nombre, latitud, longitud| #rubocop: disable all
  @request = {
    "nombre": nombre,
    "latitud": latitud,
    "longitud": longitud
  }
  @response = Faraday.post(CENTROS_URL, @request.to_json, header)
  expect(@response.status).to eq 201
  body = JSON.parse(@response.body)
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
end

Dado('otro el centro con nombre {string}') do |nombre|
  @request = {
    "nombre": nombre,
    "latitud": '-0.00',
    "longitud": '-0.00'
  }
end

Dado('que quiero crear el centro') do
  @request = {}
end

Entonces('se obtiene un mensaje de error por falta de nombre') do
  expect(@response.status).to eq 400
  expect(@response.body).to include(NOMBRE_NO_ESPECIFICADO)
end

Dado('otro el centro con nombre {string} con coordenadas geográficas latitud {string} y longitud {string}') do |nombre, latitud, longitud| #rubocop: disable all
  @request = {
    "nombre": nombre,
    "latitud": latitud,
    "longitud": longitud
  }
end
