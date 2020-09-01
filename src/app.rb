module HealthApi
  class App < Padrino::Application
    register Padrino::Helpers
    enable :sessions

    before except: '/version' do
      halt 403, '{"message": "Api-key incorrecta o faltante"}' if
          !request.env.key?('HTTP_API_KEY') || !api_key_valid?(request.env['HTTP_API_KEY'])
    end
  end
end
