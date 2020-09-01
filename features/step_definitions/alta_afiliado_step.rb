Dado('el plan con nombre {string} con costo unitario ${int}') do |nombre, costo|
  @request = {
    "nombre": nombre,
    "costo": costo
  }
end

Dado('se registra el plan') do
  @response = Faraday.post(PLANES_URL, @request.to_json, header)
  expect(@response.status).to eq 201
  body = JSON.parse(@response.body)
  expect(body.key?('id')).to eq true
  expect(body['id']).not_to eq 0
  @plan_encontrado = PlanRepository.new.find_by_id(body['id'])
end

Dado('el afiliado {string} de {int} años, conyuge {string}, hijos {int}') do |nombre, edad, conyuge, hijos| #rubocop: disable all
  conyuge_bool = conyuge.eql?('si')
  @request = {
    "nombre": nombre,
    "edad": edad,
    "conyuge": conyuge_bool,
    "hijos": hijos
  }
end

Cuando('se registra al plan {string}') do |plan|
  @plan_encontrado = PlanRepository.new.find_by_nombre(plan)
  @request[:id_plan] = @plan_encontrado.id
  @response = Faraday.post(AFILIADOS_URL, @request.to_json, header)
end

Entonces('obtiene un numero unico de afiliado') do
  body = JSON.parse(@response.body)
  expect(body.key?('id')).to eq true
  expect(body[:id]).not_to eq 0
  expect(@response.status).to eq 201
  @afiliado_encontrado = AfiliadoRepository.new.find_by_nombre(@request[:nombre])
end

Entonces('obtiene un mensaje de error por edad incorrecta') do
  expect(
    JSON.parse(@response.body)['message']
  ).to eq 'La persona supera la edad maxima para el plan'
  expect(@response.status).to eq 400
end

Entonces('obtiene un mensaje de error por tener hijos') do
  expect(
    JSON.parse(@response.body)['message']
  ).to eq 'El plan no admite tener hijos'
  expect(@response.status).to eq 400
end

Entonces('obtiene un mensaje de error por tener conyuge') do
  expect(
    JSON.parse(@response.body)['message']
  ).to eq 'El Plan no acepta conyuge'
  expect(@response.status).to eq 400
end
