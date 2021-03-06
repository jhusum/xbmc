@ECHO OFF

SETLOCAL

SET MSYS_INSTALL_PATH="%CD%\msys"
SET MINGW_INSTALL_PATH="%CD%\msys\mingw"

SET CUR_PATH=%CD%
SET APP_PATH=%CD%\..\..
SET TMP_PATH=%CD%\scripts\tmp

rem can't run rmdir and md back to back. access denied error otherwise.
IF EXIST %MSYS_INSTALL_PATH% rmdir %MSYS_INSTALL_PATH% /S /Q
IF EXIST %TMP_PATH% rmdir %TMP_PATH% /S /Q

IF $%1$ == $$ (
  SET DL_PATH="%CD%\downloads2"
) ELSE (
  SET DL_PATH="%1"
)

SET WGET=%CUR_PATH%\bin\wget
SET ZIP=%CUR_PATH%\..\Win32BuildSetup\tools\7z\7za

IF NOT EXIST %DL_PATH% md %DL_PATH%

IF NOT EXIST %MSYS_INSTALL_PATH% md %MSYS_INSTALL_PATH%
IF NOT EXIST %MINGW_INSTALL_PATH% md %MINGW_INSTALL_PATH%
IF NOT EXIST %TMP_PATH% md %TMP_PATH%

cd scripts

CALL get_msys_env.bat
IF EXIST %TMP_PATH% rmdir %TMP_PATH% /S /Q
CALL get_mingw_env.bat

cd %CUR_PATH%

rem update fstab to install path
SET FSTAB=%MINGW_INSTALL_PATH%
SET FSTAB=%FSTAB:\=/%
SET FSTAB=%FSTAB:"=%
ECHO %FSTAB% /mingw>>"%MSYS_INSTALL_PATH%\etc\fstab"
SET FSTAB=%APP_PATH%
SET FSTAB=%FSTAB:\=/%
SET FSTAB=%FSTAB:"=%
ECHO %FSTAB% /xbmc>>"%MSYS_INSTALL_PATH%\etc\fstab"

rem insert call to vsvars32.bat in msys.bat
cd %MSYS_INSTALL_PATH%
Move msys.bat msys.bat_dist
ECHO CALL "%VS120COMNTOOLS%vsvars32.bat">>msys.bat
TYPE msys.bat_dist>>msys.bat

cd %CUR_PATH%

IF EXIST %TMP_PATH% rmdir %TMP_PATH% /S /Q
