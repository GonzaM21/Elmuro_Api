Entonces('se registra exitosamente') do
  expect(@response.status).to eq 201
  body = JSON.parse(@response.body)
  expect(body.key?('id')).to eq true
  expect(body[:id]).not_to eq 0
  expect(body.key?('restricciones')).to eq true
  expect(body.key?('cobertura_medicamentos')).to eq true
  expect(body.key?('cobertura_visitas')).to eq true
end

Dado('restricciones edad min {int}, edad max {int}, hijos max {int}, conyuge {string}') do |edad_min, edad_max, hijos_max, conyuge| #rubocop: disable all
  @request = {
    nombre: @request[:nombre],
    costo: @request[:costo],
    restricciones: {
      edad_min: edad_min,
      edad_max: edad_max,
      hijos_max: hijos_max,
      conyuge: conyuge == 'si'
    }
  }
end

Entonces('la restriccion de edad minima para {string} es {int}') do |plan, edad_min|
  plan = PlanRepository.new.find_by_nombre(plan)
  plan.restricciones.each do |restriccion|
    expect(restriccion.edad_min).to eq edad_min if restriccion.nombre.equal?(RESTRICCION_EDAD)
  end
end

Entonces('la restriccion de edad máxima para {string} es {int}') do |plan, edad_max|
  plan = PlanRepository.new.find_by_nombre(plan)
  plan.restricciones.each do |restriccion|
    expect(restriccion.edad_max).to eq edad_max if restriccion.nombre.equal?(RESTRICCION_EDAD)
  end
end

Entonces('la restriccion de cantidad maxima de hijos para {string} es {int}') do |plan, hijos_max|
  plan = PlanRepository.new.find_by_nombre(plan)
  plan.restricciones.each do |restriccion|
    expect(restriccion.hijos_max).to eq hijos_max if restriccion.nombre.equal?(RESTRICCION_HIJOS)
  end
end

Entonces('{string} no acepta conyuge') do |plan|
  plan = PlanRepository.new.find_by_nombre(plan)
  plan.restricciones.each do |restriccion|
    expect(restriccion.conyuge).to be(false) if restriccion.nombre.equal?(RESTRICCION_CONYUGE)
  end
end

Entonces('{string} acepta conyuge') do |plan|
  plan = PlanRepository.new.find_by_nombre(plan)
  plan.restricciones.each do |restriccion|
    expect(restriccion.conyuge).to be(true) if restriccion.nombre.equal?(RESTRICCION_CONYUGE)
  end
end

Dado('restricciones edad min {int}, edad max {int}, hijos max {int}, admite conyuge {string}') do |edad_min, edad_max, hijos_max, conyuge| #rubocop: disable all
  conyuge_value = false if conyuge == 'no'
  @request = {
    nombre: @request[:nombre],
    costo: @request[:costo],
    restricciones: {
      edad_min: edad_min,
      edad_max: edad_max,
      hijos_max: hijos_max,
      conyuge: conyuge_value
    }
  }
end

Dado('restricciones edad min {int}, edad max {int}, hijos max {int}, requiere conyuge {string}') do |edad_min, edad_max, hijos_max, conyuge| #rubocop: disable all
  requiere = true if conyuge == 'si'
  @request = {
    nombre: @request[:nombre],
    costo: @request[:costo],
    restricciones: {
      edad_min: edad_min,
      edad_max: edad_max,
      hijos_max: hijos_max,
      conyuge: requiere
    }
  }
end

Dado('cobertura de visitas con copago ${int} y con límite infinito') do |copago|
  @request[:cobertura_visitas] = {
    copago: copago,
    limite: 'infinito'
  }
end

Dado('cobertura de visitas con copago ${int} y con límite {int}') do |copago, limite|
  @request[:cobertura_visitas] = {
    copago: copago,
    limite: limite
  }
end

Dado('cobertura de medicamentos {int}%') do |cobertura_medicamentos|
  @request[:cobertura_medicamentos] = cobertura_medicamentos
end

Dado('que existe el plan con nombre {string}') do |nombre|
  @request = {
    "nombre": nombre,
    "costo": 100
  }
  @response = Faraday.post(PLANES_URL, @request.to_json, header)
  expect(@response.status).to eq 201
end

Cuando('se agrega el plan con nombre {string}') do |nombre|
  @request = {
    "nombre": nombre,
    "costo": 100
  }
  @response = Faraday.post(PLANES_URL, @request.to_json, header)
end

Entonces('se me informa que el plan ya existe') do
  expect(@response.status).to eq 400
  body = JSON.parse(@response.body)
  expect(body['message']).to eq(PLAN_YA_EXISTEN)
end
