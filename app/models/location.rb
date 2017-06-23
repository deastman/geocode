class Location < ApplicationRecord
  scope :desc, -> { order("locations.created_at DESC") }

  def self.find_by_latitude_longitude(latitude, longitude)
    where(latitude: latitude, longitude: longitude)
  end

  def self.find_by_form_attributes(location_params)
    
  end
end
