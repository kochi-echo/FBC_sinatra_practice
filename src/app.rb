# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

PATH = 'public/data.json'

def read_memos(path)
  File.open(path) { |f| JSON.parse(f.read) }
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = read_memos(PATH)
  erb :top
end

get '/memos/:id' do
  @memo = read_memos(PATH)[params[:id]]
  erb :show
end

# get '/memos/new' do
#   erb :new
# end

# post '/memos' do
#   redirect '/memos'
# end

# get '/memos/:id/edit' do
#   erb :edit
# end

# patch '/memos/:id' do
#   redirect '/memos/:id'
# end

# delete '/memos/:id' do
#   redirect '/memos'
# end
