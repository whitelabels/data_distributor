require_relative "../../test_helper"

describe DataDistributor::Authentication::NoAuthentication do
  let(:subject) { DataDistributor::Authentication::NoAuthentication.new }

  it "won't apply anything to the connection" do
    connection = Minitest::Mock.new
    subject.apply(connection)
    connection.verify
  end
end
