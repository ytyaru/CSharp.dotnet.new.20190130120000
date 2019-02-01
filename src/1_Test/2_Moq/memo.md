# 構造

* ソリューション
    * クラスライブラリ(`Standard`)
    * テスト(`Core`)
        * dotnet add package Moq

# 概要

　単体テストでMockを使うためのライブラリをプロジェクトに追加する。

　Mockとはテスト用オブジェクト作成クラスのこと。テストしたいメソッドやプロパティの値を固定する。以下の場合に便利。

* 値が変わる
    * 乱数: System.Random((int)DateTime.Now.Ticks).Next()
    * 日付: DateTime.Now
* 外部依存
    * ファイルから値を取得する
    * データベースから値を取得する
    * ネットワークから値を取得する

# 参考

* https://www.c-sharpcorner.com/article/moq-unit-test-net-core-app-using-mock-object/
* https://qiita.com/usamik26/items/42959d8b95397d3a8ffb

