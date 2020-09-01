Sequel.migration do
  up do
    create_table(:centros) do
      primary_key :id
      String :nombre
      Float :latitud
      Float :longitud
    end
  end

  down do
    drop_table(:centros)
  end
end
