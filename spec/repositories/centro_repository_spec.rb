require 'integration_spec_helper'
require_relative '../../src/exceptions/centro_repetido_error'
describe CentroRepository do
  let(:repository) { described_class.new }

  describe 'nuevo centro' do
    it 'Dado que guardo el centro Hospital Alemán si lo busco por el nombre deberia encontrarlo' do
      nombre = 'Hospital Alemán'
      centro = Centro.new(nombre, '-58.368360', '-34.617670', nil, nil, nil)
      described_class.new.save(centro)
      centro_encontrado = described_class.new.find_by_nombre(nombre)
      expect(centro_encontrado.nombre).to eq nombre
    end

    it 'Cuando guardo un centro y pregunto si existe a Centro debe devolver un error' do
      repository = described_class.new
      nombre = 'Hospital Alemán'
      centro = Centro.new(nombre, '-58.368360', '-34.617670', nil, nil, nil)
      repository.save(centro)
      expect { Centro.puede_crearse?(repository.buscar_por_nombre(nombre)) }.to raise_error(CentroRepetidoError) #rubocop: disable all
    end

    describe 'Existe prestancion en centro' do
      it 'deberia ser false existe_prestacion_en_centro si el centro Roca no tiene Traumatologia' do
        prestacion = Prestacion.new('Traumatologia', 300)
        PrestacionRepository.new.save(prestacion)
        repository = described_class.new
        nombre = 'Roca'
        centro = Centro.new(nombre, '-58.368360', '-34.617670', nil, nil, nil)
        repository.save(centro)
        expect(repository.existe_prestacion_en_centro?(centro.id, prestacion.id)).to be false
      end
    end
  end

  describe 'Buscar centro' do
    it 'Existente pasando nombre con distinto formato deberia encontrarlo' do
      repository = described_class.new
      nombre = 'Hospital Alemán'
      centro = Centro.new(nombre, '-58.368360', '-34.617670', nil, nil, nil)
      repository.save(centro)
      nombre_con_formato = 'hOspITAL Aleman'
      expect(repository.buscar_por_nombre(nombre_con_formato).nombre).to eq(nombre)
    end

    it 'Existente pasando coordendas similares' do
      repository = described_class.new
      nombre = 'Hospital Alemán'
      centro = Centro.new(nombre, '-58.368360', '-34.617670', nil, nil, nil)
      repository.save(centro)
      expect(repository.buscar_por_coordenadas('-58.11111', '-34.22222').nombre).to eq(nombre)
    end
  end
end
