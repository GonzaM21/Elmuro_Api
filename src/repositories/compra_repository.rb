class CompraRepository < BaseRepository
  self.table_name = :compras
  self.model_class = 'Compra'

  def buscar_todos
    cargar_compras(dataset.all)
  end

  def buscar_por_id_afiliado(id)
    rows = dataset.where(id_afiliado: id).all
    cargar_compras(rows) unless rows.nil?
  end

  def buscar_por_afiliado_y_mes(id_afiliado, mes)
    rows = dataset
           .where(id_afiliado: id_afiliado)
           .where(Sequel.lit('extract(month from created_on) = ?', mes))
           .where(Sequel.lit('extract(year from created_on) = ?', Time.now.year))
           .all
    cargar_compras(rows) unless rows.nil?
  end

  protected

  def changeset(compra)
    {
      id_afiliado: compra.afiliado.id,
      costo: compra.costo
    }
  end

  def cargar_compras(compras)
    afiliados_repository = AfiliadoRepository.new
    lista_compras = []
    compras.each do |compra|
      afiliado = afiliados_repository.find_by_id(compra[:id_afiliado])
      compra_nueva = Compra.new(afiliado,
                                compra[:costo],
                                compra[:id],
                                compra[:created_on],
                                compra[:updated_on])
      lista_compras.append(compra_nueva)
    end

    lista_compras
  end
end
