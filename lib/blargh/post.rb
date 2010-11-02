module Blargh
  class Post
    attr_accessor :title, 
      :body,
      :description,
      :slug,
      :basename,
      :published_at
      
    attr_reader :new_record,
      :draft,
      :published,
  end
end
