@echo off
rem ############################################################################
rem # This software is released under the MIT License see LICENSE.txt
rem # Filename : test_main.cmd
rem # Overview : test script for logger.ps1
rem # HowToUse : test_main.cmd
rem #---------------------------------------------------------------------------
rem # Author: Isaac Factory (sir.isaac.factory@icloud.com)
rem # Date: 2021/02/02
rem # Code version: v1.00
rem ############################################################################

rem ############################################################################
rem # Define variables
rem ############################################################################
set normal_end=0
set error_end=255
set scriptdir=%~d0%~p0
set logbase=%~n0
set logfile=%scriptdir%%logbase%.log
set logger=%scriptdir%logger.cmd


rem ############################################################################
rem # Initialise
rem ############################################################################
call "%logger%" SetLogLevel debug
rem # call "%logger%" CreateLogfile "%logfile%"
rem # call "%logger%" OpenLogfile   "%logfile%"


rem ############################################################################
rem # goto main
rem ############################################################################
goto :main


rem ############################################################################
rem # displayArgs
rem ############################################################################
:displayArgs
    setlocal
    set func=displayArgs
    call "%logger%" debug "%func% start"

    call "%logger%" info "%func% The command-line options are as below:"
    for %%c in (%*%) do (
        call "%logger%" info "%func% %%c"
    )

    call "%logger%" debug "%func% end"
    endlocal
goto :eof


rem ############################################################################
rem # main
rem ############################################################################
:main
    setlocal
    set func=main
    call "%logger%" debug "%func% start"

    set argc=0
    for %%a in (%*%) do (
        set /a argc+=1
    )

    if %argc% equ 0 (
        call "%logger%" error "%func% There are no command-line options."
        exit /b %error_end%
    ) else (
        call "%logger%" info "%func% The number of command-line options is %argc%."
    )

    call :displayArgs %*%

    call "%logger%" debug "%func% end"
    endlocal
goto :eof