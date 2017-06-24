require 'httparty'

class GoogleMapsApiCaller
  attr_reader :place_id

  def initialize(place_id)
    @place_id = place_id
  end

  def call
    query_url = form_query
    fetch_data(query_url)
  end

  private

  def fetch_data(query_url)
    HTTParty.get(query_url)
  end

  def form_query
    "#{query_url}#{@place_id}&key=#{api_key}"
  end

  def api_key
    "AIzaSyAh8gDRXvu_aLNvyta6gKngau3zqxs46B4"
  end

  def query_url
    "https://maps.googleapis.com/maps/api/geocode/json?place_id="
  end

  attr_writer :place_id
end
