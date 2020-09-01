require 'spec_helper'
require 'integration_spec_helper'
require_relative '../../src/models/plan'
require_relative '../../src/exceptions/plan_no_acepta_conyuge'
require_relative '../../src/exceptions/plan_requiere_conyuge'
require_relative '../../src/exceptions/supera_maximo_de_hijos'
require_relative '../../src/exceptions/no_alcanza_edad_minima'
require_relative '../../src/exceptions/supera_edad_maxima'

describe Afiliado do
  subject(:afiliado) do
    PlanRepository.new.save(Plan.new('PlanTest', 0, nil, nil, nil, nil, nil))
    plan = PlanRepository.new.find_by_nombre('PlanTest')
    described_class.new('test', 40, plan, false, 0, nil, nil, nil, nil)
  end

  describe 'model' do
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:updated_on) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:conyuge) }
    it { is_expected.to respond_to(:hijos) }
    it { is_expected.to respond_to(:edad) }
    it { is_expected.to respond_to(:usuario) }
    it { is_expected.to respond_to(:plan) }

    describe 'errores al afiliarse' do
      it 'deberia lanzar error si el usuario no tiene conyuge y el plan lo requiere' do
        restriccion = RestriccionConyuge.new(true)
        restricciones = []
        restricciones.append(restriccion)
        plan = Plan.new('Gran Plan', 100, restricciones, nil, nil, nil, nil)

        PlanRepository.new.save(plan)
        plan = PlanRepository.new.find_by_nombre('Gran Plan')
        expect do
          described_class.new('Julia', 30, plan, false, 2, nil, nil, nil, nil)
        end .to raise_error(PlanRequiereConyugeError)
      end

      it 'deberia lanzar error si el usuario tiene conyuge y el plan no lo acepta' do
        restriccion = RestriccionConyuge.new(false)
        restricciones = []
        restricciones.append(restriccion)
        plan = Plan.new('Gran Plan', 100, restricciones, nil, nil, nil, nil)
        PlanRepository.new.save(plan)
        plan = PlanRepository.new.find_by_nombre('Gran Plan')
        expect do
          described_class.new('Julia', 30, plan, true, 2, nil, nil, nil, nil)
        end .to raise_error(PlanNoAceptaConyugeError)
      end

      it 'deberia lanzar error si el usuario no cumple requisitos de hijos' do
        restriccion = RestriccionHijos.new(1)
        restricciones = []
        restricciones.append(restriccion)
        plan = Plan.new('Gran Plan', 100, restricciones, nil, nil, nil, nil)
        PlanRepository.new.save(plan)
        plan = PlanRepository.new.find_by_nombre('Gran Plan')
        expect { described_class.new('Julia', 30, plan, true, 2, nil, nil, nil, nil) }.to raise_error(SuperaMaximoDeHijosError) #rubocop: disable all
      end

      it 'deberia lanzar error si el usuario no cumple requisitos de edad minima' do
        restriccion = RestriccionEdad.new(30, 100)
        restricciones = []
        restricciones.append(restriccion)
        plan = Plan.new('Gran Plan', 100, restricciones, nil, nil, nil, nil)
        PlanRepository.new.save(plan)
        plan = PlanRepository.new.find_by_nombre('Gran Plan')
        expect { described_class.new('Julia', 25, plan, true, 2, nil, nil, nil, nil) }.to raise_error(NoAlcanzaEdadMinimaError) #rubocop: disable all
      end

      it 'deberia lanzar error si el usuario no cumple requisitos de edad maxima' do
        restriccion = RestriccionEdad.new(0, 30)
        restricciones = []
        restricciones.append(restriccion)
        plan = Plan.new('Gran Plan', 100, restricciones, nil, nil, nil, nil)
        PlanRepository.new.save(plan)
        plan = PlanRepository.new.find_by_nombre('Gran Plan')
        expect { described_class.new('Julia', 35, plan, true, 2, nil, nil, nil, nil) }.to raise_error(SuperaEdadMaximaError) #rubocop: disable all
      end
    end
  end
end
