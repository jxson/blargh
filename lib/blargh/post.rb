
module Blargh
  class Post
    class RecordNotFound < Exception; end
    class ValidationError < Exception; end

    extend ActiveModel::Naming
    include ActiveModel::Validations
    include ActiveModel::Conversion


    attr_accessor :id, :body, :title, :description, :publish, :slug, :file

    validates_presence_of :body
    attr_accessor_with_default(:title) { body }
    attr_accessor_with_default(:description) { truncated_body }
    attr_accessor_with_default(:publish, true)

    def initialize(attributes = {})
      attributes.each { |name, value| send("#{ name }=", value) }
    end

    def css_id
      id.nil? ? nil : "post-#{ id }"
    end

    def self.create(attributes = {})
      new(attributes).tap(&:save)
    end

    def self.create!(attributes = {})
      post = new(attributes)
      raise ValidationError if !post.save
      post
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
      persisted? ? slug_from_file : title.to_url
    end

    def slug_from_file
      if File.basename(file, '.textile') =~ /\A(\d*)-(.*)/m
        $2
      end
    end

    def ==(other)
      return false unless other.is_a?(Post)
      id == other.id
    end

    def id
      if File.basename(file, '.textile') =~ /\A(\d*)-(.*)/m
        $1.to_i
      end
    end

    def file=(file)
      data = File.read(file)

      if data =~ /^(---\s*\n.*?\n?)^(---\s*$)/m
        self.body = data[($1.size + $2.size)..-1]
        attributes = YAML.load($1.strip)
        attributes.each { |name, value| send("#{ name }=", value) }
      end

      @file = file
    end

    def save
      valid? ? create_or_update_file : false
    end

    def save!
      raise ValidationError if not valid?
      save
    end

    def destroy
      if persisted?
        FileUtils.rm(file).inspect
        true
      else
        false
      end
    end
    # alias :destroy :delete

    def create_or_update_file
      new_record? ? create_file : update_file
    end

    def update_file
      true
    end

    def create_file
      return false if persisted_or_invalid
      FileUtils.mkdir_p(Post.directory)
      self.file = "#{ Post.directory }/#{ get_unique_id }-#{ slug }.#{extension}"
      File.open(file, 'w') {|f| f.write(to_file) }
      true
    end
    private :create_file

    def get_unique_id(proposed = Time.now.to_i)
      ids = Dir["#{ Post.directory }/*.textile"].map do |file|
        if File.basename(file) =~ /\A(\d*)-/
          Regexp.last_match(1).to_i
        end
      end.sort!

      ids.include?(proposed) ? get_unique_id(ids.last + 1) : proposed
    end
    private :get_unique_id

    def persisted_or_invalid
      !valid? || persisted?
    end

    def new_record?
      ! !!persisted?
    end

    def persisted?
      file ? File.exists?(file) : false
    end

    def extension
      'textile'
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
    def self.directory
      "#{ Blargh.config.root }/#{ Blargh.config.posts_directory }"
    end

    def self.files
      files = Dir["#{ directory }/*.textile"]
    end

    def self.files_with_slug(slug)
      files.select do |f|
        File.basename(f) =~ /\A(\d+)-(.*)\.textile/m && slug == $2
      end
    end

    def self.files_with_id(id)
      files.select do |f|
        File.basename(f) =~ /\A(\d+)-(.*)\.textile/m && id.to_i == $1.to_i
      end
    end

    def self.not_found; raise RecordNotFound; end

    def self.count
      Dir["#{ directory }/*"].count
    end

    # TODO: come back to this to get the tags working
    def self.reflect_on_association(association)
      nil
    end

    def to_json
      @attributes.to_json
    end

    # converts our object into a file, pretty neat
    def to_file
      # TODO this needs work
      attrs = {
        'title' => title,
        'description' => description,
      }

      ['body', 'id'].each { |key| attrs.delete(key) }

      front_matter = YAML::dump(attrs)
      front_matter << '---'

<<-FILE
#{ front_matter }
#{ body }
FILE
    end
  end
end
