module Blargh
  class Server < Sinatra::Base
    set :views, proc { Blargh.config.root + Blargh.config.templates_directory }
    set :public, proc { Blargh.config.root + Pathname.new('public') }

    # GET /posts/:slug
    # get Blargh.config.permalink do
    get '/posts/:timestamp' do
      @post = Post.find_by_slug(params[:slug])
      mustache(:post)
    end
  end
end
