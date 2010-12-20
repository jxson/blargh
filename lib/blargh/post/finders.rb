module Blargh
  class Post
    class InvalidArgument < Exception; end

    class << self
      def find(*args)
        raise InvalidArgument if args[0].nil?

        options = args.extract_options!

        case args.first
          when :all then true
        else
          find_by_id(args.first)
        end
      end

      def find_by_id(id)
        files = Dir["#{directory}/*.textile"].map do |f|
          if File.basename(f) =~ /\A(\d*)-/m
            f if id.to_i == $1.to_i
          end
        end.compact

        if files.nil? || files.empty?
          raise NotFound
        else
          file = files.pop
        end


        attributes = extract_attributes_from_file(file).merge!({
          'id' => id,
          'saved_to' => file
        })

        new(attributes)
      end

      def find_by_slug(slug)
        raise InvalidArgument if slug.nil?

        files = Dir["#{ directory }/*.textile"].map do |f|
          if File.basename(f) =~ /\A(\d+-\d+-\d+)-(.*)\.textile/m
            f if slug == $2
          end
        end.compact

        if files.nil? || files.empty?
          raise NotFound
        else
          file = files.pop
        end

        attributes = extract_attributes_from_file(file).merge!({
          'id' => $1.to_i,
          'saved_to' => file
        })

        new(attributes)
      end

      # TODO: move this into the Post.new
      def extract_attributes_from_file(file)
        content = File.read(file)

        if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          content = content[($1.size + $2.size)..-1]

          attributes = YAML.load($1)
          attributes[:body] = content
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
    end
  end
end
