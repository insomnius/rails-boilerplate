# frozen_string_literal: true

require 'google/apis/people_v1'

module AuthorizationService
  class LoginOrRegister < ::Service::Base
    include Contracts::Core
    include Contracts::Builtin

    attr_accessor :form

    Contract Form::LoginOrRegister => Any
    def initialize(form)
      @form = form

      super()
    end

    def perform
      raise Error::AuthorizationFailed unless client_id == form.client_id

      unless user
        ActiveRecord::Base.transaction do
          User.create(email: google_email, name: google_name, state: 'active')
        end
      end

      access_token
    end

    private

    def client_id
      ENV['GOGGLE_CLIENT_ID']
    end

    def google_jwk_source
      @google_jwk_source ||= Google::Auth::IDTokens::JwkHttpKeySource.new 'https://www.googleapis.com/oauth2/v3/certs'
    end

    def google_verifier
      @google_verifier ||= Google::Auth::IDTokens::Verifier.new key_source: google_jwk_source
    end

    def google_payload
      @google_payload ||= google_verifier.verify form.credential, aud: client_id
    end

    def google_email
      google_payload['email']
    end

    def google_name
      google_payload['name']
    end

    def user
      @user ||= User.find_by_email(google_email)
    end

    def access_token
      @access_token ||= Doorkeeper::AccessToken.create!(application_id: 1, resource_owner_id: user.id, scopes: 'read write update')
    end
  end
end
