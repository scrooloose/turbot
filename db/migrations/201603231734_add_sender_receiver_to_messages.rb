ROOT_DIR = File.join(File.dirname(__dir__), "..")
require File.join(File.dirname(__dir__),  "/../lib/autopof/config")

ProfileID = Config['user_profile_id'] || raise("no profile id")

Sequel.migration do
  up do
    alter_table(:messages) do
      add_foreign_key :sender_profile_id, :profiles
      add_foreign_key :recipient_profile_id, :profiles
    end

    run <<-SQL
      UPDATE messages
      SET recipient_profile_id=profile_id,
          sender_profile_id=#{ProfileID}
    SQL

    alter_table(:messages) do
      drop_foreign_key :profile_id
    end

    rename_column :messages, :responded_at, :sent_at

  end

  down do
    alter_table(:messages) do
      add_foreign_key :profile_id, :profiles
    end

    run <<-SQL
      UPDATE messages
      SET profile_id=recipient_profile_id
    SQL

    alter_table(:messages) do
      drop_foreign_key :sender_profile_id
      drop_foreign_key :recipient_profile_id
    end

    rename_column :messages, :sent_at, :responded_at
  end
end
