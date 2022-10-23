FactoryBot.define do
  factory :ruby_attribute do
    initialize_with { new(**attributes) }

    sequence(:name) { |n| "attribute_#{n}" }
    description { "<h1>Hello World</h1>" }
    access { "Read" }
  end
end
