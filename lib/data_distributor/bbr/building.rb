
module DataDistributor
  module BBR
    class Building
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def total_living_area
        data[:byg039BygningensSamledeBoligAreal]
      end

      def usage
        case data[:byg021BygningensAnvendelse]
        when "110", "120", "121", "122", "190"
          :house
        when "130", "131", "132", "140"
          :apartment
        when "150"
          :college
        when "210", "211", "212", "213", "214", "215", "216", "217", "218", "219", "970"
          :agricultire
        when "220", "221", "222", "223", "229", "290"
          :industry
        when "230", "231", "232", "233", "234", "239"
          :energy_production
        when "310", "311", "312", "313", "314", "315", "319"
          :transport_facilities
        when "320", "321", "322", "323", "324", "325", "329", "390"
          :commercial
        when "330", "331", "332", "333", "334", "339"
          :hotel_and_restaurant
        when "410", "411", "412", "413", "414", "415", "416", "419"
          :culture
        when "420", "421", "422", "429"
          :education
        when "430", "431", "432", "433", "439"
          :medical
        when "160", "440", "441", "442", "443", "444", "449", "490"
          :institution
        when "510", "520", "521", "522", "523", "529", "540", "585"
          :holiday
        when "530", "531", "532", "533", "534", "535", "539"
          :sports
        else
          :other
        end
      end

      def heating
        case data[:byg056Varmeinstallation]
        when "1"
          :remote_heating
        when "2", "3", "5", "6", "8"
          case data[:byg057Opvarmningsmiddel]
          when "1"
            :electricity
          when "2"
            :gas
          when "3"
            :liquid_fuel
          when "4"
            :solid_fuel
          when "6"
            :straw
          when "7"
            :natural_gas
          else
            :other
          end
        when "7"
          :electricity
        when "9"
          :other
        end
      end
    end
  end
end
