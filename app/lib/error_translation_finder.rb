# frozen_string_literal: true

module ErrorTranslationFinder
  def error_translation
    I18n.t! self.class.name.underscore.split('/').join('.')
  end
end
