FactoryGirl.define do
	factory :role do
		name { Faker::Cat.name }
		uid { Faker::Number.between(1500000, 2000000) }
	end
end