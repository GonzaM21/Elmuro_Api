Sequel.migration do
  up do
    add_column :afiliados, :usuario, String
  end

  down do
    drop_column :afiliados, :usuario
  end
end
