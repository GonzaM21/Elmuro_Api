require 'spec_helper'

describe Plan do
  describe 'Plan con restricciones' do
    it 'deberia mappear correctamente los campos del objeto' do #rubocop: disable all
      restricciones = []
      restricciones.append(RestriccionConyuge.new(true))
      restricciones.append(RestriccionEdad.new(40, 60))
      restricciones.append(RestriccionHijos.new(3))
      coberturas = []
      cobertura_medicamentos = CoberturaMedicamentos.new 0
      cobertura_visitas = CoberturaVisitas.new(nil, 0)
      coberturas.append cobertura_medicamentos
      coberturas.append cobertura_visitas
      plan = described_class.new('Plan Nuevo', 500, restricciones,
                                 coberturas, 10, nil, nil)
      plan_mappeado = plan.mappear.to_json
      expect(plan_mappeado).to eq(
        { nombre: 'Plan Nuevo',
          costo: 500,
          id: 10,
          cobertura_visitas: {
            copago: 0,
            limite: nil
          },
          cobertura_medicamentos: 0,
          restricciones: {
            edad_min: 40,
            edad_max: 60,
            hijos_max: 3,
            conyuge: true
          } }.to_json
      )
    end
  end

  describe 'Plan con coberturas ' do
    it 'deberia mappear correctamente los campos del objeto' do #rubocop: disable all
      restricciones = []
      restricciones.append(RestriccionConyuge.new(nil))
      restricciones.append(RestriccionEdad.new(nil, nil))
      restricciones.append(RestriccionHijos.new(nil))
      coberturas = []
      cobertura_medicamentos = CoberturaMedicamentos.new 40
      cobertura_visitas = CoberturaVisitas.new(3, 60)
      coberturas.append cobertura_medicamentos
      coberturas.append cobertura_visitas
      plan = described_class.new('Plan Nuevo', 500,
                                 restricciones, coberturas, 10, nil, nil)
      plan_mappeado = plan.mappear.to_json
      expect(plan_mappeado).to eq(
        { nombre: 'Plan Nuevo',
          costo: 500,
          id: 10,
          cobertura_visitas: {
            copago: 60,
            limite: 3
          },
          cobertura_medicamentos: 40,
          restricciones: {
            edad_min: nil,
            edad_max: nil,
            hijos_max: nil,
            conyuge: nil
          } }.to_json
      )
    end
  end
end
