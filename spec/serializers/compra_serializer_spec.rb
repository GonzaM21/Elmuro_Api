require 'spec_helper'
require_relative '../../src/models/afiliado'
require_relative '../../src/models/plan'

describe 'Compra' do
  it 'deberia mappear correctamente los campos del objeto' do
    plan = Plan.new('Plan Test', 0, nil, nil, nil, nil, nil)
    PlanRepository.new.save(plan)
    plan = PlanRepository.new.find_by_nombre('Plan Test')
    afiliado = Afiliado.new('Pepe', 50, plan, false, 15, 'Pepe', 10, nil, nil)
    compra = Compra.new(afiliado, 300, nil, nil, nil)
    compra_mappeada = compra.to_json
    expect(compra_mappeada).to eq(
      { id: compra.id,
        id_afiliado: afiliado.id,
        costo: compra.costo }.to_json
    )
  end
end
