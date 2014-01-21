require 'rspec/pride'
require 'database_cleaner'
require 'pry'
require_relative '../lib/imba'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ":memory:")

RSpec.configure do |config|
  config.color = true
  config.order = 'random'

  config.mock_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    ActiveRecord::Schema.define do
      self.verbose = false
      create_table :movies, force: true do |t|
        t.integer :uniq_id
        t.string :name
        t.string :year
        t.text :genres
        t.float :rating
      end
    end
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
