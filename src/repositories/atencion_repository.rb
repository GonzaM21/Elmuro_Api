class AtencionRepository < BaseRepository
  self.table_name = :atenciones
  self.model_class = 'Atencion'

  def buscar_todos
    cargar_atenciones(dataset.all)
  end

  def find_by_id(id_atencion)
    data = dataset.where(id: id_atencion).first
    cargar_atencion(data) unless data.nil?
  end

  def buscar_por_afiliado_y_mes(id_afiliado, mes)
    rows = dataset
           .where(id_afiliado: id_afiliado)
           .where(Sequel.lit('extract(month from created_on) = ?', mes))
           .where(Sequel.lit('extract(year from created_on) = ?', Time.now.year))
           .order(:created_on)
           .all
    cargar_atenciones(rows) unless rows.nil?
  end

  protected

  def changeset(atencion)
    {
      id_afiliado: atencion.afiliado.id,
      id_prestacion: atencion.prestacion.id,
      id_centro: atencion.centro.id
    }
  end

  def cargar_atenciones(atenciones)
    lista_atenciones = []
    atenciones.each do |atencion|
      lista_atenciones.append(cargar_atencion(atencion))
    end

    lista_atenciones
  end

  def cargar_atencion(atencion)
    centro = CentroRepository.new.find_by_id(atencion[:id_centro])
    afiliado = AfiliadoRepository.new.find_by_id(atencion[:id_afiliado])
    prestacion = PrestacionRepository.new.find_by_id(atencion[:id_prestacion])
    Atencion.new(
      afiliado,
      prestacion,
      centro,
      atencion[:id],
      atencion[:updated_on],
      atencion[:created_on]
    )
  end
end
