# frozen_string_literal: true

class AuthorizationController < ApplicationController
  before_action :doorkeeper_authorize!
  skip_before_action :doorkeeper_authorize!, only: %i[index login]
  skip_before_action :verify_authenticity_token, only: %i[login]

  def index
    return redirect_to '/home' if doorkeeper_token

    @errors = flash&.first&.last if !flash.nil? && (flash&.first&.first == 'errors')
    render :index
  end

  def login
    return redirect_to '/home' if doorkeeper_token

    credential = params['credential']
    g_csrf_token = params['g_csrf_token']
    client_id = params['client_id']

    form = AuthorizationService::Form::LoginOrRegister.new(credential, g_csrf_token, client_id)
    return redirect_to '/authorization', flash: Errors.from_active_record_validation_errors(form.errors).to_h unless form.valid?

    begin
      access_token = AuthorizationService.login_or_register(form)
      cookie_params = {
        value:   access_token.token,
        expires: Doorkeeper.configuration.access_token_expires_in
      }
      cookie_params[:secure] = true if Rails.env.production?
      cookies.signed[:jwt_token] = cookie_params
    rescue Errors => e
      return redirect_to '/authorization', flash: e.to_h
    end

    redirect_to '/home'
  end

  def logout
    cookies.delete :jwt_token
    AuthorizationService.logout(doorkeeper_token)
    redirect_to '/'
  end
end
