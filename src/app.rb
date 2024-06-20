# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'

PATH = File.join(__dir__, 'public/data.json')

class Memo
  def initialize(params)
    @params = params
  end

  def self.all
    conn.exec('SELECT * FROM memos')
  end

  def save
    result = conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', [@params[:title], @params[:content]])
    result.cmd_tuples == 1
  end

  def self.show(params)
    result = conn.exec_params('SELECT * FROM memos WHERE id = $1;', [params[:id]])
    result.ntuples > 0 ? result[0].to_h : {}
  end
end

def conn
  @conn ||= PG.connect(dbname: 'postgres')
end

configure do
  result = conn.exec("SELECT * FROM information_schema.tables WHERE table_name = 'memos'")
  conn.exec('CREATE TABLE memos (id serial, title varchar(255), content text)') if result.values.empty?
  # conn.exec_params('INSERT INTO memos_test(title, content) VALUES ($1, $2);', ['メモ1', 'メモ1の内容'])
  # conn.exec_params('INSERT INTO memos_test(title, content) VALUES ($1, $2);', ['メモ2', "メモ2の内容\nメモ2の内容"])
end


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
  @memos = Memo.all
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
  @memo = Memo.show(params)
  erb :show
end

post '/memos' do
  @memo = Memo.new(params)
  if @memo.save
    redirect '/memos'
  else
    redirect '/memos/new'
  end
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
