require 'spec_helper'

describe Atencion do
  subject(:atencion) do
    PlanRepository.new.save(Plan.new('PlanTest', 0, nil, nil, nil, nil, nil))
    plan = PlanRepository.new.find_by_nombre('PlanTest')
    afiliado = Afiliado.new('test', 40, plan, false, 0, nil, nil, nil, nil)
    centro = Centro.new('test', '0', '0', nil, nil, nil)
    prestacion = Prestacion.new('Traumatología', 1000, 1)
    centro.agregar_prestacion(prestacion)
    described_class.new(afiliado, prestacion, centro, nil, nil, nil)
  end

  describe 'model' do
    it { is_expected.to respond_to(:afiliado) }
    it { is_expected.to respond_to(:prestacion) }
    it { is_expected.to respond_to(:centro) }
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:updated_on) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:costo) }
    it { is_expected.to respond_to(:fecha) }

    it 'debería devolver el nombre de la prestacion' do
      afiliado = instance_double('Afiliado', edad: 40)
      prestacion = instance_double('Prestacion', costo: 100, nombre: 'Traumatologia')
      centro = instance_double('Centro', nombre: 'Hospital Aleman')
      atencion = described_class.new(afiliado, prestacion, centro, nil, nil, nil)
      expect(atencion.nombre_prestacion).to eq 'Traumatologia'
    end

    it 'debería devolver el nombre del centro' do
      afiliado = instance_double('Afiliado', edad: 40)
      prestacion = instance_double('Prestacion', costo: 100, nombre: 'Traumatologia')
      centro = instance_double('Centro', nombre: 'Hospital Aleman')
      atencion = described_class.new(afiliado, prestacion, centro, nil, nil, nil)
      expect(atencion.nombre_centro).to eq 'Hospital Aleman'
    end
  end
end
