class User < ApplicationRecord
  validates :user_name, :password, presence: true
end
