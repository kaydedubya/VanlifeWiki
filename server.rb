require 'rubygems'
require 'sinatra'

#### Sinatra App ####
class App < Sinatra::Base
  enable :sessions

  # Ensure we use TLS in all non-local environments
  before do
    if !request.path.start_with?('/assets/')
      if request.host != 'localhost'
        if !request.secure?
          halt 400, File.read("_site/400.html")
        end
      end
    end
  end

  #### Display wiki pages generated by Jekyll ####
  get '/*' do
    fname = params[:splat][0]

    fname = 'index' if fname.empty?
    path = File.join("_site", fname.to_s)
    if File.exist?(path)
      return send_file(path)
    else
      if File.exist?("#{path}.html")
        return send_file("#{path}.html")
      end
    end

    status 404
    File.read("_site/404.html")
  end
end
