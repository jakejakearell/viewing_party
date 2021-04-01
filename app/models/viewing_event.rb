class ViewingEvent < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  has_many :viewers
  has_many :users, through: :viewers

  validates_presence_of [:duration, :start_date, :start_date_time]
  validate :start_date_cant_be_in_the_past
  validate :duration_cant_be_less_than_movie_runtime

  def start_date_cant_be_in_the_past
    if start_date && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
  end

  def duration_cant_be_less_than_movie_runtime
    if duration && duration < Movie.find(movie_id).runtime
      errors.add(:duration, "can't be less than movie runtime")
    end
  end
end
