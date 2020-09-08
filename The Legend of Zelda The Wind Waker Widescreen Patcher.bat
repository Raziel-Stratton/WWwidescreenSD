@echo off

set originalISO=%~1




	:: First, ensure a file was provided to the script.

if NOT "%originalISO%"=="" goto :sourceProvided

echo.
echo  To use this, drag-and-drop your Vanilla The Legend of Zelda The Wind Waker USA ISO onto the batch file.
echo.
echo  (That is, the actual file icon in the folder, not this window.)
echo. 
echo  Press any key to exit. . . && pause > nul

goto eof



	:: Confirm that the CertUtil utility (to perform the hash check) exists on the system.

:sourceProvided

where CertUtil >nul 2>nul

if %ERRORLEVEL%==0 goto :validateHash

set certUtilExists=false

echo.
echo  The hash checking utility (CertUtil) was not found installed on your system.
echo  You can still skip the hash check and force the build anyway, if you'd like,
echo  by pressing any key. (Or click the window's close button to cancel.)

pause > nul
goto :buildISO



	:: Verify that the given file is a vanilla US copy of The Legend of Zelda The Wind Waker

:validateHash

set certUtilExists=true

echo.
echo  Verifying that the given file is a vanilla US copy of The Legend of Zelda The Wind Waker.
echo.
echo        This will take a few moments....

for /F "skip=1 delims=*" %%i in ('certutil -hashfile "%originalISO%" MD5') do (
    if "%%i"=="?d8 e4 d4 5a f2 03 2a 08 1a 0f 44 63 84 e9 26 1b" goto :validISO
)

echo.
echo  The file provided doesn't appear to be a vanilla US copy of The Legend of Zelda The Wind Waker.
echo  You can ignore this and build the new ISO anyway, but there's a fairly
echo  good chance you'll run into problems.
echo.
set /p continue=- Would you like to build a new ISO anyway? (y/n): 

if %continue%==n goto eof
if %continue%==no goto eof
goto :buildISO



	:: The ISO has been verified, or the user has chosen to proceed anyway.

:validISO

echo. && echo.
echo        The ISO has been verified!

:buildISO

echo.
echo  Constructing the The Legend of Zelda The Wind Waker Widescreen ISO. Please stand by....

cd /d %~dp0

xdelta.exe -d -s "%originalISO%" "TWWWide.xdelta" "The Legend of Zelda The Wind Waker Widescreen.iso"

echo. && echo.
echo        Construction complete!
echo.
echo  Press any key to exit. . . && pause > nul
:eof