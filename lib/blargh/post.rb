
module Blargh
  class Post
    extend ActiveModel::Naming
    include ActiveModel::AttributeMethods
    include ActiveModel::Dirty
    include ActiveModel::Validations
    include ActiveModel::Conversion

    validates_presence_of :body

    def initialize(attributes = {})
      if file = attributes[:file]
        attributes = extract_attributes_from_file(file)
        self.saved_to = file
        @attributes = {} # use an attr accessor
      else
        @new_record = true
        @attributes = default_attributes
      end

      attributes.each { |name, value| write_attribute(name, value) }
    end

    def ==(other)
      return false unless other.is_a?(Post)
      id == other.id
    end

    def inspect
      attr_string = @attributes.map {|k, v|
        "#{ k.inspect } => #{ v.inspect }"
      }.join(' ')

      "#<#{self.class.name} id: #{ id } #{ attr_string }>"
    end

    def extract_attributes_from_file(file)
      content = File.read(file)

      if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        content = content[($1.size + $2.size)..-1]

        attributes = YAML.load($1)
        attributes[:body] = content
        attributes[:id] = extract_id_from_file(file)
        attributes[:slug] = extract_slug_from_file(file)
      end

      attributes ||= {}
    end

    def extract_slug_from_file(file)
      basename = File.basename(file, '.textile')

      if basename =~ /\A(\d*)-(.*)/m
        $2
      end
    end

    def extract_id_from_file(file)
      basename = File.basename(file, '.textile')

      if basename =~ /\A(\d*)-(.*)/m
        $1.to_i
      end
    end

    def self.stamp
      Time.now.to_i
    end

    def self.where(conditions = {})
      Query.new(self).where(conditions)
    end

    def self.sort(attribute = :id)
      Query.new(self).sort(attribute)
    end

    def self.find(selectors = {}, opts = {})
      # TODO validate selectors
      # TODO validate options
      # find
      slugs = files_with_slug(selectors[:slug])
      ids = files_with_id(selectors[:id])
      # apply options
      # initialiaze and return
      (slugs + ids).map { |file| new(:file => file) }
    end

    # private
    def self.files
      files = Dir["#{ directory }/*.textile"]
    end

    # private
    def self.files_with_slug(slug)
      files.select do |f|
        File.basename(f) =~ /\A(\d+)-(.*)\.textile/m && slug == $2
      end
    end

    def self.files_with_id(id)
      foo = files.select do |f|
        File.basename(f) =~ /\A(\d+)-(.*)\.textile/m && id.to_i == $1.to_i
      end
    end
  end
end
