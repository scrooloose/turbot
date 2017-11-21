class TemplateMessage < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :interest

  aasm column: 'state' do
    state :pending_content, initial: true
    state :disabled
    state :live

    event :disable do
      transitions from: :live, to: :disabled
      transitions from: :pending_content, to: :disabled
    end

    event :want_to_enable do
      transitions from: :disabled, to: :pending_content
    end

    event :enable, guards: [:can_go_live?] do
      transitions from: :disabled, to: :live
      transitions from: :pending_content, to: :live
    end

    event :content_removed do
      transitions from: :live, to: :pending_content
    end
  end

private

  def can_go_live?
    content.present?
  end
end
