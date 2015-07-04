Sequel.migration do
  up do
    create_table(:profiles) do
      primary_key :id
      String :pof_key, null: false
      String :username, null: false
      String :page_content, null: false, text: true
      DateTime :message_sent_at, default: nil
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:pof_key], unique: true
      index [:username], unique: true
    end
  end

  down do
    drop_table(:profiles)
  end
end
