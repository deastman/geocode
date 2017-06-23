require 'httparty'

class GoogleMapsApiCaller
  attr_reader :query_params

  def initialize(query_params)
    @query_params = query_params
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
    query_url + request_query_string
  end

  def query_url
    "https://maps.googleapis.com/maps/api/geocode/json?address="
  end

  def request_query_string
    query_params.select { |_, v| v.present? }.values.each do |value|
      value.gsub!(/\s/,'+')
    end.compact.join(",")
  end

  def hash_to_query(query)
    require 'cgi' unless defined?(CGI) && defined?(CGI.escape)
    query.map{ |p| CGI.escape p.to_s }.compact.sort * '&'
  end

  attr_writer :query_params
end
