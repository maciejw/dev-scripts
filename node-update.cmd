@echo off

call :download v8 %1
call :download v10 %1
call :download v11 %1

goto:eof

:getfilename
set %1=%~n2
goto:eof

:download 
setlocal
set version=%1
set use=%2
set node_dir=c:\node


set url=https://nodejs.org/dist/latest-%version%.x/

echo searching for %url%

for /f delims^=^"^ tokens^=2 %%I in ('curl --silent %url% ^| findstr /R node-.*-win-x64.zip') do set file=%%I

call :getfilename filename %file%

if not exist %node_dir%\%filename% (
  echo deleting previous version
  for /d %%I in (%node_dir%\node-%version%*) do rd /q /s %%I 
  echo downloading %file%...
  curl --silent -o %file% %url%%file%
  echo extracting...
  unzip -q %file% -d %node_dir%
  del %file%
)
echo @call %node_dir%\%filename%\nodevars.bat >%node_dir%\use-%version%.cmd
if "%use%"=="%version%" (
  echo setting current version as %filename%
  if exist %node_dir%\current rd %node_dir%\current
  mklink /J %node_dir%\current %node_dir%\%filename% 
  echo @call %node_dir%\%filename%\nodevars.bat >%node_dir%\use.cmd
) else (
  echo %version% up to date
)



endlocal
goto:eof
