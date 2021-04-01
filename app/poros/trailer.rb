class Trailer
  attr_reader :key,
              :size

  def initialize(data)
    @key = data[:key]
    @size = data[:size]
  end
end
