module Rend
  class Law
    attr_reader :name, :property, :for_all

    def initialize(name, property:, for_all: [])
      @name = name
      @property = property
      @for_all = for_all
    end

    def universal?
      !@for_all.empty?
    end
  end
end
