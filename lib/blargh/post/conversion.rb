module Blargh
  class Post
    def to_json
      @attributes.to_json
    end

    # converts our object into a file, pretty neat
    def to_file
      "farts"
    end
  end
end