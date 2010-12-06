module Blargh
  class Post
    class NotFound < Exception; end

    def self.create(attributes = {})
      new(attributes).tap(&:save)
    end

    def self.create!(attributes = {})
      post = new(attributes)
      raise ValidationError if !post.save
      post
    end

    def delete
      @persisted = false
      FileUtils.rm(saved_to) if File.exists?(saved_to)
      true
    end
    alias :destroy :delete

    def new_record?
      !!@new_record
    end

    def persisted?
      !!@persisted
    end

    def save
      @previously_changed = changes
      @changed_attributes.clear
      valid? ? create_or_update_file : false
    end

    def create_or_update_file
      new_record? ? create_file : update_file
    end

    def update_file
      true
    end

    def save!
      raise ValidationError if not valid?
      save
    end

    # TODO: make private
    def create_file
      return false if !valid? || persisted? # don't create if we exist or are invalid
      @new_record = false
      FileUtils.mkdir_p(Post.directory)
      file = save_to
      File.open(file, 'w') {|f| f.write(to_file) }
      self.saved_to = file
      true
    end

    def has_file?
      @saved_to ? File.exists?(@saved_to) : false
    end

    # a new post's proposed home
    def save_to
      @attributes['id'] = get_unique_id
      "#{ Post.directory }/#{ read_attribute(:id) }-#{ slug }.#{extension}"
    end

    def saved_to=(file)
      @saved_to = file
    end

    def saved_to
      @saved_to
    end

    def id
      read_attribute(:id)
    end

    # good enough for now
    def get_unique_id(proposed = 1)
      ids = Dir["#{ Post.directory }/*.textile"].map do |file|
        if File.basename(file) =~ /\A(\d*)-/
          Regexp.last_match(1).to_i
        end
      end.sort!

      if ids.include?(proposed)
        get_unique_id(ids.last + 1)
      else
        proposed
      end
    end

    # TODO: make this configurable
    def basename
      stamp = lambda { Time.now.to_i }
      # "#{ id }-#{ slug }.#{extension}"
      "#{ stamp.call }-#{ slug }.#{extension}"
    end

    def extension
      'textile'
    end

    def file
      "#{ Post.directory }/#{ basename }"
    end

    class << self

      def directory
        # TODO: move this to an initialization of some sort
        "#{ Blargh.config.root }/#{ Blargh.config.posts_directory }"
      end

      # TODO: come back to this to get the tags working
      def reflect_on_association(association)
        nil
      end

      def delete_all
        hit_list = Dir["#{ directory }/*"]
        FileUtils.rm_r(hit_list, :secure => true)
        hit_list.count
      end
      alias :destroy_all :delete_all

      def count
        Dir["#{ directory }/*"].count
      end
    end
  end
end
