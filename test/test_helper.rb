require 'minitest/autorun'
require 'uri'
require 'securerandom'
require 'vcr'
require 'data_distributor'
require 'timecop'

VCR.configure do |config|
  config.cassette_library_dir = 'test/cassettes'
  config.hook_into :webmock
end