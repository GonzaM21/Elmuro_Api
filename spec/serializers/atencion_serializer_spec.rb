require 'spec_helper'
require_relative '../../src/models/afiliado'
require_relative '../../src/models/plan'
require_relative '../../src/models/compra'

describe Atencion do
  it 'deberia mappear correctamente los campos del objeto' do #rubocop: disable all
    PlanRepository.new.save(Plan.new('Gran Plan', 100, nil, nil, nil, nil, nil))
    plan = PlanRepository.new.find_by_nombre('Gran Plan')
    afiliado = Afiliado.new('Pepe', 50, plan, false, 15, 'Pepe', 10, nil, nil)
    centro = Centro.new('Hospital Alemán', '-34.617670', '-58.368360', 10, nil, nil)
    prestacion = Prestacion.new('Odontologia', 500, 10)
    atencion = described_class.new(afiliado, prestacion, centro, nil, nil, nil)
    expect(atencion.to_json).to eq(
      { id: atencion.id,
        afiliado: afiliado,
        id_centro: 10,
        id_prestacion: 10,
        fecha: atencion.created_on }.to_json
    )
  end
end
