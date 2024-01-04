# frozen_string_literal: true

module AuthorizationService
  module Form
    class Logout
      include ActiveModel::Serialization
      include ActiveModel::Validations
      include Contracts::Core
      include Contracts::Builtin

      attr_accessor :token

      validates_presence_of :token

      Contract String => Any
      def initialize(token)
        @token = token
      end
    end
  end
end
