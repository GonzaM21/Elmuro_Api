require 'integration_spec_helper'
describe PlanRepository do
  let(:repository) { described_class.new }

  describe 'nuevo plan' do
    it 'Dado que guardo el plan 310 si lo busco por el nombre deberia encontrarlo' do
      nombre_plan = '310'
      plan = Plan.new(nombre_plan, 0, nil, nil, nil, nil, nil)
      described_class.new.save(plan)
      plan_encontrado = described_class.new.find_by_nombre(nombre_plan)
      expect(plan_encontrado.nombre).to eq nombre_plan
    end

    it 'Dado que guardo el plan con costo $100 si lo busco su costo deberia ser $100' do
      costo = 100
      plan = Plan.new('test', costo, nil, nil, nil, nil, nil)
      described_class.new.save(plan)
      plan_encontrado = described_class.new.find_by_nombre('test')
      expect(plan_encontrado.costo).to eq costo
    end

    it 'Dado que creo un plan, puedo buscarlo por su id' do
      plan_para_insertar = Plan.new('fake-plan', 0,  nil, nil, nil, nil, nil)
      described_class.new.save(plan_para_insertar)
      plan = described_class.new.find_by_nombre('fake-plan')
      plan_encontrado = described_class.new.find_by_id(plan.id)
      expect(plan_encontrado.nombre).to eq 'fake-plan'
    end
  end

  describe 'coberturas' do
    it 'si creo un plan con coberturas, cuando lo busco las deberia tener' do
      coberturas = []
      cobertura_medicamentos = CoberturaMedicamentos.new 1
      coberturas.append cobertura_medicamentos
      cobertura_visitas = CoberturaVisitas.new(3, 2)
      coberturas.append cobertura_visitas
      plan = Plan.new('PlanFalso', 100, nil, coberturas, nil, nil, nil)
      described_class.new.save(plan)
      plan = described_class.new.find_by_nombre('PlanFalso')

      expect(plan.cobertura_medicamentos_porcentaje).to be(cobertura_medicamentos.porcentaje)
      expect(plan.cobertura_visitas_copago).to be(cobertura_visitas.copago)
      expect(plan.cobertura_visitas_limite).to be(cobertura_visitas.limite)
    end
  end

  describe 'Buscar Plan' do
    it 'Existente pasando nombre con distinto formato deberia encontrarlo' do
      nombre = 'Plan Salùd'
      plan = Plan.new(nombre, 100, nil, nil, nil, nil, nil)
      repository.save(plan)
      nombre_con_formato = 'pLAn SàLud'
      expect(repository.buscar_por_nombre(nombre_con_formato).nombre).to eq(nombre)
    end
  end
end
