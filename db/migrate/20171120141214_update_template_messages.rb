class UpdateTemplateMessages < ActiveRecord::Migration[5.1]
  def up
    change_column :template_messages, :content, :text, null: true
    change_column :template_messages, :user_id, :integer, null: false
    change_column :template_messages, :interest_id, :integer, null: false
    add_column :template_messages, :state, :string
  end

  def down
    change_column :template_messages, :content, :text, null: false
    change_column :template_messages, :user_id, :integer, null: true
    change_column :template_messages, :interest_id, :integer, null: true
    remove_column :template_messages, :state
  end
end
