module Blargh
  class Server < Sinatra::Base
    get Blargh.permalink do
      @post = Post.find_by_slug(params[:slug])
      mustache(:post)
    end
  end
end
