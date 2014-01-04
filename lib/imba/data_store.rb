require 'pstore'

module Imba
  module DataStore
    class << self
      attr_reader :data
      attr_writer :path

      def init
        @data = PStore.new(path, true)
        @data.ultra_safe = true
        @data.transaction { @data.commit }
        @data
      end

      def path
        @path ||= "#{Imba::DIRECTORY}/data.pstore"
      end

      def data_store
        data || init
      end

      def [](key)
        data_store.transaction(true) { @data[key] }
      end

      def []=(key, value)
        data_store.transaction { @data[key] = value }
      end

      def all
        data_store.transaction(true) { @data.roots }
      end

      def transaction
        data_store.transaction do
          yield @data
          @data.commit
        end
      end

      def key?(key)
        data_store.transaction(true) { @data.root?(key) }
      end

      def delete(*keys)
        data_store.transaction do
          keys.flatten.each { |key| @data.delete(key) }
          @data.commit
        end
      end

      def clear
        delete(all)
      end

      def inspect
        vars = instance_variables.map { |v| "#{v}=#{instance_variable_get(v).inspect}" }.join(', ')
        "<#{to_s}: #{vars}>"
      end
    end
  end
end
