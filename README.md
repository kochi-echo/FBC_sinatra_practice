# README

## 実行

`/pracite`以下にて、以下のコマンドをターミナルで実行してください。

```
ruby app.rb
```

## /srcディレクトリ構成

<img width="388" alt="スクリーンショット 2024-06-09 9 53 10" src="https://github.com/kochi-echo/FBC_Sinatra_practice/assets/47914971/5847d137-0816-43cc-8a89-749cecac2575">

## Method表

|Method|Path|Description|Process|
|------|--------------------|---|---|
|GET   |/memos              |メモ一覧を表示   |data.jsonからメモ名を取得して、layout.erbを表示|
|GET   |/memos/:memo_id     |指定したメモを表示|data.jsonからメモ名と内容を取得して、show.erbを表示|
|GET   |/memos/new          |メモ作成画面を表示|new.erbを表示|
|POST  |/memos              |メモを作成|new.erbのフォームに入力された内容をdata.jsonに反映し、/memosにリダイレクト|
|GET   |/memos/:memo_id/edit|指定したメモの編集画面を表示|data.jsonからメモ名と内容を取得して、edit.erb|
|PATCH |/memos/:memo_id     |指定したメモを編集|edit.erbのフォームに入力された内容をdata.jsonに反映し、/memos/:memo_idにリダイレクト|
|DELETE|/memos/:memo_id     |指定したメモを削除|data.jsonからkeyが:memo_idのデータを削除し、/memosにリダイレクト|
