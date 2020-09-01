require 'spec_helper'
require_relative '../../src/models/prestacion'
require_relative '../../src/exceptions/latitud_longitud_no_especificada'
require_relative '../../src/exceptions/nombre_no_especificado'
require_relative '../../src/exceptions/prestacion_repetida_error'
require_relative '../../src/exceptions/prestacion_inexistente_centro'

describe Centro do
  subject(:centro) { described_class.new('test', '0', '0', nil, nil, nil) }

  describe 'model' do
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:updated_on) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:latitud) }
    it { is_expected.to respond_to(:longitud) }
    it { is_expected.to respond_to(:prestaciones) }
  end

  describe 'valido?' do
    it 'Debe ser invalido cuando no tiene latitud y longitud' do
      expect { described_class.new('test', nil, nil, nil, nil, nil) }.to raise_error(LatitudLongitudNoEspecificada) # rubocop: disable all
    end

    it 'Debe ser invalido cuando no tiene nombre' do
      expect { described_class.new(nil, nil, nil, nil, nil, nil) }.to raise_error(NombreNoEspecificado) # rubocop: disable all
    end
  end

  describe 'agregar prestaciones' do
    it 'debe saltar un error si guardo 2 veces la misma prestacion' do
      centro = described_class.new('test', '0', '0', nil, nil, nil)
      prestacion = Prestacion.new('Traumatología', 1000, 1)
      centro.agregar_prestacion(prestacion)
      expect { centro.agregar_prestacion(prestacion) }.to raise_error(PrestacionRepetidaError) #rubocop: disable all
    end
    it 'devuelve true existe_prestacion Traumatologia si existe en el centro test' do
      centro = described_class.new('test', '0', '0', nil, nil, nil)
      prestacion = Prestacion.new('Traumatología', 1000, 1)
      expect { centro.verificar_no_existencia prestacion }.to raise_error PrestacionInexistenteCentroError
    end
  end
end
