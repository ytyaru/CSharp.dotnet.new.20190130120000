MakeProject() {
    # 1. プロジェクト作成
    TimeStamp=`date +%Y%m%d%H%M%S`
    SlnName="MySln${TimeStamp}"
    mkdir "${SlnName}"
    cd "${SlnName}"
    dotnet new sln -n "${SlnName}"
    LibName=MyLib
    dotnet new classlib -n "${LibName}"
    TestName=${LibName}.Test
    dotnet new nunit -n "${TestName}"
    AppName=AngularApp
    dotnet new angular -n "${AppName}"

    # 2. ソリューションにプロジェクトを追加する
    #    先頭プロジェクトがスタートアップする
    dotnet sln add "${AppName}/${AppName}.csproj"
    dotnet sln add "${TestName}/${TestName}.csproj"
    dotnet sln add "${LibName}/${LibName}.csproj"

    # 3. プロジェクトの参照を設定する
    cd "${TestName}"
    dotnet add reference "../${LibName}/${LibName}.csproj"
    cd ..
    cd "${AppName}"
    dotnet add reference "../${LibName}/${LibName}.csproj"
    cd ..
}
RunTest() {
    # 4. 実行
#    dotnet test "${TestName}/${TestName}.csproj"
    cd "${AppName}"
    dotnet run
#    npm run ng test
    cd ..
}
#Build() {
#    dotnet restore
#    dotnet publish -r linux-arm
#    "${AppName}/bin/Debug/netcoreapp2.2/linux-arm/${AppName}"
#}
echo "========== Make projects =========="
time MakeProject
echo "========== Run =========="
time RunTest
#echo "========== Build =========="
#time Build

