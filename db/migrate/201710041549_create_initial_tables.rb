class CreateInitialTables < ActiveRecord::Migration
  def up
    create_table :messages do |t|
      t.text     :content, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.datetime :sent_at
      t.integer  :sender_profile_id
      t.integer  :recipient_profile_id
    end

    add_index :messages, :recipient_profile_id
    add_index :messages, :sender_profile_id

    create_table :profiles, force: :cascade do |t|
      t.string   :pof_key, null: false
      t.string   :username, null: false
      t.text     :page_content, null: false, limit: 16_777_215
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.boolean  :unavailable, default: false
    end

    add_index :profiles, :pof_key, unique: true
    add_index :profiles, :username, unique: true

    create_table :topics do |t|
      t.string   :name, null: false
      t.text     :matchers, null: false
      t.text     :message, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    add_index :topics, :name, unique: true

    create_table :users do |t|
      t.string   :pof_username, null: false
      t.string   :pof_password, null: false
      t.string   :name, null: false
      t.integer  :profile_id
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    add_foreign_key :messages, :profiles, column: :recipient_profile_id
    add_foreign_key :messages, :profiles, column: :sender_profile_id
  end

  def down
  end
end
