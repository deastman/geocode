# Geocoder - A Toy App

Geocoder is a simple implementation of the Google Places Autocomplete web service in conjunction with the Google Maps API
that returns the latitude and longitude of a queried location. In addition to basic information about the location (city,
state, address, latitude, longitude, etc.), the application stores Google's place_id. The place_id is returned by the
Google Places Autocomplete service and is accepted as a query parameter in the Google Maps API. This allows the application to
avoid unnecessary calls to the Google Maps API if the location has already been queried for and stored in the database.

See it in action here: https://geocoder-toy-app.herokuapp.com/locations/new

## Future UI Improvements
* Incorporate pagination on the results table
* Optimize the layout for mobile viewing
* Show map in conjunction with search details
