Cuando('creo el plan {string}') do |nombre|
  @request = {
    "nombre": nombre
  }
  @response = Faraday.post(PLANES_URL, @request.to_json, header)
  expect(@response.status).to eq 201
  body = JSON.parse(@response.body)
  expect(body.key?('id')).to eq true
  expect(body[:id]).not_to eq 0
end

Entonces('si consulto los planes existentes veo {string}') do |nombre|
  @plan_encontrado = PlanRepository.new.find_by_nombre(nombre)
  expect(@plan_encontrado.nombre).to eq nombre
end

Cuando('creo un plan sin nombre') do
  @request = {}
  @response = Faraday.post(PLANES_URL, @request.to_json, header)
end

Entonces('se me informa que el nombre es requerido para dar de alta el plan') do
  expect(@response.status).to eq 400
end

Dado('el plan con nombre {string}') do |nombre|
  @request = {
    "nombre": nombre
  }
  Faraday.post(PLANES_URL, @request.to_json, header)
end

Dado('el plan con nombre {string} y id {int}') do |nombre, id|
  plan = Plan.new(nombre, 0, nil, nil, id, nil, nil)
  PlanRepository.new.save(plan)
end
