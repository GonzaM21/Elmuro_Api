HealthApi::App.controllers :reset do
  post :index do
    unless RACK_ENV.eql?('production')
      # tablas que tienen FKs se tienen que vaciar primero
      DiagnosticoCovidRepository.new.delete_all
      CentroPrestacionRepository.new.delete_all
      AtencionRepository.new.delete_all
      CompraRepository.new.delete_all

      AfiliadoRepository.new.delete_all
      CentroRepository.new.delete_all
      PrestacionRepository.new.delete_all
      PlanRepository.new.delete_all

      content_type 'application/json'
      status 200
      { message: 'DATA SET RESTAURADOS' }.to_json
    end
  end
end
