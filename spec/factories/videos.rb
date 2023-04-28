FactoryBot.define do
  factory :video do
    title {"abc"}
    url {"url.com"}
    description {"description abc"}
    association :user, strategy: :build
  end
end
