FactoryBot.define do
  factory :UrlRecord do
    id { rand(100) }
    path  { rand(36**3).to_s(36) }
    num_visits { rand(10) }
  end
end