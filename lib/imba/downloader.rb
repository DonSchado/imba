module Imba
  class Downloader
    attr_accessor :download_queue, :items

    Diff = Struct.new(:local_name, :remote_name, :result)

    def prepare(queue = Queue.new, &block)
      block.call if block_given?
      @download_queue = queue
      @items = []
      self
    end

    def download
      until download_queue.empty?
        yield if block_given?
        item = download_queue.pop
        result = Imba::Movie.search(item)
        movie_title = result.title.gsub(/\(\d+\)|\(.*\)/, '').strip.force_encoding('UTF-8')
        items << Diff.new(item, movie_title, result)
      end
      items
    end
  end
end
