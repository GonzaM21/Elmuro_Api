Sequel.migration do
  up do
    create_table(:atenciones) do
      primary_key :id
      foreign_key :id_afiliado, :afiliados
      foreign_key :id_prestacion, :prestaciones
      foreign_key :id_centro, :centros
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:atenciones)
  end
end
