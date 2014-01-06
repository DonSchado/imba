module Imba
  class MovieList
    attr_reader :movies

    def initialize
      @movies = Imba::DataStore[:movies]
    end
  end
end
