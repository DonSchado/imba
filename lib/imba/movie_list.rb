# encoding: utf-8

module Imba
  class MovieList
    include Colors
    attr_reader :movies

    def initialize
      @movies = Movie.all
    end

    def movie_dirs
      # don't belong here...
      # get movie names (dirs)
      @movie_dirs ||= Dir['*'].select { |f| File.directory? f }
    end

    def add
      Imba::DataStore[:movies] = movie_dirs
    end
    # @movie_dirs.each { |d| FileUtils.cd(d) { FileUtils.touch ".hello" } }

    #
    # TODO: make it work first, refactor later
    #
    def synch
      prompt = '(enter "y" to confirm or anything else to continue)'
      # for each movie
      movie_dirs.each do |directory_name|
        # skip if directory_name in DataStore
        indexed_movie = Imba::DataStore.to_a.grep(/#{directory_name}/).first
        if !indexed_movie.nil?
          STDOUT.puts yellow("skipped: #{indexed_movie}")
        else
          # check movie name on imdb
          result = Imdb::Movie.search(directory_name).first # needs rescue?
          movie_title = result.title.gsub(/\(\d+\)|\(\w\)/, '').strip.force_encoding('UTF-8')
          # TODO: underscore to_sym?
          genres = result.genres.map { |g| g.downcase.to_sym }
          movie = "#{movie_title} (#{result.year}) #{genres} #{result.rating}/10"

          # puts foundings
          # update movie name? (folder)
          if directory_name != movie_title
            STDOUT.puts "change #{red(directory_name)} => #{green(movie_title)}? \n#{prompt}"
            FileUtils.mv(directory_name, movie_title) if STDIN.gets.strip.downcase == 'y'
          end

          if Imba::DataStore.key?(result.id) && Imba::DataStore[result.id] != movie
            STDOUT.puts "update?\n- #{red(Imba::DataStore[result.id])} \n+ #{green(movie)} \n#{prompt}"
            Imba::DataStore[result.id] = movie if STDIN.gets.strip.downcase == 'y'
          else
            STDOUT.puts "save? #{green(movie)} \n#{prompt}"
            Imba::DataStore[result.id] = movie if STDIN.gets.strip.downcase == 'y'
            Imba::DataStore[:genres] = (genres << Imba::DataStore[:genres]).flatten.uniq.compact
          end
        end
      end
      STDOUT.puts 'done'
    end

    def find(term)
      Imba::DataStore.to_a.grep(/#{term}/)
    end
  end
end
