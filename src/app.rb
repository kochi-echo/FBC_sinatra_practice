# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

class PGDataBase
  @@conn = PG.connect(dbname: 'postgres')

  def self.conn
    @@conn
  end

  def conn
    self.class.conn
  end

  def self.set_table
    result = conn.exec("SELECT * FROM information_schema.tables WHERE table_name = 'memos'")
    return unless result.values.empty?

    conn.exec('CREATE TABLE memos (id serial, title varchar(255), content text)')
    conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', %w[メモ1 メモ1の内容])
    conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', %W[メモ2 メモ2の内容\nメモ2の内容])
  end
end

class Memo < PGDataBase
  def initialize(params = {})
    @id = params['id']
    @title = params['title']
    @content = params['content']
  end

  def self.all
    conn.exec('SELECT * FROM memos')
  end

  def self.find(id)
    conn.exec_params('SELECT * FROM memos WHERE id = $1;', [id])
  end

  def save
    result = conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', [@title, @content])
    result.cmd_tuples == 1
  end

  def update(params)
    result = conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3;', [@title, @content, @id])
    result.cmd_tuples == 1
  end

  def destroy
    conn.exec_params('DELETE FROM memos WHERE id = $1;', [@id])
  end
end

configure do
  PGDataBase.set_table
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
  memo = Memo.new(params)
  memo.destroy

  redirect '/memos'
end

get '/memos/:id' do
  set_memo
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
  set_memo
  erb :edit
end

patch '/memos/:id' do
  memo = Memo.new(params)
  if memo.update(params)
    redirect "/memos/#{params[:id]}"
  else
    redirect "/memos/#{params[:id]}/edit"
  end
end

def set_memo
  @memo_identified = Memo.find(params[:id])[0]
end
