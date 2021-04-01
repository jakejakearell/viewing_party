class MoviesFacade
  def self.top40
    @movies = []
    [1, 2].reduce([]) do |_memo, page|
      MovieService.top_films(page)[:results].each do |movie|
        @movies << Film.new(movie)
      end
      @movies
    end
  end

  def self.movie_search(query)
    @movies = []
    [1, 2].reduce([]) do |_memo, page|
      MovieService.film_finder(page, query)[:results].each do |movie|
        @movies << Film.new(movie)
      end
      @movies
    end
  end

  def self.movie_info(id)
    data = MovieService.movie_data(id)
    Film.new(data)
  end

  def self.cast_info(id)
    data = MovieService.cast_data(id)
    data.map do |info|
      Cast.new(info)
    end
  end

  def self.movie_reviews(id)
    data = MovieService.review_data(id)
    data.map do |info|
      Review.new(info)
    end
  end

  def self.movie_videos(id)
    data = MovieService.valid_trailers(id)
    videos = data.map do |info|
      Trailer.new(info)
    end
  end
end
