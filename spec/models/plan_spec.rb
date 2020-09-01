require 'spec_helper'
require_relative '../../src/exceptions/nombre_vacio_error'
require_relative '../../src/exceptions/plan_no_acepta_conyuge'
require_relative '../../src/exceptions/plan_requiere_conyuge'
require_relative '../../src/exceptions/supera_maximo_de_hijos'
require_relative '../../src/exceptions/no_alcanza_edad_minima'
require_relative '../../src/exceptions/supera_edad_maxima'
require_relative '../../src/exceptions/plan_no_admite_hijos'

describe Plan do
  subject(:plan) { described_class.new('test', 1, nil, nil, nil, nil, nil) }

  describe 'model' do
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:costo) }
    it { is_expected.to respond_to(:updated_on) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:restricciones) }
    it { is_expected.to respond_to(:coberturas) }
  end

  describe 'valido?' do
    it 'Debe ser invalido cuando no tiene nombre' do
      expect { described_class.new(nil, nil, nil, nil, nil, nil, nil) }.to raise_error(NombreVacioError) #rubocop: disable all
    end
  end
end
