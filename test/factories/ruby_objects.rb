FactoryBot.define do
  factory :ruby_object do
    initialize_with { new(**attributes) }

    transient do
      c { String }
    end

    name { c.to_s }
    constant { c.to_s.demodulize }
    description { "A string is a series of characters." }
    object_type { "class_object" }
    superclass do
      { constant: "Object" }
    end
    included_modules do
      [
        { constant: "Comparable" },
        { constant: "Enumerable" }
      ]
    end

    metadata do
      {
        depth: 1
      }
    end

    ruby_methods { FactoryBot.build_list(:ruby_method, 3, object_constant: c.to_s) }
    ruby_attributes { FactoryBot.build_list(:ruby_attribute, 2) }
    ruby_constants { FactoryBot.build_list(:ruby_constant, 3) }
  end
end
