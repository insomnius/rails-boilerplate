# frozen_string_literal: true

class ErrorsObject < StandardError
  include Contracts::Core
  include Contracts::Builtin

  attr_reader :code, :detail, :source

  Contract Integer, String, Or[Hash, nil] => Any
  def initialize(code, detail, source: nil)
    @code = code
    @detail = detail
    @source = source

    super()
  end

  def message
    "Code: #{code}, Errors: #{detail}."
  end
end
