Sequel.migration do
  up do
    create_table(:diagnostico_covid) do
      primary_key :id
      foreign_key :id_afiliado, :afiliados
      Date :created_on
    end
  end

  down do
    drop_table(:diagnostico_covid)
  end
end
