require 'rails_helper'
RSpec.describe "Movie Details page" do
  describe 'As an unregistered user, when I visit the movies details page' do
    it 'I am redirected to the home page to log in' do
      visit '/movies/496243'
      expect(current_path).to eq(root_path)
      expect(page).to have_content('Please login.')
    end
  end

  describe "As a registered user, when I visit a movies detail page" do
    before :each do
      @user_1 = create :user
      visit root_path
      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      click_button 'Login'
      visit '/discover'
      VCR.insert_cassette('jurassic_search')
    end
    after :each do
      VCR.eject_cassette('jurassic_search')
    end
    it 'I see a button to create a viewing party' do
        fill_in :search, with: 'Jurassic Park'
        click_on 'Find Movies'
        expect(current_path).to eq('/movies/search')
        within first('.title') do
          click_link
        end
        expect(current_path).to eq('/movies/329')
        expect(page).to have_button('Create Viewing Party for Movie')
        click_on 'Create Viewing Party for Movie'
        expect(current_path).to eq('/viewing-party/new')
    end
    it 'I see a the movie details' do
      fill_in :search, with: 'Jurassic Park'
      click_on 'Find Movies'
      expect(current_path).to eq('/movies/search')
      within first('.title') do
        click_link
      end
      within '#title' do
        expect(page).to have_content('Jurassic Park')
      end
      within '#vote-average' do
        expect(page).to have_content('Vote Average: 7.9')
      end
      within '#runtime' do
        expect(page).to have_content('Runtime: 2 hrs 7 mins')
      end
      within '#genre' do 
        expect(page).to have_content("Genre(s):")
      end
      within '#description' do 
        expect(page).to have_content('A wealthy entrepreneur secretly creates a theme park featuring living dinosaurs')
      end
      within '#cast' do
        expect(page).to have_content('Sam Neill as Dr. Alan Grant')
      end
      within '#review' do 
        expect(page).to have_content('4 Reviews')
      end
      within '#review' do
        expect(page).to have_content('Author: BinaryCrunch')
        expect(page).to have_content('If you somehow missed this movie and have never seen it then watch it immediately.')
      end
    end
  end
end
