require 'integration_spec_helper'
describe DiagnosticoCovidRepository do
  let(:repository) { described_class.new }

  describe 'Guardo afiliado sospechoso de covid' do
    it 'Dado que guardo un diagnostico deberia al encontrarlo tener el numero del afiliado' do
      PlanRepository.new.save(Plan.new('Gran Plan', 100, nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('Gran Plan')
      afiliado = Afiliado.new('Hugo', 25, plan, false, 0, nil, nil, nil, nil)
      AfiliadoRepository.new.save(afiliado)

      id = repository.save(afiliado.id)
      expect(repository.find_by_id(id)[:id_afiliado]).to eq afiliado.id
    end
  end
end
