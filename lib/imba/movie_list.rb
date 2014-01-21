# encoding: utf-8
require 'thread'
require 'ruby-progressbar'

module Imba
  class MovieList
    include Colors
    attr_reader :movies, :downloader
    attr_accessor :skipped, :movie_queue

    def initialize(downloader = Imba::Downloader.new)
      @downloader = downloader
      @movie_queue = Queue.new
      @skipped = []
    end

    def movie_dirs
      @movie_dirs ||= Dir['*'].select { |f| File.directory? f }
    end

    def select_movies
      movie_dirs.each do |directory_name|
        FileUtils.cd(directory_name) do
          if indexed?
            skipped << directory_name
          else
            movie_queue.push(directory_name)
          end
        end
      end
    end

    def synchronize
      select_movies
      @result = downloader.prepare(movie_queue).download
      create_movies
    end

    def indexed_movies
      @movies ||= Movie.pluck(:uniq_id)
    end

    def create_movies
      prompt = '(enter "y" to confirm or anything else to continue)'
      # puts foundings
      @result.each do |diff|
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

    private

    def indexed?
      File.exist?('.imba') && File.open('.imba') { |f| indexed_movies.include?(f.read.to_i) }
    end
  end
end
