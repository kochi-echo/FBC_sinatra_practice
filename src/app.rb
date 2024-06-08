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

delete '/memos/:id' do
  memos = read_memos(PATH)
  memos.delete(params[:id])
  write_memos(PATH, memos)

  redirect '/memos'
end

get '/memos/:id' do
  @memo = read_memos(PATH)[params[:id]]
  erb :show
end

post '/memos' do
  memos = read_memos(PATH)
  id = (memos.keys.map(&:to_i).max + 1).to_s
  memos[id] = { 'title' => params[:title], 'content' => params[:content] }
  write_memos(PATH, memos)

  redirect '/memos'
end

get '/memos/:id/edit' do
  @memo = read_memos(PATH)[params[:id]]
  erb :edit
end

patch '/memos/:id' do
  memos = read_memos(PATH)
  memos[params[:id]] = { 'title' => params[:title], 'content' => params[:content] }
  write_memos(PATH, memos)

  redirect "/memos/#{params[:id]}"
end
