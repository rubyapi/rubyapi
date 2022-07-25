FactoryBot.define do
  factory :ruby_method do
    initialize_with { new(**attributes) }

    name { "to_i" }
    description do
      "<p>Returns the result of interpreting leading characters in " \
       "self as an integer in the given base (which must be in (2..36)):</p>"
    end
    method_type { "instance_method" }
    object_constant { "String" }
    source_location { "2.6.4:string.c:L54" }

    signatures do
      [
        "(?::int base) -> ::Integer"
      ]
    end

    metadata do
      {
        depth: 1
      }
    end

    call_sequence do
      [
        "str.to_i # => 1"
      ]
    end

    source_body do
      <<~SRC
        puts "Hello world!"
      SRC
    end

    method_alias do
      {
        name: nil,
        path: nil
      }
    end

    trait :class_method do
      method_type { "class_method" }
    end

    trait :alias do
      method_alias do
        {
          name: "to_integer",
          path: "String.html#to_integer"
        }
      end
    end
  end
end
