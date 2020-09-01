Sequel.migration do
  up do
    create_table(:afiliados) do
      primary_key :id
      String :nombre
    end
  end

  down do
    drop_table(:afiliados)
  end
end
