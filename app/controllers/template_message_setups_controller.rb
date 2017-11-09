class TemplateMessageSetupsController < ApplicationController
  before_action :load_template_message_setup_form
  before_action :set_step

  def new
    session[SessionKey] = nil unless params[:step].present?
    self.send("show_step_#{@step}")
  end

  def create
    @template_message_setup_form.update(form_params.to_unsafe_h)
    put_form_to_session(@template_message_setup_form)

    if final_step?
      @template_message_setup_form.save
      redirect_to dashboards_path, notice: "Message config saved"
    else
      redirect_to new_template_message_setup_path(step: @step + 1)
    end
  end

private

  def show_step_1
    @step_title = "Choose Your Interests"
    @interests = Interest.all
  end

  def show_step_2
    @step_title = "Enter Your Messages"
    @interests = Interest.all
  end

  def set_step
    @step = if params[:step].present?
              params[:step].to_i
            else
              1
            end
  end

  SessionKey = :template_message_setup_form

  def put_form_to_session(form)
    session[SessionKey] = Marshal.dump(form)
    form
  end

  def load_template_message_setup_form
    @template_message_setup_form =
      if params[:step]
        Marshal.load(session[SessionKey])
      else
        put_form_to_session(TemplateMessageSetupForm.new(user_id: current_user.id))
      end
  end

  def form_params
    params.require(:template_message_setup_form).permit(interest_ids: [], messages: [:interest_id, :message] )
  end

  def final_step?
    @step == 2
  end
end
