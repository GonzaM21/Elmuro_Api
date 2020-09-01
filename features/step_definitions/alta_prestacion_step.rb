Dado('la prestación con nombre {string}') do |nombre|
  @request = {
    "nombre": nombre
  }
end

Dado('el costo unitario de prestación ${int}') do |costo|
  @request['costo'] = costo
end

Cuando('se registra la prestación') do
  @response = Faraday.post(PRESTACIONES_URL, @request.to_json, header)
end

Entonces('se obtiene un mensaje de error por no indicar costo') do
  json_data = JSON.parse @response.body
  expect(json_data['message']).to eq MENSAJE_ERROR_SIN_COSTO
end

Entonces('se registra exitosamente la prestacion') do
  expect(@response.status).to eq 201
  body = JSON.parse(@response.body)
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
end
