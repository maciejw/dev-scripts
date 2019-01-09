@echo off
setlocal
call :checkDriveLetter

if "%drive%"=="" net use * http://live.sysinternals.com/Tools

call :checkDriveLetter
set targetDirectory=c:\Tools

if not exist %targetDirectory% md %targetDirectory%

xcopy %drive%\*.* %targetDirectory% /d /y /c

net use %drive% /delete
endlocal
goto:eof

:checkDriveLetter
for /F "tokens=1,*" %%I in ('net use^|findstr \\\\live.sysinternals.com\\Tools') do set drive=%%I
goto:eof