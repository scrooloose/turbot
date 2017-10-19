class BreakUpTopics < ActiveRecord::Migration[5.1]
  def up
    create_table :interests do |t|
      t.string :name
      t.text :matchers
      t.timestamps
    end

    create_table :template_messages do |t|
      t.text :content, null: false
      t.integer :interest_id
      t.integer :user_id
      t.timestamps
    end

    drop_table :topics
    add_index :template_messages, :interest_id
  end

  def down
    drop_table :template_messages
    drop_table :interests
    create_table :topics do |t|
      t.string "name", null: false
      t.text "matchers", null: false
      t.text "message", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "user_id", null: false
      t.index ["name"], name: "index_topics_on_name", unique: true
      t.index ["user_id"], name: "index_topics_on_user_id"
    end

  end
end
