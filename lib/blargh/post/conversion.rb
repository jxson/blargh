module Blargh
  class Post
    def to_json
      @attributes.to_json
    end
  end
end