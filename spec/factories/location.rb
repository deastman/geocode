FactoryGirl.define do
  factory :location do
    latitude { rand(-90.000000...90.000000) }
    longitude { rand(-180.000000...180.000000) }
    place_id { ('a'..'z').to_a.shuffle[0,8].join }
  end
end
