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

    def first
      find_one
    end

    def find_each
      model.find(conditions, options)
    end

    def find_one
      model.find_one(conditions, options)
    end
  end
end
