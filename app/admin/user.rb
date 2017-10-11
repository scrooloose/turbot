ActiveAdmin.register User do
  action_item :view, only: :show do
    link_to 'Enqueue Pof Session', enqueue_pof_session_admin_user_path(resource), method: :post
  end

  member_action :enqueue_pof_session, method: :post do
    PofSessionJob.perform_later(user_id: resource.id)
    redirect_to admin_delayed_jobs_path, notice: "POF Session Enqueued"
  end

  form title: "User Form" do |f|
    inputs "POF Details" do
      input :pof_username
      input :pof_password
      input :name, hint: "This is used to sign messages"
    end

    inputs "Topics" do
      has_many :topics, heading: false, allow_destroy: true do |topic_form|

        topic_form.input :name, input_html: { placeholder: "Biking" }

        topic_form.input(
          :matchers,
          hint: "Enter a list of regular expressions, each on a new line. These are matched against the interests of the other party.",
          input_html: {
            placeholder: "(?<!motor |motor)bik(e|ing)|cycling\n(bike|cycle) ?touring",
            rows: 4
          }
        )
        topic_form.input(
          :message,
          input_html: { placeholder: "I like biking too! ...", rows: 4 },
          hint: "This message is sent to the other party. It is preceeded by \"How's it going [name]?\" and signed with your name (as above)."
        )

      end
    end

    actions
  end
end
