
module DataDistributor
  module BBR
    class Unit
      attr_reader :data

      def initialize(data={})
        @data = data
      end

      def building_id
        data[:bygning]
      end

      def total_living_area
        data[:enh026EnhedensSamledeAreal]
      end
    end
  end
end
