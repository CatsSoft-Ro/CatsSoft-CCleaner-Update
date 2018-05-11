@echo off
Title CatsSoft-Defraggler-Update
color 0B
mode con:cols=90 lines=26
echo.
echo --------------------------------------------------------------------------------- >> CatsSoft-Defraggler-Update.txt
echo Check For Updates >> CatsSoft-Defraggler-Update.txt
echo. |time |find "current" >> CatsSoft-Defraggler-Update.txt
echo %date% >> CatsSoft-Defraggler-Update.txt
echo --------------------------------------------------------------------------------- >> CatsSoft-Defraggler-Update.txt
SET "BinDir=%~dp0Bin"
SET "ZIPDir=%~dp0Bin\7-zip"
SET "TempDir=%TEMP%\7-zip"
set installdir=dfsetup
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
    Title CatsSoft-Defraggler-Update
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.    -----------------------------------
    echo.      ===  Welcome to main menu! ===   
    echo.    -----------------------------------
    echo.                                       
    echo.    [1] Type "1" and uninstall old version of Defraggler.
    echo.
    echo.    [2] Type "2" and download new version of Defraggler. 
    echo.
    echo.    [2] Type "3" and defrag your computer with Defraggler. 
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
       goto autodefrag
    ) else (
    echo.
    echo.Invalid option.
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo	=== Press any key to return to the menu ===
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    pause>nul
    goto menu
    )
    goto menu
goto :eof
cls
:: /*************************************************************************************/
:: uninstall Defraggler.
:: void uninstall();
:: /*************************************************************************************/
:uninstall
    Title CatsSoft-Uninstall-Defraggler
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo Uninstall Defraggler...
    echo.
    if %processor_architecture%==x86 ( 
      if exist "%ProgramFiles%\Defraggler\Defraggler.exe" (
        taskkill /F /IM "Defraggler.exe"
        start /d "%ProgramFiles%\Defraggler" uninst.exe /S
        echo Defraggler has been sucessfully uninstall.
        goto close_uninstaller
      ) else (
        echo Defraggler was failed uninstall.
        goto close_uninstaller
      )
    ) else (
      if exist "%ProgramFiles%\Defraggler\Defraggler64.exe" (
        taskkill /F /IM "Defraggler64.exe"
        start /d "%ProgramFiles%\Defraggler" uninst.exe /S
        echo Defraggler has been sucessfully uninstall.
        goto close_uninstaller
      ) else (
        echo Defraggler was failed uninstall.
        goto close_uninstaller
      )
    )
    :close_uninstaller
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo	=== Press any key to return to the menu ===
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    pause>nul
    goto menu
goto :eof
cls
:: /*************************************************************************************/
:: Download Defraggler.
:: void Download();
:: /*************************************************************************************/
:Download
    @cls
    Title CatsSoft-Download-Defraggler
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.    -----------------------------------
    echo.      ===  Welcome to main menu! ===   
    echo.    -----------------------------------
    echo.                                       
    echo.    [1] Type "1" and download Defraggler standard version.
    echo.
    echo.    [2] Type "2" and download Defraggler portable version. 
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
    echo	=== Press any key to return to the menu ===
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    pause>nul
    goto Download
    )
    goto Download
