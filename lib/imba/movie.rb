module Imba
  class Movie
    def self.all
      Imba::DataStore[:movies] || []
    end
  end
end
