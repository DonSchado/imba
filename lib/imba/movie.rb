module Imba
  class Movie < ActiveRecord::Base
    serialize :genres, Array

    scope :list, -> { order(name: :asc) }
    scope :top, ->(n = 25) { order(rating: :desc).limit(n) }
    scope :year, ->(year = Time.now.year) { where(year: year) }
    scope :genre, ->(genre = nil) { where('genres LIKE ?', "%#{genre}%") }

    def to_s
      "#{uniq_id}: #{name} (#{year}), #{rating}/10, #{genres}"
    end
  end
end
