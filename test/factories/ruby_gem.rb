FactoryBot.define do
  factory :ruby_gem do
    name { "rails" }
    description { "A web application framework for Ruby" }
    latest_version { "8.0.2" }
    authors { ["David Heinemeier Hansson"] }
    downloads { 100_000_000 }

    trait :with_metadata do
      metadata do
        {
          changelog_uri: "https://github.com/rails/rails/releases/tag/v8.0.2",
          bug_tracker_uri: "https://github.com/rails/rails/issues",
          source_code_uri: "https://github.com/rails/rails/tree/v8.0.2",
          mailing_list_uri: "https://discuss.rubyonrails.org/c/rubyonrails-talk",
          documentation_uri: "https://api.rubyonrails.org/v8.0.2/",
          rubygems_mfa_required: true
        }
      end
    end
  end
end