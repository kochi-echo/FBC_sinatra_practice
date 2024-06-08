require 'sinatra'
require 'sinatra/reloader'

# get '/' do
#   'hello'
# end

get "/" do
  erb :index
end
