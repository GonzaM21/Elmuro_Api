Dado('el afiliado {string}') do |nombre|
  @afiliado = Afiliado.new(nombre, 24, @plan_encontrado, false, 0, nil, nil, nil, nil)
end

Cuando('compra medicamentos por ${int}') do |costo|
  AfiliadoRepository.new.save(@afiliado)
  @request = {
    "costo": costo
  }
  path = AFILIADOS_URL + "/#{@afiliado.id}/compras"
  @response = Faraday.post(path, @request.to_json, header)
end

Dado('que registró una compra de medicamentos por ${int}') do |costo|
  AfiliadoRepository.new.save(@afiliado)
  @request = {
    "costo": costo
  }
  path = AFILIADOS_URL + "/#{@afiliado.id}/compras"
  @response = Faraday.post(path, @request.to_json, header)
end

Entonces('se registra la compra con un identificador único') do
  expect(@response.status).to eq 201
  body = JSON.parse(@response.body)['compra']
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
  expect(body['id_afiliado']).to eq @afiliado.id
  expect(body['costo']).not_to eq @request['costo']
end

Entonces('se envía un mensaje de compra invalida, costo negativo') do
  expect(@response.status).to eq 400
  json_data = JSON.parse @response.body
  expect(json_data['message']).to eq COSTO_NEGATIVO
end

Cuando('compra medicamentos sin costo') do
  AfiliadoRepository.new.save(@afiliado)
  @request = {}
  path = AFILIADOS_URL + "/#{@afiliado.id}/compras"
  @response = Faraday.post(path, @request.to_json, header)
end

Entonces('se envía un mensaje de compra invalida, costo no especificado') do
  expect(@response.status).to eq 400
  json_data = JSON.parse @response.body
  expect(json_data['message']).to eq COSTO_NO_ESPECIFICADO
end

Entonces('se envía un mensaje de compra invalida, costo no puede ser cero') do
  expect(@response.status).to eq 400
  json_data = JSON.parse @response.body
  expect(json_data['message']).to eq MEDICAMENTO_SIN_COSTO
end

Cuando('se atiende por {string} en el centro {string}') do |prestacion_nombre, centro_nombre|
  prestacion = PrestacionRepository.new.find_by_nombre(prestacion_nombre)
  @id_prestacion = nil
  @id_prestacion = prestacion.id unless prestacion.nil?
  centro = CentroRepository.new.find_by_nombre(centro_nombre)
  @id_centro = nil
  @id_centro = centro.id unless centro.nil?
  @request = {
    id_prestacion: @id_prestacion,
    id_centro: @id_centro
  }
  if @afiliado
    AfiliadoRepository.new.save(@afiliado)
    path = AFILIADOS_URL + "/#{@afiliado.id}/atenciones"
  else
    path = AFILIADOS_URL + '/0/atenciones'
  end
  @response = Faraday.post(path, @request.to_json, header)
end

Entonces('se registra la prestación con un identificador único') do
  expect(@response.status).to eq 201
  json_data = JSON.parse @response.body
  expect(json_data['atencion'].key?('id')).to eq true
  expect(json_data['atencion']['id']).not_to eq 0
end

Dado('que el usuario {string} no está afiliado') do |_string|
  @afiliado = nil
end

Entonces('obtiene un error por no estar afiliado') do
  expect(@response.status).to eq 400
  json_data = JSON.parse @response.body
  expect(json_data['message']).to eq NO_AFILIADO_ERROR
end

Entonces('obtiene un error por prestación no existente') do
  expect(@response.status).to eq 400
  json_data = JSON.parse @response.body
  expect(json_data['message']).to eq PRESTACION_INEXISTENTE
end

Entonces('obtiene un error por centro no existen') do
  expect(@response.status).to eq 400
  json_data = JSON.parse @response.body
  expect(json_data['message']).to eq CENTRO_INEXISTENTE
end

Entonces('obtiene un error por prestacion no ofrecida en el centro') do
  expect(@response.status).to eq 400
  json_data = JSON.parse @response.body
  expect(json_data['message']).to eq PRESTACION_NO_EXISTE_EN_CENTRO
end

Dado('la prestación {string} y costo ${int}') do |prestacion, precio|
  @request = {
    "nombre": prestacion,
    "costo": precio
  }
  @response = Faraday.post(PRESTACIONES_URL, @request.to_json, header)
  expect(@response.status).to eq 201
  body = JSON.parse(@response.body)
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
  @id_prestacion = body['id']

  @request = {
    prestacion: @id_prestacion
  }

  path = CENTROS_URL + '/' + @id_centro + '/prestaciones'
  @response = Faraday.post(path, @request.to_json, header)
  expect(@response.status).to eq 201
  body = JSON.parse @response.body
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
end

Dado('cobertura visitas {int}, copago {int} y medicamentos {int}%') do |limite, copago, cobertura_medicamentos| # rubocop: disable all
  @request[:cobertura_visitas] = {
    copago: copago,
    limite: limite
  }
  @request[:cobertura_medicamentos] = cobertura_medicamentos
  @response = Faraday.post(PLANES_URL, @request.to_json, header)
  expect(@response.status).to eq 201
  body = JSON.parse(@response.body)
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
  @plan_encontrado = PlanRepository.new.find_by_id(body['id'])
end

Dado('existe la prestacion {string}') do |nombre|
  @request = {
    "nombre": nombre,
    "costo": 100
  }
  @response = Faraday.post(PRESTACIONES_URL, @request.to_json, header)
  expect(@response.status).to eq 201
  body = JSON.parse(@response.body)
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
end
