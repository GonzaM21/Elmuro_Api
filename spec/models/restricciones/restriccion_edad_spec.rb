require 'spec_helper'
require_relative '../../../src/exceptions/no_alcanza_edad_minima'
require_relative '../../../src/exceptions/supera_edad_maxima'
describe RestriccionEdad do
  subject(:restriccion_edad) { described_class.new(10, 50) }

  describe 'model' do
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:edad_min) }
    it { is_expected.to respond_to(:edad_max) }
  end

  describe 'Validar' do
    it 'Deberia lanzar una excepcion si no supera la edad minima' do
      afiliado = Afiliado.new('Pepe', 9, nil, false, 0, nil, nil, nil, nil)
      expect { restriccion_edad.validar(afiliado) }.to raise_error(NoAlcanzaEdadMinimaError)
    end
    it 'Deberia lanzar una excepcion si supera la edad maxima' do
      afiliado = Afiliado.new('Pepe', 55, nil, false, 0, nil, nil, nil, nil)
      expect { restriccion_edad.validar(afiliado) }.to raise_error(SuperaEdadMaximaError)
    end
    it 'Devuelve true si la edad del afiliado esta entre la maxima y minima' do
      afiliado = Afiliado.new('Pepe', 45, nil, false, 0, nil, nil, nil, nil)
      expect(restriccion_edad.validar(afiliado)).to be true
    end
  end
end
