Sequel.migration do
  up do
    add_column :planes, :created_on, Date
    add_column :planes, :updated_on, Date
  end

  down do
    drop_column :planes, :created_on
    drop_column :planes, :updated_on
  end
end
