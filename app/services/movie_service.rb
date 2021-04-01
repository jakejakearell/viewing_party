class MovieService
  def self.conn
    Faraday.new('https://api.themoviedb.org/3/') do |request|
      request.params['api_key'] = ENV['MOVIE_API']
      request.params['language'] = 'en-US'
    end
  end

  def self.top_films(page)
    response = conn.get("movie/top_rated?page=#{page}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.film_finder(page, query)
    response = conn.get("search/movie?&query=#{query}&page=#{page}&include_adult=false")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.movie_data(id)
    response = conn.get("movie/#{id}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.cast_data(id)
    response = conn.get("movie/#{id}/credits")
    JSON.parse(response.body, symbolize_names: true)[:cast][0..9]
  end

  def self.review_data(id)
    response = conn.get("movie/#{id}/reviews")
    JSON.parse(response.body, symbolize_names: true)[:results]
  end

  def self.trailer_data(id)
    response = conn.get("movie/#{id}/videos")
    JSON.parse(response.body, symbolize_names: true)[:results]
  end

  def self.valid_trailers(id)
    trailer_data(id).find_all do |info|
      info[:site] == "YouTube" && info[:type] == "Trailer"
    end
  end
end
