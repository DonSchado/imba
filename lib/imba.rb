require 'imba/version'
require 'imba/cli'
require 'imba/data_store'
require 'imba/movie'
require 'imba/movie_list'
require "imdb"

module Imba
  PATH ||= Dir.pwd
  DIRECTORY = "#{PATH}/.imba"
end
