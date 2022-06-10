require 'faraday'

module DataDistributor
  module Authentication
    class Credentials
      attr_reader :username, :password

      def initialize(username:, password:)
        @username = username
        @password = password
      end

      def apply(connection)
        connection.use Middleware, username: username, password: password
      end

      class Middleware < Faraday::Middleware
        attr_reader :options

        def initialize(app, options)
          super(app)
          @options = options
        end

        def call(env)
          env.url.tap do |url|
            url.query = "#{url.query ? url.query + "&" : ""}username=#{options[:username]}&password=#{options[:password]}"
            env.url = url
          end

          @app.call(env)
        end
      end
    end
  end
end
