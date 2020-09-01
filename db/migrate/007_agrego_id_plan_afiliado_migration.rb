Sequel.migration do
  up do
    alter_table(:afiliados) do
      add_foreign_key :plan_id, :planes
    end
  end

  down do
    alter_table(:afiliados) do
      drop_column :plan_id
    end
  end
end
