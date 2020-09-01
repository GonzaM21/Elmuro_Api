Dado('el plan con {string} con costo unitario ${int}') do |nombre, costo|
  @request = {
    "nombre": nombre,
    "costo": costo
  }
end

Dado('el afiliado {string} afiliado a {string}') do |nombre, plan|
  @plan_encontrado = PlanRepository.new.find_by_nombre(plan)
  @afiliado = Afiliado.new(nombre, 24, @plan_encontrado, false, 0, nil, nil, nil, nil)
end

Cuando('consulta el resumen') do
  if @afiliado
    AfiliadoRepository.new.save(@afiliado)
    path = AFILIADOS_URL + "/#{@afiliado.id}/resumen"
  else
    path = AFILIADOS_URL + '/0/resumen'
  end
  @response = Faraday.get(path, {}, header)
  @resumen = JSON.parse @response.body
end

Entonces('el resumen no regista consumos') do
  json_data = JSON.parse @response.body
  expect(json_data['total_a_pagar']).to eq(@plan_encontrado.costo)
end

Dado('el usuario {string} que no esta afiliado') do |_string|
  @afiliado = nil
end

Dado('que registró una atención por la prestación {string} en {string}') do |prestacion_nombre, centro_nombre| # rubocop: disable all
  prestacion = PrestacionRepository.new.find_by_nombre(prestacion_nombre)
  centro = CentroRepository.new.find_by_nombre(centro_nombre)
  @id_prestacion = prestacion&.id
  @id_centro = centro&.id
  @request = {
    id_prestacion: @id_prestacion,
    id_centro: @id_centro
  }
  AfiliadoRepository.new.save(@afiliado)
  path = AFILIADOS_URL + "/#{@afiliado.id}/atenciones"
  @response = Faraday.post(path, @request.to_json, header)
end

Entonces('obtiene un error') do
  expect(@response.status).to eq 400
  json_data = JSON.parse @response.body
  expect(json_data['message']).to eq NO_AFILIADO_ERROR
end

Entonces('su saldo adicional es ${int}') do |valor|
  expect(@resumen['saldo_adicional']).to eq valor
end

Entonces('total a pagar es ${int}') do |valor|
  expect(@resumen['total_a_pagar']).to eq valor
end
