require 'rails_helper'

RSpec.describe Film do
  describe 'happy path' do
    it 'has attributes of size, key and is a Trailer object' do
      data = {:id=>"533ec654c3a368544800039a",
                             :iso_639_1=>"en",
                             :iso_3166_1=>"US",
                             :key=>"ctRK-4Vt7dA",
                             :name=>"The Green Mile Trailer [HD]",
                             :site=>"YouTube",
                             :size=>360,
                             :type=>"Trailer"}

      result = Trailer.new(data)

      expect(result).to be_a(Trailer)
      expect(result.key).to eq("ctRK-4Vt7dA")
      expect(result.size).to eq(360)
    end
  end
end
