Sequel.migration do
  up do
    add_column :afiliados, :created_on, Date
    add_column :afiliados, :updated_on, Date
  end

  down do
    drop_column :afiliados, :created_on
    drop_column :afiliados, :updated_on
  end
end
