@echo off
Title CatsSoft-CCleaner-Update
color 0B
mode con:cols=90 lines=26
echo.
echo --------------------------------------------------------------------------------- >> CatsSoft-CCleaner-Update.txt
echo Check For Updates >> CatsSoft-CCleaner-Update.txt
echo. |time |find "current" >> CatsSoft-CCleaner-Update.txt
echo %date% >> CatsSoft-CCleaner-Update.txt
echo --------------------------------------------------------------------------------- >> CatsSoft-CCleaner-Update.txt
echo.
SET "BinDir=%~dp0Bin"
SET "ZIPDir=%~dp0Bin\7-zip"
SET "TempDir=%TEMP%\7-zip"
set installdir=ccsetup
if exist "%BinDir%" (
 goto menu
) else (
 MD "%BinDir%"
 MD "%ZIPDir%"
 MD "%TempDir%"
 goto menu
)
goto menu
goto :eof
:: /*************************************************************************************/
:: Menu of tool.
:: void menu();
:: /*************************************************************************************/
:menu
    @cls
    Title CatsSoft-CCleaner-Update
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.    -----------------------------------
    echo.      ===  Welcome to main menu! ===   
    echo.    -----------------------------------
    echo.                                       
    echo.    [1] Type "1" and uninstall old version of CCleaner.
    echo.
    echo.    [2] Type "2" and download new version of CCleaner. 
    echo.
    echo.    [2] Type "3" and clean the computer with cleaner. 
    echo.
    echo.    [0] Type "0" and close this tool.
    echo.
    echo.

    set /P "option=Type 1, 2, 3 or 0 then press ENTER: "

    if %option% EQU 0 (
       goto close
    ) else if %option% EQU 1 (
       goto uninstall
    ) else if %option% EQU 2 (
       goto download
    ) else if %option% EQU 3 (
       goto autoclean
    ) else (
    echo.
    echo.Invalid option.
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo.Press any key to return to the menu. . .
    echo.
    pause>nul
    goto menu
    )
    goto menu
goto :eof
cls
:: /*************************************************************************************/
:: uninstall CCleaner.
:: void uninstall();
:: /*************************************************************************************/
:uninstall
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo Uninstall CCleaner...
    echo.
    if %processor_architecture%==x86 ( 
      if exist "%ProgramFiles%\CCleaner\CCleaner.exe" (
        taskkill /F /IM "CCleaner.exe"
        taskkill /F /IM "CCUpdate.exe"
        start /d "%ProgramFiles%\CCleaner" uninst.exe /S
        echo Uninstall Done.
        goto close_uninstaller
       )
    ) else (
      if exist "%ProgramFiles%\CCleaner\CCleaner64.exe" (
        taskkill /F /IM "CCleaner64.exe"
        taskkill /F /IM "CCUpdate.exe"
        start /d "%ProgramFiles%\CCleaner" uninst.exe /S
        echo Uninstall Done.
        goto close_uninstaller
       )
    )
    :close_uninstaller
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo.Press any key to return to the menu. . .
    echo.
    pause>nul
    goto menu
goto :eof
cls
:: /*************************************************************************************/
:: Download CCleaner.
:: void Download();
:: /*************************************************************************************/
:Download
    @cls
    Title CatsSoft-CCleaner-Downloader
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.    -----------------------------------
    echo.      ===  Welcome to main menu! ===   
    echo.    -----------------------------------
    echo.                                       
    echo.    [1] Type "1" and download CCleaner standard version.
    echo.
    echo.    [2] Type "2" and download CCleaner portable version. 
    echo.
    echo.    [0] Type "0" and close this tool.
    echo.
    echo.

    set /P "option=Type 1, 2, or 0 then press ENTER: "

    if %option% EQU 0 (
       goto menu
    ) else if %option% EQU 1 (
       goto standard
    ) else if %option% EQU 2 (
       goto portable
    ) else (
    echo.
    echo.Invalid option.
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo.Press any key to return to the menu. . .
    echo.
    pause>nul
    goto Download
    )
    goto Download
