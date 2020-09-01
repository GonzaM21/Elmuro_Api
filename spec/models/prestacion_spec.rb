require 'spec_helper'
require_relative '../../src/exceptions/sin_costo_error'
describe Prestacion do
  subject(:prestacion) { described_class.new('test', 1) }

  describe 'model' do
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:costo) }
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:updated_on) }
    it { is_expected.to respond_to(:created_on) }
  end

  describe 'valido?' do
    it 'Debe ser invalido cuando no tiene costo' do
      expect { described_class.new({}, nil) }.to raise_error(SinCostoError)
    end
  end
end
