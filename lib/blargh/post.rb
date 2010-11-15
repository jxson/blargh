
module Blargh
  class Post
    extend ActiveModel::Naming
    include ActiveModel::AttributeMethods
    include ActiveModel::Dirty
    include ActiveModel::Validations
    include ActiveModel::Conversion

    validates_presence_of :body

    def initialize(attributes = {})
      if attributes['id']
        @attributes = { 'id' => attributes['id'] }
        self.saved_to = attributes['saved_to']
        attributes.delete('id')
        attributes.delete('saved_to')
      else
        @new_record = true
        @attributes = default_attributes
      end

      attributes.each { |name, value| write_attribute(name, value) }
    end
  end
end
