# frozen_string_literal: true

require 'pg'

conn = PG.connect(dbname: 'postgres')

result = conn.exec("SELECT * FROM information_schema.tables WHERE table_name = 'memos'")
if result.values.empty?
  conn.exec('CREATE TABLE memos (id serial, title varchar(255), content text)')
  conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', %w[メモ1 メモ1の内容])
  conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', %W[メモ2 メモ2の内容\nメモ2の内容])
end
