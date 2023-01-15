
@echo off
if exist "C:\Windows\System32\psexec.exe" (
echo PSTools is already installed in your computer can continue...
goto :install
) else (
goto :choice
)

REM Check if PSTOOLS install in host computer , if not ask for

:choice
set /P c=You dont have PStools installed on your computer cant continue without this , you wish to install PStools [Y/N] ?
if /I "%c%" EQU "Y" goto :yes
if /I "%c%" EQU "N" goto :no
goto :choice

:no
echo You dont have PStools cant continue...program will close...
pause
exit

:yes


echo Install PStools to your computer from Support Folder
@echo off
COPY "\\rKv-files\COMPUTER-PUB$\Support\PSTools" "C:\Windows\System32"
echo Done 
echo Running again after install....Please Wait...

:install

@echo off
set /P PCNAME="Please enter the pc that you want to sync the clock :"

echo Please Accept the terms and conditions (only in first time)

psexec \\%PCNAME% -s net start w32time
psexec \\%PCNAME% -s sc config w32time start= auto
psexec \\%PCNAME% -s net time \\RKV-DC2012H /set /yes

pause
exit


echo DONE! Check if command successful

