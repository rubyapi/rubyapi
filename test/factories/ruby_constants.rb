FactoryBot.define do
  factory :ruby_constant do
    initialize_with { new(**attributes) }

    sequence(:name) { |n| "HELLO_WORLD_#{n}" }
    description { "<h1>Hello World</h1>" }
  end
end
