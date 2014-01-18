module Imba
  class Movie < ActiveRecord::Base
    include Colors
    serialize :genres, Array

    scope :list, -> { order(name: :asc) }
    scope :top, ->(n = 25) { order(rating: :desc).limit(n) }
    scope :year, ->(year = Time.now.year) { where(year: year) }
    scope :genre, ->(genre = nil) { where('genres LIKE ?', "%#{genre}%") }

    def to_s
      terminal_width = `tput cols`
      column = terminal_width.to_i / 2

      ''.tap do |s|
        s << "#{sprintf('%-9s', uniq_id)} #{green(name)}".ljust(column)
        s << ' ' + magenta("(#{year})")
        s << ' ' + red("#{rating}/10")
        s << ' ' + yellow(genres)
        s.rjust(column)
      end
    end
  end
end
