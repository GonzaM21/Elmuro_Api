class PlanRepository < BaseRepository
  self.table_name = :planes
  self.model_class = 'Plan'
  RESTRICCION_CONYUGE = 'RestriccionConyuge'.freeze
  RESTRICCION_EDAD = 'RestriccionEdad'.freeze
  RESTRICCION_HIJOS = 'RestriccionHijos'.freeze

  def find_by_nombre(nombre)
    row = dataset.where(nombre: nombre).first
    cargar_plan(row) unless row.nil?
  end

  def buscar_todos
    dataset.all.map do |plan|
      cargar_plan(plan)
    end
  end

  def buscar_por_nombre(nombre)
    planes = buscar_todos
    planes.each do |plan|
      nombre_sin_formato = Utils.new.sacar_formato_string nombre
      nombre_plan = Utils.new.sacar_formato_string plan.nombre
      return plan if nombre_plan == nombre_sin_formato
    end
    nil
  end

  def find_by_id(id_plan)
    plan_data = dataset.where(id: id_plan).first
    cargar_plan(plan_data) unless plan_data.nil?
  end

  protected

  def changeset(plan)
    fields = {
      nombre: plan.nombre,
      costo: plan.costo
    }
    agregar_restricciones(plan.restricciones, fields) if plan.tiene_restricciones?
    agregar_coberturas(plan, fields) unless plan.coberturas.nil?
    fields[:id] = plan.id unless plan.id.nil?
    fields
  end

  def agregar_restricciones(restricciones, fields)
    restricciones.each do |restriccion|
      case restriccion.nombre
      when RESTRICCION_EDAD
        fields[:edad_min] =  restriccion.edad_min
        fields[:edad_max] =  restriccion.edad_max
      when RESTRICCION_CONYUGE
        fields[:conyuge] = restriccion.conyuge
      when RESTRICCION_HIJOS
        fields[:hijos_max] = restriccion.hijos_max
      end
    end
  end

  def agregar_coberturas(plan, fields)
    fields[:limite_visitas] = plan.cobertura_visitas_limite
    fields[:copago_visitas] = plan.cobertura_visitas_copago
    fields[:cobertura_medicamentos] = plan.cobertura_medicamentos_porcentaje
  end

  def cargar_plan(plan_data) #rubocop: disable all
    restricciones = cargar_restricciones(plan_data[:conyuge],
                                         plan_data[:edad_min],
                                         plan_data[:edad_max],
                                         plan_data[:hijos_max])
    coberturas = cargar_coberturas(plan_data[:cobertura_medicamentos],
                                   plan_data[:limite_visitas],
                                   plan_data[:copago_visitas])

    Plan.new(plan_data[:nombre],
             plan_data[:costo],
             restricciones,
             coberturas,
             plan_data[:id],
             plan_data[:created_on],
             plan_data[:updated_on])
  end

  def cargar_restricciones(conyuge, edad_min, edad_max, hijos_max)
    restricciones = []
    restricciones.append(RestriccionConyuge.new(conyuge))
    restricciones.append(RestriccionEdad.new(edad_min, edad_max))
    restricciones.append(RestriccionHijos.new(hijos_max))
    restricciones
  end

  def cargar_coberturas(medicamentos, limite, copago)
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new medicamentos
    coberturas.append cobertura_medicamentos
    cobertura_visitas = CoberturaVisitas.new(limite, copago)
    coberturas.append cobertura_visitas
    coberturas
  end
end
