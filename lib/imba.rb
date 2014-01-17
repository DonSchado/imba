# encoding: utf-8
require 'active_record'
require 'yaml'
require 'imba/version'
require 'imba/cli'
require 'imba/colors'
require 'imba/data_store'
require 'imba/movie'
require 'imba/movie_list'
require 'imdb'

module Imba
  PATH ||= Dir.pwd
  DIRECTORY = "#{PATH}/.imba"

  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: "#{DIRECTORY}/data.sqlite3",
    pool: 5,
    timeout: 5000
  )
end
