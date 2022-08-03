require_relative "../../test_helper"

describe DataDistributor::DAR::Client do
  let(:dar) { DataDistributor::DAR::Client.new }

  describe "authentication" do
    it "apply the given authentication" do
      authentication = Minitest::Mock.new
      authentication.expect(:apply, nil, [Faraday::Connection])

      DataDistributor::DAR::Client.new(authentication)

      authentication.verify
    end
  end

  describe "addresses" do
    let(:id) { "8d00ef82-8aaf-458a-bbc2-232f8f989588" }

    it "request on id" do
      VCR.use_cassette("dar/addresses") do
        dar.addresses(id: id)
      end
    end

    it "map the data to a Address object" do
      VCR.use_cassette("dar/addresses") do
        address = dar.addresses(id: id).first
        _(address).must_be_instance_of(DataDistributor::DAR::Address)
      end
    end
  end
end
