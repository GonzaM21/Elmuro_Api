Sequel.migration do
  up do
    create_table(:planes) do
      primary_key :id
      String :nombre
    end
  end

  down do
    drop_table(:planes)
  end
end
