FactoryBot.define do
  factory :ruby_version do
    initialize_with { new(**attributes) }

    version { "3.1" }
    url { "https://cache.ruby-lang.org/pub/ruby/3.1/ruby-3.1.2.zip" }
    sha256 { "61843112389f02b735428b53bb64cf988ad9fb81858b8248e22e57336f24a83e" }
    default { false }

    git do
      {
        branch: "ruby_3_1",
        tag: "v3_1_0"
      }
    end

    trait :default do
      default { true }
    end

    trait :dev do
      version { "dev" }
      url { "https://github.com/ruby/ruby/archive/master.zip" }
      sha256 { "" }
      git do
        {
          branch: "master",
          tag: ""
        }
      end
    end
  end
end
