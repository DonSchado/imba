module Imba
  module DataStore
    class << self
      def init
        ActiveRecord::Base.establish_connection(
          adapter: 'sqlite3',
          database: "#{DIRECTORY}/data.sqlite3",
          pool: 5,
          timeout: 5000
        )
      end

      def migrate
        ActiveRecord::Schema.define do
          create_table :movies do |t|
            t.integer :uniq_id
            t.string :name
            t.string :year
            t.text :genres
            t.float :rating
          end
        end
      end
    end
  end
end
