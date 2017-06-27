require 'rails_helper'

RSpec.feature 'Locations' do

  describe 'create' do
    it 'creates a new location' do
      visit polymorphic_path([:new, :location])

      fill_in_autocomplete_field("1400 Amphitheatre Pkwy, Mountain View, CA")

      stub_successful_request

      click_button('Search')

      within('div.alert') do
        expect(page).to have_content("This location has a latitude of 37.4224764 and a longitude of -122.0842499 and we've saved it to our database!")
      end

      expect(Location.all.length).to eq(1)

      created_location = Location.first
      expect(created_location.place_id).to eq('ChIJ2eUgeAK6j4ARbn5u_wAGqWA')
      expect(created_location.street_address).to eq('1600 Amphitheatre Pkwy')
      expect(created_location.city).to eq('Mountain View')
      expect(created_location.state).to eq('CA')
      expect(created_location.country).to eq('United States')
      expect(created_location.latitude).to eq(BigDecimal('37.422476'))
      expect(created_location.longitude).to eq(BigDecimal('-122.08425'))
    end

    context 'invalid search terms' do
      before { visit polymorphic_path([:new, :location]) }

      it 'shows an error message if the search parameters are missing' do
        fill_in_autocomplete_field("")

        click_button('Search')

        within('div.alert') do
          expect(page).to have_content("We couldn't understand your search terms. Please try another search.")
        end

        expect(Location.all.length).to eq(0)
      end

      context 'response' do
        it 'shows an error message if the returned response is not OK' do
          fill_in_autocomplete_field("anything")

          stub_invalid_request

          click_button('Search')

          within('div.alert') do
            expect(page).to have_content("No results match your query. Please try another search.")
          end

          expect(Location.all.length).to eq(0)
        end

        it 'logs an error if the returned response is not OK' do
          fill_in_autocomplete_field("anything")

          stub_invalid_request

          expect(ErrorLog).to receive(:debug).with("INVALID_REQUEST")

          click_button('Search')
        end
      end
    end

    context 'when the location already exists' do
      before do
        location = Location.new(
          place_id: 'ChIJ2eUgeAK6j4ARbn5u_wAGqWA',
          latitude: BigDecimal('37.4224764'),
          longitude: BigDecimal('-122.0842499')
        )

        location.save!
      end

      it 'does not create a new location' do
        visit polymorphic_path([:new, :location])

        expect(Location.all.length).to eq(1)

        fill_in_autocomplete_field("1400 Amphitheatre Pkwy, Mountain View, CA")

        stub_successful_request

        click_button('Search')

        within('div.alert') do
          expect(page).to have_content("This location has a latitude of 37.422476 and a longitude of -122.08425 and we already have it in our database!")
        end

        expect(Location.all.length).to eq(1)
      end
    end
  end

  describe 'new' do
    let!(:location_1) { FactoryGirl.create(:location, city: "Boston", state: "MA", country: "United States") }

    let!(:location_2) do
      FactoryGirl.create(
        :location,
        city: "Chicago",
        state: "IL",
        street_address: "12234 South Michigan Avenue",
        country: "United States"
      )
    end

    before { visit polymorphic_path([:new, :location]) }

    it 'contains a search field for a location' do
      expect(page).to have_css("input#pac-input")
    end

    it 'displays the right location data in a table' do
      expect(table_data_by_row_and_column(1, 1)).to eq("12234 South Michigan Avenue")
      expect(table_data_by_row_and_column(1, 2)).to eq("Chicago")
      expect(table_data_by_row_and_column(1, 3)).to eq("IL")
      expect(table_data_by_row_and_column(1, 4)).to eq("United States")
      expect(table_data_by_row_and_column(1, 5)).to eq(location_2.latitude.to_s)
      expect(table_data_by_row_and_column(1, 6)).to eq(location_2.longitude.to_s)

      expect(table_data_by_row_and_column(2, 1)).to eq("")
      expect(table_data_by_row_and_column(2, 2)).to eq("Boston")
      expect(table_data_by_row_and_column(2, 3)).to eq("MA")
      expect(table_data_by_row_and_column(2, 4)).to eq("United States")
      expect(table_data_by_row_and_column(2, 5)).to eq(location_1.latitude.to_s)
      expect(table_data_by_row_and_column(2, 6)).to eq(location_1.longitude.to_s)
    end
  end
end
