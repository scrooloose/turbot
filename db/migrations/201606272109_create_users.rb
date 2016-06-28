class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :pof_username, null: false
      t.string :pof_password, null: false
      t.string :name, null: false
      t.integer :profile_id

      t.timestamps null: false
    end
  end

  def down
    drop_table :users
  end
end

CreateUsers.migrate(ARGV[0])
