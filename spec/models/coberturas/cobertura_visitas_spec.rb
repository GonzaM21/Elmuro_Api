require 'spec_helper'
describe CoberturaVisitas do
  subject(:cobertura) { described_class.new(10) }

  describe 'model' do
    it { is_expected.to respond_to(:limite) }
    it { is_expected.to respond_to(:copago) }
    it { is_expected.to respond_to(:nombre) }
  end
end
