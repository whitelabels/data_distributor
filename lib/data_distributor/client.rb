require "faraday"

module DataDistributor
  class Client
    attr_reader :connection

    def initialize(url, authentication)
      @connection = Faraday.new(url) do |connection|
        connection.use Faraday::Response::RaiseError
        authentication.apply(connection)
        connection.adapter Faraday.default_adapter
      end
    end
  end
end
