require 'spec_helper'
describe CoberturaMedicamentos do
  subject(:cobertura) { described_class.new(10) }

  describe 'model' do
    it { is_expected.to respond_to(:porcentaje) }
    it { is_expected.to respond_to(:nombre) }
  end
end