goto :eof
cls
:: /*************************************************************************************/
:: Download CCleaner standard version.
:: void Standard();
:: /*************************************************************************************/
:Standard
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    if %processor_architecture%==x86 ( 
      if exist "%BinDir%\wget.exe" (
       goto ccstandard
      ) else (
        bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/32/wget.exe" "%BinDir%\wget.exe"
       goto ccstandard
      )
    ) else (
      if exist "%BinDir%\wget.exe" (
       goto ccstandard
      ) else (
       bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/64/wget.exe" "%BinDir%\wget.exe"
       goto ccstandard
      )
    )
    :ccstandard
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo Check for updates 
    echo.
    cd /d "%~dp0"
    bin\wget --no-check-certificate --content-disposition -N -S "https://www.ccleaner.com/ccleaner/download/standard"
    echo.
    for /f "tokens=2delims=<>    " %%a in ('type standard ^|find "data-download-url"') do set "URL=%%a"
    echo URL: %URL%
    echo.
    for /F "delims=" %%a in ('findstr /I "data-download-url" standard') do set "URL=%%a"
    echo.
    echo stage 2, downloading the standard installer
    REM bin\wget --no-check-certificate -nc %URL:~65,43%
    echo.
    set "URL=%URL:	=%"
    REM echo."%URL%"
    echo URL: %URL:~63,44% >>  CatsSoft-CCleaner-Update.txt
    set "URL=%URL:~63,44%"
    echo.
    for %%g in ("%URL%") do set "File=%%~nxg"
    echo File: %File% >>  CatsSoft-CCleaner-Update.txt
    echo.
    FOR /F "tokens=1,2,3,4,5 delims=/" %%A IN ("%URL%") DO set "Domain=%%B"
    echo Domain: %Domain% >> CatsSoft-CCleaner-Update.txt
    echo.
    FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\CCleaner" /v DisplayVersion`) DO (
        set DisplayVersion=%%A
    )
    for /f "tokens=1,2 delims=. " %%A in ("%DisplayVersion%") do set "DisplayVersion=%%A%%B"
    echo Current Version: %DisplayVersion% >> CatsSoft-CCleaner-Update.txt
    echo.
    for /f "tokens=1,2,3,4,5delims=ccsetup." %%F in ("%File%") do set "NewVersion=%%F"
    echo New Version: %NewVersion% >> CatsSoft-CCleaner-Update.txt
    echo.
    for %%f in ("%~dp0ccsetup*.exe") do (
     set cver=%%~nf
    )
    if not exist "%~dp0%cver%.exe" ( set cver=none )
    echo.
    REM [DEBUG]
    echo current install is %cver%
    echo.
    echo Checking server for updates . . .
    echo.
    bin\wget.exe --continue --show-progress --no-check-certificate "%URL%" -O "%~dp0%File%"
    if %errorlevel%==1 exit 1
    if exist "%~dp0%File%" (
      echo The files "%File%" has been sucessfully downloaded!
      goto install_standard
    ) else (
      echo The files "%File%" could not be downloaded! Try again later.
      goto Close_down_standard
    )
    :install_standard
    for /f "skip=1 eol=: delims=" %%F in ('dir /b /o-d "%~dp0ccsetup*.exe"') do @del "%%F"
    for %%f in ("%~dp0ccsetup*.exe") do (
    if %%~nf==%cver% (
     echo.
     echo CCleaner is already up to date [%%~nf]
     echo.
    ) else (
     echo.
     echo A newer version of CCleaner was found [%cver% --^> %%~nf]
     echo.
     echo Installing . . .
     echo.
     REM [DEBUG] comment this for debugging
     %%~ff /S
     echo.
     echo complete!
     echo.
     )
     echo.
     if %processor_architecture%==x86 ( 
       if exist "%ProgramFiles%\CCleaner\CCleaner.exe" (
         echo CCleaner has been successfully installed!
       ) else ( 
         echo CCleaner installation was failed!
       )
     ) else (
        if exist "%ProgramFiles%\CCleaner\ccleaner64.exe" (
         echo CCleaner has been successfully installed!
       ) else ( 
         echo CCleaner installation was failed!
       )
     )
    )
    REM echo.
    :Close_down_standard
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo.Press any key to return to the menu. . .
    echo.
    pause>nul
    goto menu
