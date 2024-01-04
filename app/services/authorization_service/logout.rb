# frozen_string_literal: true

module AuthorizationService
  class Logout < ::Service::Base
    include Contracts::Core
    include Contracts::Builtin

    attr_accessor :request

    Contract Request::Authorization::Logout => Any
    def initialize(request)
      @request = request

      super()
    end

    def perform
      access_token.delete
    end

    private

    def access_token
      @access_token ||= Doorkeeper::AccessToken.where(token: request.token).first
    end
  end
end
