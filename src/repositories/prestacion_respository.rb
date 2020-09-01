class PrestacionRepository < BaseRepository
  self.table_name = :prestaciones
  self.model_class = 'Prestacion'

  def find_by_nombre(nombre)
    prestaciones = buscar_todos
    prestaciones.each do |prestacion|
      nombre_sin_formato = Utils.new.sacar_formato_string nombre
      nombre_prestacion = Utils.new.sacar_formato_string prestacion.nombre
      return prestacion if nombre_prestacion == nombre_sin_formato
    end
    nil
  end

  def find_by_id(id)
    row = dataset.first(id: id)
    cargar_prestacion(row) unless row.nil?
  end

  def buscar_todos
    dataset.all.map do |prestacion|
      cargar_prestacion(prestacion)
    end
  end

  def obtener_centros(prestacion)
    CentroPrestacionRepository.new.buscar_por_id_prestacion(prestacion.id)
  end

  protected

  def changeset(prestacion)
    {
      nombre: prestacion.nombre,
      costo: prestacion.costo
    }
  end

  def cargar_prestacion(prestacion_data)
    Prestacion.new(
      prestacion_data[:nombre],
      prestacion_data[:costo],
      prestacion_data[:id],
      prestacion_data[:created_on],
      prestacion_data[:updated_on]
    )
  end
end