goto :eof
cls
:: /*************************************************************************************/
:: Download CCleaner portable version.
:: void portable();
:: /*************************************************************************************/
:portable
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    cd /d "%~dp0"
    for %%f in ("%~dp07z*.msi") do (
	set cver=%%~nf
    )

    if not exist "%~dp0%cver%.msi" ( set cver=none )

    echo Checking server for updates . . .
    echo.

    if %processor_architecture%==x86 ( 
      if exist "%~dp0bin\7-zip\7z.exe" (
        goto :next
      ) else (
        bitsadmin /transfer wcb /priority high "https://www.7-zip.org/a/7z1801.msi" "%~dp07z1801.msi"
        goto :next
      )
    ) else (
      if exist "%~dp0bin\7-zip\7z.exe" (
        goto :next
      ) else (
        bitsadmin /transfer wcb /priority high "https://www.7-zip.org/a/7z1801-x64.msi" "%~dp07z1801-x64.msi"
        goto :next
      )
    )
    :next
    echo.
    for /f "skip=1 eol=: delims=" %%F in ('dir /b /o-d "%~dp07z*.msi"') do @del "%%F"
    for %%f in ("%~dp07z*.msi") do (
	if %%~nf==%cver% (
		echo 7z is already up to date [%%~nf]
	) else (
		echo A newer version of 7z was found [%cver% --^> %%~nf]
		echo Installing . . .

		msiexec.exe /EXTRACTMSI:"%TEMP%\7-zip" "%%~ff"
		msiexec.exe /a "%%~ff" TARGETDIR="%TEMP%\7-zip" /qn /norestart

		Xcopy "%TEMP%\7-zip\Files\7-Zip\*.*" /s /e /f "%~dp0Bin\7-zip\"

		RD "%TEMP%\7-zip"
		echo Finished
	)
    )
    echo.
    if %processor_architecture%==x86 ( 
      if exist "%BinDir%\wget.exe" (
       goto ccportable
      ) else (
        bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/32/wget.exe" "%BinDir%\wget.exe"
       goto ccportable
      )
    ) else (
      if exist "%BinDir%\wget.exe" (
       goto ccportable
      ) else ( 
        bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/64/wget.exe" "%BinDir%\wget.exe"
        goto ccportable
       )
    )
    :ccportable
    echo.
    echo Check for updates 
    echo.
    for %%f in ("%~dp0ccsetup*.zip") do (
	set cver=%%~nf
    )
    if not exist "%~dp0%cver%.zip" ( set cver=none )
    echo.
    echo Checking server for updates . . .
    echo.
    "%~dp0bin\wget" --continue --show-progress --no-check-certificate -nc --content-disposition "https://www.ccleaner.com/ccleaner/download/portable/downloadfile"
    REM if %errorlevel%==1 exit 1
    if %errorlevel%==1 (
	echo.
	echo ccleaner could not update
	pause>nul
	goto :menu
    )
    for /f "skip=1 eol=: delims=" %%F in ('dir /b /o-d "%~dp0ccsetup*.zip"') do @del "%%F"
    for %%f in ("%~dp0ccsetup*.zip") do (
	if %%~nf==%cver% (
	    echo CCleaner is already up to date [%%~nf]
	) else (
	    echo A newer version of CCleaner was found [%cver% --^> %%~nf]
	    echo Installing . . .
	    "%ZIPDir%\7z.exe" x -o"%installdir%" -y "%%~ff"
            echo. 
            echo complete!
            echo.
     	)
     )
     echo.
     echo Check if CCleaner is installed correctly ...
     echo.
     if %processor_architecture%==x86 ( 
       if exist "%installdir%\CCleaner.exe" (
         echo CCleaner has been successfully installed!
       ) else ( 
         echo CCleaner installation was failed!
       )
     ) else (
        if exist "%installdir%\ccleaner64.exe" (
         echo CCleaner has been successfully installed!
       ) else ( 
         echo CCleaner installation was failed!
       )
     )
    REM echo.
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo.Press any key to return to the menu. . .
    echo.
    pause>nul
    goto menu
goto :eof
cls
:: /*************************************************************************************/
:: Autoclean.
:: void autoclean();
:: /*************************************************************************************/
:autoclean
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo Automatic cleaning...
    echo.
    if exist "%ProgramFiles%\CCleaner\ccleaner.exe" (
      if exist "%ProgramFiles%\CCleaner\ccleaner.exe" (
        start /d "%ProgramFiles%\CCleaner" CCleaner.exe /AUTO
      ) else (
        start /d "%ProgramFiles%\CCleaner" ccleaner64.exe /AUTO
      )
    ) else (
      if exist "%~dp0%installdir%\ccleaner.exe" (
       start "%~dp0%installdir%\ccleaner.exe" /AUTO
       ) else ( 
       start "%~dp0%installdir%\ccleaner64.exe" /AUTO
      )
    )
    echo.
    echo complete!
    echo.
    :Close_clean
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo.Press any key to return to the menu. . .
    echo.
    pause>nul
    goto menu
goto :eof
cls
:: /*************************************************************************************/
:: End tool.
:: void close();
:: /*************************************************************************************/
:close
goto :eof
exit