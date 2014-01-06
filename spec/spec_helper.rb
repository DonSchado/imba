require 'rspec/pride'
require 'pry'
require_relative '../lib/imba'

RSpec.configure do |config|
  config.color = true
  config.order = 'random'

  config.before(:all) do
    FileUtils.mkdir_p("../tmp/.imba_test")
    Imba::DataStore.path = "../tmp/.imba_test/test_data.pstore"
    Imba::DataStore.init
  end

  config.before(:each) { Imba::DataStore.clear }
  config.after(:all) { Imba::DataStore.clear }
end
