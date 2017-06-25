class Location < ApplicationRecord
  scope :desc, -> { order("locations.created_at DESC") }

  validates :place_id, :latitude, :longitude, presence: true 

  def self.find_by_place_id(place_id)
    where(place_id: place_id)
  end
end
