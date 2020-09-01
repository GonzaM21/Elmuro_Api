HealthApi::App.controllers :version do
  get :index do
    Version.current
  end
end
