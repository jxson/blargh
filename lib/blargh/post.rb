
module Blargh
  class Post
    extend ActiveModel::Naming
    include ActiveModel::AttributeMethods
    include ActiveModel::Dirty
    include ActiveModel::Validations
    include ActiveModel::Conversion


    def new_record?() true end
    def destroyed?()  true end

    def persisted?
      false
    end

    # TODO: come back to this to get the tags working
    def self.reflect_on_association(association)
      nil
    end
    ##########################################################################
    validates_presence_of :body

    define_attribute_methods [:title, :body]

    attr_reader(:attributes)
    attr_accessor(:title, :body)

    def initialize(attributes = {})
      @attributes = attributes

      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    #     include ActiveModel::Serialization
    #
    #     attr_accessor :name
    #
    #     def attributes
    #       @attributes ||= {'name' => 'nil'}
    #     end

    # defaults to the first 255 characters of the body
    def title
      @title || @body.truncate(255, :omission => '')
    end

  #   attr_accessor :attributes,
  #     :title,
  #     :body,
  #     :description,
  #     :slug,
  #     :basename,
  #     :published_at
  #
  #   attr_reader :new_record,
  #     :draft,
  #     :published
  #
  #   def initialize(attrs = {})
  #     @attributes = {
  #       :draft => attrs[:draft] || true,
  #       :title => attrs[:title],
  #       :body => attrs[:body]
  #     }
  #   end
  #
  #   def draft?
  #     !!@attributes[:draft]
  #   end
  #
  #   def published?
  #     ! draft?
  #   end
  #
  #   def title
  #     @attributes[:title]
  #   end
  #
  #   def body
  #     @attributes[:body]
  #   end
  end
end
