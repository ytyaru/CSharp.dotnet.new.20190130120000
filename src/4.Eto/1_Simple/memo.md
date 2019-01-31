# 構造

* ソリューション
    * クラスライブラリ(`Standard2.0`)
    * テスト(`Core`)
    * Eto.Froms
        * EtoApp(`Standard1.6`)
        * EtoApp.Desktop(`net461`)　スタートアッププロジェクト

# 結論

　開発工程ごとに開発環境を変更する必要がある。

* Eto.Formsは`MonoDevelop`で開発する
    * Linux上において`dotnet`では`net461`をビルド＆実行できないため
* テストは`dotnet`で開発する
    * `MonoDevelop`では`Core`をビルド＆実行できないため
        * テスト用フレームワーク(`NUnit`, `xUnit`, `MSTest`)は`Core`, `Framework`でのみ動作する

# 参考

* https://github.com/dotnet/templating/wiki/Available-templates-for-dotnet-new

　Eto.Forms用プロジェクトテンプレートをインストールする必要がある。

```bash
dotnet new -i "Eto.Forms.Templates::*"
```

　`dotnet new -h`で確認する。

```
Templates                                         Short Name         Language          Tags                                 
----------------------------------------------------------------------------------------------------------------------------
Eto Application                                   etoapp             [C#], F#          Cross Platform/Eto                   
Eto Panel, Dialog or Form                         etofile            [C#], F#          Cross Platform/Eto
```

# 問題点

* ClassLibとEto.Formsの.NETStandardバージョンが合わない
* ビルド＆実行できない

## ClassLibとEto.Formsの.NETStandardバージョンが合わない

　ClassLibのバージョンは以下。

```
$ dotnet new classlib -h
...
Options:                                                                             
  -f|--framework  The target framework for the project.                              
                      netcoreapp2.2     - Target netcoreapp2.2                       
                      netstandard2.0    - Target netstandard2.0                      
                  Default: netstandard2.0
...                                            
```

　EtoAppのバージョンは以下。ヘルプには表示されなかったので指定できないらしい。`.csproj`ファイルを出力して内容を確認した。

プロジェクト|環境ver
------------|-------
ClassLib|`netstandard2.0` or `netcoreapp2.2`
EtoApp|`netstandard1.6`
EtoApp.Desktop|`net461`

　ClassLibが`2.0`で、EtoAppが`1.6`。EtoAppがClassLibを参照するため`1.6`でないとダメ。小さい方に合わせる必要がある。なのにClassLibは`2.0`のみ対応。よってEtoAppではClassLibを使うことができないと思われる。

## ビルド＆実行できない

　`dotnet run`, `dotnet restore`, `dotnet publish -r linux-arm`などのコマンドでビルドや実行ができない。対象プロジェクトは`EtoApp.Desktop`。

　`EtoApp.Desktop`プロジェクトの環境が`net461`のせいだと思われる。これは.NET Framework 4.6.1である。そしてこれはWindowsのみ対応。これをLinuxでビルドするにはMONOを使う必要があると思われる。

　`dotnet`コマンドにおいて`net461`はWindows上でしかビルドできないのではないか？　だとすると「***Linux上で`dotnet`によるEto.Form開発はできない***」ことになる。もし***LinuxでEto.Form開発したいならMonoDevelopを使う***以外に選択肢はないと思われる。少なくとも私は知らない。

```
========== Build ==========
...
/home/pi/root/lib/.NETCore/2.2.101/sdk/2.2.101/Microsoft.Common.CurrentVersion.targets(1179,5): error MSB3644: The reference assemblies for framework ".NETFramework,Version=v4.6.1" were not found. To resolve this, install the SDK or Targeting Pack for this framework version or retarget your application to a version of the framework for which you have the SDK or Targeting Pack installed. Note that assemblies will be resolved from the Global Assembly Cache (GAC) and will be used in place of reference assemblies. Therefore your assembly may not be correctly targeted for the framework you intend. [/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/EtoApp/EtoApp.Desktop/EtoApp.Desktop.csproj]
```

　MONOでビルドするのが正しいとして、どうやってビルドすればいいのか？

* xbuild
    * https://codeday.me/jp/qa/20181209/59054.html

　ソリューションファイル(`.sln`)が存在するパスへ`cd`して`xbuild`コマンドを実行すると以下のようにエラーとなった。

