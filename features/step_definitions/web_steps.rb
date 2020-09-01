And('the response message is {string}') do |message|
  response = JSON.parse(@response.body)
  expect(response['message']).to eq(message)
end

Then('the response status is {int}') do |status|
  expect(@response.status).to eq(status)
end

Cuando('se registra pero no envia api-key') do
  @request ||= {}
  @response = Faraday.post(AFILIADOS_URL, @request.to_json)
end

Entonces('obtiene error {int}') do |_int|
  expect(@response.status).to eq(403)
  parsed_response = JSON.parse(@response.body)
  expect(parsed_response['message']).to eq 'Api-key incorrecta o faltante'
end

Cuando('se se ejecuta GET {string}') do |version|
  @response = Faraday.get(version, @request.to_json)
end

Entonces('obtiene una version semántica de {int} números') do |_int|
  expect(@response.body).to eq Version.current
end
