# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :doorkeeper_authorize!

  def index
    render 'index'
  end
end