goto :eof
cls
:: /*************************************************************************************/
:: Download Defraggler standard version.
:: void Standard();
:: /*************************************************************************************/
:Standard
    @cls
    Title CatsSoft-Download-Defraggler-Standard-Version
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    if %processor_architecture%==x86 ( 
      if exist "%BinDir%\wget.exe" (
       goto dfstandard
      ) else (
        bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/32/wget.exe" "%BinDir%\wget.exe"
       goto dfstandard
      )
    ) else (
      if exist "%BinDir%\wget.exe" (
       goto dfstandard
      ) else (
       bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/64/wget.exe" "%BinDir%\wget.exe"
       goto dfstandard
      )
    )
    :dfstandard
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo Check for updates 
    echo.
    cd /d "%~dp0"
    bin\wget --no-check-certificate --content-disposition -N -S https://www.ccleaner.com/defraggler/download/standard
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
    echo URL: %URL:~63,44% >> CatsSoft-Defraggler-Update.txt
    set "URL=%URL:~63,44%"
    echo.
    for %%g in ("%URL%") do set "File=%%~nxg"
    echo File: %File% >> CatsSoft-Defraggler-Update.txt
    echo.
    FOR /F "tokens=1,2,3,4,5 delims=/" %%A IN ("%URL%") DO set "Domain=%%B"
    echo Domain: %Domain% >> CatsSoft-Defraggler-Update.txt
    echo.
    FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Defraggler" /v DisplayVersion`) DO (
        set DisplayVersion=%%A
    )
    for /f "tokens=1,2 delims=. " %%A in ("%DisplayVersion%") do set "DisplayVersion=%%A%%B"
    echo Current Version: %DisplayVersion% >> CatsSoft-Defraggler-Update.txt
    echo.
    for %%f in ('findstr /I "dfsetup*.exe" "%File%"') do set "NewVersion=%%~nf"
    echo New Version: %NewVersion:~7% >> CatsSoft-Defraggler-Update.txt
    echo.
    for %%f in ("%~dp0dfsetup*.exe") do (
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
    for /f "skip=1 eol=: delims=" %%F in ('dir /b /o-d "%~dp0dfsetup*.exe"') do @del "%%F"
    for %%f in ("%~dp0dfsetup*.exe") do (
     if %%~nf==%cver% (
       echo.
       echo Defraggler is already up to date [%%~nf]
       echo.
     ) else (
       echo.
       echo A newer version of Defraggler was found [%cver% --^> %%~nf]
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
       if exist "%ProgramFiles%\Defraggler\Defraggler.exe" (
         echo Defraggler has been successfully installed!
       ) else ( 
         echo Defraggler has been sucessfully install!
       )
     ) else (
        if exist "%ProgramFiles%\Defraggler\Defraggler64.exe" (
         echo Defraggler has been successfully installed!
       ) else ( 
         echo Defraggler was faild install!
       )
     )
    )
    REM echo.
    :Close_down_standard
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo	=== Press any key to return to the menu ===
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    pause>nul
    goto menu
goto :eof
cls
:: /*************************************************************************************/
:: Download Defraggler portable version.
:: void portable();
:: /*************************************************************************************/
:portable
    @cls
    Title CatsSoft-Download-Defraggler-Portable-Version
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
        bitsadmin /transfer wcb /priority high "https://www.7-zip.org/a/7z1805.msi" "%~dp07z1805.msi"
        goto :next
      )
    ) else (
      if exist "%~dp0bin\7-zip\7z.exe" (
        goto :next
      ) else (
        bitsadmin /transfer wcb /priority high "https://www.7-zip.org/a/7z1805-x64.msi" "%~dp07z1805-x64.msi"
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
       goto dfportable
      ) else (
        bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/32/wget.exe" "%BinDir%\wget.exe"
       goto dfportable
      )
    ) else (
      if exist "%BinDir%\wget.exe" (
       goto dfportable
      ) else ( 
        bitsadmin /transfer wcb /priority high "https://eternallybored.org/misc/wget/1.19.4/64/wget.exe" "%BinDir%\wget.exe"
        goto dfportable
       )
    )
    :dfportable
    echo.
    echo Check for updates 
    echo.
    for %%f in ("%~dp0dfsetup*.zip") do (
	set cver=%%~nf
    )
    if not exist "%~dp0%cver%.zip" ( set cver=none )
    echo.
    echo Checking server for updates . . .
    echo.
    "%~dp0bin\wget" --continue --show-progress --no-check-certificate -nc --content-disposition "https://www.ccleaner.com/defraggler/download/portable/downloadfile"
    REM if %errorlevel%==1 exit 1
    if %errorlevel%==1 (
	echo.
	echo Defraggler could not update
	pause>nul
	goto :menu
    )
    for /f "skip=1 eol=: delims=" %%F in ('dir /b /o-d "%~dp0dfsetup*.zip"') do @del "%%F"
    for %%f in ("%~dp0dfsetup*.zip") do (
	if %%~nf==%cver% (
	    echo Defraggler is already up to date [%%~nf]
	) else (
	    echo A newer version of Defraggler was found [%cver% --^> %%~nf]
	    echo Installing . . .
	    "%ZIPDir%\7z.exe" x -o"%installdir%" -y "%%~ff"
            echo. 
            echo complete!
            echo.
     	)
     )
     echo.
     echo Check if Defraggler is installed correctly ...
     echo.
     if %processor_architecture%==x86 ( 
       if exist "%installdir%\Defraggler.exe" (
         echo Defraggler has been successfully installed!
       ) else ( 
         echo Defraggler has been sucessfully install!
       )
     ) else (
        if exist "%installdir%\Defraggler64.exe" (
         echo Defraggler has been successfully installed!
       ) else ( 
         echo Defraggler was failed install!
       )
     )
    REM echo.
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    echo	=== Press any key to return to the menu ===
    echo.
    echo ---------------------------------------------------------------------------------
    echo.
    pause>nul
    goto menu
