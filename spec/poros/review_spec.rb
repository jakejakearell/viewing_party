require 'rails_helper'

RSpec.describe Review do
  describe 'happy path' do
    it 'should build a Review PORO based on input' do
      page = 1

      VCR.use_cassette('top_movie_data') do
        @movies = MovieService.top_films(page)
      end

      @movie_id = @movies[:results][0][:id]

      VCR.use_cassette('review_data') do
        @data = MovieService.review_data(@movie_id)
      end
      
      review = Review.new(@data[0])
      expect(review).to be_a(Review)
      expect(review.author).to be_a(String)
      expect(review.review).to be_a(String)
    end

  end
end
