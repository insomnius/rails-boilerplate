# frozen_string_literal: true

class AuthorizationController < ApplicationController
  before_action do
    doorkeeper_authorize! unless params['action'] == 'index'
  end

  def index
    render :index
  end

  def login
    binding.pry
  end

  def logout
    binding.pry
  end
end
