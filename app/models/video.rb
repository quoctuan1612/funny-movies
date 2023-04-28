class Video < ApplicationRecord
  belongs_to :user

  validates :title, :video_id, presence: true
  validates :video_id, uniqueness: true
end
