
module Blargh
  class Post
    extend ActiveModel::Naming
    include ActiveModel::AttributeMethods
    include ActiveModel::Dirty
    include ActiveModel::Validations
    include ActiveModel::Conversion

    # persistence

    def new_record?
      !!@new_record
    end

    def persisted?
      !new_record?
    end

    def insert

    end

    def save
      valid? ? save_to_file : false
    end

    # TODO: make private
    def save_to_file
      # TODO: check validations on creation if new record
      @new_record = false
      File.open(file, 'w') {|f| f.write(to_file) }
    end

    # TODO: make this configurable
    def file
      "#{ lambda { Time.now.to_i } }-#{ slug }"
    end

    # converts our object into a file, pretty neat
    def to_file
      "farts"
    end

    # TODO: come back to this to get the tags working
    def self.reflect_on_association(association)
      nil
    end

    validates_presence_of :body

    define_attribute_methods [:title, :body, :description, :publish, :slug]

    attr_reader(:attributes)
    attr_accessor(:title, :body, :description, :publish, :slug)

    def initialize(attributes = {})
      @new_record = true
      @attributes = attributes

      attributes.each do |name, value|
        send("#{name}=", value)
      end

      @publish ||= true
    end

    # defaults to the first 255 characters of the body
    def title
      @title || truncated_body
    end

    # defaults to the first 255 characters of the body
    def description
      @description || truncated_body
    end

    def published?
      !!@publish
    end

    def draft?
      ! !!@publish
    end

    def slug
      title.to_url
    end

    private
    def truncated_body
      @body.truncate(255)
    end
  end
end
