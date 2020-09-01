require_relative 'compra_repository'
require_relative 'atencion_repository'
require_relative 'plan_repository'

class AfiliadoRepository < BaseRepository
  self.table_name = :afiliados
  self.model_class = 'Afiliado'

  def find_by_nombre(nombre)
    row = dataset.first(nombre: nombre)
    cargar_afilliado(row) unless row.nil?
  end

  def find_by_id(id)
    data = dataset.where(id: id).first
    cargar_afilliado(data) unless data.nil?
  end

  def buscar_todos
    dataset.all
  end

  def agregar_compra(compra)
    CompraRepository.new.save(compra)
  end

  def agregar_atencion(atencion)
    AtencionRepository.new.save(atencion)
  end

  def buscar_compras_del_mes(afiliado)
    CompraRepository.new.buscar_por_afiliado_y_mes(afiliado.id, Time.now.month)
  end

  def buscar_atenciones_del_mes(afiliado)
    AtencionRepository.new.buscar_por_afiliado_y_mes(afiliado.id, Time.now.month)
  end

  def buscar_atencion_por_id(id)
    AtencionRepository.new.find_by_id id
  end

  def guardar_diagnostico_covid(afiliado)
    DiagnosticoCovidRepository.new.save afiliado.id
  end

  def buscar_todos_diagnosticos_covid
    DiagnosticoCovidRepository.new.buscar_todos
  end

  protected

  def changeset(afiliado)
    {
      nombre: afiliado.nombre,
      conyuge: afiliado.conyuge,
      hijos: afiliado.hijos,
      edad: afiliado.edad,
      usuario: afiliado.usuario,
      id_plan: afiliado.plan.id
    }
  end

  def cargar_afilliado(afiliado_data)
    plan = PlanRepository.new.find_by_id(afiliado_data[:id_plan])
    Afiliado.new(
      afiliado_data[:nombre],
      afiliado_data[:edad],
      plan,
      afiliado_data[:conyuge],
      afiliado_data[:hijos],
      afiliado_data[:usuario],
      afiliado_data[:id],
      afiliado_data[:created_on],
      afiliado_data[:updated_on]
    )
  end
end
