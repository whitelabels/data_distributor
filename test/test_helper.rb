require 'minitest/autorun'
require 'uri'
require 'securerandom'
require 'vcr'

require_relative '../lib/data_distributor/authentication/no_authentication'
require_relative '../lib/data_distributor/authentication/credentials'
require_relative '../lib/data_distributor/bbr/building'
require_relative '../lib/data_distributor/bbr/unit'
require_relative '../lib/data_distributor/bbr/client'

VCR.configure do |config|
  config.cassette_library_dir = 'test/cassettes'
  config.hook_into :webmock
end