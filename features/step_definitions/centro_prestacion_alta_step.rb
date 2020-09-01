Cuando('se agrega la prestación {string} al centro') do |prestacion_nombre|
  @response = Faraday.get(PRESTACIONES_URL, {}, header)
  body = (JSON.parse @response.body)['prestaciones']
  id_prestacion = 0
  body.each do |prestacion|
    id_prestacion = prestacion['id'] if prestacion['nombre'].eql?(prestacion_nombre)
  end
  @request[:prestacion] = id_prestacion
end

Entonces('se actualiza exitosamente') do
  path = CENTROS_URL + '/' + @id_centro + '/prestaciones'
  @response = Faraday.post(path, @request.to_json, header)
  expect(@response.status).to eq 201
  body = JSON.parse @response.body
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
end

Entonces('se obtiene un error por prestación inexistente') do
  path = CENTROS_URL + '/' + @id_centro + '/prestaciones'
  @response = Faraday.post(path, @request.to_json, header)
  expect(@response.status).to eq 400
  expect(@response.body).to include(PRESTACION_INEXISTENTE)
end

Dado('se agrega la prestación {string}') do |prestacion_nombre|
  @response = Faraday.get(PRESTACIONES_URL, {}, header)
  body = (JSON.parse @response.body)['prestaciones']
  id_prestacion = 0
  body.each do |prestacion|
    id_prestacion = prestacion['id'] if prestacion['nombre'].eql?(prestacion_nombre)
  end
  @request[:prestacion] = id_prestacion
end

Dado('se actualiza el centro exitosamente') do
  path = CENTROS_URL + '/' + @id_centro + '/prestaciones'
  @response = Faraday.post(path, @request.to_json, header)
  centro_id = (JSON.parse @response.body)['id']
  expect(@response.status).to eq 201
  expect(centro_id.to_s).to eq @id_centro
end

Entonces('se obtiene un error por prestación repetida') do
  path = CENTROS_URL + '/' + @id_centro + '/prestaciones'
  @response = Faraday.post(path, @request.to_json, header)
  expect(@response.status).to eq 400
  expect(@response.body).to include(CENTRO_PRESTACION_EXISTENTE)
end

Entonces('se obtiene un error por centro inexistente') do
  path = CENTROS_URL + '/' + @id_centro + '/prestaciones'
  @response = Faraday.post(path, @request.to_json, header)
  expect(@response.status).to eq 400
  expect(@response.body).to include(CENTRO_INEXISTENTE)
end

Dado('se registra el centro correctamente') do
  @response = Faraday.post(CENTROS_URL, @request.to_json, header)
  expect(@response.status).to eq 201
  body = JSON.parse @response.body
  @id_centro = body['id'].to_s
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
end

Dado('se registra la prestación correctamente') do
  @response = Faraday.post(PRESTACIONES_URL, @request.to_json, header)
  expect(@response.status).to eq 201
  body = JSON.parse(@response.body)
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
end

Dado('el centro con nombre {string} no almacenado') do |_centro|
  @id_centro = '0'
end
