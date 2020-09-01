require 'integration_spec_helper'
require_relative '../../src/repositories/plan_repository'
require_relative '../../src/repositories/centro_repository'
require_relative '../../src/repositories/prestacion_respository'
require_relative '../../src/models/afiliado'
require_relative '../../src/models/plan'
require_relative '../../src/models/centro'
require_relative '../../src/models/prestacion'
require_relative '../../src/models/atencion'
describe AtencionRepository do
  let(:repository) { described_class.new }

  describe 'nuevo registro de atencion' do
    it 'Dado que guardo una nueva atencion se encuentra en la bdd' do
      PlanRepository.new.save(Plan.new('Gran Plan', 100, nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('Gran Plan')
      afiliado = Afiliado.new('Hugo', 25, plan, false, 0, nil, nil, nil, nil)
      AfiliadoRepository.new.save(afiliado)

      centro = Centro.new('Hospital Alemán', '-58.368360', '-34.617670', nil, nil, nil)
      CentroRepository.new.save(centro)

      prestacion = Prestacion.new('Odontologia', 0)
      PrestacionRepository.new.save(prestacion)
      centro.agregar_prestacion(prestacion)
      CentroRepository.new.actualizar_prestaciones(centro)

      atencion = Atencion.new(afiliado, prestacion, centro, nil, nil, nil)

      described_class.new.save(atencion)

      atenciones = described_class.new.buscar_todos
      expect(atenciones[0].afiliado.id).to eq afiliado.id
      expect(atenciones[0].centro.id).to eq centro.id
      expect(atenciones[0].prestacion.id).to eq prestacion.id
    end
    it 'Si creo una atencion y la busco por el id la deberia encontrar' do
      PlanRepository.new.save(Plan.new('Gran Plan', 100, nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('Gran Plan')
      afiliado = Afiliado.new('Hugo', 25, plan, false, 0, nil, nil, nil, nil)
      AfiliadoRepository.new.save(afiliado)

      centro = Centro.new('Hospital Alemán', '-58.368360', '-34.617670', nil, nil, nil)
      CentroRepository.new.save(centro)

      prestacion = Prestacion.new('Odontologia', 0)
      PrestacionRepository.new.save(prestacion)
      centro.agregar_prestacion(prestacion)
      CentroRepository.new.actualizar_prestaciones(centro)

      atencion = Atencion.new(afiliado, prestacion, centro, nil, nil, nil)

      described_class.new.save(atencion)

      atencion_encontrada = described_class.new.find_by_id(atencion.id)

      expect(atencion_encontrada.id).to eq(atencion.id)
    end
  end

  describe 'filtro por afiliado y mes' do
    it 'dado que el afiliado no se atendio, deberia ser vacío' do
      PlanRepository.new.save(Plan.new('Gran Plan', 100, nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('Gran Plan')
      afiliado = Afiliado.new('Hugo', 25, plan, false, 0, nil, nil, nil, nil)
      AfiliadoRepository.new.save(afiliado)

      atenciones = described_class.new.buscar_por_afiliado_y_mes(afiliado.id, Time.now.month)
      expect(atenciones.length).to eq 0
    end

    it 'deberia devolverme las atenciones del afiliado del mes' do
      PlanRepository.new.save(Plan.new('Gran Plan', 100, nil, nil, nil, nil, nil))
      plan = PlanRepository.new.find_by_nombre('Gran Plan')
      afiliado = Afiliado.new('Hugo', 25, plan, false, 0, nil, nil, nil, nil)
      AfiliadoRepository.new.save(afiliado)

      centro = Centro.new('Hospital Alemán', '-58.368360', '-34.617670', nil, nil, nil)
      CentroRepository.new.save(centro)

      prestacion = Prestacion.new('Odontologia', 0)
      PrestacionRepository.new.save(prestacion)
      centro.agregar_prestacion(prestacion)
      CentroRepository.new.actualizar_prestaciones(centro)

      atencion1 = Atencion.new(afiliado, prestacion, centro, nil, nil, nil)
      atencion2 = Atencion.new(afiliado, prestacion, centro, nil, nil, nil)
      described_class.new.save(atencion1)
      described_class.new.save(atencion2)

      atenciones = described_class.new.buscar_por_afiliado_y_mes(afiliado.id, Time.now.month)
      expect(atenciones.length).to eq 2
      expect(atenciones[0].id).to eq described_class.new.find_by_id(atencion1.id).id
      expect(atenciones[1].id).to eq described_class.new.find_by_id(atencion2.id).id
    end
  end
end
