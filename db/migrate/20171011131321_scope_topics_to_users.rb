class ScopeTopicsToUsers < ActiveRecord::Migration[5.1]
  class User < ActiveRecord::Base; end

  def change
    add_column :topics, :user_id, :integer
    execute "UPDATE topics set user_id=#{User.first.id}"
    change_column :topics, :user_id, :integer, null: false
    add_index :topics, :user_id
  end
end
