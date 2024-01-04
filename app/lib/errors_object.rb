# frozen_string_literal: true

class ErrorsObject < StandardError
  include Contracts::Core
  include Contracts::Builtin

  attr_reader :code, :detail, :source

  def self.from_hash(error_hash)
    ErrorsObject.new(error_hash['code'], error_hash['detail'], source: error_hash['source'])
  end

  Contract Integer, String, Or[Hash, nil] => Any
  def initialize(code, detail, source: nil)
    @code = code
    @detail = detail
    @source = source

    super()
  end

  def message
    "Code: #{code}, Errors: #{compiled_detail}."
  end

  private

  def compiled_detail
    return detail unless source

    "`#{source['pointer']}` #{detail}"
  end
end
