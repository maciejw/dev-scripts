@echo off
setlocal
call :set-new-port
call :set-ip

set _path=%~1
echo Press Q to quit...
echo start browse http://localhost:%port%/
 
"C:\Program Files (x86)\IIS Express\appcmd.exe" set config -section:system.applicationHost/sites /+[name='WebSite%port%',id='%port%'] /+[name='WebSite%port%',id='%port%'].bindings.[protocol='http',bindingInformation=':%port%:'] /+[name='WebSite%port%',id='%port%'].[path='/'] /+[name='WebSite%port%',id='%port%'].[path='/'].[path='/'] /[name='WebSite%port%',id='%port%'].[path='/'].[path='/'].physicalPath:%_path%
"C:\Program Files (x86)\IIS Express\iisexpress.exe" /siteid:%port%
"C:\Program Files (x86)\IIS Express\appcmd.exe" set config -section:system.applicationHost/sites /-[name='WebSite%port%',id='%port%']
 

endlocal
goto:eof

:set-ip
for /f "tokens=4 delims=: "  %%i in ('ping %COMPUTERNAME% /4 /n 1^|findstr /r "Ping.statistics.for"') do set ip=%%i

goto:eof


:set-new-port
::ports from 49152 to 65535

SET /a port=49152+%RANDOM%*16383/32768+1
netstat /an|findstr /i 0.0.0.0:0|findstr /r "\<%port%\>"
if %ERRORLEVEL%==0 call :set-new-port 
goto:eof




