class ViewingEventsController < ApplicationController
  def new
    @movie = Movie.find_or_create(session[:movie_info])
  end

  def create
    viewing_event = ViewingEvent.new(viewing_event_params)
    if viewing_event.save && params[:friends]
      Viewer.create_event_viewers(params[:friends], viewing_event.id)
      session.delete(:movie_info)
      redirect_to dashboard_index_path
    elsif viewing_event.save
      session.delete(:movie_info)
      redirect_to dashboard_index_path
    else
      @movie = Movie.find(params[:movie_id])
      flash.now[:errors] = viewing_event.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def viewing_event_params
    params.permit(:duration, :start_date_time, :start_date, :user_id, :movie_id)
  end
end
