# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

PATH = File.join(__dir__, 'public/data.json')

def read_memos
  File.open(PATH) { |f| JSON.parse(f.read) }
end

def write_memos(input)
  File.open(PATH, 'w') { |f| JSON.dump(input, f) }
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = read_memos
  erb :top
end

get '/memos/new' do
  erb :new
end

delete '/memos/:id' do
  memos = read_memos
  memos.delete(params[:id])
  write_memos(memos)

  redirect '/memos'
end

get '/memos/:id' do
  @memo = read_memos[params[:id]]
  erb :show
end

post '/memos' do
  memos = read_memos
  id = (memos.keys.map(&:to_i).max + 1).to_s
  memos[id] = { 'title' => params[:title], 'content' => params[:content] }
  write_memos(memos)

  redirect '/memos'
end

get '/memos/:id/edit' do
  @memo = read_memos[params[:id]]
  erb :edit
end

patch '/memos/:id' do
  memos = read_memos
  memos[params[:id]] = { 'title' => params[:title], 'content' => params[:content] }
  write_memos(memos)

  redirect "/memos/#{params[:id]}"
end
