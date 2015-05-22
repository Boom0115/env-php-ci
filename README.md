Wired開発環境のセットアップ手順

参考書籍『CakePHPで学ぶ、継続的インテグレーション』
本書104ページからの説明に沿って環境を構築

http://book.impress.co.jp/books/1114101035

注意事項：Windows環境であること

環境 Windows7

・Vagrant
・ChefDk（Ruby環境入りのChef開発キット）
・SourceTree(Gitクライアント）

プロビジョニングする際は、DOSプロンプトをUTF-8にしておかないとRubyのエラーで失敗する。

このため作業する際は、"chcp 65001"にしてコードページをUTF-8に切り替えて行った。コードページがUTF-8のDOSプロンプトでは日本語が表示できないことに注意。

また、書籍中にある"bundle exec knife ...."は失敗してしまうため、直接"knife ..."コマンドを実行した。原因は不明。

provision.batを実行するとクックブックの再構築が行われるため、後は"Vagrant provision ホスト名"でプロビジョンが出来る。

