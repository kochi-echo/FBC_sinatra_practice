# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

class Memo
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def self.all
    conn.exec('SELECT * FROM memos')
  end

  def self.find(id)
    result = conn.exec_params('SELECT * FROM memos WHERE id = $1;', [id])
    Memo.new(result[0])
  end

  def save
    result = conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', [@params['title'], @params['content']])
    result.cmd_tuples == 1
  end

  def update(params)
    result = conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3;', [params['title'], params['content'], params['id']])
    result.cmd_tuples == 1
  end

  def destroy
    conn.exec_params('DELETE FROM memos WHERE id = $1;', [@params['id']])
  end
end

def conn
  @conn ||= PG.connect(dbname: 'postgres')
end

configure do
  result = conn.exec("SELECT * FROM information_schema.tables WHERE table_name = 'memos'")
  if result.values.empty?
    conn.exec('CREATE TABLE memos (id serial, title varchar(255), content text)')
    conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', %w[メモ1 メモ1の内容])
    conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', %W[メモ2 メモ2の内容\nメモ2の内容])
  end
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
  set_memo
  @memo.destroy

  redirect '/memos'
end

get '/memos/:id' do
  @memo_identified = set_memo.params
  erb :show
end

post '/memos' do
  memo = Memo.new(params)
  if memo.save
    redirect '/memos'
  else
    redirect '/memos/new'
  end
end

get '/memos/:id/edit' do
  @memo_identified = set_memo.params
  erb :edit
end

patch '/memos/:id' do
  set_memo
  if @memo.update(params)
    redirect "/memos/#{params['id']}"
  else
    redirect "/memos/#{params['id']}/edit"
  end
end

def set_memo
  @memo = Memo.find(params['id'])
end
