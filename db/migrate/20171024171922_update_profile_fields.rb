class UpdateProfileFields < ActiveRecord::Migration[5.1]
  def change
    create_table :profile_interests do |t|
      t.integer :profile_id
      t.integer :interest_id
      t.timestamps

      t.index [:profile_id, :interest_id]
    end

    add_column :profiles, :bio, :text
    add_column :profiles, :name, :string
  end
end
