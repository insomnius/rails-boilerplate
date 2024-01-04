# frozen_string_literal: true

module AuthorizationService
  module_function

  def login_or_register(*args) = LoginOrRegister.new(*args).call
  def logout(*args) = Logout.new(*args).call
end
