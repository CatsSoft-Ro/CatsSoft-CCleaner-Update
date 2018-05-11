@echo off
echo.
SET "BinDir=%~dp0Bin"
if exist "%BinDir%" (
 goto start
) else (
 MD "%BinDir%"
 MD "%BinDir%\7-zip"
 MD "%TEMP%\7-zip"
 goto start
)
:start
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
      bitsadmin /transfer wcb /priority high "https://www.7-zip.org/a/7z1805.msi" "%~dp07z1805.msi"
      echo.
    ) else (
      bitsadmin /transfer wcb /priority high "https://www.7-zip.org/a/7z1805-x64.msi" "%~dp07z1805-x64.msi"
      echo.
    )
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
pause>nul
exit