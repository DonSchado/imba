module Imba
  class Downloader
    attr_accessor :download_queue, :items

    Diff = Struct.new(:directory_name, :movie_title, :result)

    def prepare(queue = Queue.new)
      @download_queue = queue
      @items = []
      self
    end

    def download
      p = ProgressBar.create(title: 'Downloading', total: download_queue.length)
      until download_queue.empty?
        item = download_queue.pop
        result = Imdb::Movie.search(item).first
        movie_title = result.title.gsub(/\(\d+\)|\(.*\)/, '').strip.force_encoding('UTF-8')
        items << Diff.new(item, movie_title, result)
        p.increment
      end
      items
    end
  end
end
