class GoogleMapsApiResultsParser

  attr_accessor :results_array, :result

  def initialize(results_array)
    @results_array = results_array

    @result = {}
    @result[:data] = []
  end

  ## Status
  ##
  # OK                no errors occurred; the address was successfully parsed and at least one geocode was returned
  # ZERO_RESULTS      the geocode was successful but returned no results. This may occur if the geocoder was passed a non-existent address
  # OVER_QUERY_LIMIT  over quota
  # REQUEST_DENIED    request was denied
  # INVALID_REQUEST   generally indicates that the query (address, components or latlng) is missing
  # UNKNOWN_ERROR
  ##
  def parse
    return {} unless results_array

    if results_array['status'] == "OK" || results_array['status'] == "ZERO_RESULTS"
      result[:data] = results_array['results']
    else
      ErrorLog.debug(results_array['status'])
    end

    result
  end
end
