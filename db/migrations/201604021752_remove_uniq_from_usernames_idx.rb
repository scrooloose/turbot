Sequel.migration do
  up do
    alter_table(:profiles) do
      drop_index [:username]
      add_index [:username]
    end
  end

  down do
      drop_index [:username]
      add_index [:username], unique: true
  end
end
