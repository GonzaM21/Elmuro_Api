class Resumen
  attr_reader :afiliado, :plan
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  def initialize(afiliado, compras: [], atenciones: [])
    @afiliado = afiliado
    @plan = afiliado.plan
    @compras = compras
    @atenciones = atenciones
  end

  def attributes
    {
      nombre: nombre,
      plan_nombre: plan_nombre,
      costo_plan: costo_plan,
      saldo_adicional: saldo_adicional,
      total_a_pagar: total_a_pagar,
      detalle: detalle
    }
  end

  def nombre
    @afiliado.nombre
  end

  def plan_nombre
    @plan.nombre
  end

  def costo_plan
    @plan.costo
  end

  def saldo_adicional
    gastos_medicamentos + gastos_atenciones
  end

  def total_a_pagar
    costo_plan + saldo_adicional
  end

  def gastos_medicamentos
    subtotal = 0
    @compras.each do |compra|
      subtotal += costo_final_compra(compra)
    end
    subtotal
  end

  def gastos_atenciones
    subtotal = 0
    @atenciones.each_with_index do |atencion, indice|
      subtotal += costo_final_atencion(atencion, indice)
    end
    subtotal
  end

  def detalle
    detalle_gastos = detalle_atenciones
    detalle_gastos += detalle_compras
    detalle_gastos = detalle_gastos.sort_by { |detalle| [detalle[:fecha]] }
    detalle_gastos.map do |detalle|
      {
        fecha: detalle[:fecha].strftime('%d/%m/%Y'),
        concepto: detalle[:concepto],
        costo: detalle[:costo]
      }
    end
  end

  private

  def costo_final_compra(compra)
    porcentaje_cubierto_por_plan = @plan.cobertura_medicamentos_porcentaje || 0
    compra.costo * (100 - porcentaje_cubierto_por_plan) / 100
  end

  def costo_final_atencion(atencion, nro_de_atencion)
    copago = @plan.cobertura_visitas_copago
    limite = @plan.cobertura_visitas_limite
    paso_limite = !limite.nil? && nro_de_atencion >= limite
    return copago unless paso_limite

    atencion.costo
  end

  def detalle_atenciones
    detalle = []
    @atenciones.each_with_index do |atencion, indice|
      detalle << {
        fecha: atencion.fecha,
        concepto: "#{atencion.nombre_prestacion} - #{atencion.nombre_centro}",
        costo: costo_final_atencion(atencion, indice)
      }
    end
    detalle
  end

  def detalle_compras
    detalle = []
    @compras.each do |compra|
      detalle << {
        fecha: compra.fecha,
        concepto: 'Medicamentos',
        costo: costo_final_compra(compra)
      }
    end
    detalle
  end
end
