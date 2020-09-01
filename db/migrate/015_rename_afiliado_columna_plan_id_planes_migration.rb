Sequel.migration do
  up do
    alter_table(:afiliados) do
      rename_column :plan_id, :id_plan
    end
  end

  down do
    alter_table(:afiliados) do
      rename_column :id_plan, :plan_id
    end
  end
end
