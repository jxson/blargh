module Blargh
  class Server < Sinatra::Base
    get '/posts/:slug' do
      @post = Post.find(params[:slug])
      mustache(:post)
    end
  end
end
