require 'integration_spec_helper'
require_relative '../../src/exceptions/prestacion_repetida_error'
describe CentroPrestacionRepository do
  let(:table) { described_class.new }

  describe 'nueva prestacion en un centro' do
    it 'Dado que guardo la prestacion Odontologia en el hospital alemán' do #rubocop: disable all
      centro = Centro.new('Hospital Alemán', '-58.368360', '-34.617670', nil, nil, nil)
      CentroRepository.new.save(centro)

      prestacion = Prestacion.new('Odontologia', 0)
      PrestacionRepository.new.save(prestacion)
      centro.agregar_prestacion(prestacion)

      described_class.new.save(centro.id, prestacion.id)
      prestacion_centro_encontrado = described_class.new.buscar_por_id_prestacion(prestacion.id) #rubocop: disable all
      expect(prestacion_centro_encontrado[0].prestaciones[0].id).to eq prestacion.id
      expect(prestacion_centro_encontrado[0].id).to eq centro.id
    end

    it 'Dado que guardo la prestacion Odontologia y Kinesiologia en el hospital alemán y busco por centro' do #rubocop: disable all
      centro = Centro.new('Hospital Alemán', '-58.368360', '-34.617670', nil, nil, nil)
      CentroRepository.new.save(centro)

      prestacion = Prestacion.new('Odontologia', 0)
      PrestacionRepository.new.save(prestacion)
      prestacion2 = Prestacion.new('Kinesiologia', 0)
      PrestacionRepository.new.save(prestacion2)

      centro.agregar_prestacion(prestacion)
      centro.agregar_prestacion(prestacion2)

      described_class.new.save(centro.id, prestacion.id)
      described_class.new.save(centro.id, prestacion2.id)

      prestaciones_centro_encontradas = described_class.new.buscar_por_id_centro(centro.id)
      expect(prestaciones_centro_encontradas[0].id).to eq prestacion.id
      expect(prestaciones_centro_encontradas[1].id).to eq prestacion2.id
    end

    it 'Dado que guardo la prestacion Odontologia y Kinesiologia en el hospital alemán y busco por Hopital Alemán, Odonlología' do #rubocop: disable all
      centro = Centro.new('Hospital Alemán', '-58.368360', '-34.617670', nil, nil, nil)
      CentroRepository.new.save(centro)

      prestacion = Prestacion.new('Odontologia', 0)
      PrestacionRepository.new.save(prestacion)
      prestacion2 = Prestacion.new('Kinesiologia', 0)
      PrestacionRepository.new.save(prestacion2)

      centro.agregar_prestacion(prestacion)
      centro.agregar_prestacion(prestacion2)

      described_class.new.save(centro.id, prestacion.id)

      prestacion_centro_encontrado = described_class.new.buscar_por_centro_prestacion(prestacion.id, centro.id) #rubocop: disable all
      expect(prestacion_centro_encontrado[:id_prestacion]).to eq prestacion.id
      expect(prestacion_centro_encontrado[:id_centro]).to eq centro.id
    end
  end
end
