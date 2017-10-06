class AdminMailer < ApplicationMailer
  def error(error:)
    @error = error
    mail to: Config['admin_email'], from: Config['admin_email'], subject: "Turbot Error"
  end
end
