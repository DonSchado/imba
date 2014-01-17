module Imba
  class Movie < ActiveRecord::Base
    serialize :genres, Array

    scope :list, -> { order(name: :asc) }

    def to_s
      "#{uniq_id}: #{name} (#{year}), #{rating}/10, #{genres}"
    end
  end
end
