ROOT_DIR = File.join(File.dirname(__dir__), "..")
require File.join(File.dirname(__dir__),  "/../lib/autopof/config")
ProfileID = Config['user_profile_id'] || raise("no profile id")

Sequel.migration do
  up do
    run <<-SQL
      UPDATE messages
      SET sent_at=created_at
      WHERE sent_at IS NULL
    SQL
  end

  down do
    raise "can't"
  end
end
