module Rubulex
  class App < Sinatra::Base
    helpers Sinatra::JSON
    set :json_encoder, :to_json
    set :static, true
    set :public_folder, File.join(Gem.datadir("rubulex"), "public")
    set :views, File.join(Gem.datadir("rubulex"), "views")
    set :slim, { format: :html5 }

    get '/' do
      slim :index
    end 

    get '/stylesheets/:name.css' do
      content_type 'text/css', charset: 'utf-8'

      sass :"/stylesheets/#{params[:name]}"
    end

    post '/regex/test' do
      content_type 'text/html', charset: 'utf-8'

      parser = Rubulex::RegexpParser.new(
        params[:regex].to_s, 
        params[:options].to_s, 
        params[:test_data].to_s
      )

      json parser.result
    end

  end
end
