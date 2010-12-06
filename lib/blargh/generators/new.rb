module Blargh
  module Generators
    class New < Thor::Group
      include Thor::Actions

      argument :directory, :type => :string
      class_option :verbose, :default => 'true'

      def verbose?
        options['verbose'] == 'true'
      end

      def self.source_root
        File.dirname(__FILE__) + "/new"
      end

      def create_directory
        empty_directory(directory, { :verbose => verbose? })
      end

      def copy_config_ru
        template('config.ru', "#{ directory }/config.ru",
          { :verbose => verbose? })
      end

      def copy_first_page
        template('pages/about-this-blog.textile',
          "#{ directory }/pages/about-this-blog.textile",
          { :verbose => verbose? })
      end

      def copy_first_post
        template("posts/first-post.textile",
          "#{ directory }/posts/#{ Post.stamp }-first-post.textile",
          { :verbose => verbose? })
      end

      def copy_layout_template
        template('templates/layout.mustache',
          "#{ directory }/templates/layout.mustache",
          { :verbose => verbose? })
      end

      def copy_post_template
        template('templates/post.mustache',
          "#{ directory }/templates/post.mustache",
          { :verbose => verbose? })
      end
    end
  end
end
