require 'faraday'
require 'uri'

module DataDistributor
  module Authentication
    class Proxy
      attr_reader :proxy_host

      def initialize(proxy_host:)
        @proxy_host = URI(proxy_host)
      end

      def apply(connection)
        connection.use Middleware, proxy_host: proxy_host
      end

      class Middleware < Faraday::Middleware
        attr_reader :options

        def initialize(app, options)
          super(app)
          @options = options
        end

        def call(env)
          env.url.tap do |url|
            url.scheme = options[:proxy_host].scheme
            url.host = options[:proxy_host].host
            url.port = options[:proxy_host].port
            env.url = url
          end

          @app.call(env)
        end
      end
    end
  end
end