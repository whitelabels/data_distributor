require 'faraday'

module DataDistributor
  module Authentication
    class Certificate
      attr_reader :pfx, :passphrase

      def initialize(pfx:, passphrase:)
        @pfx = pfx
        @passphrase = passphrase
      end

      def apply(connection)
        connection.use Middleware, pfx: pfx, passphrase: passphrase
      end

      class Middleware < Faraday::Middleware
        attr_reader :options

        def initialize(app, options)
          super(app)
          @options = options
        end

        def call(env)
          env.url.tap do |url|
            url.query = "#{url.query ? url.query + "&" : ""}&passphrase=#{options[:passphrase]}"
            url.pfx = options[:pxf].pxf
            url.passphrase = options[:passphrase].passphrase
            env.url = url
          end

          @app.call(env)
        end
      end
    end
  end
end
