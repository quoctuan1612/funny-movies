class User < ApplicationRecord
  has_many :video

  validates :user_name, :password, presence: true
end
