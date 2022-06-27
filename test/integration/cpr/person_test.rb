require_relative "../../test_helper"

describe DataDistributor::CPR::Person do
  let (:subject) { DataDistributor::CPR::Person.new(data, cpr: "0106851001")}
  let (:data) { {Person:{ status:"bopael_i_danmark", Vaergemaal: "hansen",
                  Navn:{
                    adresseringsnavn:"Hans Hansen",efternavn: "Hansen", fornavne: "Hans", status: "aktuel" },
                  Adresseoplysninger:{
                    CprAdresse: {
                      cprKommunekode:"0573", cprKommunenavn: "Varde", cprVejkode:"5731", husnummer: "012",
                      postdistrikt: "Varde", postnummer:"6800", vejadresseringsnavn: "Boulevarden" ,
                      etage: "2"},# sidedoer: "Th."},
                    status:"aktuel", virkningFra:"2005-01-01T11:12:00.000000+01:00",
                                       virkningFraUsikkerhedsmarkering:false } } } }


  it "returns last name" do
    _(subject.last_name).must_equal("Hansen")
  end

  it "returns first name" do
    _(subject.first_names).must_equal("Hans")
  end

  it "returns date of birth" do
    _(subject.date_of_birth).must_equal(Date.new(1985,06,01))
  end

  it "returns correct age on birthday" do
    Timecop.freeze(Time.local(2022,06,01)) do
      _(subject.age_in_years).must_equal(37)
    end
  end

  it "returns correct age the day before birthday" do
    Timecop.freeze(Time.local(2022, 05,31)) do
      _(subject.age_in_years).must_equal(36)
    end
  end

  it "returns true if under guardianship" do
    _(subject).must_be :under_guardianship?
  end

  it "returns false if not under guardianship" do
    data[:Person][:Vaergemaal] = nil
    _(subject).wont_be :under_guardianship?
  end

  it "returns nil if name and address is protected" do
    data[:Person][:Adresseoplysninger][:CprAdresse] = nil
    _(subject.address).must_be_nil
  end

  it "returns the address" do
    _(subject.address).must_be_instance_of DataDistributor::CPR::Address
  end

  describe "correct century in birth year" do
    {0..3 => {0..36 => 1900, 37..57 => 1900, 58..99 => 1900},
     4..4 => {0..36 => 2000, 37..57 => 1900, 58..99 => 1900},
     5..8 => {0..36 => 2000, 37..57 => 2000, 58..99 => 1800},
     9..9 => {0..36 => 2000, 37..57 => 1900, 58..99 => 1900}}.each do |century_digits, years_hash|

      century_digits.each do |century_digit |
        describe "based on 7th digit being #{century_digit}" do
          years_hash.each do |year_range, century|
            it "year: #{year_range}, century: #{century}" do
              year = rand(year_range)
              cpr = "0101#{"%02d" % year}#{century_digit}999"
              person = DataDistributor::CPR::Person.new({}, cpr: cpr)
              _(person.date_of_birth).must_equal Date.new(century + year, 1, 1)
            end
          end
        end
      end
    end
  end
end
