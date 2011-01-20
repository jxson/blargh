module Blargh
  class Server < Sinatra::Base
    set :views, proc { Blargh.config.root + Blargh.config.templates_directory }
    set :public, proc { Blargh.config.root + Pathname.new('public') }

    # GET /posts/:slug
    # get Blargh.config.permalink do
    get '/posts/:slug' do
      @post = Post.where(:slug => params[:slug]).first
      mustache(:post)
    end
  end
end
