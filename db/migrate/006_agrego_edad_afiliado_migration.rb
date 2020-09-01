Sequel.migration do
  up do
    add_column :afiliados, :edad, Integer, default: 0
  end

  down do
    drop_column :afiliados, :edad
  end
end
