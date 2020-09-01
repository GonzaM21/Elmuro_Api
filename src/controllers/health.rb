HealthApi::App.controllers :health do
  get :index do
    status 200
    'ok'
  end
end
