module DataDistributor
  module CPR
    class Address
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def street_name
        data[:vejadresseringsnavn]
      end

      def building_number
        data[:husnummer].to_i.to_s
      end

      def floor_identification
        data[:etage]
      end

      def room_identification
        data[:sidedoer]
      end

      def zip_code
        data[:postnummer]
      end

      def city
        data[:postdistrikt]
      end

    end
  end
end
