require_relative "../test_helper"

describe DataDistributor::Client do
  let(:authentication) { DataDistributor::Authentication::NoAuthentication.new }

  it "limits how long a request may take" do
    client = DataDistributor::Client.new("BBR/BBRPublic/1/rest/", authentication)

    _(client.connection.options.open_timeout).must_equal 2
    _(client.connection.options.timeout).must_equal 5
  end

  it "lets the caller choose the limits" do
    client = DataDistributor::Client.new("BBR/BBRPublic/1/rest/", authentication, timeout: 30, open_timeout: 10)

    _(client.connection.options.open_timeout).must_equal 10
    _(client.connection.options.timeout).must_equal 30
  end

  it "passes the limits through the service clients" do
    [DataDistributor::BBR::Client, DataDistributor::CPR::Client, DataDistributor::DAR::Client].each do |klass|
      client = klass.new(authentication, timeout: 30)

      _(client.connection.options.timeout).must_equal 30
      _(client.connection.options.open_timeout).must_equal 2
    end
  end
end
