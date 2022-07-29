module DataDistributor
  module DAR
    class Address
      attr_reader :data

      def initialize(data={})
        @data = data
      end

      def street_name
        data.dig(:husnummer, :navngivenVej, :vejnavn)
      end

      def building_number
        data.dig(:husnummer, :husnummertekst)
      end

      def floor_identification
        data.dig(:etagebetegnelse)
      end

      def room_identification
        data.dig(:dørbetegnelse)
      end

      def zip_code
        data.dig(:husnummer, :postnummer, :postnr)
      end

      def city
        data.dig(:husnummer, :postnummer, :navn)
      end

      def city_sub_division_name
        data.dig(:husnummer, :supplerendebynavn, :navn)
      end
    end
  end
end
