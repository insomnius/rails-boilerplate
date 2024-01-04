# frozen_string_literal: true

module AuthorizationService
  module Form
    class LoginOrRegister
      include ActiveModel::Serialization
      include ActiveModel::Validations
      include Contracts::Core
      include Contracts::Builtin

      attr_accessor :credential, :g_csrf_token, :client_id

      validates_presence_of :credential, :g_csrf_token, :client_id

      Contract String, String, String => Any
      def initialize(credential, g_csrf_token, client_id)
        @credential = credential
        @g_csrf_token = g_csrf_token
        @client_id = client_id
      end
    end
  end
end
