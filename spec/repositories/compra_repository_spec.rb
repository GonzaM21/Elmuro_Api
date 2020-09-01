require 'integration_spec_helper'
require_relative '../../src/repositories/plan_repository'
require_relative '../../src/models/afiliado'
require_relative '../../src/models/plan'
require_relative '../../src/models/compra'
describe CompraRepository do
  let(:repository) { described_class.new }

  describe 'nuevo registro de compra' do
    it 'Dado que guardo la compra de medicamento de valor 200 el afiliado Hugo' do
      PlanRepository.new.save(Plan.new('Gran Plan', 100,  nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('Gran Plan')
      afiliado = Afiliado.new('Hugo', 25, plan, false, 0, nil, nil, nil, nil)
      AfiliadoRepository.new.save(afiliado)
      compra = Compra.new(afiliado, 200, nil, nil, nil)
      described_class.new.save(compra)
      compras = described_class.new.buscar_todos
      expect(compras[0].afiliado.id).to eq afiliado.id
      expect(compras[0].costo).to eq 200
    end

    it 'Dado que guardo dos compras de medicamentos de valor 200 y 300 el afiliado Hugo' do #rubocop: disable all
      PlanRepository.new.save(Plan.new('Gran Plan', 100, nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('Gran Plan')
      afiliado = Afiliado.new('Hugo', 25, plan, false, 0, nil, nil, nil, nil)
      AfiliadoRepository.new.save(afiliado)
      compra1 = Compra.new(afiliado, 200, nil, nil, nil)
      compra2 = Compra.new(afiliado, 300, nil, nil, nil)
      described_class.new.save(compra1)
      described_class.new.save(compra2)
      compras = described_class.new.buscar_por_id_afiliado(afiliado.id)
      expect(compras[0].afiliado.id).to eq afiliado.id
      expect(compras[0].costo).to eq 200
      expect(compras[1].costo).to eq 300
    end
  end

  describe 'buscar compras de un mes para afiliado' do
    it 'dado que el afiliado no realizo compras en el mes, deberia ser un array vacio' do
      PlanRepository.new.save(Plan.new('Gran Plan', 100, nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('Gran Plan')
      afiliado = Afiliado.new('Hugo', 25, plan, false, 0, nil, nil, nil, nil)
      AfiliadoRepository.new.save(afiliado)
      compras = described_class.new.buscar_por_afiliado_y_mes(afiliado.id, 1)
      expect(compras.length).to be 0
    end

    it 'deberia devolverme las compras de un afiliado recien creadas' do
      PlanRepository.new.save(Plan.new('Gran Plan', 100, nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('Gran Plan')
      afiliado = Afiliado.new('Hugo', 25, plan, false, 0, nil, nil, nil, nil)
      AfiliadoRepository.new.save(afiliado)
      described_class.new.save(Compra.new(afiliado, 200, nil, nil, nil))
      described_class.new.save(Compra.new(afiliado, 300, nil, nil, nil))
      compras = described_class.new.buscar_por_afiliado_y_mes(afiliado.id, Time.now.month)
      expect(compras.length).to be 2
      expect(compras[0].costo).to eq 200
      expect(compras[1].costo).to eq 300
    end
  end
end
