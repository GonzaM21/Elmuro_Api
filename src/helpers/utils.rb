require_relative '../exceptions/no_string_error'
class Utils
  def sacar_formato_string(string)
    raise NoStringError unless string.is_a? String

    I18n.transliterate(string).downcase
  end
end
