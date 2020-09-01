require 'spec_helper'

describe 'VersionController' do
  it 'debe retornar 200 de status' do
    get '/version'
    expect(last_response).to be_ok
  end
end
