ActiveAdmin.register User do
  action_item :view, only: :show do
    link_to 'Enqueue Pof Session', enqueue_pof_session_admin_user_path(resource), method: :post
  end

  member_action :enqueue_pof_session, method: :post do
    PofSessionJob.perform_later(user_id: resource.id)
    redirect_to admin_delayed_jobs_path, notice: "POF Session Enqueued"
  end
end
