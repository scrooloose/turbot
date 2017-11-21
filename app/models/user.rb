class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :pof_username, presence: true, uniqueness: true
  validates :pof_password, presence: true
  validates :name, presence: true

  validates :email, presence: true, uniqueness: true

  belongs_to :profile, optional: true
  has_many :template_messages
  has_many :interests, through: :template_messages
  has_many :active_interests, -> { where.not('template_messages.state' => 'disabled') },
    through: :template_messages,
    source: :interest

  accepts_nested_attributes_for :template_messages

  def has_interest?(i)
    template_messages.exists?(interest_id: i.id)
  end

  def update_enabled_interests(enabled_interest_ids:)
    InterestPreferenceProcessor.new(user: self, interest_ids: enabled_interest_ids).perform
  end
end
