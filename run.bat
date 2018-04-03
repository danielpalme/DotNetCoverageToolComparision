rmdir /q /s target
mkdir target

set "opencover=%UserProfile%\.nuget\packages\opencover\4.6.519\tools\OpenCover.Console.exe"
set "reportgenerator=%UserProfile%\.nuget\packages\reportgenerator\3.1.2\tools\ReportGenerator.exe"
set "xunit=%UserProfile%\.nuget\packages\xunit.runner.console\2.3.1\tools\net452\xunit.console.exe"
set "altcover=%UserProfile%\.nuget\packages\altcover\3.0.388\tools\netcoreapp2.0\AltCover.dll"
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

"%dotnet%" test --no-build /p:CollectCoverage=true /p:CoverletOutputFormat=opencover /p:CoverletOutputDirectory=..\%targetdir% BusinessTest_NetCore2\BusinessTest_NetCore2.csproj

"%reportGenerator%" -reports:%targetdir%\coverage.xml -reporttypes:HtmlInline -targetdir:%targetdir%

::%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% .NET Core 2.0 - AltCover %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msbuild .\CoverageDemo.sln /v:m /t:Clean
rmdir /q /s BusinessTest_NetCore2\bin
rmdir /q /s BusinessTest_NetCore2\obj
msbuild .\CoverageDemo.sln /v:m /t:Restore
msbuild .\CoverageDemo.sln /v:m /t:Rebuild

set "targetdir=target\NetCore2_AltCover"
mkdir %targetdir%

::Instrument
"%dotnet%" "%altcover%" /i=BusinessTest_NetCore2\bin\Debug\netcoreapp2.0 /o=BusinessTest_NetCore2\bin\Debug\netcoreapp2.0\instrumented -x=%targetdir%\coverage.xml --opencover

::Copy the instrumented libraries back over the originals
xcopy /s /y BusinessTest_NetCore2\bin\Debug\netcoreapp2.0\instrumented BusinessTest_NetCore2\bin\Debug\netcoreapp2.0

::Execute tests
"%dotnet%" test --no-build BusinessTest_NetCore2\BusinessTest_NetCore2.csproj

"%reportGenerator%" -reports:%targetdir%\coverage.xml -reporttypes:HtmlInline -targetdir:%targetdir%