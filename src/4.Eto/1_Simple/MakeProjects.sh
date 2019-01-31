InstallTemplate() {
    # 0. Eto.Forms用プロジェクトテンプレートをインストールする
    dotnet new -i "Eto.Forms.Templates::*"
}
MakeProject() {
    # 1. プロジェクト作成
    TimeStamp=`date +%Y%m%d%H%M%S`
    SlnName=MySln${TimeStamp}
    mkdir "${SlnName}"
    cd "${SlnName}"
    dotnet new sln -n "${SlnName}"
    LibName=MyLib
    dotnet new classlib -n "${LibName}" -f netstandard2.0
    TestName=${LibName}.Test
    dotnet new nunit -n "${TestName}"
    AppName=EtoApp
    dotnet new etoapp -n "${AppName}"

    # 2. ソリューションにプロジェクトを追加する
    dotnet sln add "${AppName}/${AppName}.Desktop/${AppName}.Desktop.csproj"
    dotnet sln add "${AppName}/${AppName}/${AppName}.csproj"
    dotnet sln add "${AppName}/${AppName}.csproj"
    dotnet sln add "${TestName}/${TestName}.csproj"
    dotnet sln add "${LibName}/${LibName}.csproj"

    # 3. プロジェクトの参照を設定する
    cd "${TestName}"
    dotnet add reference "../${LibName}/${LibName}.csproj"
    cd ..
    cd "${AppName}/${AppName}"
    dotnet add reference "../../${LibName}/${LibName}.csproj"
    cd ../..
}
RunTest() {
    # 4. テスト実行
#    dotnet test "${TestName}/${TestName}.csproj"
#    cd ${AppName}
    cd "${AppName}/${AppName}.Desktop"
    dotnet run
    cd ..
}
Build() {
    dotnet restore
    dotnet publish -r linux-arm
    "${AppName}/bin/Debug/netcoreapp2.2/linux-arm/${AppName}"
}
#echo "========== Install template =========="
#time InstallTemplate
echo "========== Make projects =========="
time MakeProject
echo "========== Run tests =========="
time RunTest
echo "========== Build =========="
time Build

