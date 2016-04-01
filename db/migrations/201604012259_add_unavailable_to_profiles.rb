Sequel.migration do
  up do
    alter_table(:profiles) do
      add_column :unavailable, TrueClass, default: false
    end
  end

  down do
    alter_table(:profiles) do
      drop_column :unavailable
    end
  end
end
