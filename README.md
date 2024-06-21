# README

## 概要

以下の機能のある簡単なメモアプリです。

- メモ一覧を表示
- 新規メモを作成
- メモ一覧内のメモを選んで詳細（タイトルと内容）を表示
- メモ詳細からメモのタイトルと内容を変更
- メモ詳細からメモを削除

## 手順

### アプリの準備

1. ローカルに以下のコマンドでcloneしてください。

```
$ git clone https://github.com/kochi-echo/FBC_Sinatra_practice.git
```

2. `/FBC_Sinatra_practice`にて、以下のコマンドをターミナルで実行してください。

- 開発中メモアプリを実行する場合は以下のコマンドでbranchを移動してください。

```
$ git checkout simple-db
```

- Gemfileに従ってGemをインストールするには以下のコマンド実行してください（一度だけで良い）。

```
$ bundle install
```

### postgresqlの準備（Mac&Homebrewの場合）

Mac PCかつHomebrewを使用する場合は、以下のコマンドを実行してpostgresqlをインストールしてください。

```
$ brew update
$ brew install postgresql
$ psql --version
```

※以下のバージョンで動作確認済み

```
psql (PostgreSQL) 14.12 (Homebrew)
```

### 実行方法

- データベース（DB）を起動するには以下のコマンドを実行してください

```
$ brew services start postgresql
```

- サイトを閲覧にするには、上記のDBの起動をした後に以下のコマンドを実行してください

```
$ bundle exec ruby src/app.rb
```

以下のリンクからサイトの閲覧ができます。

[メモアプリTop画面](http://localhost:4567/memos)

- サーバ終了には`Ctrl + C`をしてください。

- DBを終了する場合は以下のコマンドを実行してください

```
$ brew services stop postgresql
```

※終了させるのを忘れることが多いので、サイト閲覧後は必ず終了させてください。

## 操作方法

### [メモアプリTop画面](http://localhost:4567/memos)

- メモのタイトル：ハイパーリンクがついているメモのタイトルを押すとメモ詳細に移動
- 追加ボタン：新規メモ作成画面に移動

### 新規メモ作成画面

- タイトルのフォーム：メモのタイトルを記入
- 内容のフォーム：メモの内容を記入
- 保存ボタン：フォームに記入した内容で新規メモを作成し、Topに移動

### メモ詳細画面

- メモのタイトルと内容を表示
- 変更ボタン：メモの変更画面に移動
- 削除ボタン：表示しているメモを削除して、Topに移動
- Topボタン：メモを編集せずにTopに移動

### メモ変更画面

- タイトルのフォーム：変更したいタイトルを記入
- 内容のフォーム：変更したい内容を記入
- 保存ボタン：フォームの内容でメモを変更し、メモ詳細表示画面に移動

## ディレクトリ構成

<img width="388" alt="スクリーンショット 2024-06-09 9 53 10" src="https://github.com/kochi-echo/FBC_Sinatra_practice/assets/47914971/5847d137-0816-43cc-8a89-749cecac2575">

## Method表

|Method|Path|Description|Process|
|------|--------------------|---|---|
|GET   |/memos              |メモ一覧を表示   |DB:memosからメモ名を取得して、top.erbを表示|
|GET   |/memos/:memo_id     |指定したメモを表示|DB:memosからメモ名と内容を取得して、show.erbを表示|
|GET   |/memos/new          |メモ作成画面を表示|new.erbを表示|
|POST  |/memos              |メモを作成|new.erbのフォームに入力された内容をDB:memosに反映し、/memosにリダイレクト|
|GET   |/memos/:memo_id/edit|指定したメモの編集画面を表示|DB:memosからメモ名と内容を取得して、edit.erbを表示|
|PATCH |/memos/:memo_id     |指定したメモを編集|edit.erbのフォームに入力された内容をDB:memosに反映し、/memos/:memo_idにリダイレクト|
|DELETE|/memos/:memo_id     |指定したメモを削除|DB:memosから:memo_idのデータを削除し、/memosにリダイレクト|

## レビュアー用コマンド

- rubocop：rubyコードスタイルチェックgem

```
$ rubocop
```

- ERB Lint：erbファイルスタイルチェックgem

```
$ bundle exec erblint --lint-all
```
