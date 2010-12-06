module Blargh
  class Server < Sinatra::Base
    set :views, proc { Blargh.config.root + Blargh.config.templates_directory }

    # GET /posts/:slug
    get Blargh.config.permalink do
      @post = Post.find_by_slug(params[:slug])
      mustache(:post)
    end
  end
end
