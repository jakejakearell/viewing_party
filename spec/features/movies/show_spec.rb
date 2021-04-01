require 'rails_helper'

describe "As an authenticated user, when I visit the movies detail page I see" do
  before :each do
    @user_1 = User.create!(email: 'sassy@email.com', password: 'sassyperson1')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)

    VCR.use_cassette('top_movie_data_movie_index') do
      @movies = MoviesFacade.top40
    end
    @find_movie = @movies.third
  end

  it "An overview with the movie name, vote average, runtime, genre(s), and summary" do
    VCR.use_cassette('single_movie_show_page') do
      visit movie_path(@find_movie.id)

      @movie = MoviesFacade.movie_info(@find_movie.id)

      within ".overview" do
        expect(page).to have_content("#{@movie.title}")
        expect(page).to have_content("#{@movie.vote_average}")
        expect(page).to have_content("#{@movie.runtime_hours_mins}")
        expect(page).to have_content("#{@movie.genre_names}")
        expect(page).to have_content("#{@movie.summary}")
      end
    end
  end

  it "A cast section with up to 10 cast members" do
    VCR.use_cassette('single_movie_show_page_cast') do
      visit movie_path(@find_movie.id)

      cast = MoviesFacade.cast_info(@find_movie.id)

      within ".cast" do
        expect(page).to have_content("#{cast.first.name}")
        expect(page).to have_content("#{cast.first.character}")
        expect(page).to have_content("#{cast.last.name}")
        expect(page).to have_content("#{cast.last.character}")
        expect(page.all('li', count: 10))
      end
    end
  end

  it "A reviews section with a count of the reviews, each review and author" do
    VCR.use_cassette('single_movie_show_page_reviews') do
      visit movie_path(@find_movie.id)

      reviews = MoviesFacade.movie_reviews(@find_movie.id)

      within ".reviews" do
        expect(page).to have_content("#{reviews.count}")
        expect(page).to have_content("#{reviews.first.author}")
        expect(page).to have_content("#{reviews.first.review}")
        expect(page).to have_content("#{reviews.last.author}")
        expect(page).to have_content("#{reviews.last.review}")
        expect(page.all('p', count: reviews.count))
      end
    end
  end

  it "A button to create a viewing party, when clicked I am taken to a form" do
    @user_2 = User.create!(email: 'grumpy@email.com', password: 'grumpyperson1')
    @user_3 = User.create!(email: 'sleepy@email.com', password: 'sleepyperson1')
    @friend_1 = Friend.create!(follower_id: @user_1.id, followed_id: @user_2.id)
    @friend_2 = Friend.create!(follower_id: @user_1.id, followed_id: @user_3.id)

    VCR.use_cassette('single_movie_show_page_reviews') do
      visit movie_path(@find_movie.id)

      expect(page).to have_button('Create Viewing Party for Movie')

      click_button 'Create Viewing Party for Movie'

      expect(current_path).to eq(new_viewing_event_path)
      expect(page).to have_content("#{@find_movie.title}")
    end
  end

  it "shows the youtube trailer when available" do
    VCR.use_cassette('single_movie_show_page_vidoes') do
      visit movie_path(@find_movie.id)

      trailer = MoviesFacade.movie_videos(@find_movie.id)

      within ".trailer" do
        expect(page.all('iframe', count: trailer.count))
      end
    end
  end
end
