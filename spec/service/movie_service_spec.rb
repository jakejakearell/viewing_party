require 'rails_helper'

RSpec.describe Film do
  describe "happy path" do
    it 'tests the structure of our api data for top rated movies' do
      data = ''
      page = 1

      VCR.use_cassette('top_movie_data') do
        data = MovieService.top_films(page)
      end

      expect(data).to be_a(Hash)
      expect(data).to have_key(:results)
      expect(data[:results][0]).to be_a(Hash)
      expect(data[:results].length).to eq(20)
      expect(data[:results][0][:title]).to be_a(String)
      expect(data[:results][0][:popularity]).to be_a(Float)
      expect(data[:results][0][:id]).to be_a(Integer)
    end

    it 'tests the structure of our api data for searched movies' do
      data = ''
      page = 1

      VCR.use_cassette('searched_movie_data') do
        data = MovieService.top_films(page)
      end

      expect(data).to be_a(Hash)
      expect(data).to have_key(:results)
      expect(data[:results][0]).to be_a(Hash)
      expect(data[:results].length).to eq(20)
      expect(data[:results][0][:title]).to be_a(String)
      expect(data[:results][0][:popularity]).to be_a(Float)
      expect(data[:results][0][:id]).to be_a(Integer)
    end

    it "returns the top rated movies" do
      data = ''
      page = 1

      VCR.use_cassette('top_movie_data') do
        data = MovieService.top_films(page)
      end

      expect(data[:results].length).to eq(20)
      expect(data[:results][0]).to have_key(:title)
      expect(data[:results][0]).to have_key(:id)
      expect(data[:results][0]).to have_key(:popularity)
    end

    it "returns movies related to searched for keyword" do
      data = ''
      page = 1
      keyword = 'fire'

      VCR.use_cassette('searched_movie_data') do
        data = MovieService.film_finder(page, keyword)
      end

      expect(data[:results].length).to be <= 20
      expect(data[:results][0]).to have_key(:title)
      expect(data[:results][0]).to have_key(:id)
      expect(data[:results][0]).to have_key(:popularity)
    end

    it "returns all videos related to a movie" do
      VCR.use_cassette('all green mile video info') do
        green_mile_movie_id = 497
        data = MovieService.trailer_data(green_mile_movie_id)

        expect(data.class).to be(Array)
        expect(data.first.class).to be(Hash)
        expect(data.first).to have_key(:id)
        expect(data.first).to have_key(:iso_639_1)
        expect(data.first).to have_key(:iso_3166_1)
        expect(data.first).to have_key(:key)
        expect(data.first).to have_key(:name)
        expect(data.first).to have_key(:site)
        expect(data.first).to have_key(:size)
        expect(data.first).to have_key(:type)
      end
    end

    it "filters out all results that are not on YouTube and a trailer" do
      VCR.use_cassette('all green mile video info') do
        green_mile_movie_id = 497
        data = MovieService.valid_trailers(green_mile_movie_id)
        
        expect(data.class).to be(Array)
        expect(data.first.class).to be(Hash)
        expect(data.first[:site]).to eq("YouTube")
        expect(data.first[:type]).to eq("Trailer")
        expect(data.last[:site]).to eq("YouTube")
        expect(data.last[:type]).to eq("Trailer")
      end
    end
  end
end
