module Blargh
  class Post
    class InvalidArgument < Exception; end

    class << self
      # def find(*args)
      #   raise InvalidArgument if args[0].nil?
      #
      #   options = args.extract_options!
      #
      #   case args.first
      #     when :all then true
      #   else
      #     find_by_id(args.first)
      #   end
      # end

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


    end
  end
end
