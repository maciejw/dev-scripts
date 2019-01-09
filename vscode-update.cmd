@echo off
setlocal
set version=latest
set channel=stable
set outdir=%~dp0vscode\

set url=https://update.code.visualstudio.com/%version%/win32-x64-archive/%channel%

for /f "tokens=2" %%I in ('curl --silent %url% -I ^| grep -Fi Location') do set url=%%I

call :getfilename folder %url%

set file=%folder%.zip

if not exist %outdir% md %outdir%

pushd %outdir%
if not exist %folder% (
  echo downloading %file%...
  curl --silent --remote-name --remote-header-name %url%
  echo extracting...
  unzip -q %file% -d %folder%
  del %file%
  echo @call %outdir%%folder%\bin\code.cmd %%*> %outdir%code.cmd
) else (
  echo up to date
)
popd

endlocal
goto:eof


:getfilename
set %1=%~n2
goto:eof
