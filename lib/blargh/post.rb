
module Blargh
  class Post
    extend ActiveModel::Naming
    include ActiveModel::AttributeMethods
    include ActiveModel::Dirty
    include ActiveModel::Validations
    include ActiveModel::Conversion

    validates_presence_of :body

    def initialize(attributes = {})
      @new_record = true
      @attributes = default_attributes

      attributes.each { |name, value| write_attribute(name, value) }
    end
  end
end
