
module Blargh
  class Post
    class RecordNotFound < Exception; end

    extend ActiveModel::Naming
    include ActiveModel::Validations
    include ActiveModel::Conversion

    attr_accessor :id, :body, :title, :description, :publish, :slug

    validates_presence_of :body
    attr_accessor_with_default(:title) { body }
    attr_accessor_with_default(:description) { truncated_body }
    attr_accessor_with_default(:publish, true)

    def initialize(attributes = {})
      if file = attributes[:file] # use delete
        attributes = extract_attributes_from_file(file)
        self.saved_to = file # why not just use file?
      else
        @new_record = true
      end

      attributes.each { |name, value| send("#{ name }=", value) }
    end

    def truncated_body
      body.truncate(255) unless body.nil?
    end
    private :truncated_body

    def content
      RedCloth.new(Mustache.render(body, self)).to_html
    end

    def published?
      !!publish
    end

    def draft?
      ! !!publish
    end

    def slug
      title.to_url
    end

    def ==(other)
      return false unless other.is_a?(Post)
      id == other.id
    end

    # def inspect
    #   attr_string = @attributes.map {|k, v|
    #     "#{ k.inspect } => #{ v.inspect }"
    #   }.join(' ')
    #
    #   "#<#{self.class.name} id: #{ id } #{ attr_string }>"
    # end

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
      records = (slugs + ids).flatten

      # apply options
      limit  = opts.delete(:limit) || records.length

      # initialiaze and return
      records[0..limit].map { |file| new(:file => file) }
    end

    def self.find_one(selectors = {}, opts = {})
      result = find(selectors, opts.merge(:limit => 1))

      result.empty? ? not_found : result.first
    end

    private
    def self.files
      files = Dir["#{ directory }/*.textile"]
    end

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

    def self.not_found; raise RecordNotFound; end
  end
end
