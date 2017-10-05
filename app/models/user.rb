class User < ApplicationRecord
  validates :pof_username, presence: true, uniqueness: true
  validates :pof_password, presence: true
  validates :name, presence: true

  belongs_to :profile
end
