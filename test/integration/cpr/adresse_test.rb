require_relative "../../test_helper"

describe DataDistributor::CPR::Address do
  let (:subject) { DataDistributor::CPR::Address.new(data) }
  let (:data) { { cprKommunekode:"0573", cprKommunenavn: "Varde", cprVejkode:"5731", husnummer: "012",
                              postdistrikt: "Varde", postnummer:"6800", vejadresseringsnavn: "Boulevarden" ,
                              etage: "2"} }

  it "returns street name" do
    _(subject.street_name).must_equal("Boulevarden")
  end

  it "returns building number" do
    _(subject.building_number).must_equal("12")
  end

  it "returns floor" do
    data[:etage] = "3"
    _(subject.floor_identification).must_equal("3")
  end

  it "returns nil if no floor" do
    data[:etage] = nil
    _(subject.floor_identification).must_be_nil
  end

  it "returns room" do
    data[:sidedoer] = "Th."
    _(subject.room_identification).must_equal("Th.")
  end

  it "returns nil if no room" do
    data[:sidedoer] = nil
    _(subject.room_identification).must_be_nil
  end

  it "returns zip code" do
    _(subject.zip_code).must_equal("6800")
  end

  it "returns city" do
    _(subject.city).must_equal("Varde")
  end
end
