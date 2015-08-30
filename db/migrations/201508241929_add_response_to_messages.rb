Sequel.migration do
  up do
    add_column :messages, :response, String, text: true
    add_column :messages, :responded_at, DateTime
  end

  down do
    drop_column :messages, :response
    drop_column :messages, :responded_at
  end
end
