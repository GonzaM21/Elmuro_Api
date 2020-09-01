require 'spec_helper'

describe Resumen do
  it 'deberia mappear correctamente los campos de resumen' do
    plan = Plan.new('Plan Nuevo', 500, nil, nil, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 50, plan, false, 0, 'Pepe', 10, nil, nil)
    resumen = described_class.new(afiliado)
    resumen_mappeado = resumen.to_json
    expect(resumen_mappeado).to eq(
      { nombre: afiliado.nombre,
        plan_nombre: plan.nombre,
        costo_plan: plan.costo,
        saldo_adicional: 0,
        total_a_pagar: plan.costo,
        detalle: [] }.to_json
    )
  end
end
