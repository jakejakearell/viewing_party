class ViewingEventsController < ApplicationController
  def new
    @movie = Movie.find_or_create_by(session[:movie_info])
  end

  def create
    viewing_event = ViewingEvent.new(viewing_event_params)
    if viewing_event.save && params[:friends]
      create_event_and_viewers(params[:friends], viewing_event.id)
    elsif viewing_event.save
      redirect_to dashboard_index_path
    else
      @movie = Movie.find(params[:movie_id])
      flash.now[:errors] = viewing_event.errors.full_messages.to_sentence
      render :new
    end
    session.delete(:movie_info)
  end

  def create_event_and_viewers(friends, viewing_event_id)
    Viewer.create_event_viewers(friends, viewing_event_id)
    redirect_to dashboard_index_path
  end

  private

  def viewing_event_params
    params.permit(:duration, :start_date_time, :start_date, :user_id, :movie_id)
  end
end
