require 'spec_helper'
require_relative '../../../src/exceptions/supera_maximo_de_hijos'
require_relative '../../../src/exceptions/plan_no_admite_hijos'
require_relative '../../../src/exceptions/no_alcanza_minimo_de_hijos'
describe RestriccionHijos do
  subject(:restriccion_hijos) { described_class.new(10) }

  describe 'model' do
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:hijos_max) }
  end

  describe 'validaar' do
    it 'Deberia lanzar una excepcion si supera la cantidad maxima de hijos' do
      afiliado = Afiliado.new('Pepe', 9, nil, false, 11, 0, nil, nil, nil)
      expect { restriccion_hijos.validar(afiliado) }.to raise_error(SuperaMaximoDeHijosError)
    end
    it 'Deberia lanzar una excepcion si tiene hijos y la cantidad de hijo max es 0' do
      restriccion_hijos_cero = described_class.new(0)
      afiliado = Afiliado.new('Pepe', 9, nil, false, 11, 0, nil, nil, nil)
      expect { restriccion_hijos_cero.validar(afiliado) }.to raise_error(PlanNoAdmiteHijosError)
    end
    it 'Deberia lanzar una excepcion si no tiene hijo y la cantidad de hijo es positiva' do
      afiliado = Afiliado.new('Pepe', 9, nil, false, 0, 0, nil, nil, nil)
      expect { restriccion_hijos.validar(afiliado) }.to raise_error(NoAlcanzaMinimoDeHijosError)
    end
  end
end
