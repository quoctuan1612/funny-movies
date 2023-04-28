FactoryBot.define do
  factory :video do
    title {"abc"}
    video_id {"sadasd"}
    description {"description abc"}
    association :user, strategy: :build
  end
end
