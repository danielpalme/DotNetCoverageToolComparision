rmdir /q /s target
mkdir target

set "opencover=%UserProfile%\.nuget\packages\opencover\4.6.519\tools\OpenCover.Console.exe"
set "reportgenerator=%UserProfile%\.nuget\packages\reportgenerator\3.1.2\tools\ReportGenerator.exe"
set "xunit=%UserProfile%\.nuget\packages\xunit.runner.console\2.4.0\tools\net452\xunit.console.exe"
set "dotnet=C:\Program Files\dotnet\dotnet.exe"


::%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% .NET 4.7 - OpenCover %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msbuild .\CoverageDemo.sln /v:m /t:Clean
rmdir /q /s BusinessTest_NetCore2\bin
rmdir /q /s BusinessTest_NetCore2\obj
msbuild .\CoverageDemo.sln /v:m /t:Restore
msbuild .\CoverageDemo.sln /v:m /t:Rebuild

set "targetdir=target\Net47_OpenCover"
mkdir %targetdir%

"%opencover%" -register:user "-target:%xunit%" -targetargs:"BusinessTest_Net47\bin\Debug\BusinessTest_Net47.dll -noshadow -xml %targetdir%\xunit.xml" -output:%targetdir%\coverage.xml -returntargetcode -coverbytest:* -mergebyhash

"%reportGenerator%" -reports:%targetdir%\coverage.xml -reporttypes:HtmlInline -targetdir:%targetdir%

::%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% .NET Core 2.0 - OpenCover %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msbuild .\CoverageDemo.sln /v:m /t:Clean
rmdir /q /s BusinessTest_NetCore2\bin
rmdir /q /s BusinessTest_NetCore2\obj
msbuild .\CoverageDemo.sln /v:m /t:Restore
msbuild .\CoverageDemo.sln /v:m /t:Rebuild

set "targetdir=target\NetCore2_OpenCover"
mkdir %targetdir%

"%opencover%" -register:user "-target:%dotnet%" -targetargs:"test BusinessTest_NetCore2\BusinessTest_NetCore2.csproj" -output:%targetdir%\coverage.xml -returntargetcode -coverbytest:* -mergebyhash -oldstyle

"%reportGenerator%" -reports:%targetdir%\coverage.xml -reporttypes:HtmlInline -targetdir:%targetdir%

::%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% .NET Core 2.0 - Coverlet %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msbuild .\CoverageDemo.sln /v:m /t:Clean
rmdir /q /s BusinessTest_NetCore2\bin
rmdir /q /s BusinessTest_NetCore2\obj
msbuild .\CoverageDemo.sln /v:m /t:Restore
msbuild .\CoverageDemo.sln /v:m /t:Rebuild

set "targetdir=target\NetCore2_Coverlet"
mkdir %targetdir%

"%dotnet%" test --no-build /p:CollectCoverage=true /p:CoverletOutputFormat=opencover /p:CoverletOutput=..\%targetdir%\ BusinessTest_NetCore2\BusinessTest_NetCore2.csproj
"%dotnet%" test --no-build /p:CollectCoverage=true /p:CoverletOutputFormat=cobertura /p:CoverletOutput=..\%targetdir%\ BusinessTest_NetCore2\BusinessTest_NetCore2.csproj

"%reportGenerator%" -reports:%targetdir%\coverage.opencover.xml -reporttypes:HtmlInline -targetdir:%targetdir%

::%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% .NET Core 2.0 - AltCover %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msbuild .\CoverageDemo.sln /v:m /t:Clean
rmdir /q /s BusinessTest_NetCore2\bin
rmdir /q /s BusinessTest_NetCore2\obj
msbuild .\CoverageDemo.sln /v:m /t:Restore
msbuild .\CoverageDemo.sln /v:m /t:Rebuild

set "targetdir=target\NetCore2_AltCover"
mkdir %targetdir%

"%dotnet%" test --no-build /p:AltCover=true /p:AltCoverXmlReport=..\%targetdir%\coverage.opencover.xml /p:AltCoverCobertura=..\%targetdir%\coverage.cobertura.xml BusinessTest_NetCore2\BusinessTest_NetCore2.csproj

"%reportGenerator%" -reports:%targetdir%\coverage.opencover.xml -reporttypes:HtmlInline -targetdir:%targetdir%