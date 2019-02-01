# 構造

* ソリューション
    * クラスライブラリ(`Core`)
    * テスト(`Core`)

# 問題点

* テストコードにクラスライブラリの`using`がない
* クラスライブラリのテストコード例がない
* ファイル名が固定
* 遅すぎる

## テストコードにクラスライブラリの`using`がない

　テストコードにクラスライブラリを`using`するコードがない。

UnitTest1.cs
```csharp
using MyLib.Class1
```

## クラスライブラリのテストコード例がない

　デフォルトでは以下。

```csharp
        [Test]
        public void Test1()
        {
            Assert.Pass();
        }
```

　以下のようにテストコードの書き方を把握できるくらいのコードは欲しい。

```csharp
        [Test]
        public void Test1()
        {
            var c = new MyLib.Class1();
            var actual = c.Value;
            Assert.Equals("Hello World !!", actual)
        }
```

## ファイル名が固定

　デフォルトは以下。

* Class1.cs
* UnitTest1.cs

　これを任意にしたい。テスト用クラスも対応した名前にしたい。

プロジェクト|ファイル名(default)|ファイル名(希望)
------------|-------------------|----------------
ClassLib|`Class1.cs`|`[任意].cs`
NUnit|`UnitTest1.cs`|`[任意]Test.cs`

## 遅すぎる

　なんと5分もかかっている。プロジェクト作成だけでも2分。

項目|時間
----|----
作成|real	2m0.922s
テスト|real	2m52.163s
計|real	4m53.309s

# テンプレート作成コマンド

　任意のクラス名とその対応テストクラスが作成される。

```
$ dotnet new libtest -n MyLib
```

　複数クラスに対応できるとなお良い。

```
$ dotnet new libtest -n MyLib1 MyLib2 MyLib3
```
```
$ dotnet new libtest --classes MyLib1 MyLib2 MyLib3
```


