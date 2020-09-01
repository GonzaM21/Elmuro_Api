Sequel.migration do
  up do
    create_table(:prestacionescentros) do
      primary_key :id
      foreign_key :id_prestacion, :prestaciones
      foreign_key :id_centro, :centros
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:prestacionescentros)
  end
end
