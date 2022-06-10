require_relative "../../test_helper"

describe DataDistributor::BBR do
  let(:bbr) { DataDistributor::BBR::Client.new }

  describe "authentication" do
    it "apply the given authentication" do
      authentication = Minitest::Mock.new
      authentication.expect(:apply, nil, [Faraday::Connection])

      DataDistributor::BBR::Client.new(authentication)

      authentication.verify
    end
  end

  describe "units" do
    it "request on address identifier" do
      VCR.use_cassette("bbr/unit") do
        bbr.units(address_identifier: "0a3f50c1-f404-32b8-e044-0003ba298018")
      end
    end

    it "map the data to a Unit objects" do
      VCR.use_cassette("bbr/unit") do
        unit = bbr.units(address_identifier: "0a3f50c1-f404-32b8-e044-0003ba298018").first
        _(unit).must_be_instance_of(DataDistributor::BBR::Unit)
      end
    end
  end

  describe "buildings" do
    it "can request on id" do
      VCR.use_cassette("bbr/building") do
        bbr.buildings(id: "e6ecc711-b634-45e9-b95b-bd95ba056134")
      end
    end

    it "map the data to a Building object" do
      VCR.use_cassette("bbr/building") do
        building = bbr.buildings(id: "e6ecc711-b634-45e9-b95b-bd95ba056134").first
        _(building).must_be_instance_of(DataDistributor::BBR::Building)
      end
    end
  end
end
