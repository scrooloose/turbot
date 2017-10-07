ActiveAdmin.register Profile do
  filter :pof_key
  filter :username
  filter :unavailable
  filter :page_content
  filter :created_at
  filter :updated_at

  index do
    id_column
    column :pof_key
    column :username
    column :unavailable
    actions
  end
end
