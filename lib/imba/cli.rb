require 'optparse'

module Imba
  class Cli
    EXECUTABLE = File.basename($PROGRAM_NAME)

    def self.execute(stdout, argv)
      option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{EXECUTABLE} command [arguments...] [options...]"

        opts.on('--init', 'Initialize imba data store in current directory') do
          Imba::DataStore.init
          exit
        end

        opts.on('--destroy', 'Remove all .imba files and data store from current directory') do
          FileUtils.rm_rf(Imba::DIRECTORY)
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
      end

      option_parser.parse!
      stdout.puts option_parser.help if argv.empty?
    end
  end
end
