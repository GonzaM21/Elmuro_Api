class DiagnosticoCovidRepository < BaseRepository
  self.table_name = :diagnostico_covid

  def save(afiliado_id)
    insert(afiliado_id)
  end

  def buscar_todos
    dataset.all
  end

  def find_by_id(id_diagnostico_covid)
    data = dataset.where(id: id_diagnostico_covid).first
    data unless data.nil?
  end

  protected

  def changeset(afiliado_id)
    {
      id_afiliado: afiliado_id,
      created_on: Date.today
    }
  end

  def insert(afiliado_id)
    dataset.insert(changeset(afiliado_id))
  end
end
