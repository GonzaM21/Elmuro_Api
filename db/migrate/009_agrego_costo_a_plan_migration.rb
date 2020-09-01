Sequel.migration do
  up do
    add_column :planes, :costo, Integer, default: 0
  end

  down do
    drop_column :planes, :costo
  end
end
