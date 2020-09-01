require 'spec_helper'
require 'integration_spec_helper'
require_relative '../../src/models/plan'
require_relative '../../src/models/afiliado'
require_relative '../../src/exceptions/costo_medicamento_no_especificado_error'
require_relative '../../src/exceptions/costo_medicamento_negativo_error'
require_relative '../../src/exceptions/costo_medicamento_cero_error'

describe Compra do
  subject(:compra) do
    PlanRepository.new.save(Plan.new('PlanTest', 0, nil, nil, nil, nil, nil))
    plan = PlanRepository.new.find_by_nombre('PlanTest')
    afiliado = Afiliado.new('test', 40, plan, false, 0, nil, nil, nil, nil)
    described_class.new(afiliado, 10_000, nil, nil, nil)
  end

  describe 'model' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:costo) }
    it { is_expected.to respond_to(:afiliado) }
    it { is_expected.to respond_to(:updated_on) }
    it { is_expected.to respond_to(:created_on) }
  end

  describe 'valido?' do
    it 'error cuando creo sin costo' do
      PlanRepository.new.save(Plan.new('PlanTest', 0, nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('PlanTest')
      afiliado = Afiliado.new('test', 40, plan, false, 0, nil, nil, nil, nil)
      expect { described_class.new(afiliado, nil, nil, nil, nil) }.to raise_error(CostoNoEspecificadoError) #rubocop: disable all
    end

    it 'error cuando creo con costo negativo' do
      PlanRepository.new.save(Plan.new('PlanTest', 0, nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('PlanTest')
      afiliado = Afiliado.new('test', 40, plan, false, 0, nil, nil, nil, nil)
      expect { described_class.new(afiliado, -10, nil, nil, nil) }.to raise_error(CostoMedicamentoNegativoError) #rubocop: disable all
    end

    it 'error cuando creo con costo cero' do
      PlanRepository.new.save(Plan.new('PlanTest', 0, nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('PlanTest')
      afiliado = Afiliado.new('test', 40, plan, false, 0, nil, nil, nil, nil)
      expect { described_class.new(afiliado, 0, nil, nil, nil) }.to raise_error(CostoMedicamentoCeroError) #rubocop: disable all
    end
  end
end
