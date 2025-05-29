@echo off
setlocal ENABLEDELAYEDEXPANSION

set build_version=
FOR /F "tokens=*" %%i in ('type .build-info') do (
    if "%build_version%"=="" (
        set build_version=%%i
    )
)
set major=
set minor=
set patch=
set env=
for /F "tokens=1,2,3 delims=. " %%a in ("%build_version%") do (
    set major=%%a
    set minor=%%b
    set patch=%%c
)

:read_args
if "%1" == "" goto load_env_vars
    if "%1" == "--env" (
        SET env=%2
        shift
    ) else if "%1" == "--minor" (
        set /a minor+=1
        set /a patch=0
    ) else if "%1" == "--major" (
        set /a major+=1
        set /a minor=0
        set /a patch=0
    ) else if "%1" == "--patch" (
        set /a patch+=1
    )
shift
goto read_args
:load_env_vars

if "%env%"=="" (
    FOR /F "tokens=*" %%i in ('type .env') do SET %%i
) else (
    FOR /F "tokens=*" %%i in ('type .env.%env%') do SET %%i
)

set build_version=%major%.%minor%.%patch%


SET build_time=%date:~6,4%-%date:~3,2%-%date:~0,2% %time:~0,2%:%time:~3,2%:%time:~6,2%

echo %build_version% > .build-info

flutter build web --release ^
    --dart-define=ENV=%env% ^
    --dart-define=BUILD_DATE="%build_time%" ^
    --dart-define=BUILD_VERSION=%build_version% ^

endlocal
