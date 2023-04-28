class Video < ApplicationRecord
  belongs_to :user

  validates :title, :url, presence: true
  validates :url, uniqueness: true
end
