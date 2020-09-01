Sequel.migration do
  up do
    create_table(:compras) do
      primary_key :id
      foreign_key :id_afiliado, :afiliados
      Integer :costo
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:compras)
  end
end
