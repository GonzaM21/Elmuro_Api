Sequel.migration do
  up do
    add_column :centros, :created_on, Date
    add_column :centros, :updated_on, Date
  end

  down do
    drop_column :centros, :created_on
    drop_column :centros, :updated_on
  end
end
