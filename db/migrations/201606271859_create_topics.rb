class CreateTopics < ActiveRecord::Migration
  def up
    create_table :topics do |t|
      t.string :name, null: false
      t.text :matchers, null: false
      t.text :message, null: false
      t.timestamps null: false
    end

    add_index :topics, :name, unique: true
  end

  def down
    drop_table :topics
  end
end

CreateTopics.migrate(ARGV[0])
