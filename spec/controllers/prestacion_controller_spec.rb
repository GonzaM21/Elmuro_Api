require 'spec_helper'
require_relative '../../src/exceptions/prestacion_inexistente'
API_KEY = ENV['API_KEY'] || 'secret'

describe 'PrestacionesController' do
  it 'debe retornar 200 de status' do
    get '/prestaciones', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY
    expect(last_response).to be_ok
  end
end
