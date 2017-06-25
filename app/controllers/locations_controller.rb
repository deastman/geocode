class LocationsController < ApplicationController
  def new
    set_locations
  end

  def create
    if location_params[:place_id].present?
      # If the location already exists in the db, we don't need to call to the Google Maps API
      @location_results = Location.find_by_place_id(location_params[:place_id]).first

      if @location_results.blank?
        parsed_results = call_parse_and_return_api_results

        if parsed_results[:data].empty?
          flash.now[:error] = t('no_results')
        else
          @location_results = LocationResults.new(parsed_results[:data].first)

          if create_new_location(@location_results)
            flash.now[:notice] = t('new_result_and_save_success', latitude: @location_results.latitude, longitude: @location_results.longitude)
          else
            flash.now[:notice] = t('new_result_and_save_failure', latitude: @location_results.latitude, longitude: @location_results.longitude)
          end
        end
      else
        flash.now[:notice] = t('location_already_exists', latitude: @location_results.latitude, longitude: @location_results.longitude)
      end
    else
      flash.now[:error] = t('invalid_search')
    end

    set_locations

    render :new
  end

  private

  def query_params_present_in_form?
    location_params.any? { |_, v| v.present? }
  end

  def call_parse_and_return_api_results
    results = call_to_api_for_location_data
    parse_api_results(results)
  end

  def call_to_api_for_location_data
    GoogleMapsApiCaller.new(params_place_id).call
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
    location.place_id = location_results.place_id

    location.save!
  end

  def params_place_id
    location_params[:place_id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def location_params
    params.require(:location).permit(:result_string, :place_id)
  end
end
