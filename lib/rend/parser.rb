require "prism"

module Rend
  class Parser
    def parse(source)
      result = Prism.parse(source)
      if result.errors.any?
        raise ParseError, result.errors.map(&:message).join("\n")
      end
      result.value
    end

    class ParseError < StandardError; end
  end
end
