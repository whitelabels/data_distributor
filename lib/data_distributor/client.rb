require "faraday"

module DataDistributor
  class Client
    attr_reader :connection

    def initialize(path, authentication)
      @connection = Faraday.new("https://services.datafordeler.dk/#{path}") do |connection|
        connection.use Faraday::Response::RaiseError
        authentication.apply(connection)
        connection.adapter Faraday.default_adapter
      end
    end
  end
end
