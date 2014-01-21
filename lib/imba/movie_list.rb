# encoding: utf-8
require 'thread'
require 'ruby-progressbar'

module Imba
  class MovieList
    include Colors
    attr_reader :movies, :downloader, :progress_bar
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
          skip(directory_name) or movie_queue.push(directory_name)
        end
      end
    end

    def synchronize
      select_movies
      downloader.prepare(movie_queue) { init_progress_bar }
      @result = downloader.download { progress_bar.increment }
      create_movies
    end

    def indexed_movies
      @movies ||= Movie.pluck(:uniq_id)
    end

    def init_progress_bar(length = movie_queue.length)
      @progress_bar ||= ProgressBar.create(title: 'Downloading', total: length)
    end

    def create_movies
      prompt = '(enter "y" to confirm or anything else to continue)'
      # puts foundings
      @result.each do |diff|
        # update movie name? (folder)
        if diff.local_name != diff.remote_name
          STDOUT.puts "change #{red(diff.local_name)} => #{green(diff.remote_name)}? \n#{prompt}"
          FileUtils.mv(diff.local_name, diff.remote_name) if STDIN.gets.strip.downcase == 'y'
        end

        # create movie from result
        STDOUT.puts "save #{green(diff.remote_name)}? \n#{prompt}"
        if STDIN.gets.strip.downcase == 'y'
          movie = Movie.create(
            uniq_id: diff.result.id,
            name: diff.remote_name,
            year: diff.result.year,
            genres: diff.result.genres.map { |g| g.downcase.to_sym },
            rating: Float(diff.result.rating)
          )
          FileUtils.cd(diff.remote_name) do
            File.open('.imba', 'w+') { |f| f.write(movie.uniq_id) }
          end
          STDOUT.puts cyan("#{movie.to_s}\n")
        end
      end

      skipped.each { |skip| STDOUT.puts yellow("skipped: #{skip}") }
      STDOUT.puts "\ndone"
    end

    def skip(name)
      skipped << name if indexed?
    end

    private

    def indexed?
      File.exist?('.imba') && File.open('.imba') { |f| indexed_movies.include?(f.read.to_i) }
    end
  end
end
