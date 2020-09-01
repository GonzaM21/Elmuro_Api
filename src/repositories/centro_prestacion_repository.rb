class CentroPrestacionRepository < BaseRepository
  self.table_name = :prestacionescentros

  def buscar_por_id_prestacion(id)
    rows = dataset.where(id_prestacion: id).all
    obtener_centros(rows) unless rows.nil?
  end

  def buscar_por_id_centro(id)
    rows = dataset.where(id_centro: id).all
    obtener_prestaciones(rows) unless rows.nil?
  end

  def buscar_por_centro_prestacion(id_prestacion, id_centro)
    rows = dataset.first(id_prestacion: id_prestacion, id_centro: id_centro)
    rows unless rows.nil?
  end

  def buscar_todos
    dataset.all
  end

  def save(id_centro, id_prestacion) #rubocop: disable all
    prestacion_centro = { id: nil,
                          id_prestacion: id_prestacion,
                          id_centro: id_centro,
                          created_on: nil,
                          updated_on: nil }

    if find_dataset_by_id(prestacion_centro[:id]).first
      update(prestacion_centro).positive?
    else
      !insert(prestacion_centro)[:id].nil?
    end
  end

  protected

  def changeset(prestacioncentro)
    {
      id_prestacion: prestacioncentro[:id_prestacion],
      id_centro: prestacioncentro[:id_centro]
    }
  end

  def insert(a_record)
    id = dataset.insert(insert_changeset(a_record))
    a_record[:id] = id
    a_record
  end

  def insert_changeset(a_record)
    changeset_with_timestamps(a_record).merge(created_on: Date.today)
  end

  def changeset_with_timestamps(a_record)
    changeset(a_record).merge(created_on: a_record[:created_on], updated_on: a_record[:updated_on])
  end

  def obtener_prestaciones(filas)
    prestaciones = []
    repository = PrestacionRepository.new
    filas.each do |fila|
      prestaciones.append(repository.find_by_id(fila[:id_prestacion]))
    end

    prestaciones
  end

  def obtener_centros(filas)
    centros = []
    centros_nombres = []
    repository = CentroRepository.new
    filas.each do |fila|
      centro = repository.find_by_id(fila[:id_centro])
      unless centros_nombres.include?(centro.nombre)
        centros.append(centro)
        centros_nombres.append(centro.nombre)
      end
    end

    centros
  end
end
