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
          else
            # type code here
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
          #if data[:Person][:Adresseoplysninger][:CprAdresse].nil?
          nil
        else
          Address.new(data[:Person][:Adresseoplysninger][:CprAdresse])
        end


      end

      def street
        begin
          street_name = result['Personer'][0]['Person']['Adresseoplysninger']['CprAdresse']['vejadresseringsnavn']
          house_number = result['Personer'][0]['Person']['Adresseoplysninger']['CprAdresse']['husnummer'].to_i
          zip_code = result['Personer'][0]['Person']['Adresseoplysninger']['CprAdresse']['postnummer']
          city = result['Personer'][0]['Person']['Adresseoplysninger']['CprAdresse']['postdistrikt']#bynavn']

          street_address = street_name + ' ' + house_number.to_s
        rescue
          street_address = ''
          zip_code = ''
          city = ''
        end

        return street_address, zip_code, city
      end


=begin
  def initialize(is_valid, full_name, street, zip, city, age, under_guardianship)
    @valid_cpr_number = is_valid
    @full_name = full_name
    @street = street
    @zip = zip
    @city = city
    @age = age
    @under_guardianship = under_guardianship
  end
=end
    end
  end
end