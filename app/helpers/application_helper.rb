module ApplicationHelper
  def errors_for(model, exclude: [])
    return unless model
    messages = model.errors.to_hash(true).except(*exclude).values.flatten
    if messages.any?
      render partial: "shared/form_errors", locals: { messages: messages }
    end
  end
end
