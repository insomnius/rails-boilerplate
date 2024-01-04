# frozen_string_literal: true

class AuthorizationController < ApplicationController
  before_action :doorkeeper_authorize!
  skip_before_action :doorkeeper_authorize!, only: %i[index login]
  skip_before_action :verify_authenticity_token, only: %i[login]

  def index
    @errors = flash&.first&.last if !flash.nil? && (flash&.first&.first == 'errors')
    render :index
  end

  def login
    credential = params['credential']
    g_csrf_token = params['g_csrf_token']
    client_id = params['client_id']

    form = AuthorizationService::Form::LoginOrRegister.new(credential, g_csrf_token, client_id)
    redirect_to '/authorization', flash: Errors.from_active_record_validation_errors(form.errors).to_h unless form.valid?

    begin
      AuthorizationService.login_or_register(form)
    rescue Errors => e
      redirect_to '/authorization', flash: e.to_h
    end

    redirect_to '/home'
  end

  def logout
    binding.pry
  end
end
