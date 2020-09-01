Sequel.migration do
  up do
    create_table(:prestaciones) do
      primary_key :id
      String :nombre
      Integer :costo
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:prestaciones)
  end
end
