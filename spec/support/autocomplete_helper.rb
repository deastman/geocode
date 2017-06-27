module AutocompleteHelper
  def fill_in_autocomplete_field(string)
    if string.present?
      place_id = "ChIJ2eUgeAK6j4ARbn5u_wAGqWA"
      first('input#location_place_id', visible: false).set(place_id)
      first("input[name='location[result_string]']").set(string)
    end
  end
end
