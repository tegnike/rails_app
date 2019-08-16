FactoryBot.define do
  factory :micropost do
    sequence(:content) { |n| "Example content #{n}" }
    user
  end
end
