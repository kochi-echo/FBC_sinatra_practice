# README

## 実行

`/pracite`以下にて、以下のコマンドをターミナルで実行してください。

```
ruby app.rb
```

## /srcディレクトリ構成

.
├── app.rb #メイン処理
├── public
│   └── data.json #メモのデータファイル
└── views
    ├── edit.erb #選択したメモ編集画面erbファイル
    ├── layout.erb #デフォルトerbファイル
    ├── new.erb #メモ新規作成erbファイル
    ├── show.erb #選択したメモ表示画面erbファイル
    └── top.erb #メモ一覧表示erbファイル

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
