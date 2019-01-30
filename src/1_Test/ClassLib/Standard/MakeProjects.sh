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

    # 2. ソリューションにプロジェクトを追加する
    dotnet sln add "${LibName}/${LibName}.csproj"
    dotnet sln add "${TestName}/${TestName}.csproj"

    # 3. プロジェクトの参照を設定する
    cd ${TestName}
    dotnet add reference "../${LibName}/${LibName}.csproj"
    cd ..
}
RunTest() {
    # 4. テスト実行
    dotnet test "${TestName}/${TestName}.csproj"
}
echo "========== Make projects =========="
time MakeProject
echo "========== Run tests =========="
time RunTest

