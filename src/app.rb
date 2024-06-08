# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

PATH = 'public/data.json'

def read_memos(path)
  File.open(path) { |f| JSON.parse(f.read) }
end

def write_memos(path, input)
  File.open(path, 'w') { |f| JSON.dump(input, f) }
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = read_memos(PATH)
  erb :top
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  @memo = read_memos(PATH)[params[:id]]
  erb :show
end

post '/memos' do
  title = params['title']
  content = params['content']

  memos = read_memos(PATH)
  id = (memos.keys.map(&:to_i).max + 1).to_s
  memos[id] = { 'title' => title, 'content' => content }
  write_memos(PATH, memos)

  redirect '/memos'
end

# get '/memos/:id/edit' do
#   erb :edit
# end

# patch '/memos/:id' do
#   redirect '/memos/:id'
# end

# delete '/memos/:id' do
#   redirect '/memos'
# end
