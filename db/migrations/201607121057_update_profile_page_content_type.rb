class UpdateProfilePageContentType < ActiveRecord::Migration
  def up
    change_column :profiles, :page_content, :text, limit: 16777215
  end

  def down
    change_column :profiles, :page_content, :text
  end
end

UpdateProfilePageContentType.migrate(ARGV[0])
