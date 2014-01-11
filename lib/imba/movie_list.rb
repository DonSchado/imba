module Imba
  class MovieList
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
      movie_dirs.each do |movie_name|
        # check movie name on imdb
        result = Imdb::Movie.search(movie_name).first # needs rescue?
        # puts foundings
        movie_title = result.title.gsub(/\(\d+\)/, '').strip
        movie = "#{movie_title}, #{result.year}, #{result.genres}, #{result.rating}/10"
        Imba::DataStore["#{result.id}"] = movie

        # update movie name? (folder)
        if movie_name != movie_title
          puts "change #{movie_name} => #{movie_title}? \n(enter 'y' to confirm or anything else to continue)"
          if STDIN.gets.strip.downcase == "y"
            FileUtils.mv(movie_name, movie_title)
          end
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
