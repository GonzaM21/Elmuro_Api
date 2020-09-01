require 'spec_helper'

describe Centro do
  it 'deberia mappear correctamente los campos del objeto' do
    centro = described_class.new('Centro Nuevo', '-10.0', '-10.5', 10, nil, nil)
    centro_mappeado = centro.to_json
    expect(centro_mappeado).to eq(
      { id: 10,
        nombre: 'Centro Nuevo',
        latitud: '-10.5',
        longitud: '-10.0' }.to_json
    )
  end
end
