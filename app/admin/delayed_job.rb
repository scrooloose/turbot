ActiveAdmin.register DelayedJob do
  index do
    column :id
    column :priority
    column :attempts
    column :handler do |dj|
      dj.handler.try(:truncate, 100, omission: "...")
    end
    column :last_error do |dj|
      dj.last_error.try(:truncate, 100, omission: "...")
    end
    column :run_at
    column :locked_at
    column :failed_at
    column :locked_by
    column :queue
    column :created_at
    column :updated_at
    actions
  end
end
