# frozen_string_literal: true

class AuthorizationController < ApplicationController
  before_action :doorkeeper_authorize!
  skip_before_action :doorkeeper_authorize!, only: %i[index]

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
