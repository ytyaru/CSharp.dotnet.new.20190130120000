# 構造

* ソリューション
    * クラスライブラリ(`Standard`)
    * テスト(`Core`)
    * ASP.NET(`Core`)

　未調査。

# 種類

　`dotnet new -h`で確認したところ以下の通り。
                       
Razor Page                                        page               [C#]              Web/ASP.NET                          
MVC ViewImports                                   viewimports        [C#]              Web/ASP.NET                          
MVC ViewStart                                     viewstart          [C#]              Web/ASP.NET                          
ASP.NET Core Empty                                web                [C#], F#          Web/Empty                            
ASP.NET Core Web App (Model-View-Controller)      mvc                [C#], F#          Web/MVC                              
ASP.NET Core Web App                              webapp             [C#]              Web/MVC/Razor Pages                  
ASP.NET Core with Angular                         angular            [C#]              Web/MVC/SPA                          
ASP.NET Core with React.js                        react              [C#]              Web/MVC/SPA                          
ASP.NET Core with React.js and Redux              reactredux         [C#]              Web/MVC/SPA                          
Razor Class Library                               razorclasslib      [C#]              Web/Razor/Library/Razor Class Library
ASP.NET Core Web API                              webapi             [C#], F#          Web/WebAPI                           

# Framework

　AngularとReact.jsの違い。

* https://employment.en-japan.com/engineerhub/entry/2018/04/13/110000

F/W|方針
---|----
Angluar|Angularが公式で提供しているものを使えば、安心してアプリケーションを作れる
React.js|Facebook社が提供しているフレームワーク。自分たちがプロダクトで使うもの以外はメンテナンスしない方針

　Angularのほうが良さそう。

## Angular

* https://docs.microsoft.com/ja-jp/aspnet/core/client-side/spa/angular?view=aspnetcore-2.2&tabs=visual-studio

## React 

* https://docs.microsoft.com/ja-jp/aspnet/core/client-side/spa/react?view=aspnetcore-2.2&tabs=visual-studio

# Node.js必須

　実行したところビルドエラーになった。

```bash
$ cd MySln20190131084255/AngularApp
$ dotnet run
```

　Node.jsのインストールが必要らしい。

```
/tmp/work/CSharp.dotnet.new.20190130120000/src/3_ASP.NET/angular/MySln20190131084255/AngularApp/AngularApp.csproj(33,5): warning MSB3073: The command "node --version" exited with code 127.
/tmp/work/CSharp.dotnet.new.20190130120000/src/3_ASP.NET/angular/MySln20190131084255/AngularApp/AngularApp.csproj(36,5): error : Node.js is required to build and run this project. To continue, please install Node.js from https://nodejs.org/, and then restart your command prompt or IDE.

The build failed. Please fix the build errors and run again.
```

　dotnetだけで完結できない。やめた。

