require "json"

module DataDistributor
  module BBR
    class Client < DataDistributor::Client
      def initialize(authentication=Authentication::NoAuthentication.new, **request_options)
        super('BBR/BBRPublic/1/rest/', authentication, **request_options)
      end

      def units(address_identifier: nil, registration_from: nil, registration_to: nil)
        body = connection.get("enhed", { AdresseIdentificerer: address_identifier, RegistreringFra: registration_from }.compact).body
        JSON.parse(body, symbolize_names: true).map { |data| Unit.new(data) }
      end

      def buildings(id: nil, registration_from: nil, registration_to: nil)
        body = connection.get("bygning", { Id: id, RegistreringFra: registration_from, RegistreringTil: registration_to }.compact).body
        JSON.parse(body, symbolize_names: true).map { |data| Building.new(data) }
      end
    end
  end
end
