require_relative "../../test_helper"

describe DataDistributor::CPR::Client do
  let(:cpr) { DataDistributor::CPR::Client.new }

  describe "authentication" do
    it "apply the given authentication" do
      authentication = Minitest::Mock.new
      authentication.expect(:apply, nil, [Faraday::Connection])

      DataDistributor::CPR::Client.new(authentication)

      authentication.verify
    end
  end

  describe "person" do
    it "request on cpr_number" do
      VCR.use_cassette("cpr/person") do
        cpr.person(cpr:"0101851001")

      end
    end

    it "returns a person" do
      VCR.use_cassette("cpr/person") do
        person = cpr.person(cpr:"0101851001")
        _(person).must_be_instance_of(DataDistributor::CPR::Person)
      end
    end

    it "returns nil if cpr invalid" do
      VCR.use_cassette("cpr/non_existing_person") do
        person = cpr.person(cpr:"0101851001")
        _(person).must_be_nil
      end
    end
  end
end

