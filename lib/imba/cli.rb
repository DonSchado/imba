# encoding: utf-8
require 'optparse'

module Imba
  class Cli
    EXECUTABLE = File.basename($PROGRAM_NAME)

    def self.execute(stdout, argv)
      option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{EXECUTABLE} command [arguments...] [options...]"

        opts.on('--init', 'Initialize imba data store in current directory') do
          if File.directory?('.imba')
            stdout.puts 'here is already an .imba directory'
          else
            "#{PATH}/.imba".tap { |dir| FileUtils.mkdir_p(dir) }
            Imba::DataStore.init
            Imba::DataStore.migrate
          end
          exit
        end

        opts.on('--destroy', 'Remove all .imba files and data store from current directory') do
          if File.directory?('.imba')
            # TODO: dangerous stuff...
            FileUtils.rm_rf(Imba::DIRECTORY)
          else
            stdout.puts 'nothing to destroy here'
          end
          exit
        end

        opts.on('-s', '--synch', 'Scan movies and update database') do
          Imba::MovieList.new.synch
          exit
        end

        opts.on('-l', '--list', 'List all your movies') do
          stdout.puts Imba::Movie.list
          exit
        end

        opts.on('-v', '--version', 'Show current version') do
          stdout.puts "IMBA #{Imba::VERSION}"
          exit
        end

        opts.on('-h', '--help', 'Display this screen') do
          stdout.puts opts
          exit
        end

        opts.on('-e', 'execute raw ruby in the "Imba::*" scope') do
          stdout.puts eval("Imba::#{argv[0]}")
          exit
        end
      end

      option_parser.parse!
      stdout.puts option_parser.help if argv.empty?
    end
  end
end
