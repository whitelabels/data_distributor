require 'faraday'
require 'json'
require 'date'

module DataDistributor
  module CPR
    class Client
      attr_reader :connection

      def initialize(authentication=DataDistributor::Authentication::NoAuthentication.new)
        @connection = Faraday.new(url: "https://services.datafordeler.dk/CPR/CprPrivatePNR/2.0.0/rest/") do |connection|
          connection.use Faraday::Response::RaiseError
          authentication.apply(connection)
          connection.adapter Faraday.default_adapter
        end
      end

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