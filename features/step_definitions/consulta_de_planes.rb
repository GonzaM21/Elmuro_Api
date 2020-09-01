require 'json'

Dado('que no existen planes') do
  PlanRepository.new.delete_all
end

Cuando('pido todos los planes') do
  @response = Faraday.get(BASE_URL + '/planes', {}, header)
end

Entonces('la respuesta deberia tener la informacion del {string}') do |nombre|
  plan_encontrado = PlanRepository.new.find_by_nombre(nombre)
  plan_info = JSON.parse(@response.body)
  expect(@response.status).to eq 200
  expect(plan_encontrado.id).to eq(plan_info['id'])
  expect(plan_encontrado.nombre).to eq(plan_info['nombre'])
  expect(plan_encontrado.costo).to eq(plan_info['costo'])
end

Entonces('no deberia haber planes en la respuesta') do
  expect(@response.status).to eq 200
  expect(@response.body).to eq({ planes: [] }.to_json)
end

Entonces('la respuesta deberia tener el plan {string}') do |nombre|
  expect(@response.status).to eq 200
  response = JSON.parse(@response.body)
  nombre_planes = response['planes'].map { |plan| plan['nombre'] }
  expect(nombre_planes.include?(nombre)).to be(true)
end

Entonces('la respuesta deberia ser que no encontro el plan') do
  expect(@response.status).to eq 404
end

Cuando('pido información sobre el plan del {string}') do |nombre|
  @response = Faraday.get(BASE_URL + "/planes?nombre=#{nombre}", {}, header)
end
