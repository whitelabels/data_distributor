require "faraday"

module DataDistributor
  class Client
    attr_reader :connection

    # Datafordeler occasionally stalls for a minute and most callers render web pages.
    def initialize(path, authentication, timeout: 5, open_timeout: 2)
      @connection = Faraday.new("https://services.datafordeler.dk/#{path}", request: { timeout: timeout, open_timeout: open_timeout }) do |connection|
        connection.use Faraday::Response::RaiseError
        authentication.apply(connection)
        connection.adapter Faraday.default_adapter
      end
    end
  end
end
