require_relative "../../test_helper"

describe DataDistributor::BBR::Building do
  let(:subject) { DataDistributor::BBR::Building.new(data) }
  let(:data) { { byg039BygningensSamledeBoligAreal: (50 + SecureRandom.random_number * 100).to_i } }

  it "can map total living area" do
    _(subject.total_living_area).must_equal data[:byg039BygningensSamledeBoligAreal]
  end

  describe "usage" do
    %w[110 120 121 122 185 190].each do |usage_code|
      it "maps #{usage_code} to house" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :house
      end
    end

    %w[130 131 132 140 150].each do |usage_code|
      it "maps #{usage_code} to apartment" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :apartment
      end
    end

    %w[210 211 212 213 214 215 216 217 218 219 970].each do |usage_code|
      it "maps #{usage_code} to agricultire" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :agriculture
      end
    end

    %w[220 221 222 223 229 290].each do |usage_code|
      it "maps #{usage_code} to industry" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :industry
      end
    end

    %w[230 231 232 233 234 239].each do |usage_code|
      it "maps #{usage_code} to energy production" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :energy_production
      end
    end

    %w[310 311 312 313 314 315 319].each do |usage_code|
      it "maps #{usage_code} to transport facilities" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :transport_facilities
      end
    end

    %w[320 321 322 323 324 325 329 390].each do |usage_code|
      it "maps #{usage_code} to commercial" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :commercial
      end
    end

    %w[330 331 332 333 334 339].each do |usage_code|
      it "maps #{usage_code} to hotel and resturant" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :hotel_and_restaurant
      end
    end

    %w[410 411 412 413 414 415 416 419].each do |usage_code|
      it "maps #{usage_code} to culture" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :culture
      end
    end

    %w[420 421 422 429].each do |usage_code|
      it "maps #{usage_code} to education" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :education
      end
    end

    %w[430 431 432 433 439].each do |usage_code|
      it "maps #{usage_code} to medical" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :medical
      end
    end

    %w[160 440 441 442 443 444 449 490].each do |usage_code|
      it "maps #{usage_code} to institution" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :institution
      end
    end

    %w[510 520 523 529 540 585].each do |usage_code|
      it "maps #{usage_code} to holiday" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :holiday
      end
    end

    %w[521 522].each do |usage_code|
      it "maps #{usage_code} to commercial_holiday" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :commercial_holiday
      end
    end

    %w[530 531 532 533 534 535 539].each do |usage_code|
      it "maps #{usage_code} to sports" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :sports
      end
    end

    %w[590 910 920 930 940 950 960 990 999].each do |usage_code|
      it "maps #{usage_code} to other" do
        data[:byg021BygningensAnvendelse] = usage_code

        _(subject.usage).must_equal :other
      end
    end
  end

  describe "heating" do
   [[1, nil, :district_heating],
    [5, 1, :electricity],
    [2, 2, :gas],
    [2, 3, :liquid_fuel],
    [2, 4, :solid_fuel],
    [2, 6, :straw],
    [2, 7, :natural_gas],
    [2, 8, :other],
    [7, nil, :electricity],
    [9, nil, :none],
    [99, nil, :mixed],
    [nil, nil, :other]].map do |installation, agent, expectation|
      it "maps installation=#{installation} agent=#{agent} to #{expectation}" do
        data[:byg056Varmeinstallation] = installation.to_s
        data[:byg057Opvarmningsmiddel] = agent.to_s

        _(subject.heating).must_equal expectation
      end
    end
  end
end
