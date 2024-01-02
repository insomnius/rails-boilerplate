# frozen_string_literal: true

class Errors < StandardError
  include Contracts::Core
  include Contracts::Builtin

  attr_reader :objects, :status

  def self.from_active_record_validation_errors(errors)
    error_objects = []
    errors.each do |error|
      error_objects << ErrorsObject.new(10422, error.message, source: {
                                          pointer: error.attribute
                                        })
    end

    new(422, error_objects)
  end

  Contract Integer, ArrayOf[ErrorsObject] => Any
  def initialize(status, objects)
    @objects = objects
    @status = status

    super()
  end

  def message
    error_message = ''
    objects.each do |object|
      error_message += "#{object.message} "
    end

    error_message
  end

  def to_h
    { errors: serialized_objects }
  end

  private

  def serialized_objects
    serialized = []
    objects.each do |object|
      e = { code: object.code, detail: object.detail }
      e[:source] = object.source unless object.source.nil?
      serialized << e
    end
    serialized
  end
end
