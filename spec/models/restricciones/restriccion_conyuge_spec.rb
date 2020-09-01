require 'spec_helper'
require_relative '../../../src/exceptions/plan_no_acepta_conyuge'
require_relative '../../../src/exceptions/plan_requiere_conyuge'
describe RestriccionConyuge do
  subject(:restriccion_conyuge) { described_class.new(true) }

  describe 'model' do
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:conyuge) }
  end

  describe 'Validar' do
    it 'Debe lanzar excepcion si tiene conyuge y no se acepta conyuge' do
      restriccion_no_conyuge = described_class.new(false)
      afiliado = Afiliado.new('Pepe', 9, nil, true, 0, nil, nil, nil, nil)
      expect { restriccion_no_conyuge.validar(afiliado) }.to raise_error(PlanNoAceptaConyugeError)
    end
    it 'Debe lanzar excepcion si no tiene conyuge y se requiere conyuge' do
      afiliado = Afiliado.new('Pepe', 9, nil, false, 0, nil, nil, nil, nil)
      expect { restriccion_conyuge.validar(afiliado) }.to raise_error(PlanRequiereConyugeError)
    end
  end
end
