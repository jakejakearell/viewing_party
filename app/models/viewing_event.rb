class ViewingEvent < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  has_many :viewers
  has_many :users, through: :viewers

  validates :duration, :start_date, :start_date_time, presence: true
  validate :start_date_cant_be_in_the_past
  validate :duration_cant_be_less_than_movie_runtime

  def start_date_cant_be_in_the_past
    errors.add(:start_date, "can't be in the past") if start_date && start_date < Date.today
  end

  def duration_cant_be_less_than_movie_runtime
    errors.add(:duration, "can't be less than movie runtime") if duration && duration < Movie.find(movie_id).runtime
  end
end
