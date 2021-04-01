require 'rails_helper'

RSpec.describe Film do
  describe 'happy path' do
    it 'should build a Film PORO based on input' do
      data = ''
      page = 1

      VCR.use_cassette('top_movie_data') do
        data = MovieService.top_films(page)
      end

      film = Film.new(data[:results][0])
      expect(film).to be_a(Film)
      expect(film.title).to be_a(String)
      expect(film.id).to be_a(Integer)
      expect(film.vote_average).to be_a(Float)
    end

    it 'should build a Film PORO based on input' do
      page = 1

      VCR.use_cassette('top_movie_data') do
        @data_1 = MovieService.top_films(page)
      end

      @film_1 = Film.new(@data_1[:results][0])

      VCR.use_cassette('movie_data') do
        @data_2 = MovieService.movie_data(@film_1.id)
      end

      film_2 = Film.new(@data_2)
      expect(film_2).to be_a(Film)
      expect(film_2.title).to be_a(String)
      expect(film_2.id).to be_a(Integer)
      expect(film_2.vote_average).to be_a(Float)
      expect(film_2.runtime).to be_a(Integer)
      expect(film_2.genres.first).to be_a(Hash)
      expect(film_2.summary).to be_a(String)
    end
  end
end
