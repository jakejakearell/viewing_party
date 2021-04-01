require 'rails_helper'

RSpec.describe MoviesFacade do
  describe 'happy path' do
    it "called Facade top40 and gets data" do
      result = ''

      VCR.use_cassette('top_movie_data') do
        result = MoviesFacade.top40
      end

      expect(result).to be_an(Array)
      expect(result[0]).to be_an(Film)
      expect(result.length).to eq(40)
    end

    it "called Facade movie_search and gets data" do
      result = ''
      keyword = 'pulp fiction'

      VCR.use_cassette('searched_movie_specific_keyword') do
        result = MoviesFacade.movie_search(keyword)
      end

      expect(result).to be_an(Array)
      expect(result[0]).to be_an(Film)
      expect(result[0].title).to eq('Pulp Fiction')
    end

    it "called Facade movie_info and gets specfic movie data" do
      result = ''
      id = 238

      VCR.use_cassette('movie_info_given_id') do
        result = MoviesFacade.movie_info(id)
      end

      expect(result).to be_an(Film)
      expect(result.genres).to be_an(Array)
      expect(result.genres[0]).to be_an(Hash)
      expect(result.summary).to be_a(String)
      expect(result.runtime).to be_a(Integer)
    end

    it "called Facade movie_cast and gets specfic movie cast data" do
      result = ''
      id = 238

      VCR.use_cassette('cast_info_given_id') do
        result = MoviesFacade.cast_info(id)
      end

      expect(result).to be_an(Array)
      expect(result[0]).to be_a(Cast)
      expect(result[0].character).to be_a(String)
      expect(result[0].name).to be_a(String)
    end

    it "called Facade movie_reviews and gets specfic movie review data" do
      result = ''
      id = 238

      VCR.use_cassette('review_info_given_id') do
        result = MoviesFacade.movie_reviews(id)
      end

      expect(result).to be_an(Array)
      expect(result[0]).to be_a(Review)
      expect(result[0].author).to be_a(String)
      expect(result[0].review).to be_a(String)
    end

    it "called Facade movie_search and gets data" do

      VCR.use_cassette('green mile trailers') do
        green_mile_movie_id = 497
        result = MoviesFacade.movie_videos(green_mile_movie_id)

        expect(result).to be_an(Array)
        expect(result[0]).to be_an(Trailer)
        expect(result[0].size.class).to eq(Integer)
        expect(result[0].key.class).to eq(String)
      end
    end
  end
end
