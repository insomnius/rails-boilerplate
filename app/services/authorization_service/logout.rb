# frozen_string_literal: true

module AuthorizationService
  class Logout < ::Service::Base
    include Contracts::Core
    include Contracts::Builtin

    attr_accessor :token

    Contract Doorkeeper::AccessToken => Any
    def initialize(token)
      @token = token

      super()
    end

    def perform
      access_token.revoke
    end

    private

    def access_token
      @access_token ||= Doorkeeper::AccessToken.where(token: token.token).first
    end
  end
end
