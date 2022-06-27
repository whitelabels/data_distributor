require_relative "../../test_helper"

describe DataDistributor::Authentication::Credentials do
  it "can apply the middleware to the connection" do
    connection = Minitest::Mock.new
    connection.expect(:use, nil) do |middleware, options|
      _(middleware).must_equal DataDistributor::Authentication::Credentials::Middleware
      _(options).must_equal({ username: "SampleUsername", password: "SamplePassword" })
    end

    DataDistributor::Authentication::Credentials.new(username: "SampleUsername", password: "SamplePassword").apply(connection)
    connection.verify
  end

  it "will append username and password to query" do
    env = Minitest::Mock.new
    env.expect(:url, URI("http://example.com/?query=hello+world"))
    env.expect(:url=, nil) { |url| _(url.query).must_equal("query=hello+world&username=SampleUsername&password=SamplePassword") }

    app = Minitest::Mock.new
    app.expect(:call, nil, [env])

    DataDistributor::Authentication::Credentials::Middleware.new(app, username: "SampleUsername", password: "SamplePassword").call(env)

    env.verify
  end

  it "will add query with username and password" do
    env = Minitest::Mock.new
    env.expect(:url, URI("http://example.com/"))
    env.expect(:url=, nil) { |url| _(url.query).must_equal("username=SampleUsername&password=SamplePassword") }

    app = Minitest::Mock.new
    app.expect(:call, nil, [env])

    DataDistributor::Authentication::Credentials::Middleware.new(app, username: "SampleUsername", password: "SamplePassword").call(env)

    env.verify
  end
end
