# frozen_string_literal: true

module AuthorizationService
  module Error
    class AuthorizationFailed < ErrorsObject
      include ErrorTranslationFinder

      def initialize
        super(11000, error_translation)
      end
    end
  end
end
