module Imba
  class Movie
    attr_reader :id
    attr_accessor :data

    def initialize(id)
      @id = id
      @data = Imba::DataStore.data_store
    end

    def save
      Imba::DataStore[id] = { id: id, title: title, year: year, genres: genres, rating: rating }
    end

    def self.all
      []
    end

    def id
      Imba::DataStore[id][:id]
    end

    def title
      Imba::DataStore[id][:title]
    end

    def title=(value)
      update(:title, value)
    end

    def year
      Imba::DataStore[id][:year]
    end

    def year=(value)
      update(:year, value)
    end

    def genres
      Imba::DataStore[id][:genres]
    end

    def genres=(values)
      update(:genres, values.map { |g| g.downcase.to_sym })
    end

    def rating
      Imba::DataStore[id][:rating]
    end

    def rating=(value)
      update(:rating, value)
    end

    def update(key, value)
      Imba::DataStore[id] = Imba::DataStore[id].merge(key => value)
    end
  end
end