goto :eof
cls
:: /*************************************************************************************/
:: Autoclean.
:: void autoDefrag();
:: /*************************************************************************************/
:AutoDefrag
    @cls
    Title CatsSoft-Defrag-Disk-With-Defraggler
    color 0B
    mode con:cols=90 lines=26
    @cls
    echo.    -----------------------------------
    echo.      ===  Welcome to main menu! ===   
    echo.    -----------------------------------
    echo.                                       
    echo.    [1] Type "1" and start defrag srive C: .
    echo.
    echo.    [2] Type "2" abd start defrag srive D: . 
    echo.
    echo.    [2] Type "3" and start defrag srive E: . 
    echo.
    echo.    [0] Type "0" and close this tool.
    echo.
    echo.

    set /P "Choice=Type 1, 2, 3 or 0 then press ENTER: "

    if [%Choice%]==[1] goto fixC
    if [%Choice%]==[2] goto fixD
    if [%Choice%]==[3] goto fixE
    if [%Choice%]==[0] goto menu

    For %%a in (1,2,3) do if not [%Choice%]==[%%0] goto menu
    echo.

    :fixC
     if exist "%ProgramFiles%\Defraggler\Defraggler.exe" (
      if exist "%ProgramFiles%\Defraggler\Defraggler.exe" (
        start /d "%ProgramFiles%\Defraggler" df.exe /QD C:\
      ) else (
        start /d "%ProgramFiles%\Defraggler" df.exe /QD C:\
      )
     ) else (
      if exist "%~dp0%installdir%\Defraggler.exe" (
       start "" "%~dp0%installdir%" df.exe /QD C:\
       ) else ( 
       start "" "%~dp0%installdir%" df.exe /QD C:\
      )
     )
     echo.
     echo complete!
     echo.
     echo ---------------------------------------------------------------------------------
     echo.
     echo	=== Press any key to return to the menu ===
     echo.
     echo ---------------------------------------------------------------------------------
     echo.
     pause>nul
     goto menu

    :fixD
     if exist "%ProgramFiles%\Defraggler\Defraggler.exe" (
      if exist "%ProgramFiles%\Defraggler\Defraggler.exe" (
        start /d "%ProgramFiles%\Defraggler" df.exe /QD D:\
      ) else (
        start /d "%ProgramFiles%\Defraggler" df.exe /QD D:\
      )
     ) else (
      if exist "%~dp0%installdir%\Defraggler.exe" (
       start "" "%~dp0%installdir%" df.exe /QD D:\
       ) else ( 
       start "" "%~dp0%installdir%" df.exe /QD D:\
      )
     )
     echo.
     echo complete!
     echo.
     echo ---------------------------------------------------------------------------------
     echo.
     echo	=== Press any key to return to the menu ===
     echo.
     echo ---------------------------------------------------------------------------------
     echo.
     pause>nul
     goto menu

    :fixE
     if exist "%ProgramFiles%\Defraggler\Defraggler.exe" (
      if exist "%ProgramFiles%\Defraggler\Defraggler.exe" (
        start /d "%ProgramFiles%\Defraggler" df.exe /QD E:\
      ) else (
        start /d "%ProgramFiles%\Defraggler" df.exe /QD E:\
      )
     ) else (
      if exist "%~dp0%installdir%\Defraggler.exe" (
       start "" "%~dp0%installdir%" df.exe /QD E:\
       ) else ( 
       start "" "%~dp0%installdir%" df.exe /QD E:\
      )
     )
     echo.
     echo complete!
     echo.
     echo ---------------------------------------------------------------------------------
     echo.
     echo	=== Press any key to return to the menu ===
     echo.
     echo ---------------------------------------------------------------------------------
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