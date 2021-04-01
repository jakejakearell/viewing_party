class Movie < ApplicationRecord
  has_many :viewing_events, dependent: :destroy
end
