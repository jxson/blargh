module Blargh
  class Post
    class ValidationError < Exception; end

    attr_reader(:attributes)

    define_attribute_methods [ :title,
      :body,
      :description,
      :publish,
      :slug
    ]

    def default_attributes
      {
        'publish' => true
      }
    end

    def write_attribute(name, value)
      send("#{ name }_will_change!") unless value == read_attribute(name)
      key = name.to_s
      @attributes[key] = value
    end

    def read_attribute(name)
      key = name.to_s
      @attributes[key]
    end

    def title=(value)
      write_attribute(:title, value)
    end

    def title
      read_attribute(:title) || truncated_body
    end

    def body=(value)
      write_attribute(:body, value)
    end

    def body
      read_attribute(:body)
    end

    def description=(value)
      write_attribute(:description, value)
    end

    def description
      read_attribute(:description) || truncated_body
    end

    def publish=(value)
      write_attribute(:publish, value)
    end

    def publish
      read_attribute(:publish)
    end

    def published?
      !!publish
    end

    def draft?
      ! !!publish
    end

    def slug
      return if title.nil?
      title.to_url
    end

    private
    def truncated_body
      return if body.nil?
      body.truncate(255)
    end
  end
end