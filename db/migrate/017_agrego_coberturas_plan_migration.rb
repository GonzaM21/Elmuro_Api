Sequel.migration do
  up do
    add_column :planes, :limite_visitas, Integer
    add_column :planes, :copago_visitas, Integer
    add_column :planes, :cobertura_medicamentos, Integer
  end

  down do
    drop_column :planes, :limite_visitas
    drop_column :planes, :copago_visitas
    drop_column :planes, :cobertura_medicamentos
  end
end
