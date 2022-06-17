require "faraday"
require "json"
require "date"

module DataDistributor
  module CPR
    # This class is used for retrieving data from the Danish CPR register
    class Client
      attr_reader :connection


      def initialize(authentication=DataDistributor::Authentication::NoAuthentication.new)
        @connection = Faraday.new(url: "https://services.datafordeler.dk/CPR/CprPrivatePNR/2.0.0/rest/") do |connection|
          connection.use Faraday::Response::RaiseError
          authentication.apply(connection)
          connection.adapter Faraday.default_adapter
        end
      end

      # create Person object based on information in Central Person Register (cpr)
      # @param [String] the cpr-number to check
      # @return [Person] or nil
      def person(cpr:)
        body = connection.get("PrivatePersonCurrentPNR", { "pnr.personnummer.eq" => cpr }).body
        data = JSON.parse(body, symbolize_names: true)[:Personer].first
        if data.nil?
          nil
        else
          Person.new(data, cpr: cpr)
        end
      end
    end
  end
end