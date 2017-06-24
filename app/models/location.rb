class Location < ApplicationRecord
  scope :desc, -> { order("locations.created_at DESC") }

  def self.find_by_place_id(place_id)
    where(place_id: place_id)
  end

  def self.find_by_form_attributes(location_params)

  end
end
