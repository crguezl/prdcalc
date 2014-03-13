require 'sinatra'
# Avoid stopping and starting the server while in development
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'
require 'v8'
require 'coffee-script'

#configure do
#  set :static_cache_control, [:public, :no_cache, :no_store, :must_revalidate]
#end

before do
  set_title
end

helpers do
  def css(*stylesheets)
    stylesheets.map do |stylesheet| 
      %Q{
        <link href="/#{stylesheet}.css" 
              media="screen, projection" 
              rel="stylesheet" 
        />
      }
    end.join
  end
  
  def current?(path='/')
    (request.path==path || request.path==path+'/') ? "current" : nil
  end
  
  def set_title
    @title ||= "Predictive Recursive Descent Parser"
  end
end

get('/styles.css'){ scss :styles }
get('/javascripts/main.js'){ coffee :main }

get '/' do
  slim :home
end

get '/grammar' do
  slim :grammar
end

not_found do
  slim :not_found
end

