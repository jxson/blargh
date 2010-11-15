module Blargh
  class Post
    def to_json
      @attributes.to_json
    end

    # converts our object into a file, pretty neat
    def to_file
      attrs = @attributes.clone

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