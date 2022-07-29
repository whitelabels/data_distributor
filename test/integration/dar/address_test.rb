require_relative "../../test_helper"

describe DataDistributor::DAR::Address do
  let(:subject) { DataDistributor::DAR::Address.new(data) }
  let(:data) { { dørbetegnelse: "th", etagebetegnelse: "3", husnummer: { husnummertekst: "12", navngivenVej: { vejnavn: "Boulevarden" }, postnummer: { postnr: "6800", navn: "Varde" }, supplerendebynavn: { navn: "Gelllerup" } } } }

  it "returns the street name" do
    _(subject.street_name).must_equal "Boulevarden"
  end

  it "returns the building number" do
    _(subject.building_number).must_equal "12"
  end

  it "returns the floor identification" do
    _(subject.floor_identification).must_equal "3"
  end

  it "returns nil if no floor identification" do
    data[:etagebetegnelse] = nil

    _(subject.floor_identification).must_be_nil
  end

  it "returns the room identification" do
    _(subject.room_identification).must_equal "th"
  end

  it "returns nil if no room identification" do
    data[:dørbetegnelse] = nil

    _(subject.room_identification).must_be_nil
  end

  it "returns the zip code" do
    _(subject.zip_code).must_equal "6800"
  end

  it "returns the city" do
    _(subject.city).must_equal "Varde"
  end

  it "returns the city sub division name" do
    _(subject.city_sub_division_name).must_equal "Gelllerup"
  end

  it "returns nil if no city sub division" do
    data[:husnummer][:supplerendebynavn] = nil

    _(subject.city_sub_division_name).must_be_nil
  end
end
