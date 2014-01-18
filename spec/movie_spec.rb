require 'spec_helper'

module Imba
  describe Movie do
    let!(:sneakers) { Movie.create(name: 'Sneakers', uniq_id: 1, year: 2012, genres: [:foo, :hackers], rating: 7.0) }
    let!(:war_games) { Movie.create(name: 'War Games', uniq_id: 2, year: 2012, genres: [:foo, :war], rating: 8.0) }
    let!(:tron) { Movie.create(name: 'Tron: Legacy', uniq_id: 3, year: 2012, genres: [:foo, :tron], rating: 9.0) }

    it { expect(Movie.list).to match_array([sneakers, tron, war_games]) }
    it { expect(Movie.top(5).first).to eql(tron) }
    it { expect(Movie.top(5).last).to eql(sneakers) }
  end
end
