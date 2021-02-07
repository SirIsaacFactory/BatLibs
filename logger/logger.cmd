@echo off
rem ############################################################################
rem # This software is released under the MIT License see LICENSE.txt
rem # Filename : logger.cmd
rem # Overview : Dispay log /Write log to file.
rem # HowToUse : Define variables
rem #              when logger.ps1 is located to functions folder
rem #              set scriptdir=%~d0%~p0
rem #              set logger=%scriptdir%functions\logger.cmd
rem #            Log output configuration
rem #              when you use the debug level:
rem #                call "%logger%" SetLogLevel debug
rem #              if you need a log file:
rem #                clear log file before write
rem #                  call "%logger%" CreateLogFile "%logfile%"
rem #                not clear log file before write
rem #                  call "%logger%" SetLogFile "%logfile%"
rem #            Lot output
rem #              call "%logger%" debug    "debug level message"
rem #              call "%logger%" info     "info level message"
rem #              call "%logger%" warning  "warning level message"
rem #              call "%logger%" error    "error level message"
rem #              call "%logger%" critical "critical level message"
rem #---------------------------------------------------------------------------
rem # Author: Isaac Factory (sir.isaac.factory@icloud.com)
rem # Date: 2021/02/02
rem # Code version: v1.00
rem ############################################################################

rem ############################################################################
rem # Define variables
rem ############################################################################
rem # return values
if not defined logger_end_of_initialise (
    set logger_normal_end=0
    set logger_error_end=255

    rem # log levels
    set logger_debug_level=0
    set logger_info_level=1
    set logger_warning_level=2
    set logger_error_level=3
    set logger_critical_level=4

    rem # log labels
    set logger_debug_label=debug
    set logger_info_label=info
    set logger_warning_label=warning
    set logger_error_label=error
    set logger_critical_label=critical

    rem # default log level
    if not defined logger_loglevel (
        set logger_loglevel=%logger_info_level%
    )

    rem # end of initialise
    set logger_end_of_initialise=""
)

rem ############################################################################
rem # Check command-line argments
rem ############################################################################
set argc=0
for %%a in (%*%) do (
    set /a argc+=1
)

if %argc% neq 2 (
    echo "%date%","%time%","%logger_error_label%","command-line argment error"
    exit /b %logger_error_end%
)


rem ############################################################################
rem # Execute function
rem ############################################################################
goto %~1%


rem ############################################################################
rem # Create logfile
rem ############################################################################
:CreateLogFile
    set logger_logfile_tmp=%~2%
    call :SetLogDir "%logger_logfile_tmp%"

    rem # Check whether the log directory exists
    dir /a:d "%logger_logdir%" > nul 2>&1
    if %errorlevel% neq 0 (
        echo "%date%","%time%","%logger_error_label%","logger_logdir %logger_logdir% does not exit."
        exit /b %logger_error_end%
    )
 
    rem # Check whether the log file is a folder
    dir /a:d "%logger_logfile_tmp%" > nul 2>&1
    if %errorlevel% equ 0 (
        echo "%date%","%time%","%logger_error_label%","logger_logfile %logger_logfile_tmp% is a folder"
        exit /b %logger_error_end%
    )

    set logger_logfile=%logger_logfile_tmp%
    type nul > "%logger_logfile%"

goto :eof

rem ############################################################################
rem # Set logfile
rem ############################################################################
:OpenLogFile
    set logger_logfile_tmp=%~2%
    call :SetLogDir "%logger_logfile_tmp%"

    rem # Check whether the log directory exists
    dir /a:d "%logger_logdir%" > nul 2>&1
    if %errorlevel% neq 0 (
        echo logger_logdir %logger_logdir% does not exit.
        exit /b %logger_error_end%
    )

    rem # Check whether the log file is a folder
    dir /a:d "%logger_logfile_tmp%" > nul 2>&1
    if %errorlevel% equ 0 (
        echo logger_logfile %logger_logfile_tmp% is a foldr
        exit /b %logger_error_end%
    )

    set logger_logfile=%logger_logfile_tmp%

goto :eof


rem ############################################################################
rem # Set log directory
rem ############################################################################
:SetLogDir
    set logger_logdir=%~d1%~p1
goto :eof


rem ############################################################################
rem # Set loglevel
rem ############################################################################
:SetLogLevel
    set logger_setloglevel=%~2%
    if %logger_setloglevel% equ %logger_debug_label% (
        set logger_loglevel=%logger_debug_level%
    ) else if %logger_setloglevel% equ %logger_info_label% (
        set logger_loglevel=%logger_info_level%
    ) else if %logger_setloglevel% equ %logger_warning_label% (
        set logger_loglevel=%logger_warning_level%
    ) else if %logger_setloglevel% equ %logger_error_label% (
        set logger_loglevel=%logger_error_level%
    ) else if %logger_setloglevel% equ %logger_critical_label% (
        set logger_loglevel=%logger_critical_level%
    )

goto :eof


rem ############################################################################
rem # Output log
rem ############################################################################
:debug
    set logger_label=%logger_debug_label%
    set logger_level=%logger_debug_level%
    call :outputLine "%~2%"
goto :eof

:info
    set logger_label=%logger_info_label%
    set logger_level=%logger_info_level%
    call :outputLine "%~2%"
goto :eof

:warning
    set logger_label=%logger_warning_label%
    set logger_level=%logger_warning_level%
    call :outputLine "%~2%"
goto :eof

:error
    set logger_label=%logger_error_label%
    set logger_level=%logger_error_level%
    call :outputLine "%~2%"
goto :eof

:critical
    set logger_label=%logger_critical_label%
    set logger_level=%logger_critical_level%
    call :outputLine "%~2%"
goto :eof

:outputLine
    if %logger_level% geq %logger_loglevel% (
        echo "%date%","%time%","%logger_label%","%~1%"

        if exist "%logger_logfile%" (
            echo "%date%","%time%","%logger_label%","%~1" >> "%logger_logfile%"
        )
    )
goto :eof

