module Blargh
  class Query
    include Enumerable
    extend  Forwardable

    attr_reader :model, :conditions, :options
    def_delegators :to_a, :each

    def initialize(model)
      @model = model
      @options = { :sort => :timestamp }
    end

    def where(hash = {})
      @conditions = hash
      self
    end

    def to_a
      all
    end

    def all
      find_each.to_a
    end

    def find_each
      model.find(conditions, options)
    end
  end
end
