class MoviesController < ApplicationController
  before_action :require_current_user

  def index
    @movies = MoviesFacade.top40
  end

  def search
    if params[:find_movie] == ''
      flash.now[:message] = 'Please enter a search term'
      @movies = MoviesFacade.top40
    else
      @movies = MoviesFacade.movie_search(params[:find_movie])
    end
    flash.now[:message] = 'Your search returned 0 results' if @movies.empty?
    render :index
  end

  def show
    @movie = MoviesFacade.movie_info(params[:id])
    @cast = MoviesFacade.cast_info(params[:id])
    @reviews = MoviesFacade.movie_reviews(params[:id])
    @trailers = MoviesFacade.movie_videos(params[:id])
    session[:movie_info] = {movie_db_id: @movie.id, title: @movie.title, runtime: @movie.runtime}
  end

  private

  def require_current_user
    render file: '/public/401' unless current_user
  end
end
