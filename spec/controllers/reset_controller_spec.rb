require 'spec_helper'
API_KEY = ENV['API_KEY'] || 'secret'

describe 'ResetController' do
  it 'debe retornar 200 de status' do
    post '/reset', '{}', 'Content-Type' => 'application/json', 'HTTP_API_KEY' => API_KEY
    expect(last_response).to be_ok
  end
end
