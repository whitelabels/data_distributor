module DataDistributor
  module CPR
    class Person
      attr_reader :data, :cpr

      def initialize(data, cpr:)
        @data = data
        @cpr = cpr
      end

      def first_name
        data[:Person][:Navn][:fornavne]
      end

      def last_name
        data[:Person][:Navn][:efternavn]
      end

      def date_of_birth
        @date_of_birth ||= begin
          day = cpr[0..1].to_i
          month = cpr[2..3].to_i
          year = cpr[4..5].to_i
          century_digit = cpr[6].to_i

          case century_digit
          when 0..3
            year += 1900
          when 4
            if year <= 36
              year += 2000
            else
              year += 1900
            end
          when 5..8
            if year <= 57
              year += 2000
            else
              year += 1800
            end
          when 9
            if year <= 36
              year += 2000
            else
              year += 1900
            end
          end

          Date.new(year, month, day)
        end
      end

      def age
        @age ||= begin
                   today = Time.now.to_date
                   today.year - date_of_birth.year - (today.strftime('%m%d') < date_of_birth.strftime('%m%d') ? 1 : 0)
                 end
      end

      def under_guardianship?
        !data[:Person][:Vaergemaal].nil?
      end

      def address
        if data.dig(:Person, :Adresseoplysninger, :CprAdresse).nil?
          nil
        else
          Address.new(data[:Person][:Adresseoplysninger][:CprAdresse])
        end
      end
    end
  end
end