require "json"

module DataDistributor
  module DAR
    class Client < DataDistributor::Client
      def initialize(authentication=Authentication::NoAuthentication.new, **request_options)
        super("DAR/DAR/1/rest/", authentication, **request_options)
      end

      def addresses(id:)
        body = connection.get("adresse", { "Id" => id }).body
        JSON.parse(body, symbolize_names: true).map { |data| Address.new(data) }
      end
    end
  end
end
