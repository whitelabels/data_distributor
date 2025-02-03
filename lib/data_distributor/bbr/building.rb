# encoding: UTF-8

module DataDistributor
  module BBR
    class Building
      attr_reader :data

      USAGE_CODES = {
                      110 => { description: "Stuehus til landbrugsejendom", category: :house },
                      120 => { description: "Fritliggende enfamiliehus", category: :house },
                      121 => { description: "Sammenbygget enfamiliehus", category: :house },
                      122 => { description: "Fritliggende enfamiliehus i tæt-lav bebyggelse", category: :house },
                      130 => { description: "(UDFASES) Række-, kæde-, eller dobbelthus (lodret adskillelse mellem enhederne)", category: :apartment },
                      131 => { description: "Række-, kæde- og klyngehus", category: :apartment },
                      132 => { description: "Dobbelthus", category: :apartment },
                      140 => { description: "Etagebolig-bygning, flerfamiliehus eller to-familiehus", category: :apartment },
                      150 => { description: "Kollegium", category: :apartment },
                      160 => { description: "Boligbygning til døgninstitution", category: :institution },
                      185 => { description: "Anneks i tilknytning til helårsbolig", category: :house },
                      190 => { description: "Anden bygning til helårsbeboelse", category: :house },
                      210 => { description: "(UDFASES) Bygning til erhvervsmæssig produktion vedrørende landbrug, gartneri, råstofudvinding o. lign", category: :agriculture },
                      211 => { description: "Stald til svin", category: :agriculture },
                      212 => { description: "Stald til kvæg, får mv.", category: :agriculture },
                      213 => { description: "Stald til fjerkræ", category: :agriculture },
                      214 => { description: "Minkhal", category: :agriculture },
                      215 => { description: "Væksthus", category: :agriculture },
                      216 => { description: "Lade til foder, afgrøder mv.", category: :agriculture },
                      217 => { description: "Maskinhus, garage mv.", category: :agriculture },
                      218 => { description: "Lade til halm, hø mv.", category: :agriculture },
                      219 => { description: "Anden bygning til landbrug mv.", category: :agriculture },
                      220 => { description: "(UDFASES) Bygning til erhvervsmæssig produktion vedrørende industri, håndværk m.v. (fabrik, værksted o.lign.)", category: :industry },
                      221 => { description: "Bygning til industri med integreret produktionsapparat", category: :industry },
                      222 => { description: "Bygning til industri uden integreret produktionsapparat", category: :industry },
                      223 => { description: "Værksted", category: :industry },
                      229 => { description: "Anden bygning til produktion", category: :industry },
                      230 => { description: "(UDFASES) El-, gas-, vand- eller varmeværk, forbrændingsanstalt m.v.", category: :industry },
                      231 => { description: "Bygning til energiproduktion", category: :energy_production },
                      232 => { description: "Bygning til energidistribution", category: :energy_production },
                      233 => { description: "Bygning til vandforsyning", category: :energy_production },
                      234 => { description: "Bygning til håndtering af affald og spildevand", category: :energy_production },
                      239 => { description: "Anden bygning til energiproduktion og forsyning", category: :energy_production },
                      290 => { description: "(UDFASES) Anden bygning til landbrug, industri etc.", category: :industry },
                      310 => { description: "(UDFASES) Transport- og garageanlæg", category: :transport_facilities },
                      311 => { description: "Bygning til jernbane- og busdrift", category: :transport_facilities },
                      312 => { description: "Bygning til luftfart", category: :transport_facilities },
                      313 => { description: "Bygning til parkering- og transportanlæg", category: :transport_facilities },
                      314 => { description: "Bygning til parkering af flere end to køretøjer i tilknytning til boliger", category: :transport_facilities },
                      315 => { description: "Havneanlæg", category: :transport_facilities },
                      319 => { description: "Andet transportanlæg", category: :transport_facilities },
                      320 => { description: "(UDFASES) Bygning til kontor, handel, lager, herunder offentlig administration", category: :commercial },
                      321 => { description: "Bygning til kontor", category: :commercial },
                      322 => { description: "Bygning til detailhandel", category: :commercial },
                      323 => { description: "Bygning til lager", category: :commercial },
                      324 => { description: "Butikscenter", category: :commercial },
                      325 => { description: "Tankstation", category: :commercial },
                      329 => { description: "Anden bygning til kontor, handel og lager", category: :commercial },
                      330 => { description: "(UDFASES) Bygning til hotel, restaurant, vaskeri, frisør og anden servicevirksomhed", category: :hotel_and_restaurant },
                      331 => { description: "Hotel, kro eller konferencecenter med overnatning", category: :hotel_and_restaurant },
                      332 => { description: "Bed & breakfast mv.", category: :hotel_and_restaurant },
                      333 => { description: "Restaurant, café og konferencecenter uden overnatning", category: :hotel_and_restaurant },
                      334 => { description: "Privat servicevirksomhed som frisør, vaskeri, netcafé mv.", category: :hotel_and_restaurant },
                      339 => { description: "Anden bygning til serviceerhverv", category: :hotel_and_restaurant },
                      390 => { description: "(UDFASES) Anden bygning til transport, handel etc.", category: :commercial },
                      410 => { description: "(UDFASES) Bygning til biograf, teater, erhvervsmæssig udstilling, bibliotek, museum, kirke o. lign.", category: :culture },
                      411 => { description: "Biograf, teater, koncertsted mv.", category: :culture },
                      412 => { description: "Museum", category: :culture },
                      413 => { description: "Bibliotek", category: :culture },
                      414 => { description: "Kirke eller anden bygning til trosudøvelse for statsanerkendte trossamfund", category: :culture },
                      415 => { description: "Forsamlingshus", category: :culture },
                      416 => { description: "Forlystelsespark", category: :culture },
                      419 => { description: "Anden bygning til kulturelle formål", category: :culture },
                      420 => { description: "(UDFASES) Bygning til undervisning og forskning (skole, gymnasium, forskningslaboratorium o.lign.)", category: :education },
                      421 => { description: "Grundskole", category: :education },
                      422 => { description: "Universitet", category: :education },
                      429 => { description: "Anden bygning til undervisning og forskning", category: :education },
                      430 => { description: "(UDFASES) Bygning til hospital, sygehjem, fødeklinik o.lign.", category: :medical },
                      431 => { description: "Hospital og sygehus", category: :medical },
                      432 => { description: "Hospice, behandlingshjem mv.", category: :medical },
                      433 => { description: "Sundhedscenter, lægehus, fødeklinik mv.", category: :medical },
                      439 => { description: "Anden bygning til sundhedsformål", category: :medical },
                      440 => { description: "(UDFASES) Bygning til daginstitution", category: :institution },
                      441 => { description: "Daginstitution", category: :institution },
                      442 => { description: "Servicefunktion på døgninstitution", category: :institution },
                      443 => { description: "Kaserne", category: :institution },
                      444 => { description: "Fængsel, arresthus mv.", category: :institution },
                      449 => { description: "Anden bygning til institutionsformål", category: :institution },
                      451 => { description: "Beskyttelsesrum", category: :other },
                      490 => { description: "(UDFASES) Bygning til anden institution, herunder kaserne, fængsel o.lign.", category: :institution },
                      510 => { description: "Sommerhus", category: :holiday },
                      520 => { description: "(UDFASES) Bygning til feriekoloni, vandrehjem o.lign. bortset fra sommerhus", category: :holiday },
                      521 => { description: "Feriecenter, center til campingplads mv.", category: :commercial_holiday },
                      522 => { description: "Bygning med ferielejligheder til erhvervsmæssig udlejning", category: :commercial_holiday },
                      523 => { description: "Bygning med ferielejligheder til eget brug", category: :holiday },
                      529 => { description: "Anden bygning til ferieformål", category: :holiday },
                      530 => { description: "(UDFASES) Bygning i forbindelse med idrætsudøvelse", category: :sports },
                      531 => { description: "Klubhus i forbindelse med fritid og idræt", category: :sports },
                      532 => { description: "Svømmehal", category: :sports },
                      533 => { description: "Idrætshal", category: :sports },
                      534 => { description: "Tribune i forbindelse med stadion", category: :sports },
                      535 => { description: "Bygning til træning og opstaldning af heste", category: :sports },
                      539 => { description: "Anden bygning til idrætformål", category: :sports },
                      540 => { description: "Kolonihavehus", category: :holiday },
                      585 => { description: "Anneks i tilknytning til fritids- og sommerhus", category: :holiday },
                      590 => { description: "Anden bygning til fritidsformål", category: :other },
                      910 => { description: "Garage", category: :other },
                      920 => { description: "Carport", category: :other },
                      930 => { description: "Udhus", category: :other },
                      940 => { description: "Drivhus", category: :other },
                      950 => { description: "Fritliggende overdækning", category: :other },
                      960 => { description: "Fritliggende udestue", category: :other },
                      970 => { description: "Tiloversbleven landbrugsbygning", category: :agriculture },
                      990 => { description: "Faldefærdig bygning", category: :other },
                      999 => { description: "Ukendt bygning", category: :other }
                    }.freeze

      def initialize(data)
        @data = data
      end

      def total_living_area
        data[:byg039BygningensSamledeBoligAreal]
      end

      def usage_code
        data[:byg021BygningensAnvendelse]
      end

      def usage
        USAGE_CODES.dig(data[:byg021BygningensAnvendelse].to_i, :category)
      end

      def description
        USAGE_CODES.dig(data[:byg021BygningensAnvendelse].to_i, :description)
      end

      def heating
        case data[:byg056Varmeinstallation]
          when "1"
            :district_heating
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
            :none
          when "99"
            :mixed
          else
            :other
        end
      end
    end
  end
end
