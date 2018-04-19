@echo off
Title CatsSoft-Recuva-Update
color 0B
mode con:cols=90 lines=26
echo.
echo --------------------------------------------------------------------------------- >> CatsSoft-Recuva-Update.txt
echo Check For Updates >> CatsSoft-Recuva-Update.txt
echo. |time |find "current" >> CatsSoft-Recuva-Update.txt
echo %date% >> CatsSoft-Recuva-Update.txt
echo --------------------------------------------------------------------------------- >> CatsSoft-Recuva-Update.txt
SET "BinDir=%~dp0Bin"
SET "ZIPDir=%~dp0Bin\7-zip"
SET "TempDir=%TEMP%\7-zip"
set installdir=rcsetup
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
    Title CatsSoft-Recuva-Update
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.    -----------------------------------
    echo.      ===  Welcome to main menu! ===   
    echo.    -----------------------------------
    echo.                                       
    echo.    [1] Type "1" and uninstall old version of Recuva.
    echo.
    echo.    [2] Type "2" and download new version of Recuva. 
    echo.
    echo.    [2] Type "3" and starts Recuva. 
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
       goto runrecuva
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
:: uninstall Recuva.
:: void uninstall();
:: /*************************************************************************************/
:Uninstall
    @cls
    Title CatsSoft-Uninstall-Recuva
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo Uninstall Recuva...
    echo.
    if %processor_architecture%==x86 ( 
      if exist "%ProgramFiles%\Recuva\Recuva.exe" (
        taskkill /F /IM "Recuva.exe"
        start /d "%ProgramFiles%\Recuva" uninst.exe /S
        echo Recuva has been sucessfully Uninstall.
        goto close_uninstaller
      ) else (
        echo Recuva was failed Uninstall.
        goto close_uninstaller
      )
    ) else (
      if exist "%ProgramFiles%\Recuva\Recuva64.exe" (
        taskkill /F /IM "Recuva64.exe"
        start /d "%ProgramFiles%\Recuva" uninst.exe /S
        echo Recuva has been sucessfully Uninstall.
        goto close_uninstaller
      ) else (
        echo Recuva was failed Uninstall.
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
:: Download Recuva.
:: void Recuva();
:: /*************************************************************************************/
:Download
    @cls
    Title CatsSoft-Download-Recuva
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.    -----------------------------------
    echo.      ===  Welcome to main menu! ===   
    echo.    -----------------------------------
    echo.                                       
    echo.    [1] Type "1" and download Recuva standard version.
    echo.
    echo.    [2] Type "2" and download Recuvar portable version. 
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
:: Download Recuva standard version.
:: void Standard();
:: /*************************************************************************************/
:Standard
    @cls
    Title CatsSoft-Download-Recuva-Standard-Version
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    if %processor_architecture%==x86 ( 
      if exist "%BinDir%\wget.exe" (
       goto rcstandard
      ) else (
        bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/32/wget.exe" "%BinDir%\wget.exe"
       goto rcstandard
      )
    ) else (
      if exist "%BinDir%\wget.exe" (
       goto rcstandard
      ) else (
       bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/64/wget.exe" "%BinDir%\wget.exe"
       goto rcstandard
      )
    )
    :rcstandard
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo Check for updates 
    echo.
    cd /d "%~dp0"
    bin\wget --no-check-certificate --content-disposition -N -S https://www.ccleaner.com/recuva/download/standard
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
    echo URL: %URL:~63,44% >> CatsSoft-Recuva-Update.txt
    set "URL=%URL:~63,44%"
    echo.
    for %%g in ("%URL%") do set "File=%%~nxg"
    echo File: %File% >> CatsSoft_Recuva-Update.txt
    echo.
    FOR /F "tokens=1,2,3,4,5 delims=/" %%A IN ("%URL%") DO set "Domain=%%B"
    echo Domain: %Domain% >> CatsSoft-Recuva-Update.txt
    echo.
    echo.
    FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Recuva" /v DisplayVersion`) DO (
        set DisplayVersion=%%A
    )
    for /f "tokens=1,2 delims=. " %%A in ("%DisplayVersion%") do set "DisplayVersion=%%A%%B"
    echo Current Version: %DisplayVersion% >> CatsSoft-Recuva-Update.txt
    echo.
    for %%f in ('findstr /I "rcsetup*.exe" "%File%"') do set "NewVersion=%%~nf"
    echo New Version: %NewVersion:~7% >> CatsSoft-Recuva-Update.txt
    echo.
    for %%f in ("%~dp0rcsetup*.exe") do (
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
    echo.
    if %errorlevel%==1 exit 1
    if exist "%~dp0%File%" (
      echo The files "%File%" has been sucessfully downloaded!
      goto install_standard
    ) else (
      echo The files "%File%" could not be downloaded! Try again later.
      del "%~dp0%File%"
      goto Close_down_standard
    )
    :install_standard
    for /f "skip=1 eol=: delims=" %%F in ('dir /b /o-d "%~dp0rcsetup*.exe"') do @del "%%F"

    for %%f in ("%~dp0rcsetup*.exe") do (
     if %%~nf==%cver% (
       echo.
       echo Recuva is already up to date [%%~nf]
       echo.
     ) else (
       echo.
       echo A newer version of Recuva was found [%cver% --^> %%~nf]
       echo.
       echo Installing . . .
       echo.
       REM [DEBUG] comment this for debugging
       %%~ff /S
       echo.
       echo complete!
       echo.
     )
    )
     echo.
     if %processor_architecture%==x86 ( 
       if exist "%ProgramFiles%\Recuva\Recuva.exe" (
         echo Recuva has been successfully install!
       ) else ( 
         echo Recuva was failed install!
       )
     ) else (
        if exist "%ProgramFiles%\Recuva\Recuva64.exe" (
         echo Recuva has been successfully install!
       ) else ( 
         echo Recuva was failed install!
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
cls
:: /*************************************************************************************/
:: Download Recuva portable version.
:: void portable();
:: /*************************************************************************************/
:portable
    @cls
    Title CatsSoft-Download-Recuva-Portable-Version
    color 0B
    mode con:cols=90 lines=26
    @cls
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
       goto rcportable
      ) else (
        bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/32/wget.exe" "%BinDir%\wget.exe"
       goto rcportable
      )
    ) else (
      if exist "%BinDir%\wget.exe" (
       goto rcportable
      ) else ( 
        bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/64/wget.exe" "%BinDir%\wget.exe"
        goto rcportable
       )
    )
    :rcportable
    echo.
    echo Check for updates 
    echo.
    for %%f in ("%~dp0rcsetup*.zip") do (
	set cver=%%~nf
    )
    if not exist "%~dp0%cver%.zip" ( set cver=none )
    echo.
    echo Checking server for updates . . .
    echo.
    "%~dp0bin\wget" --continue --show-progress --no-check-certificate -nc --content-disposition "https://www.ccleaner.com/recuva/download/portable/downloadfile"
    REM if %errorlevel%==1 exit 1
    if %errorlevel%==1 (
	echo.
	echo Recuva could not update
	pause>nul
	goto :menu
    )
    for /f "skip=1 eol=: delims=" %%F in ('dir /b /o-d "%~dp0rcsetup*.zip"') do @del "%%F"
    for %%f in ("%~dp0rcsetup*.zip") do (
	if %%~nf==%cver% (
	    echo Recuva is already up to date [%%~nf]
	) else (
	    echo A newer version of Recuva was found [%cver% --^> %%~nf]
	    echo Installing . . .
	    "%ZIPDir%\7z.exe" x -o"%installdir%" -y "%%~ff"
            echo. 
            echo complete!
            echo.
     	)
     )
     echo.
     echo Check if Recuva is installed correctly ...
     echo.
     if %processor_architecture%==x86 ( 
       if exist "%installdir%\Recuva.exe" (
         echo Recuva has been successfully install!
       ) else ( 
         echo Recuva was failed install!
       )
     ) else (
        if exist "%installdir%\Recuva64.exe" (
         echo Recuva has been successfully install!
       ) else ( 
         echo Recuva was failed install!
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
:: Run Recuva.
:: void runrecuva();
:: /*************************************************************************************/
:runrecuva
    @cls
    Title CatsSoft-Run-Recuva
    color 0B
    mode con:cols=90 lines=26
    @cls
     echo.
     echo ---------------------------------------------------------------------------------
     echo.
     if exist "%ProgramFiles%\Recuva\Recuva.exe" (
      if %processor_architecture%==x86 ( start "" "%PROGRAMFILES%\Recuva\Recuva.exe"
      ) else ( start "" "%PROGRAMFILES%\Recuva\Recuva64.exe" )
     ) else (
      if %processor_architecture%==x86 ( start "" "%~dp0%installdir%\Recuva.exe"
      ) else ( start "" "%~dp0%installdir%\Recuva64.exe" )
     )
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