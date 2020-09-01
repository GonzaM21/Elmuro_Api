require 'spec_helper'
API_KEY = ENV['API_KEY'] || 'secret'

describe 'HealthController' do
  it 'deberia devolver ok' do
    get '/health', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY
    expect(last_response).to be_ok
  end
end
