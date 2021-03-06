require_relative "../../test_helper"

describe DataDistributor::Middleware::Proxy do
  it "can apply the middleware to the connection" do
    connection = Minitest::Mock.new
    connection.expect(:use, nil) do |middleware, options|
      _(middleware).must_equal DataDistributor::Middleware::Proxy::Middleware
      _(options).must_equal({ proxy_host: URI("http://example.com:9000") })
    end
    DataDistributor::Middleware::Proxy.new(proxy_host: "http://example.com:9000").apply(connection)
    connection.verify
  end

  it "will change the scheme" do
    env = Minitest::Mock.new
    env.expect(:url, URI("http://example.com"))
    env.expect(:url=, nil) { |url| _(url.scheme).must_equal("https")}
    app = Minitest::Mock.new
    app.expect(:call, nil, [env])
    DataDistributor::Middleware::Proxy::Middleware.new(app, proxy_host: URI("https://example.com")).call(env)

    env.verify
  end

  it "will change the host" do
    env = Minitest::Mock.new
    env.expect(:url, URI("http://example.com"))
    env.expect(:url=, nil) { |url| _(url.host).must_equal("example.org")}
    app = Minitest::Mock.new
    app.expect(:call, nil, [env])
    DataDistributor::Middleware::Proxy::Middleware.new(app, proxy_host: URI("http://example.org")).call(env)

    env.verify
  end

  it "will change the port" do
    env = Minitest::Mock.new
    env.expect(:url, URI("http://example.com:8000"))
    env.expect(:url=, nil) { |url| _(url.port).must_equal(8009)}
    app = Minitest::Mock.new
    app.expect(:call, nil, [env])
    DataDistributor::Middleware::Proxy::Middleware.new(app, proxy_host: URI("http://example.com:8009")).call(env)

    env.verify
  end
end
