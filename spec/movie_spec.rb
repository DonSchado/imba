require 'spec_helper'

module Imba
  describe Movie do
    it { expect(Movie.all).to eql([]) }
  end
end