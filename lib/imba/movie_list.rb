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
        result = Imdb::Movie.search(movie_name).first
        # puts foundings
        movie = "#{result.title} (#{result.id}) #{result.genres} #{result.rating}/10"
        Imba::DataStore["#{result.id}"] = movie
        puts "#{movie_name} \t=>\t #{movie}"
          # ask if founding is correct
          # update movie name? (folder)

        # write .imdb_uniq_id in movie folder
        # save movie name and imdb_uniq_id in DataStore[:movies]
        # or serialize hole imdb movie object?!
      end
    end

  end
end
