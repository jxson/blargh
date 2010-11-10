module Blargh
  class Post
    class ValidationError < Exception
    end

    def new_record?
      !!@new_record
    end

    def persisted?
      !new_record?
    end

    def save
      @previously_changed = changes
      @changed_attributes.clear
      valid? ? save_to_file : false
    end

    def save!
      raise ValidationError if not valid?
      save
    end

    # TODO: make private
    def save_to_file
      # TODO: check validations on creation if new record
      @new_record = false
      FileUtils.mkdir_p(directory)
      File.open(file, 'w') {|f| f.write(to_file) }
    end

    def has_file?
      File.exists?(file)
    end

    # TODO: make this configurable
    def basename
      stamp = Time.now.to_i
      "#{ stamp }-#{ slug }"
    end

    def extension
      '.textile'
    end

    def file
      "#{ directory }/#{ basename }#{ extension }"
    end

    def directory
      # TODO: move this to an initialization of some sort
      raise 'You need to configure your Blargh!' if Blargh.root.nil?
      "#{ Blargh.root }/#{ Blargh.posts_directory }"
    end

    # converts our object into a file, pretty neat
    def to_file
      "farts"
    end

    # TODO: come back to this to get the tags working
    def self.reflect_on_association(association)
      nil
    end
  end
end
