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

    def synch
      prompt = '(enter "y" to confirm or anything else to continue)'
      # for each movie
      movie_dirs.each do |directory_name|
        # check movie name on imdb
        result = Imdb::Movie.search(directory_name).first # needs rescue?
        movie_title = result.title.gsub(/\(\d+\)/, '').strip
        movie = "#{movie_title} (#{result.year}) #{result.genres} #{result.rating}/10"

        # puts foundings
        # update movie name? (folder)
        if directory_name != movie_title
          puts "change #{red(directory_name)} => #{green(movie_title)}? \n#{prompt}"
          FileUtils.mv(directory_name, movie_title) if STDIN.gets.strip.downcase == 'y'
        end

        if Imba::DataStore.key?(result.id) && Imba::DataStore[result.id] != movie
          puts "update?\n- #{red(Imba::DataStore[result.id])} \n+ #{green(movie)} \n#{prompt}"
          Imba::DataStore[result.id] = movie if STDIN.gets.strip.downcase == 'y'
        else
          Imba::DataStore[result.id] = movie
        end

        # ask if founding is correct
        # write .imdb_uniq_id in movie folder
        # save movie name and imdb_uniq_id in DataStore[:movies]
        # or serialize hole imdb movie object?!
      end
      STDOUT.puts 'done'
    end
  end
end
