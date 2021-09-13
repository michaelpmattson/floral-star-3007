require 'rails_helper'

RSpec.describe 'the mechanics show page' do
  context 'when I visit a mechanic show page' do
    before(:each) do
      @speed_land = AmusementPark.create!(name: 'Speed Land', price_of_admission: 50)

      @frog_hop        = @speed_land.rides.create!(name: 'The Frog Hopper', thrill_rating: 2, open: true)
      @fahrenheit      = @speed_land.rides.create!(name: 'Fahrenheit', thrill_rating: 7, open: true)
      @kiss_raise      = @speed_land.rides.create!(name: 'The Kiss Raise', thrill_rating: 4, open: true)
      @lightning_racer = @speed_land.rides.create!(name: 'Lightning Racer', thrill_rating: 9, open: false)
      @storm_runner    = @speed_land.rides.create!(name: 'Storm Runner', thrill_rating: 8, open: false)
      @great_bear      = @speed_land.rides.create!(name: 'The Great Bear', thrill_rating: 6, open: true)

      @speed     = Mechanic.create!(name: 'Speed Racer', years_experience: 5)
      @trixie    = Mechanic.create!(name: 'Trixie',      years_experience: 4)
      @chimchim  = Mechanic.create!(name: 'Chim-Chim',   years_experience: 2)

      @speed.rides << @frog_hop
      @speed.rides << @kiss_raise
      @speed.rides << @fahrenheit
      @speed.rides << @lightning_racer

      visit "/mechanics/#{@speed.id}"
    end

    it 'shows their name, years of experience, and the names of rides theyre working on, in desc order of thrill rating' do
      expect(page).to have_content('Mechanic: Speed Racer')
      expect(page).to have_content('Years of Experience: 5')

      expect("Current rides they're working on:").to appear_before('Fahrenheit')
      expect('Fahrenheit').to appear_before('The Kiss Raise')
      expect('The Kiss Raise').to appear_before('The Frog Hopper')
    end

    it 'shows only the rides that are open' do
      expect(page).to_not have_content('Lightning Racer')
    end

    it 'has a form to add a ride to their workload that takes ride id' do
      expect(page).to_not have_content('The Great Bear')

      fill_in('ride_id', with: "#{@great_bear.id}")
      click_button('Add ride by id')

      expect(current_path).to eq("/mechanics/#{@speed.id}")
      expect(page).to have_content('The Great Bear')
    end

    it 'returns an error if the ride id does not exist' do
      fill_in('ride_id', with: 1)
      click_button('Add ride by id')
      save_and_open_page
    end
  end
end
