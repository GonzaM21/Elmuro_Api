Sequel.migration do
  up do
    alter_table(:planes) do
      drop_column :acepta_conyuge
      add_column :conyuge, TrueClass, default: nil
    end
  end

  down do
    alter_table(:planes) do
      drop_column :conyuge
      add_column :acepta_conyuge, TrueClass, default: nil
    end
  end
end
