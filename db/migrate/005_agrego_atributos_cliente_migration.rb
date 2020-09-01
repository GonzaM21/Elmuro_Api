Sequel.migration do
  up do
    add_column :afiliados, :conyuge, TrueClass, default: false
    add_column :afiliados, :hijos, Integer, default: 0
  end

  down do
    drop_column :afiliados, :conyuge
    drop_column :afiliados, :hijos
  end
end
