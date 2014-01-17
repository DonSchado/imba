module Imba
  class Movie < ActiveRecord::Base
    serialize :genres, Array

    scope :list, -> { order(name: :asc) }
    scope :top_25, -> { order(rating: :desc).limit(25) }

    def to_s
      "#{uniq_id}: #{name} (#{year}), #{rating}/10, #{genres}"
    end
  end
end