```
$ xbuild

>>>> xbuild tool is deprecated and will be removed in future updates, use msbuild instead <<<<

XBuild Engine Version 14.0
Mono, Version 5.18.0.240
Copyright (C) 2005-2013 Various Mono authors

Build started 2019/01/31 10:09:18.
__________________________________________________
/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MySln20190131093233.sln:  warning : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/EtoApp/EtoApp/EtoApp.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MySln20190131093233.sln:  warning : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/EtoApp/EtoApp.Desktop/EtoApp.Desktop.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MySln20190131093233.sln:  warning : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MyLib.Test/MyLib.Test.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MySln20190131093233.sln:  warning : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MyLib/MyLib.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
Project "/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MySln20190131093233.sln" (default target(s)):
	Target ValidateSolutionConfiguration:
		Building solution configuration "Debug|Any CPU".
	Target Build:
/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/EtoApp/EtoApp/EtoApp.csproj: error : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/EtoApp/EtoApp/EtoApp.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/EtoApp/EtoApp.Desktop/EtoApp.Desktop.csproj: error : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/EtoApp/EtoApp.Desktop/EtoApp.Desktop.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MyLib.Test/MyLib.Test.csproj: error : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MyLib.Test/MyLib.Test.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MyLib/MyLib.csproj: error : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MyLib/MyLib.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
	Task "MSBuild" execution -- FAILED
	Done building target "Build" in project "/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MySln20190131093233.sln".-- FAILED
Done building project "/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MySln20190131093233.sln".-- FAILED

Build FAILED.

Warnings:

/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MySln20190131093233.sln:  warning : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/EtoApp/EtoApp/EtoApp.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MySln20190131093233.sln:  warning : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/EtoApp/EtoApp.Desktop/EtoApp.Desktop.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MySln20190131093233.sln:  warning : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MyLib.Test/MyLib.Test.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MySln20190131093233.sln:  warning : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MyLib/MyLib.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  

Errors:

/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MySln20190131093233.sln (default targets) ->
(Build target) ->

	/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/EtoApp/EtoApp/EtoApp.csproj: error : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/EtoApp/EtoApp/EtoApp.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
	/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/EtoApp/EtoApp.Desktop/EtoApp.Desktop.csproj: error : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/EtoApp/EtoApp.Desktop/EtoApp.Desktop.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
	/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MyLib.Test/MyLib.Test.csproj: error : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MyLib.Test/MyLib.Test.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  
	/tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MyLib/MyLib.csproj: error : /tmp/work/CSharp.dotnet.new.20190130120000/src/4.Eto/1_Simple/MySln20190131093233/MyLib/MyLib.csproj: The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.  

	 4 Warning(s)
	 4 Error(s)

Time Elapsed 00:00:01.2119980
```

　どうやら`.csproj`に問題があるらしい。

```
The default XML namespace of the project must be the MSBuild XML namespace. If the project is authored in the MSBuild 2003 format, please add xmlns="http://schemas.microsoft.com/developer/msbuild/2003" to the <Project> element. If the project has been authored in the old 1.0 or 1.2 format, please convert it to MSBuild 2003 format.
```

　おそらく`dotnet`コマンドで作成された`.csproj`はVisualStudio20xxやMONOのそれと違うのだろう。どうすればいいのか……。

* https://symfoware.blog.fc2.com/blog-entry-1753.html

　上記URLと`dotnet new etoapp`で出力された`.csproj`を見比べてみる。`etoapp`出力された`.csproj`には`<Project>`要素に`xmlns`属性が設定されていない。また、`<?xml>`も無かった。<br>
　そういえばエラーメッセージに`MSBuild`,`2003`のキーワードがあった。それっぽい。これをコマンド引数で指定できたらいいのだが、できなさそう。`dotnet new etoapp -h`で確認してもそれらしい引数は無かった。

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes" ?>
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003" DefaultTargets="Build">
```

　`.csproj`はVS2017に仕様変更されたらしい。MONOが対応しているのは古い方のみ。`dotnet`では新しい方のみ。今回は`dotnet`で出力した新しい仕様の`.csproj`をMONOでビルドしたためエラーとなった。

* https://ufcpp.net/blog/2017/5/newcsproj/

　新しい`.csproj`はソースファイルひとつひとつを追加・削除せずに済む。何も書かなくても以下のようにディレクトリ配下にある全`.cs`ファイルをビルド対象にしてくれるらしい。つまり`dotnet`の`.csproj`では単純に`.cs`ファイルのみをプロジェクトディレクトリ配下に追加すればビルドしてくれる。<br>
　テンプレートファイル(`.cs`)を自作するとき少し楽になりそう。

```
<Compile Include="**/*.cs" />
```

　仮にこれらができたとしてもEto.Forms関連のDLLファイルが出力されていないし、その依存関係も設定されていない。もうEto.FormsはMonoDevelopでやったほうが早いと思う。こんな苦労してまで`dotnet`でやる必要ない。<br>
　つまり***単体テストまでは`dotnet`で行い、Eto.FormsはMonoDevelopで開発する***。さもなくばテストとGUI開発ができない。開発環境をコロコロ変える必要があり面倒だが他に方法がない。

　おまけ。単一コード`.cs`をビルドするなら`mcs`コマンドを使うらしい。今回は`.sln`, `.csproj`などの単位でビルドすることが要件であるため対象外。

* mcs
    * https://qiita.com/matsuda_sinsuke/items/76068f4c396887459803

