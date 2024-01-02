# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from StandardError do |exception|
    Rails.logger.error({
                         message:    exception.message,
                         controller: self.class.name.underscore,
                         e_class:    exception.class,
                         backtrace:  exception.backtrace[0..8]
                       })

    render status: :internal_server_error, json: { errors: [{ detail: 'internal server error' }] }
  end

  rescue_from Errors do |error|
    Rails.logger.error({
                         message:    error.message,
                         controller: self.class.name.underscore
                       })

    render status: error.status, json: error.to_h
  end

  rescue_from ActionDispatch::Http::Parameters::ParseError do |error|
    Rails.logger.error({
                         message:    error.message,
                         controller: self.class.name.underscore
                       })

    render status: :bad_request, json: { errors: [{ detail: 'invalid parameters sent by the client' }] }
  end

  def current_user
    return nil unless current_token

    @current_user ||= User.find(current_token.resource_owner_id)
  end

  def current_token
    @current_token ||= doorkeeper_token
  end

  def current_jwt
    return @current_jwt if defined?(@current_jwt)

    secret = File.open(Doorkeeper::JWT.configuration.secret_key_path) do |f|
      OpenSSL::PKey::RSA.new(f)
    end

    @current_jwt = JWT.decode(current_token&.token, secret, true, algorithm: Doorkeeper::JWT.configuration.encryption_method.to_s)

    @current_jwt
  end

  def not_found
    render_error(:not_found, 'not found')
  end

  def internal_server_error
    render_error(:internal_server_error, 'internal server error')
  end

  def forbidden
    render_error(:forbidden, 'access is forbidden')
  end

  def catch_unrecognized
    not_found
  end

  private

  def render_error(status, msg)
    render status:, json: {
      errors: [{
        detail: msg
      }]
    }
  end
end
