module GoogleMapsApiHelpers

  def stub_successful_request(options = {})
    url = "https://maps.googleapis.com/maps/api/geocode/json"
    status = options.fetch(:status, 200)
    response_body = options.fetch(:body,
                                  json_string("google_maps_success_results.json"))
    stub_request(:get, url).with(query: hash_including({})).
      to_return(status: status, body: response_body, headers: { content_type: 'application/json' })
  end

  def stub_invalid_request(options = {})
    url = "https://maps.googleapis.com/maps/api/geocode/json"
    status = options.fetch(:status, 200)
    response_body = options.fetch(:body,
                                  json_string("google_maps_invalid_results.json"))
    stub_request(:get, url).with(query: hash_including({})).
      to_return(status: status, body: response_body, headers: { content_type: 'application/json' })
  end


  # Return the path to the JSON fixtures directory
  def json_dir
    File.join File.dirname(__FILE__), "/fixtures/json"
  end

  # Return a filename for a JSON fixture
  def json_file(filename)
    File.join json_dir, filename
  end

  # Return the contents of a JSON fixture as a String
  def json_string(filename)
    File.read json_file(filename)
  end

  # Return the contents of a JSON fixture as a data structure
  def json_struct(filename)
    JSON.parse json_string(filename)
  end
end
