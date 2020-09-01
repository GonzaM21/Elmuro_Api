Sequel.migration do
  up do
    add_column :planes, :hijos_max, Integer, default: nil
    add_column :planes, :edad_min, Integer, default: nil
    add_column :planes, :edad_max, Integer, default: nil
    add_column :planes, :acepta_conyuge, TrueClass, default: true
  end

  down do
    drop_column :planes, :hijos_max
    drop_column :planes, :edad_min
    drop_column :planes, :edad_max
    drop_column :planes, :acepta_conyuge
  end
end
