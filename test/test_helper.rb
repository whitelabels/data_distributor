require 'minitest/autorun'
require 'uri'
require 'securerandom'
require 'vcr'

require_relative '../lib/authentication/no_authentication'
require_relative '../lib/authentication/credentials'
require_relative '../lib/bbr/building'
require_relative '../lib/bbr/unit'
require_relative '../lib/bbr/client'

VCR.configure do |config|
  config.cassette_library_dir = 'test/cassettes'
  config.hook_into :webmock
end