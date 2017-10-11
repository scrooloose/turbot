class User < ApplicationRecord
  validates :pof_username, presence: true, uniqueness: true
  validates :pof_password, presence: true
  validates :name, presence: true

  belongs_to :profile, optional: true
  has_many :topics

  accepts_nested_attributes_for :topics
end
