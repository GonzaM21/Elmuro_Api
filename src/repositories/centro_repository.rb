class CentroRepository < BaseRepository
  self.table_name = :centros
  self.model_class = 'Centro'

  def find_by_nombre(nombre)
    row = dataset.first(nombre: nombre)
    cargar_centro(row) unless row.nil?
  end

  def find_by_id(id)
    row = dataset.first(id: id)
    cargar_centro(row) unless row.nil?
  end

  def buscar_todos
    dataset.all.map do |centro|
      cargar_centro(centro)
    end
  end

  def buscar_por_nombre(nombre)
    centros = buscar_todos
    centros.each do |centro|
      nombre_sin_formato = Utils.new.sacar_formato_string nombre
      nombre_centro = Utils.new.sacar_formato_string centro.nombre
      return centro if nombre_centro == nombre_sin_formato
    end
    nil
  end

  def buscar_por_coordenadas(longitud, latitud)
    row = dataset
          .where(Sequel.lit('CAST(TRUNC(latitud) AS INTEGER) = ?', latitud.to_i))
          .where(Sequel.lit('CAST(TRUNC(longitud) AS INTEGER) = ?', longitud.to_i))
          .first
    cargar_centro(row) unless row.nil?
  end

  def actualizar_prestaciones(centro)
    tabla = CentroPrestacionRepository.new
    centro.prestaciones.each do |prestacion|
      tabla.save(centro.id, prestacion.id) if tabla.buscar_por_centro_prestacion(prestacion.id, centro.id).nil?
    end
  end

  def existe_prestacion_en_centro?(centro_id, prestacion_id)
    !CentroPrestacionRepository.new.buscar_por_centro_prestacion(prestacion_id, centro_id).nil?
  end

  protected

  def changeset(centro)
    {
      nombre: centro.nombre,
      longitud: centro.longitud,
      latitud: centro.latitud
    }
  end

  def cargar_centro(centro_data)
    centro = Centro.new(
      centro_data[:nombre],
      centro_data[:longitud],
      centro_data[:latitud],
      centro_data[:id],
      centro_data[:created_on],
      centro_data[:updated_on]
    )
    cargar_prestaciones(centro)
  end

  def cargar_prestaciones(centro)
    prestaciones = CentroPrestacionRepository.new.buscar_por_id_centro(centro.id)
    prestaciones.each do |prestacion|
      centro.agregar_prestacion(prestacion)
    end

    centro
  end
end
