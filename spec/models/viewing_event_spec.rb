require 'rails_helper'

RSpec.describe ViewingEvent, type: :model do
  describe 'relationships' do
    it {should have_many(:viewers)}
    it {should have_many(:users).through(:viewers)}
    it {should belong_to(:user)}
    it {should belong_to(:movie)}
  end

  describe 'validations' do
    it "should throw an error if start date is in the past" do
      user = User.create!(email: 'myself@email.com', password: 'memyselfandI')
      movie = Movie.create!(movie_db_id: 1, title: "Movie", runtime: 120)
      date = Time.new(2020).strftime("%Y-%m-%d")
      time = Time.now.strftime("%H:%M")
      duration = movie.runtime + 30

      viewing_event = ViewingEvent.new(
        duration: duration,
        start_date: date,
        start_date_time: time,
        user_id: user.id,
        movie_id: movie.id
      )

      expect(viewing_event.save).to eq(false)
      expect(viewing_event.errors[:start_date].to_sentence).to eq("can't be in the past")
    end
  end
end
