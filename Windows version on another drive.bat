@ECHO OFF
CHCP 65001>NUL
net sess>NUL 2>&1||(powershell try{saps '%0'-Verb RunAs}catch{}&exit)

ECHO.
set /p "disk=Enter disk:"
cls
if "%disk%" == "c" goto CDrive

ECHO.&ECHO REG LOAD..&ECHO.
REG UNLOAD HKLM\%disk%                                        2>nul >nul
REG LOAD HKLM\%disk% %disk%:\Windows\System32\config\SOFTWARE 2>nul >nul
REG LOAD HKLM\%disk%2 %disk%:\Windows\System32\config\SYSTEM  2>nul >nul
cls
FOR /F "tokens=4,5" %%I in ('reg query "HKLM\%disk%2\CurrentControlSet\Services\Tcpip\Parameters" /v "NV Hostname"')                    Do set "Hostname=%%I %%J"
FOR /F "tokens=4,5" %%I in ('reg query "HKLM\%disk%2\CurrentControlSet\Services\Tcpip\Parameters" /v "NV Domain"')                      Do set "Domain=%%I %%J"
FOR /F "tokens=3,4" %%I in ('reg query "HKLM\%disk%\Microsoft\Windows NT\CurrentVersion" /v ProductName')                               Do set "ProductName=%%I %%J"
FOR /F "tokens=3,4" %%I in ('reg query "HKLM\%disk%\Microsoft\Windows NT\CurrentVersion" /v EditionID')                                 Do set "EditionID=%%I %%J"
FOR /F "tokens=3,4" %%I in ('reg query "HKLM\%disk%\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild')                              Do set "CurrentBuild=%%I %%J"
FOR /F "tokens=3,4" %%I in ('reg query "HKLM\%disk%2\CurrentControlSet\Control\Session Manager\Environment" /v Processor_architecture') Do if [%%I]==[AMD64] ( set "architecture=x64" ) ELSE ( set "architecture=x32" )
ECHO.&ECHO REG UNLOAD..&ECHO.
REG UNLOAD HKLM\%disk%  2>nul >nul
REG UNLOAD HKLM\%disk%2 2>nul >nul
cls
ECHO.&ECHO HOSTNAME: %Hostname% 
ECHO DOMAIN: %Domain%
ECHO OS: %ProductName% %EditionID%%CurrentBuild%%architecture% &ECHO.
PAUSE&EXIT

:CDrive
FOR /F "tokens=4,5" %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NV Hostname"')                    Do set "Hostname=%%I %%J"
FOR /F "tokens=4,5" %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NV Domain"')                      Do set "Domain=%%I %%J"
FOR /F "tokens=3,4" %%I in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName')                            Do set "ProductName=%%I %%J"
FOR /F "tokens=3,4" %%I in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID')                              Do set "EditionID=%%I %%J"
FOR /F "tokens=3,4" %%I in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild')                           Do set "CurrentBuild=%%I %%J"
FOR /F "tokens=3,4" %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Processor_architecture') Do if [%%I]==[AMD64] ( set "architecture=x64" ) ELSE ( set "architecture=x32" )
ECHO.&ECHO HOSTNAME: %Hostname% 
ECHO DOMAIN: %Domain%
ECHO OS: %ProductName% %EditionID%%CurrentBuild%%architecture% &ECHO.
PAUSE&EXIT