require 'integration_spec_helper'
require_relative '../../src/models/plan'
require_relative '../../src/models/compra'

describe AfiliadoRepository do
  let(:repository) { described_class.new }

  describe 'nuevo Afiliado' do
    it 'Dado que guardo el afiliado Pedro Alfonso si lo busco por el nombre deberia encontrarlo' do
      PlanRepository.new.save(Plan.new('Test', 0, nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('Test')
      described_class.new.save(Afiliado.new('Pedro', 30, plan, false, 0, nil, nil, nil, nil))
      afiliado_encontrado = described_class.new.find_by_nombre('Pedro')
      expect(afiliado_encontrado.nombre).to eq 'Pedro'
    end
  end

  describe 'buscar Afiliado' do
    it 'No existente devuelve nil' do
      afiliado_encontrado = described_class.new.find_by_id(-1)
      expect(afiliado_encontrado.nil?).to be true
    end
  end

  describe 'Agregar compra' do
    it 'Se guarda la compra correctamente' do
      PlanRepository.new.save(Plan.new('Test', 0, nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('Test')
      afiliado = Afiliado.new('Pedro', 30, plan, false, 0, nil, nil, nil, nil)
      described_class.new.save(afiliado)
      compra = Compra.new(afiliado, 300, nil, nil, nil)
      expect(described_class.new.agregar_compra(compra)).to eq true
    end
  end
end
