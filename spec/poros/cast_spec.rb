require 'rails_helper'

RSpec.describe Cast do
  describe 'happy path' do
    it "should build a cast PORO based on give data" do
      data = ''
      id = 238

      VCR.use_cassette('cast_info_given_id') do
        data = MovieService.cast_data(id)
      end

      cast = Cast.new(data[0])
      expect(cast).to be_a(Cast)
      expect(cast.name).to be_a(String)
      expect(cast.character).to be_a(String)
    end
  end
end
