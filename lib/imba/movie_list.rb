# encoding: utf-8
require 'thread'
require 'ruby-progressbar'

module Imba
  class MovieList
    include Colors
    attr_reader :movies
    attr_accessor :directory_queue, :movie_queue

    Diff = Struct.new(:directory_name, :movie_title, :result)

    def initialize
      @movies = Movie.all
      @directory_queue = Queue.new
      @movie_queue = Queue.new
    end

    def movie_dirs
      # don't belong here...
      # get movie names (dirs)
      # @movie_dirs.each { |d| FileUtils.cd(d) { FileUtils.touch ".hello" } }
      @movie_dirs ||= Dir['*'].select { |f| File.directory? f }
    end

    #
    # TODO: make it work first, refactor later (for even more fun!)
    #
    def synch
      prompt = '(enter "y" to confirm or anything else to continue)'
      indexed_movies = Movie.pluck(:uniq_id)
      p = ProgressBar.create(title: 'Scanning your movies', total: movie_dirs.length)
      skipped = []

      # populate queue
      movie_dirs.each do |directory_name|
        FileUtils.cd(directory_name) do
          if File.exist?('.imba') && File.open('.imba') { |f| indexed_movies.include?(f.read.to_i) }
            skipped << directory_name
            p.increment
          else
            directory_queue.push(directory_name)
          end
        end
      end

      # download all the movies
      until directory_queue.empty?
        directory_name = directory_queue.pop
        result = Imdb::Movie.search(directory_name).first
        movie_title = result.title.gsub(/\(\d+\)|\(.*\)/, '').strip.force_encoding('UTF-8')
        movie_queue.push Diff.new(directory_name, movie_title, result)
        p.increment
      end

      # puts foundings
      until movie_queue.empty?
        diff = movie_queue.pop
        # update movie name? (folder)
        if diff.directory_name != diff.movie_title
          STDOUT.puts "change #{red(diff.directory_name)} => #{green(diff.movie_title)}? \n#{prompt}"
          FileUtils.mv(diff.directory_name, movie_title) if STDIN.gets.strip.downcase == 'y'
        end

        # create movie from result
        STDOUT.puts "save #{green(diff.movie_title)}? \n#{prompt}"
        if STDIN.gets.strip.downcase == 'y'
          movie = Movie.create(
            uniq_id: diff.result.id,
            name: diff.movie_title,
            year: diff.result.year,
            genres: diff.result.genres.map { |g| g.downcase.to_sym },
            rating: Float(diff.result.rating)
          )
          FileUtils.cd(diff.movie_title) do
            File.open('.imba', 'w+') { |f| f.write(movie.uniq_id) }
          end
          STDOUT.puts cyan("#{movie.to_s}\n")
        end
      end

      skipped.each { |skip| STDOUT.puts yellow("skipped: #{skip}") }
      STDOUT.puts "\ndone"
    end
  end
end
