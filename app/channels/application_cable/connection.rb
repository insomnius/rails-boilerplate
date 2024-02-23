# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    rescue_from StandardError, with: :report_error

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      return reject_unauthorized_connection unless doorkeeper_token

      User.find(doorkeeper_token.resource_owner_id)
    end

    def current_jwt
      return @current_jwt if defined?(@current_jwt)

      secret = File.open(Doorkeeper::JWT.configuration.secret_key_path) do |f|
        OpenSSL::PKey::RSA.new(f)
      end

      @current_jwt = JWT.decode(doorkeeper_token&.token, secret, true, algorithm: Doorkeeper::JWT.configuration.encryption_method.to_s)

      @current_jwt
    end

    def doorkeeper_token
      @doorkeeper_token ||= ::Doorkeeper.authenticate(request)
    end

    def report_error(error)
      # Currently empty
    end
  end
end
