class MoviesController < ApplicationController
  before_action :require_current_user

  def index
    @movies = MoviesFacade.top40
  end

  def search
    @movies = MoviesFacade.movie_search(params[:find_movie])
    render :index
  end

  def show
    @movie = MoviesFacade.movie_info(params[:id])
    @cast = MoviesFacade.cast_info(params[:id])
  end

  private

  def require_current_user
    render file: '/public/401' unless current_user
  end
end
