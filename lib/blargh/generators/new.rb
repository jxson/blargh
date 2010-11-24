module Blargh
  module Generators
    class New < Thor::Group
      include Thor::Actions

      argument :directory, :type => :string

      def self.source_root
        File.dirname(__FILE__) + "/new"
      end

      def create_directory
        empty_directory(directory)
      end

      def copy_config_ru
        template('config.ru', "#{ directory }/config.ru")
      end

      def copy_first_page
        template('pages/about-this-blog.textile',
          "#{ directory }/pages/about-this-blog.textile")
      end

      def copy_first_post
        template("posts/first-post.textile",
          "#{ directory }/posts/#{ Post.stamp }-first-post.textile")
      end
    end
  end
end
