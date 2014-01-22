# encoding: utf-8
require 'optparse'
require 'ostruct'

module Imba
  class Cli
    EXECUTABLE = File.basename($PROGRAM_NAME)

    def self.execute(argv)
      options = OpenStruct.new
      option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{EXECUTABLE} command [arguments...] [options...]"

        opts.on('--init', 'Initialize imba data store in current directory') do
          if File.directory?('.imba')
            puts 'here is already an .imba directory'
          else
            "#{PATH}/.imba".tap { |dir| FileUtils.mkdir_p(dir) }
            Imba::DataStore.init
            Imba::DataStore.migrate
          end
        end

        opts.on('--destroy', 'Remove all .imba files and data store from current directory') do
          if File.directory?('.imba')
            # TODO: dangerous stuff...
            FileUtils.rm_rf(Imba::DIRECTORY)
          else
            puts 'nothing to destroy here'
          end
        end

        opts.on('-s', '--synch', 'Scan movies and update database') do
          Imba::MovieList.new.synchronize
        end

        # order by
        opts.on('-l', '--list', 'List all your movies') do
          puts Imba::Movie.list
        end

        opts.on('-f', '--find MOVIE', 'Find movie by NAME') do |name|
          puts Imba::Movie.where('name like ?', "%#{name}%")
        end

        opts.on('-t', '--top [n]', 'List top movies') do |limit|
          options[:limit] = limit
          puts Imba::Movie.top(limit)
        end

        opts.on('-g', '--genre FILTER', 'Filter movies by GENRE') do |genre|
          options[:genre] = genre
          puts Imba::Movie.genre(genre)
        end

        opts.on('-y', '--year FILTER', 'Filter movies by YEAR') do |year|
          options[:year] = year
          puts Imba::Movie.year(year)
        end

        opts.on('-r', '--rating FILTER', 'Filter movies by RATING') do |rating|
          options[:rating] = rating
          puts Imba::Movie.rating(rating)
        end

        opts.on('-v', '--version', 'Show current version') do
          puts "IMBA #{Imba::VERSION}"
        end

        opts.on('-e', 'execute raw ruby in the "Imba::*" scope', '(just for dev purpose, will be removed soon!)') do
          puts eval("Imba::#{argv[0]}")
        end

        opts.separator ''
        opts.on_tail('-h', '--help', 'Display this screen') do
          puts opts.help
        end
      end

      puts option_parser.help if argv.empty?
      option_parser.parse!
    end
  end
end
