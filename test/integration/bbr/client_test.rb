require_relative "../../test_helper"

describe DataDistributor::BBR::Unit do
  let(:subject) { DataDistributor::BBR::Unit.new(data) }
  let(:data) do
    { bygning:                    SecureRandom.uuid,
      enh026EnhedensSamledeAreal: (50 + SecureRandom.random_number * 100).to_i }
  end

  it "can fetch building id" do
    _(subject.building_id).must_equal data[:bygning]
  end

  it "can fetch total living area" do
    _(subject.total_living_area).must_equal data[:enh026EnhedensSamledeAreal]
  end
end
