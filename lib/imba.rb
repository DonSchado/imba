require 'imba/version'
require 'imba/cli'
require 'imba/data_store'

module Imba
  DIRECTORY ||= "#{Dir.pwd}/.imba".tap { |dir| FileUtils.mkdir_p(dir) }
end
