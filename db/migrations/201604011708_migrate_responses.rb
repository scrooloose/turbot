ROOT_DIR = File.join(File.dirname(__dir__), "..")
require File.join(File.dirname(__dir__),  "/../lib/autopof/config")
ProfileID = Config['user_profile_id'] || raise("no profile id")

Sequel.migration do
  up do
    DB[:messages].where("response IS NOT NULL").each do |message|
      DB[:messages].insert(
        content: message[:response],
        created_at: message[:created_at],
        sent_at: message[:created_at],
        sender_profile_id: message[:recipient_profile_id],
        recipient_profile_id: Config['user_profile_id']
      )
    end

    alter_table(:messages) do
      drop_column :response
    end
  end

  down do
    raise "can't"
  end
end
