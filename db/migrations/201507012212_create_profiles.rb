Sequel.migration do
  up do
    create_table(:profiles) do
      primary_key :id
      String :page_content, null: false, text: true
      TrueClass :message_sent, default: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end

  down do
    drop_table(:profiles)
  end
end
