require 'spec_helper'
require_relative '../../src/models/plan'

describe Afiliado do
  it 'deberia mappear correctamente los campos del objeto' do
    plan = Plan.new('Plan Test', 0, nil, nil, nil, nil, nil)
    PlanRepository.new.save(plan)
    plan = PlanRepository.new.find_by_nombre('Plan Test')
    afiliado = described_class.new('Pepe', 50, plan, false, 15, 'Pepe', 10, nil, nil)
    afiliado_mappeado = afiliado.to_json
    expect(afiliado_mappeado).to eq(
      {
        id: 10,
        nombre: 'Pepe',
        edad: 50,
        id_plan: plan.id,
        conyuge: false,
        hijos: 15,
        usuario: 'Pepe'
      }.to_json
    )
  end
end
