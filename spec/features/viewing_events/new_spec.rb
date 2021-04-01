require 'rails_helper'

describe "As an authenticated user, when I visit the movies detail page and create viewing party" do
  before :each do
    @user_1 = User.create!(email: 'sassy@email.com', password: 'sassyperson1')
    @user_2 = User.create!(email: 'grumpy@email.com', password: 'grumpyperson1')
    @user_3 = User.create!(email: 'sleepy@email.com', password: 'sleepyperson1')
    @user_4 = User.create!(email: 'dopey@email.com', password: 'dopeyperson1')
    @friend_1 = Friend.create!(follower_id: @user_1.id, followed_id: @user_2.id)
    @friend_2 = Friend.create!(follower_id: @user_1.id, followed_id: @user_3.id)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)

    VCR.use_cassette('create_viewing_party') do
      @movies = MoviesFacade.top40
      @find_movie = @movies.third
      visit movie_path(@find_movie.id)
      @movie = MoviesFacade.movie_info(@find_movie.id)
    end
    click_button 'Create Viewing Party for Movie'
  end

  it "I see a form with the movie title, duration, date, time" do
    date = Time.now.strftime("%Y-%m-%d")

    expect(page).to have_content("#{@find_movie.title}")
    expect(page).to have_field(:duration, with: "#{@movie.runtime}")
    expect(page).to have_field(:start_date, with: date)
    expect(page).to have_field(:start_date_time)
  end

  it "I also see an invite section where I can invite my friends" do
    friend_1 = @user_1.followed.first
    friend_2 = @user_1.followed.last

    expect(page).to have_unchecked_field("friends_#{friend_1.id}")
    expect(page).to have_unchecked_field("friends_#{friend_2.id}")
    expect(page).to_not have_unchecked_field("friends_#{@user_4.id}")
  end

  describe "and if I fill out the form with valid info" do
    it "I create a viewing party and am taken to the dashboard where I can see it" do
      date = Time.now.strftime("%Y-%m-%d")
      time = Time.now.strftime("%H:%M")
      duration = @movie.runtime + 30
      friend_1 = @user_1.followed.first
      friend_2 = @user_1.followed.last

      fill_in :duration, with: duration
      fill_in :start_date, with: date
      fill_in :start_date_time, with: time
      check "friends_#{friend_1.id}"
      click_button 'Create Party'

      expect(current_path).to eq(dashboard_index_path)
      expect(page).to have_content("#{@movie.title}")
    end

    it "I can create an event without inviting friends" do
      date = Time.now.strftime("%Y-%m-%d")
      time = Time.now.strftime("%H:%M")
      duration = @movie.runtime + 30

      fill_in :duration, with: duration
      fill_in :start_date, with: date
      fill_in :start_date_time, with: time
      click_button 'Create Party'

      expect(current_path).to eq(dashboard_index_path)

      viewing_event = ViewingEvent.find_by(user_id: @user_1.id)

      expect(viewing_event.duration).to eq(duration)
      expect(viewing_event.user_id).to eq(@user_1.id)
      expect(viewing_event.viewers.count).to eq(0)
      expect { Viewer.find(viewing_event.id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe "and if I do not fill out the form with valid info" do
    it "I cannot create a event for a date in the past" do
      date = Time.new(2002).strftime("%Y-%m-%d")
      time = Time.now.strftime("%H:%M")
      duration = @movie.runtime + 30

      fill_in :duration, with: duration
      fill_in :start_date, with: date
      fill_in :start_date_time, with: time
      click_button 'Create Party'

      expect(current_path).to eq(viewing_events_path)
      expect(page).to have_content("Start date can't be in the past")

    end

    it "I cannot create a event for a duration less than the movie runtime" do
      date = Time.now.strftime("%Y-%m-%d")
      time = Time.now.strftime("%H:%M")
      duration = @movie.runtime - 30

      fill_in :duration, with: duration
      fill_in :start_date, with: date
      fill_in :start_date_time, with: time
      click_button 'Create Party'

      expect(current_path).to eq(viewing_events_path)
      expect(page).to have_content("Duration can't be less than movie runtime")
    end

    it "I cannot create without a duration" do
      date = Time.now.strftime("%Y-%m-%d")
      time = Time.now.strftime("%H:%M")

      fill_in :duration, with: ""
      fill_in :start_date, with: date
      fill_in :start_date_time, with: time
      click_button 'Create Party'

      expect(current_path).to eq(viewing_events_path)
      expect(page).to have_content("Duration can't be blank")
    end

    it "I cannot create an event without a start date" do
      date = Time.now.strftime("%Y-%m-%d")
      time = Time.now.strftime("%H:%M")
      duration = @movie.runtime

      fill_in :duration, with: duration
      fill_in :start_date, with: ""
      fill_in :start_date_time, with: time
      click_button 'Create Party'

      expect(current_path).to eq(viewing_events_path)
      expect(page).to have_content("Start date can't be blank")
    end

    it "I cannot create an event without a start time" do
      date = Time.now.strftime("%Y-%m-%d")
      time = Time.now.strftime("%H:%M")
      duration = @movie.runtime

      fill_in :duration, with: duration
      fill_in :start_date, with: date
      fill_in :start_date_time, with: ""
      click_button 'Create Party'

      expect(current_path).to eq(viewing_events_path)
      expect(page).to have_content("Start date time can't be blank")
    end
  end
end
