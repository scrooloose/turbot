ActiveAdmin.register Message do
  filter :content
  filter :created_at
  filter :updated_at
  filter :sent_at
end
