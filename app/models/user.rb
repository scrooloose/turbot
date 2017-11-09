class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :pof_username, presence: true, uniqueness: true
  validates :pof_password, presence: true
  validates :name, presence: true

  validates :email, presence: true, uniqueness: true

  belongs_to :profile, optional: true
  has_many :template_messages
  has_many :interests, through: :template_messages

  accepts_nested_attributes_for :template_messages
end
