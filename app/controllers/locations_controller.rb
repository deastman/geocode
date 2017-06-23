class LocationsController < ApplicationController
  def new
    set_locations
  end

  def create
    if query_params_present_in_form?
      results = call_to_api_for_location_data
      parsed_results = parse_api_results(results)

      if parsed_results[:data].empty?
        flash[:notice] = 'No results match your query. Please try another search.'
      else
        @location_results = LocationResults.new(parsed_results[:data].first)

        if !location_already_in_db?(@location_results)
          create_new_location(@location_results)
        end

        flash[:notice] = "Your location has coordinates #{@location_results.latitude}, #{@location_results.longitude}"
      end
    else
      flash[:error] = 'Please fill in at least one form field.'
    end

    set_locations
    render :new
  end

  private

  def query_params_present_in_form?
    location_params.any? { |_, v| v.present? }
  end

  def call_to_api_for_location_data
    GoogleMapsApiCaller.new(location_params.deep_dup).call
  end

  def parse_api_results(results)
    GoogleMapsApiResultsParser.new(results).parse
  end

  def set_locations
    @location = Location.new
    @locations = Location.all
  end

  def create_new_location(location_results)
    location = Location.new

    location.latitude = location_results.latitude
    location.longitude = location_results.longitude
    location.street_address = location_results.street_address
    location.city = location_results.city
    location.state = location_results.state_code
    location.country = location_results.country

    location.save!
  end

  def location_already_in_db?(location_results)
    latitude = BigDecimal.new(location_results.latitude, 9)
    longitude = BigDecimal.new(location_results.longitude, 8)

    Location.find_by_latitude_longitude(latitude, longitude).any?
  end

  def retrieve_location_from_db_by_form_input
    Location.find_by_form_attributes(location_params)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def location_params
    params.require(:location).permit(:street_address, :city, :state, :country, :latitude, :longitude)
  end
end
