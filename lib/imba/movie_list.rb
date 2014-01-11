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
      @movie_dirs ||= Dir['*'].select {|f| File.directory? f}
    end

    def add
      Imba::DataStore[:movies] = movie_dirs
    end
    # @movie_dirs.each { |d| FileUtils.cd(d) { FileUtils.touch ".hello" } }

    def synch
      # for each movie
      movie_dirs.each do |directory_name|
        # check movie name on imdb
        result = Imdb::Movie.search(directory_name).first # needs rescue?
        movie_title = result.title.gsub(/\(\d+\)/, '').strip
        movie = "#{movie_title} (#{result.year}) #{result.genres} #{result.rating}/10"

        # puts foundings
        # update movie name? (folder)
        if directory_name != movie_title
          puts "change #{red(directory_name)} => #{green(movie_title)}? \n(enter 'y' to confirm or anything else to continue)"
          if STDIN.gets.strip.downcase == "y"
            FileUtils.mv(directory_name, movie_title)
          end
        end

        if Imba::DataStore.key?(result.id) && Imba::DataStore[result.id] != movie
          puts "update?\n- #{red(Imba::DataStore[result.id])} \n+ #{green(movie)} \n(enter 'y' to confirm or anything else to continue)"
          if STDIN.gets.strip.downcase == "y"
            Imba::DataStore[result.id] = movie
          end
        else
          Imba::DataStore[result.id] = movie
        end

        # ask if founding is correct
        # write .imdb_uniq_id in movie folder
        # save movie name and imdb_uniq_id in DataStore[:movies]
        # or serialize hole imdb movie object?!
      end
      "done"
    end

  end
end
