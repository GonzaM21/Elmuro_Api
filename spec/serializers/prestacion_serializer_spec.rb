require 'spec_helper'

describe Prestacion do
  it 'deberia mappear correctamente los campos del objeto' do
    prestacion = described_class.new('Prestacion Nuevo', 500, 10)
    prestacion_mappeado = prestacion.to_json
    expect(prestacion_mappeado).to eq(
      { id: 10,
        nombre: 'Prestacion Nuevo',
        costo: 500 }.to_json
    )
  end
end
