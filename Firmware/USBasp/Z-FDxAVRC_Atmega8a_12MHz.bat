::#############################################################################
::### Flyandance 8-bit AVR C/C++ FDxAVRC IDE-Less Build 1.3
::#############################################################################
:: Portable IDE-less application and bootloader build script for 8-bit AVR MCUs.
:: AVR GNU Toolchain and AVRDUDE must be installed separately.
::                                                     (c) 2024-2026 Flyandance

@echo off
setlocal EnableExtensions DisableDelayedExpansion

::#############################################################################
::### Toolchain
:: Folder containing avr-gcc.exe and related AVR GNU tools.
set "AVR_TOOLCHAIN_BIN=C:\App\avr\avr8-gnu-toolchain-win32_x86\bin"

:: Folder containing avrdude.exe. Example: C:\App\avr\avrdude
set "AVRDUDE_DIR=C:\App\avr\avrdude"

::#############################################################################
::### Primary Project Settings
::#############################################################################

::========== Project Key Settings =============================================
:: atmega8, atmega88, atmega168, atmega328p, atmega16, atmega32,
:: attiny10, attiny13, attiny85, atmega64, atmega128, atmega169p
set "MCU=atmega8"

:: Semicolon-separated definitions without -D. Example: DEBUG;BUFFER_SIZE=128;
set "DEFINES="

:: Firmware type: [application] or [bootloader]
set "BUILD_TYPE=application"

:: Reserved bootloader size in bytes: [512, 1024, 2048, 4096]
set "BOOTLOADER_SIZE_BYTES=1024"

:: -nostartfiles -nodefaultlibs -nostdlib -Wl,--gc-sections;
set "LINK_OPTIONS=-Wl,--gc-sections"

  :: [yes] upload after a successful default build; [no] build only.
  set "AUTO_UPLOAD=yes"
  
  :: AVRDUDE programmer ID. USB: usbasp; UART: butterfly, avr109, avr910, stk500v2, stk500v1
  set "PROGRAMMER=usbasp"

  :: UART programmer port. Example: COM3
  set "PROGRAMMER_PORT=COM3"

  :: UART programmer baud. Common: 2000000, 1000000, 500000, 250000, 230400, 115200, 57600, 38400, 19200
  set "PROGRAMMER_BAUD=1000000"
  
  :: Extra AVRDUDE options. Example: Override MCU: -F | -x devcode=0x11
  set "AVRDUDE_OPTIONS="
  
  ::========== Lock Byte After Upload ===========================================
  :: Application lock mode: [unlocked, bootProtect, appProtect, fullLock]
  set "APPLICATION_LOCK_MODE=unlocked"

::*****************************************************************************
::********** Compiler Options *************************************************
:: Optimization: -Os -O0 -Og -O1 -O2 -O3 -flto
:: Diagnostics/layout: -g -Wall -Wextra -Wpedantic -Werror -ffunction-sections -fdata-sections
:: AVR code generation: -fno-jump-tables -mcall-prologues
set "COMMON_COMPILE_OPTIONS=-Os -Wall -ffunction-sections -fdata-sections"

:: C diagnostics: -Wstrict-prototypes -Wmissing-prototypes -Wold-style-definition -Wshadow -Wconversion
set "C_COMPILE_OPTIONS="

:: C++ runtime/size: -fno-exceptions -fno-rtti -fno-threadsafe-statics -fno-use-cxa-atexit
:: C++ diagnostics: -Wold-style-cast -Wnon-virtual-dtor -Woverloaded-virtual
set "CPP_COMPILE_OPTIONS="

:: GNU assembly: -g -Wa,--gstabs -x assembler-with-cpp
set "ASM_COMPILE_OPTIONS="

:: Semicolon-separated include folders without -I. Example: include;drivers;vendor\include
set "INCLUDE_DIRS=.;usbdrv"

:: [yes] compile every source file; [no] reuse unchanged object files.
set "RECOMPILE_ALL=no"

::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::++++++++++ Libraries and Linker ++++++++++++++++++++++++++++++++++++++++++++++++
:: Semicolon-separated library folders without -L. Example: lib;prebuilt;vendor\lib
set "LIBRARY_DIRS="

:: libc, libgcc, and MCU support are automatic; list only extra or custom libraries.
:: Semicolon-separated library names without -l; link order is preserved.
:: [m] AVR-LibC math library; custom example: m;mydriver
set "LIBRARIES="

:: Object files and static archives linked directly. Example: startup.o;lib\support.a
set "EXTRA_OBJECTS="

::################################################################################
::########## Project: Source and Output ##########################################
:: Final linker: [auto, c, cpp]. Source extensions still select avr-gcc or avr-g++.
set "PROJECT_LANGUAGE=auto"

:: Output filename without an extension; blank uses the project-folder name. Example: MyFirmware
set "OUTPUT_NAME="

:: Source folders scanned recursively; [.] scans the whole project. Multiple roots: src;common
set "SOURCE_DIRS=."

:: Additional excluded folders, project-relative or absolute.
set "EXCLUDE_DIRS="

:: Build files use app or boot subfolders; APP_*.hex and BOOT_*.hex are placed here.
set "OUTPUT_DIR=_Output"

::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
::@@@@@@@@@@ Build Settings @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

:: [yes] compile .s and .S files; [no] ignore assembly source files.
set "COMPILE_ASSEMBLY=yes"

:: [yes] recursively scan EXTERNAL_OBJECT_DIRS for .o and .obj files; [no] disable.
:: OUTPUT_DIR is always excluded from this scan.
set "LINK_EXTERNAL_OBJECTS=no"

:: C standard; blank uses the compiler default. Example: c11, c17, gnu11, gnu17
set "C_STANDARD="

:: C++ standard; blank uses the compiler default. Example: c++11, c++14, gnu++17
set "CPP_STANDARD="

::#############################################################################
::### Programmer and Upload Settings
::#############################################################################

  :: Connection path: [usb, uart]. USB ignores PROGRAMMER_PORT and PROGRAMMER_BAUD.
  set "PROGRAMMER_CONNECTION=usb"

  :: EEPROM upload: [no, yes, auto]. Auto uploads initialized EEPROM only when its image exists.
  set "UPLOAD_EEPROM=no"

  :: Serial reset before upload: [auto, yes, no]. Auto enables it for butterfly and avr109.
  set "SERIAL_AUTO_RESET=auto"

::#############################################################################
::### Bootloader Settings
::#############################################################################
:: Select the firmware type here; remaining settings apply only to bootloader builds.

:: [auto] uses flash size minus BOOTLOADER_SIZE_BYTES; or enter an address. Example: 0x7C00
set "BOOT_START_ADDRESS=auto"

:: [yes] disable compiler-generated jump tables; [no] allow jump tables.
set "BOOT_NO_JUMP_TABLES=yes"

:: Bootloader-only compiler options. Example: -mcall-prologues -fno-inline-small-functions
set "BOOT_COMPILE_OPTIONS="

:: Bootloader-only linker options. Example: -Wl,--undefined=entry_symbol
set "BOOT_LINK_OPTIONS="

:: Bootloader uploads request write protection only for verified classic profiles.
:: Unprofiled devices are blocked from automatic lock-byte writes.

::#############################################################################
::### Advanced Build Settings
::#############################################################################

::========== AVRDUDE and Device ===============================================
:: AVRDUDE configuration file; blank uses AVRDUDE_DIR\avrdude.conf when present.
set "AVRDUDE_CONF="

:: AVRDUDE part ID; [auto] matches MCU against the installed AVRDUDE device list.
set "AVRDUDE_PART=auto"

::========== External Objects =================================================
:: External-object roots scanned only when LINK_EXTERNAL_OBJECTS=yes. Example: prebuilt;vendor\objects
set "EXTERNAL_OBJECT_DIRS=prebuilt"

::========== Application Profile ==============================================
:: Application-only compiler options. Example: -O2 -flto
set "APPLICATION_COMPILE_OPTIONS="

:: Application-only linker options. Example: -Wl,--relax
set "APPLICATION_LINK_OPTIONS="

  ::========== Application-only Custom Section ================================
  :: Optional application section placed at CUSTOM_SECTION_ADDRESS; blank disables it.
  :: This setting is ignored completely when BUILD_TYPE=bootloader.
  set "CUSTOM_SECTION_NAME=FD_App_Start_Add"

  :: Address for the application-only custom section.
  set "CUSTOM_SECTION_ADDRESS=0x0"

::========== ( Manual Device Capacity ) ====================================
:: Manual Flash bytes; blank uses profile data. Common: 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072, 262144
set "FLASH_SIZE_BYTES="

:: Manual SRAM bytes; blank uses profile data. Common: 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384
set "SRAM_SIZE_BYTES="

:: Manual EEPROM bytes; blank uses profile data. Use 0 when the device has none. Common: 0, 64, 128, 256, 512, 1024, 2048, 4096
set "EEPROM_SIZE_BYTES="

  ::========== Generated Files and Display ======================================
  :: [yes] retain the linked ELF file; [no] delete it after all reports are generated.
  set "KEEP_ELF=yes"

  :: [yes] create a disassembly and source listing; [no] disable.
  set "CREATE_LSS=yes"

  :: [yes] create a linker map file; [no] disable.
  set "CREATE_MAP_FILE=yes"

  :: [yes] create *.EEPROM.hex for nonzero initialized EEPROM data; [no] disable.
  set "CREATE_EEPROM_FILE=yes"

  :: [yes] create a symbol-size report using avr-nm; [no] disable.
  set "CREATE_SYMBOL_REPORT=no"

  :: [no] keeps objects for incremental builds; [yes] removes the object cache after linking.
  set "DELETE_OBJECTS=no"

  :: [yes] display firmware and memory sizes; [no] hide them for applications.
  :: Bootloader builds measure only loadable bytes inside the reserved boot region.
  :: A low-address custom section is reported separately and is not charged to the boot region.
  set "SHOW_SIZE=yes"

  :: [yes] print complete compiler, linker, converter, and AVRDUDE commands.
  set "SHOW_COMMANDS=no"

::========== Exit Behavior =====================================================
:: Successful builds and uploads close automatically after five seconds.
:: Errors remain open until a key is pressed.


::#############################################################################
::### Fail-Safe Wrapper
::#############################################################################
:: The build engine runs in a child CMD process. A parser failure in the engine
:: still returns here, where the last completed stage is shown before pausing.

if /i "%~1"=="__FDX_AVR_ENGINE__" goto :EngineEntry

set "FDX_STATUS_FILE=%TEMP%\FDx_AVRC_Build_%RANDOM%_%RANDOM%.status"
>"%FDX_STATUS_FILE%" echo Starting child build engine

"%ComSpec%" /d /c call "%~f0" __FDX_AVR_ENGINE__ %*
set "FDX_WRAPPER_EXIT=%ERRORLEVEL%"

set "FDX_LAST_STAGE="
if exist "%FDX_STATUS_FILE%" set /p FDX_LAST_STAGE=<"%FDX_STATUS_FILE%"

if not "%FDX_WRAPPER_EXIT%"=="0" goto :WrapperFailure
if /i not "%FDX_LAST_STAGE%"=="SUCCESS" goto :WrapperIncomplete
goto :WrapperSuccess

:WrapperIncomplete
set "FDX_WRAPPER_EXIT=1"
echo.
echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
echo xxxxx                       Internal Script Failure                       xxxxx
echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
echo.
echo     The build engine ended before reporting completion.
if defined FDX_LAST_STAGE echo     Last stage: %FDX_LAST_STAGE%
echo     This indicates a CMD parser or batch-engine error.
echo.
echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
goto :WrapperPauseFailure

:WrapperFailure
if /i "%FDX_LAST_STAGE%"=="FAILURE_REPORTED" goto :WrapperPauseFailure
echo.
echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
echo xxxxx                       Internal Script Failure                       xxxxx
echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
echo.
echo     Build engine exit code: %FDX_WRAPPER_EXIT%
if defined FDX_LAST_STAGE echo     Last stage: %FDX_LAST_STAGE%
echo     No normal failure report was returned by the build engine.
echo.
echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

:WrapperPauseFailure
echo.
echo     Press any key to close this build window.
pause >nul
call :WrapperDeleteTemporaryFiles
endlocal & exit /b %FDX_WRAPPER_EXIT%

:WrapperSuccess
call :WrapperDeleteTemporaryFiles
echo.
timeout 5
endlocal & exit /b 0

:WrapperDeleteTemporaryFiles
if exist "%FDX_STATUS_FILE%.sources" del /q "%FDX_STATUS_FILE%.sources" >nul 2>&1
if exist "%FDX_STATUS_FILE%.compile" del /q "%FDX_STATUS_FILE%.compile" >nul 2>&1
if exist "%FDX_STATUS_FILE%.seen_source_plan" del /q "%FDX_STATUS_FILE%.seen_source_plan" >nul 2>&1
if exist "%FDX_STATUS_FILE%.seen_source_compile" del /q "%FDX_STATUS_FILE%.seen_source_compile" >nul 2>&1
if exist "%FDX_STATUS_FILE%.seen_link_plan" del /q "%FDX_STATUS_FILE%.seen_link_plan" >nul 2>&1
if exist "%FDX_STATUS_FILE%.seen_link_compile" del /q "%FDX_STATUS_FILE%.seen_link_compile" >nul 2>&1
if exist "%FDX_STATUS_FILE%" del /q "%FDX_STATUS_FILE%" >nul 2>&1
exit /b 0


::#############################################################################
::### Build Engine
::#############################################################################

:EngineEntry
set "SCRIPT_VERSION=1.3"
set "FINAL_EXIT_CODE=1"
set "FAIL_MESSAGE="
set "FAIL_EXIT_CODE="
set "FAIL_TITLE=Build Failed"
set "CURRENT_STAGE=engine startup"
set "PUSHD_ACTIVE=no"
set "SOURCE_DISPLAY_FILE=%FDX_STATUS_FILE%.sources"
set "COMPILE_DISPLAY_FILE=%FDX_STATUS_FILE%.compile"
set "SEEN_SOURCE_PLAN_FILE=%FDX_STATUS_FILE%.seen_source_plan"
set "SEEN_SOURCE_COMPILE_FILE=%FDX_STATUS_FILE%.seen_source_compile"
set "SEEN_LINK_PLAN_FILE=%FDX_STATUS_FILE%.seen_link_plan"
set "SEEN_LINK_COMPILE_FILE=%FDX_STATUS_FILE%.seen_link_compile"
set "NEED_BUILD_TOOLS=no"
set "NEED_C_COMPILER=no"
set "NEED_CPP_COMPILER=no"
set "NEED_OBJCOPY_TOOL=no"
set "NEED_SIZE_TOOL=no"
set "NEED_OBJDUMP_TOOL=no"
set "NEED_NM_TOOL=no"
set "NEED_OUTPUT_DIR=no"
set "NEED_AVRDUDE=no"
set "NEED_PROFILE_SELECTION=no"
set "NEED_FIRMWARE_NAMING=no"
set "NEED_LOCK_RESOLUTION=no"
call :WriteStage "%CURRENT_STAGE%"

set "PROJECT_DIR=%~dp0"
pushd "%PROJECT_DIR%" >nul 2>&1
if errorlevel 1 goto :ProjectDirectoryFailed
set "PUSHD_ACTIVE=yes"

for %%P in ("%CD%") do set "PROJECT_NAME=%%~nxP"
if not defined OUTPUT_NAME set "OUTPUT_NAME=%PROJECT_NAME%"

set "PROFILE_FOLDER=app"
set "PROFILE_DISPLAY=Application"
set "HEX_PREFIX=APP"
if /i "%BUILD_TYPE%"=="bootloader" set "PROFILE_FOLDER=boot"
if /i "%BUILD_TYPE%"=="bootloader" set "PROFILE_DISPLAY=Bootloader"
if /i "%BUILD_TYPE%"=="bootloader" set "HEX_PREFIX=BOOT"

for %%P in ("%OUTPUT_DIR%") do set "OUTPUT_ROOT_ABS=%%~fP"
set "OUTPUT_DIR_ABS=%OUTPUT_ROOT_ABS%\%PROFILE_FOLDER%"
set "OBJECT_ROOT=%OUTPUT_DIR_ABS%\obj"
set "OBJECT_LIST_FILE=%OUTPUT_DIR_ABS%\objects.rsp"
set "BUILD_SIGNATURE_FILE=%OUTPUT_DIR_ABS%\build_signature.txt"
set "BUILD_SIGNATURE_TEMP=%OUTPUT_DIR_ABS%\build_signature.tmp"
set "ELF_PATH=%OUTPUT_DIR_ABS%\%OUTPUT_NAME%.elf"
set "FIRMWARE_FILE_BASE=%HEX_PREFIX%_%OUTPUT_NAME%"
set "FIRMWARE_HEX_NAME=%FIRMWARE_FILE_BASE%.hex"
set "FIRMWARE_EEP_NAME=%FIRMWARE_FILE_BASE%.EEPROM.hex"
set "HEX_PATH=%OUTPUT_ROOT_ABS%\%FIRMWARE_HEX_NAME%"
set "EEP_PATH=%OUTPUT_ROOT_ABS%\%FIRMWARE_EEP_NAME%"
set "LSS_PATH=%OUTPUT_DIR_ABS%\%OUTPUT_NAME%.lss.txt"
set "MAP_PATH=%OUTPUT_DIR_ABS%\%OUTPUT_NAME%.map"
set "SYMBOL_PATH=%OUTPUT_DIR_ABS%\%OUTPUT_NAME%.symbols.txt"

set "ACTION=%~2"
if not defined ACTION set "ACTION=default"

if /i "%ACTION%"=="default" goto :ActionDefault
if /i "%ACTION%"=="build" goto :ActionBuild
if /i "%ACTION%"=="rebuild" goto :ActionRebuild
if /i "%ACTION%"=="clean" goto :ActionClean
if /i "%ACTION%"=="clean-all" goto :ActionCleanAll
if /i "%ACTION%"=="upload" goto :ActionUpload
if /i "%ACTION%"=="build-upload" goto :ActionBuildUpload
if /i "%ACTION%"=="verify" goto :ActionVerify
if /i "%ACTION%"=="probe" goto :ActionProbe
if /i "%ACTION%"=="size" goto :ActionSize
if /i "%ACTION%"=="lss" goto :ActionLss
if /i "%ACTION%"=="symbols" goto :ActionSymbols
if /i "%ACTION%"=="check" goto :ActionCheck
if /i "%ACTION%"=="list-mcus" goto :ActionListMcus
if /i "%ACTION%"=="list-parts" goto :ActionListParts
if /i "%ACTION%"=="list-programmers" goto :ActionListProgrammers
if /i "%ACTION%"=="help" goto :ShowHelp
if /i "%ACTION%"=="/?" goto :ShowHelp
if /i "%ACTION%"=="-h" goto :ShowHelp
if /i "%ACTION%"=="--help" goto :ShowHelp

set "FAIL_MESSAGE=Unknown action: %ACTION%"
goto :BuildFailed

:ProjectDirectoryFailed
set "FAIL_MESSAGE=Cannot open the project directory: %PROJECT_DIR%"
goto :BuildFailed

:ActionDefault
set "NEED_BUILD_TOOLS=yes"
set "NEED_OUTPUT_DIR=yes"
set "NEED_PROFILE_SELECTION=yes"
set "NEED_FIRMWARE_NAMING=yes"
set "RUN_UPLOAD=%AUTO_UPLOAD%"
if /i "%RUN_UPLOAD%"=="yes" set "NEED_AVRDUDE=yes"
if /i "%RUN_UPLOAD%"=="yes" set "NEED_LOCK_RESOLUTION=yes"
goto :BuildProject

:ActionBuild
set "NEED_BUILD_TOOLS=yes"
set "NEED_OUTPUT_DIR=yes"
set "NEED_PROFILE_SELECTION=yes"
set "NEED_FIRMWARE_NAMING=yes"
set "RUN_UPLOAD=no"
goto :BuildProject

:ActionBuildUpload
set "NEED_BUILD_TOOLS=yes"
set "NEED_OUTPUT_DIR=yes"
set "NEED_PROFILE_SELECTION=yes"
set "NEED_FIRMWARE_NAMING=yes"
set "NEED_LOCK_RESOLUTION=yes"
set "RUN_UPLOAD=yes"
set "NEED_AVRDUDE=yes"
goto :BuildProject

:ActionRebuild
call :ValidateChoice "%BUILD_TYPE%" "application bootloader" "BUILD_TYPE"
if errorlevel 1 goto :BuildFailed
call :SetStage "cleaning current build profile"
call :CleanCurrentProfile
if errorlevel 1 goto :BuildFailed
set "NEED_BUILD_TOOLS=yes"
set "NEED_OUTPUT_DIR=yes"
set "NEED_PROFILE_SELECTION=yes"
set "NEED_FIRMWARE_NAMING=yes"
set "RUN_UPLOAD=no"
set "RECOMPILE_ALL=yes"
goto :BuildProject

:ActionClean
call :ValidateChoice "%BUILD_TYPE%" "application bootloader" "BUILD_TYPE"
if errorlevel 1 goto :BuildFailed
call :SetStage "cleaning current build profile"
call :CleanCurrentProfile
if errorlevel 1 goto :BuildFailed
echo.
echo     Clean completed: %PROFILE_DISPLAY%
goto :FinishSuccess

:ActionCleanAll
call :SetStage "cleaning all output profiles"
call :CleanAllOutput
if errorlevel 1 goto :BuildFailed
echo.
echo     Clean completed: all output profiles
goto :FinishSuccess

:ActionUpload
set "NEED_AVRDUDE=yes"
set "NEED_PROFILE_SELECTION=yes"
set "NEED_FIRMWARE_NAMING=yes"
set "NEED_LOCK_RESOLUTION=yes"
call :SetStage "preparing existing firmware upload"
call :InitializeBuild
if errorlevel 1 goto :BuildFailed
call :PrintBuildHeader
call :UploadFirmware
if errorlevel 1 goto :BuildFailed
goto :FinishSuccess

:ActionVerify
set "NEED_AVRDUDE=yes"
set "NEED_PROFILE_SELECTION=yes"
set "NEED_FIRMWARE_NAMING=yes"
call :SetStage "preparing firmware verification"
call :InitializeBuild
if errorlevel 1 goto :BuildFailed
call :PrintBuildHeader
call :VerifyFirmware
if errorlevel 1 goto :BuildFailed
goto :FinishSuccess

:ActionProbe
set "NEED_AVRDUDE=yes"
call :SetStage "preparing device probe"
call :InitializeBuild
if errorlevel 1 goto :BuildFailed
call :PrintBuildHeader
call :ProbeDevice
if errorlevel 1 goto :BuildFailed
goto :FinishSuccess

:ActionSize
set "NEED_SIZE_TOOL=yes"
set "NEED_PROFILE_SELECTION=yes"
set "NEED_FIRMWARE_NAMING=yes"
call :SetStage "reading existing firmware size"
call :InitializeBuild
if errorlevel 1 goto :BuildFailed
call :PrintBuildHeader
if not exist "%ELF_PATH%" goto :ExistingElfMissing
call :ShowFirmwareSize
if errorlevel 1 goto :BuildFailed
goto :FinishSuccess

:ActionLss
set "NEED_OBJDUMP_TOOL=yes"
set "NEED_PROFILE_SELECTION=yes"
set "NEED_FIRMWARE_NAMING=yes"
call :SetStage "creating listing from existing ELF"
call :InitializeBuild
if errorlevel 1 goto :BuildFailed
call :PrintBuildHeader
if not exist "%ELF_PATH%" goto :ExistingElfMissing
call :CreateLss
if errorlevel 1 goto :BuildFailed
goto :FinishSuccess

:ActionSymbols
set "NEED_NM_TOOL=yes"
set "NEED_PROFILE_SELECTION=yes"
set "NEED_FIRMWARE_NAMING=yes"
call :SetStage "creating symbol report from existing ELF"
call :InitializeBuild
if errorlevel 1 goto :BuildFailed
call :PrintBuildHeader
if not exist "%ELF_PATH%" goto :ExistingElfMissing
call :CreateSymbolReport
if errorlevel 1 goto :BuildFailed
goto :FinishSuccess

:ActionCheck
set "NEED_C_COMPILER=yes"
set "NEED_AVRDUDE=yes"
set "NEED_PROFILE_SELECTION=yes"
set "NEED_FIRMWARE_NAMING=yes"
set "NEED_LOCK_RESOLUTION=yes"
call :SetStage "checking selected AVR configuration"
call :InitializeBuild
if errorlevel 1 goto :BuildFailed
call :PrintBuildHeader
call :CheckConfiguration
if errorlevel 1 goto :BuildFailed
goto :FinishSuccess

:ActionListMcus
call :SetStage "listing installed AVR-GCC MCU targets"
call :ListInstalledMcus
if errorlevel 1 goto :BuildFailed
goto :FinishSuccess

:ActionListParts
call :SetStage "listing installed AVRDUDE parts"
call :LocateAvrdude
if errorlevel 1 goto :BuildFailed
echo.
echo     AVRDUDE part IDs installed on this computer:
echo.
"%AVRDUDE_TOOL%" %AVRDUDE_CONFIG_OPTION% -p ?
goto :FinishSuccess

:ActionListProgrammers
call :SetStage "listing installed AVRDUDE programmers"
call :LocateAvrdude
if errorlevel 1 goto :BuildFailed
echo.
echo     AVRDUDE programmer IDs installed on this computer:
echo.
"%AVRDUDE_TOOL%" %AVRDUDE_CONFIG_OPTION% -c ?
goto :FinishSuccess

:BuildProject
set "NEED_C_COMPILER=yes"
set "NEED_CPP_COMPILER=yes"
set "NEED_OBJCOPY_TOOL=yes"
set "NEED_SIZE_TOOL=yes"
if /i "%CREATE_LSS%"=="yes" set "NEED_OBJDUMP_TOOL=yes"
if /i "%BUILD_TYPE%"=="bootloader" set "NEED_OBJDUMP_TOOL=yes"
if /i "%CREATE_SYMBOL_REPORT%"=="yes" set "NEED_NM_TOOL=yes"
call :SetStage "validating configuration and toolchain"
call :InitializeBuild
if errorlevel 1 goto :BuildFailed

call :PrintBuildHeader
call :RemoveStaleFirmwareFiles

call :SetStage "preparing incremental object cache"
call :PrepareObjectCache
if errorlevel 1 goto :BuildFailed

>"%OBJECT_LIST_FILE%" type nul
if errorlevel 1 goto :ObjectListCreateFailed
>"%SOURCE_DISPLAY_FILE%" type nul
if errorlevel 1 goto :SourceListCreateFailed
>"%COMPILE_DISPLAY_FILE%" type nul
if errorlevel 1 goto :CompileListCreateFailed
>"%SEEN_SOURCE_PLAN_FILE%" type nul
>"%SEEN_SOURCE_COMPILE_FILE%" type nul
>"%SEEN_LINK_PLAN_FILE%" type nul
>"%SEEN_LINK_COMPILE_FILE%" type nul

set /a SOURCE_ROOT_INDEX=0
set /a SOURCE_COUNT=0
set /a C_SOURCE_COUNT=0
set /a CPP_SOURCE_COUNT=0
set /a ASM_SOURCE_COUNT=0
set /a EXTERNAL_OBJECT_COUNT=0
set /a LINK_INPUT_COUNT=0
set /a COMPILED_OBJECT_COUNT=0
set /a REUSED_OBJECT_COUNT=0
set "HAS_CPP=0"
set "SOURCE_PHASE=plan"

call :SetStage "discovering source files"
call :ScanSourceList "%SOURCE_DIRS%"
if errorlevel 1 goto :BuildFailed

if /i "%LINK_EXTERNAL_OBJECTS%"=="yes" call :ScanExternalObjectList "%EXTERNAL_OBJECT_DIRS%"
if /i "%LINK_EXTERNAL_OBJECTS%"=="yes" if errorlevel 1 goto :BuildFailed

call :AddExplicitObjectList "%EXTRA_OBJECTS%"
if errorlevel 1 goto :BuildFailed

if "%LINK_INPUT_COUNT%"=="0" goto :NoLinkInputs

call :SelectLinker
if errorlevel 1 goto :BuildFailed
call :PrepareDisplayDetails

call :PrintCompileHeader
call :PrintSourceSummary

set /a SOURCE_ROOT_INDEX=0
set "SOURCE_PHASE=compile"
call :SetStage "compiling source files"
call :ScanSourceList "%SOURCE_DIRS%"
if errorlevel 1 goto :BuildFailed

if /i "%LINK_EXTERNAL_OBJECTS%"=="yes" call :ScanExternalObjectList "%EXTERNAL_OBJECT_DIRS%"
if /i "%LINK_EXTERNAL_OBJECTS%"=="yes" if errorlevel 1 goto :BuildFailed

call :AddExplicitObjectList "%EXTRA_OBJECTS%"
if errorlevel 1 goto :BuildFailed

call :PrintLinkHeader
call :SetStage "linking AVR ELF"
call :LinkFirmware
if errorlevel 1 goto :BuildFailed

call :PrintFirmwareFilesHeader
call :SetStage "creating firmware output files"
call :CreateFirmwareFiles
if errorlevel 1 goto :BuildFailed

if /i "%SHOW_SIZE%"=="yes" call :ShowFirmwareSize
if /i "%SHOW_SIZE%"=="no" if /i "%BUILD_TYPE%"=="bootloader" call :ShowFirmwareSize
if /i "%SHOW_SIZE%"=="yes" if errorlevel 1 goto :BuildFailed
if /i "%SHOW_SIZE%"=="no" if /i "%BUILD_TYPE%"=="bootloader" if errorlevel 1 goto :BuildFailed

if /i "%DELETE_OBJECTS%"=="yes" call :DeleteObjectCache
if exist "%OBJECT_LIST_FILE%" del /q "%OBJECT_LIST_FILE%" >nul 2>&1

if /i "%KEEP_ELF%"=="no" if exist "%ELF_PATH%" del /q "%ELF_PATH%" >nul 2>&1

echo.
echo *******************************************************************************
echo *****                     Build Completed Successfully                    *****
echo *******************************************************************************

if /i "%RUN_UPLOAD%"=="yes" call :SetStage "uploading firmware"
if /i "%RUN_UPLOAD%"=="yes" call :UploadFirmware
if /i "%RUN_UPLOAD%"=="yes" if errorlevel 1 goto :BuildFailed

goto :FinishSuccess

:ObjectListCreateFailed
set "FAIL_MESSAGE=Cannot create linker response file: %OBJECT_LIST_FILE%"
goto :BuildFailed

:SourceListCreateFailed
set "FAIL_MESSAGE=Cannot create temporary source display list."
goto :BuildFailed

:CompileListCreateFailed
set "FAIL_MESSAGE=Cannot create temporary compilation display list."
goto :BuildFailed

:NoLinkInputs
set "FAIL_MESSAGE=No compilable source or linkable object file was found."
goto :BuildFailed

:ExistingElfMissing
set "FAIL_MESSAGE=ELF file not found. Build the selected profile first: %ELF_PATH%"
goto :BuildFailed


::#############################################################################
::### Initialization and Configuration
::#############################################################################

:InitializeBuild
if /i "%NEED_PROFILE_SELECTION%"=="yes" call :ValidateChoice "%BUILD_TYPE%" "application bootloader" "BUILD_TYPE"
if /i "%NEED_PROFILE_SELECTION%"=="yes" if errorlevel 1 exit /b 1
if /i "%NEED_BUILD_TOOLS%"=="yes" call :ValidateChoice "%PROJECT_LANGUAGE%" "auto c cpp" "PROJECT_LANGUAGE"
if /i "%NEED_BUILD_TOOLS%"=="yes" if errorlevel 1 exit /b 1

if /i "%NEED_BUILD_TOOLS%"=="yes" call :ValidateBuildSettings
if /i "%NEED_BUILD_TOOLS%"=="yes" if errorlevel 1 exit /b 1
if /i "%NEED_AVRDUDE%"=="yes" call :ValidateUploadSettings
if /i "%NEED_AVRDUDE%"=="yes" if errorlevel 1 exit /b 1

call :ResolveMcuProfile
if errorlevel 1 exit /b 1
call :ResetLockState
if /i "%NEED_LOCK_RESOLUTION%"=="yes" call :ResolveLockMode
if /i "%NEED_LOCK_RESOLUTION%"=="yes" if errorlevel 1 exit /b 1
if /i "%NEED_FIRMWARE_NAMING%"=="yes" call :PrepareMcuFileTag
if /i "%NEED_FIRMWARE_NAMING%"=="yes" if errorlevel 1 exit /b 1
if /i "%NEED_FIRMWARE_NAMING%"=="yes" call :PrepareFirmwareFileNames
if /i "%NEED_FIRMWARE_NAMING%"=="yes" if errorlevel 1 exit /b 1
call :ConfigureToolchain
if errorlevel 1 exit /b 1
if /i "%NEED_BUILD_TOOLS%"=="yes" call :PrepareBuildOptions
if /i "%NEED_BUILD_TOOLS%"=="yes" if errorlevel 1 exit /b 1
if /i "%NEED_AVRDUDE%"=="yes" call :PrepareAvrdude
if /i "%NEED_AVRDUDE%"=="yes" if errorlevel 1 exit /b 1

if /i not "%NEED_OUTPUT_DIR%"=="yes" exit /b 0
if exist "%OUTPUT_DIR_ABS%\" exit /b 0
mkdir "%OUTPUT_DIR_ABS%" >nul 2>&1
if errorlevel 1 goto :OutputDirectoryCreateFailed
exit /b 0

:ValidateBuildSettings
call :ValidateChoice "%AUTO_UPLOAD%" "yes no" "AUTO_UPLOAD"
if errorlevel 1 exit /b 1
call :ValidateChoice "%RECOMPILE_ALL%" "yes no" "RECOMPILE_ALL"
if errorlevel 1 exit /b 1
call :ValidateChoice "%COMPILE_ASSEMBLY%" "yes no" "COMPILE_ASSEMBLY"
if errorlevel 1 exit /b 1
call :ValidateChoice "%LINK_EXTERNAL_OBJECTS%" "yes no" "LINK_EXTERNAL_OBJECTS"
if errorlevel 1 exit /b 1
call :ValidateChoice "%BOOT_NO_JUMP_TABLES%" "yes no" "BOOT_NO_JUMP_TABLES"
if errorlevel 1 exit /b 1
call :ValidateChoice "%KEEP_ELF%" "yes no" "KEEP_ELF"
if errorlevel 1 exit /b 1
call :ValidateChoice "%CREATE_LSS%" "yes no" "CREATE_LSS"
if errorlevel 1 exit /b 1
call :ValidateChoice "%CREATE_MAP_FILE%" "yes no" "CREATE_MAP_FILE"
if errorlevel 1 exit /b 1
call :ValidateChoice "%CREATE_EEPROM_FILE%" "yes no" "CREATE_EEPROM_FILE"
if errorlevel 1 exit /b 1
call :ValidateChoice "%CREATE_SYMBOL_REPORT%" "yes no" "CREATE_SYMBOL_REPORT"
if errorlevel 1 exit /b 1
call :ValidateChoice "%DELETE_OBJECTS%" "yes no" "DELETE_OBJECTS"
if errorlevel 1 exit /b 1
call :ValidateChoice "%SHOW_SIZE%" "yes no" "SHOW_SIZE"
if errorlevel 1 exit /b 1
call :ValidateChoice "%SHOW_COMMANDS%" "yes no" "SHOW_COMMANDS"
if errorlevel 1 exit /b 1
exit /b 0

:ValidateUploadSettings
call :ValidateChoice "%PROGRAMMER_CONNECTION%" "usb uart" "PROGRAMMER_CONNECTION"
if errorlevel 1 exit /b 1
call :ValidateChoice "%SERIAL_AUTO_RESET%" "auto yes no" "SERIAL_AUTO_RESET"
if errorlevel 1 exit /b 1
if /i "%ACTION%"=="upload" call :ValidateChoice "%APPLICATION_LOCK_MODE%" "unlocked bootProtect appProtect fullLock" "APPLICATION_LOCK_MODE"
if /i "%ACTION%"=="build-upload" call :ValidateChoice "%APPLICATION_LOCK_MODE%" "unlocked bootProtect appProtect fullLock" "APPLICATION_LOCK_MODE"
if /i "%ACTION%"=="default" call :ValidateChoice "%APPLICATION_LOCK_MODE%" "unlocked bootProtect appProtect fullLock" "APPLICATION_LOCK_MODE"
if /i "%ACTION%"=="check" call :ValidateChoice "%APPLICATION_LOCK_MODE%" "unlocked bootProtect appProtect fullLock" "APPLICATION_LOCK_MODE"
if errorlevel 1 exit /b 1
if /i not "%ACTION%"=="probe" call :ValidateChoice "%UPLOAD_EEPROM%" "no yes auto" "UPLOAD_EEPROM"
if /i not "%ACTION%"=="probe" if errorlevel 1 exit /b 1
call :ValidateChoice "%SHOW_COMMANDS%" "yes no" "SHOW_COMMANDS"
if errorlevel 1 exit /b 1
exit /b 0

:OutputDirectoryCreateFailed
set "FAIL_MESSAGE=Cannot create output directory: %OUTPUT_DIR_ABS%"
exit /b 1

:ValidateChoice
set "VALIDATE_VALUE=%~1"
set "VALIDATE_CHOICES=%~2"
set "VALIDATE_NAME=%~3"
for %%V in (%VALIDATE_CHOICES%) do if /i "%VALIDATE_VALUE%"=="%%V" exit /b 0
set "FAIL_MESSAGE=%VALIDATE_NAME% has an invalid value: %VALIDATE_VALUE%"
exit /b 1


::#############################################################################
::### MCU Profiles and Bootloader Layout
::#############################################################################

:ResolveMcuProfile
if /i "%MCU%"=="prompt" call :PromptMcu
if /i "%MCU%"=="prompt" if errorlevel 1 exit /b 1
if not defined MCU goto :McuMissing

set "MCU_DISPLAY=%MCU%"
set "PROFILE_AVRDUDE_PART="
set "PROFILE_FLASH_BYTES="
set "PROFILE_SRAM_BYTES="
set "PROFILE_EEPROM_BYTES="
set "PROFILE_BOOT_AUTO_SUPPORTED=no"
set "PROFILE_BOOT_SIZES="
set "PROFILE_LOCK_LAYOUT=unknown"

if /i "%MCU%"=="atmega8" goto :ProfileAtmega8
if /i "%MCU%"=="atmega48p" goto :ProfileAtmega48p
if /i "%MCU%"=="atmega88" goto :ProfileAtmega88
if /i "%MCU%"=="atmega88p" goto :ProfileAtmega88p
if /i "%MCU%"=="atmega168" goto :ProfileAtmega168
if /i "%MCU%"=="atmega168p" goto :ProfileAtmega168p
if /i "%MCU%"=="atmega328p" goto :ProfileAtmega328p
if /i "%MCU%"=="atmega16" goto :ProfileAtmega16
if /i "%MCU%"=="atmega32" goto :ProfileAtmega32
if /i "%MCU%"=="atmega64" goto :ProfileAtmega64
if /i "%MCU%"=="atmega128" goto :ProfileAtmega128
if /i "%MCU%"=="atmega169p" goto :ProfileAtmega169p
if /i "%MCU%"=="atmega644p" goto :ProfileAtmega644p
if /i "%MCU%"=="atmega1284p" goto :ProfileAtmega1284p
if /i "%MCU%"=="attiny10" goto :ProfileAttiny10
if /i "%MCU%"=="attiny13" goto :ProfileAttiny13
if /i "%MCU%"=="attiny13a" goto :ProfileAttiny13a
if /i "%MCU%"=="attiny24" goto :ProfileAttiny24
if /i "%MCU%"=="attiny44" goto :ProfileAttiny44
if /i "%MCU%"=="attiny84" goto :ProfileAttiny84
if /i "%MCU%"=="attiny25" goto :ProfileAttiny25
if /i "%MCU%"=="attiny45" goto :ProfileAttiny45
if /i "%MCU%"=="attiny85" goto :ProfileAttiny85
if /i "%MCU%"=="attiny2313" goto :ProfileAttiny2313
goto :ProfileResolved

:ProfileAtmega8
set "MCU=atmega8"
set "MCU_DISPLAY=ATmega8"
set "PROFILE_AVRDUDE_PART=m8"
set "PROFILE_FLASH_BYTES=8192"
set "PROFILE_SRAM_BYTES=1024"
set "PROFILE_EEPROM_BYTES=512"
goto :ProfileResolved

:ProfileAtmega48p
set "MCU=atmega48p"
set "MCU_DISPLAY=ATmega48P"
set "PROFILE_AVRDUDE_PART=m48p"
set "PROFILE_FLASH_BYTES=4096"
set "PROFILE_SRAM_BYTES=512"
set "PROFILE_EEPROM_BYTES=256"
goto :ProfileResolved

:ProfileAtmega88
set "MCU=atmega88"
set "MCU_DISPLAY=ATmega88"
set "PROFILE_AVRDUDE_PART=m88"
set "PROFILE_FLASH_BYTES=8192"
set "PROFILE_SRAM_BYTES=1024"
set "PROFILE_EEPROM_BYTES=512"
goto :ProfileResolved

:ProfileAtmega88p
set "MCU=atmega88p"
set "MCU_DISPLAY=ATmega88P"
set "PROFILE_AVRDUDE_PART=m88p"
set "PROFILE_FLASH_BYTES=8192"
set "PROFILE_SRAM_BYTES=1024"
set "PROFILE_EEPROM_BYTES=512"
goto :ProfileResolved

:ProfileAtmega168
set "MCU=atmega168"
set "MCU_DISPLAY=ATmega168"
set "PROFILE_AVRDUDE_PART=m168"
set "PROFILE_FLASH_BYTES=16384"
set "PROFILE_SRAM_BYTES=1024"
set "PROFILE_EEPROM_BYTES=512"
goto :ProfileResolved

:ProfileAtmega168p
set "MCU=atmega168p"
set "MCU_DISPLAY=ATmega168P"
set "PROFILE_AVRDUDE_PART=m168p"
set "PROFILE_FLASH_BYTES=16384"
set "PROFILE_SRAM_BYTES=1024"
set "PROFILE_EEPROM_BYTES=512"
goto :ProfileResolved

:ProfileAtmega328p
set "MCU=atmega328p"
set "MCU_DISPLAY=ATmega328P"
set "PROFILE_AVRDUDE_PART=m328p"
set "PROFILE_FLASH_BYTES=32768"
set "PROFILE_SRAM_BYTES=2048"
set "PROFILE_EEPROM_BYTES=1024"
goto :ProfileResolved

:ProfileAtmega16
set "MCU=atmega16"
set "MCU_DISPLAY=ATmega16"
set "PROFILE_AVRDUDE_PART=m16"
set "PROFILE_FLASH_BYTES=16384"
set "PROFILE_SRAM_BYTES=1024"
set "PROFILE_EEPROM_BYTES=512"
goto :ProfileResolved

:ProfileAtmega32
set "MCU=atmega32"
set "MCU_DISPLAY=ATmega32"
set "PROFILE_AVRDUDE_PART=m32"
set "PROFILE_FLASH_BYTES=32768"
set "PROFILE_SRAM_BYTES=2048"
set "PROFILE_EEPROM_BYTES=1024"
goto :ProfileResolved

:ProfileAtmega64
set "MCU=atmega64"
set "MCU_DISPLAY=ATmega64"
set "PROFILE_AVRDUDE_PART=m64"
set "PROFILE_FLASH_BYTES=65536"
set "PROFILE_SRAM_BYTES=4096"
set "PROFILE_EEPROM_BYTES=2048"
goto :ProfileResolved

:ProfileAtmega128
set "MCU=atmega128"
set "MCU_DISPLAY=ATmega128"
set "PROFILE_AVRDUDE_PART=m128"
set "PROFILE_FLASH_BYTES=131072"
set "PROFILE_SRAM_BYTES=4096"
set "PROFILE_EEPROM_BYTES=4096"
goto :ProfileResolved

:ProfileAtmega169p
set "MCU=atmega169p"
set "MCU_DISPLAY=ATmega169P"
set "PROFILE_AVRDUDE_PART=m169p"
set "PROFILE_FLASH_BYTES=16384"
set "PROFILE_SRAM_BYTES=1024"
set "PROFILE_EEPROM_BYTES=512"
goto :ProfileResolved

:ProfileAtmega644p
set "MCU=atmega644p"
set "MCU_DISPLAY=ATmega644P"
set "PROFILE_AVRDUDE_PART=m644p"
set "PROFILE_FLASH_BYTES=65536"
set "PROFILE_SRAM_BYTES=4096"
set "PROFILE_EEPROM_BYTES=2048"
goto :ProfileResolved

:ProfileAtmega1284p
set "MCU=atmega1284p"
set "MCU_DISPLAY=ATmega1284P"
set "PROFILE_AVRDUDE_PART=m1284p"
set "PROFILE_FLASH_BYTES=131072"
set "PROFILE_SRAM_BYTES=16384"
set "PROFILE_EEPROM_BYTES=4096"
goto :ProfileResolved

:ProfileAttiny10
set "MCU=attiny10"
set "MCU_DISPLAY=ATtiny10"
set "PROFILE_AVRDUDE_PART=t10"
set "PROFILE_FLASH_BYTES=1024"
set "PROFILE_SRAM_BYTES=32"
set "PROFILE_EEPROM_BYTES=0"
goto :ProfileResolved

:ProfileAttiny13
set "MCU=attiny13"
set "MCU_DISPLAY=ATtiny13"
set "PROFILE_AVRDUDE_PART=t13"
set "PROFILE_FLASH_BYTES=1024"
set "PROFILE_SRAM_BYTES=64"
set "PROFILE_EEPROM_BYTES=64"
goto :ProfileResolved

:ProfileAttiny13a
set "MCU=attiny13a"
set "MCU_DISPLAY=ATtiny13A"
set "PROFILE_AVRDUDE_PART=t13a"
set "PROFILE_FLASH_BYTES=1024"
set "PROFILE_SRAM_BYTES=64"
set "PROFILE_EEPROM_BYTES=64"
goto :ProfileResolved

:ProfileAttiny24
set "MCU=attiny24"
set "MCU_DISPLAY=ATtiny24"
set "PROFILE_AVRDUDE_PART=t24"
set "PROFILE_FLASH_BYTES=2048"
set "PROFILE_SRAM_BYTES=128"
set "PROFILE_EEPROM_BYTES=128"
goto :ProfileResolved

:ProfileAttiny44
set "MCU=attiny44"
set "MCU_DISPLAY=ATtiny44"
set "PROFILE_AVRDUDE_PART=t44"
set "PROFILE_FLASH_BYTES=4096"
set "PROFILE_SRAM_BYTES=256"
set "PROFILE_EEPROM_BYTES=256"
goto :ProfileResolved

:ProfileAttiny84
set "MCU=attiny84"
set "MCU_DISPLAY=ATtiny84"
set "PROFILE_AVRDUDE_PART=t84"
set "PROFILE_FLASH_BYTES=8192"
set "PROFILE_SRAM_BYTES=512"
set "PROFILE_EEPROM_BYTES=512"
goto :ProfileResolved

:ProfileAttiny25
set "MCU=attiny25"
set "MCU_DISPLAY=ATtiny25"
set "PROFILE_AVRDUDE_PART=t25"
set "PROFILE_FLASH_BYTES=2048"
set "PROFILE_SRAM_BYTES=128"
set "PROFILE_EEPROM_BYTES=128"
goto :ProfileResolved

:ProfileAttiny45
set "MCU=attiny45"
set "MCU_DISPLAY=ATtiny45"
set "PROFILE_AVRDUDE_PART=t45"
set "PROFILE_FLASH_BYTES=4096"
set "PROFILE_SRAM_BYTES=256"
set "PROFILE_EEPROM_BYTES=256"
goto :ProfileResolved

:ProfileAttiny85
set "MCU=attiny85"
set "MCU_DISPLAY=ATtiny85"
set "PROFILE_AVRDUDE_PART=t85"
set "PROFILE_FLASH_BYTES=8192"
set "PROFILE_SRAM_BYTES=512"
set "PROFILE_EEPROM_BYTES=512"
goto :ProfileResolved

:ProfileAttiny2313
set "MCU=attiny2313"
set "MCU_DISPLAY=ATtiny2313"
set "PROFILE_AVRDUDE_PART=t2313"
set "PROFILE_FLASH_BYTES=2048"
set "PROFILE_SRAM_BYTES=128"
set "PROFILE_EEPROM_BYTES=128"
goto :ProfileResolved

:ProfileResolved
call :ApplyClassicProfileCapabilities

set "FLASH_BYTES_EFFECTIVE=%FLASH_SIZE_BYTES%"
if not defined FLASH_BYTES_EFFECTIVE set "FLASH_BYTES_EFFECTIVE=%PROFILE_FLASH_BYTES%"
set "SRAM_BYTES_EFFECTIVE=%SRAM_SIZE_BYTES%"
if not defined SRAM_BYTES_EFFECTIVE set "SRAM_BYTES_EFFECTIVE=%PROFILE_SRAM_BYTES%"
set "EEPROM_BYTES_EFFECTIVE=%EEPROM_SIZE_BYTES%"
if not defined EEPROM_BYTES_EFFECTIVE set "EEPROM_BYTES_EFFECTIVE=%PROFILE_EEPROM_BYTES%"

set "AVRDUDE_PART_EFFECTIVE=%AVRDUDE_PART%"
if /i "%AVRDUDE_PART_EFFECTIVE%"=="auto" set "AVRDUDE_PART_EFFECTIVE=%PROFILE_AVRDUDE_PART%"

if /i "%BUILD_TYPE%"=="bootloader" if /i "%NEED_BUILD_TOOLS%"=="yes" call :PrepareBootloaderLayout
if /i "%BUILD_TYPE%"=="bootloader" if /i "%NEED_BUILD_TOOLS%"=="yes" if errorlevel 1 exit /b 1
if /i "%BUILD_TYPE%"=="bootloader" if /i "%ACTION%"=="check" call :PrepareBootloaderLayout
if /i "%BUILD_TYPE%"=="bootloader" if /i "%ACTION%"=="check" if errorlevel 1 exit /b 1
exit /b 0

:ApplyClassicProfileCapabilities
if /i "%MCU%"=="atmega8" goto :ClassicBoot512To4096
if /i "%MCU%"=="atmega88" goto :ClassicBoot256To2048
if /i "%MCU%"=="atmega88p" goto :ClassicBoot256To2048
if /i "%MCU%"=="atmega168" goto :ClassicBoot512To4096
if /i "%MCU%"=="atmega168p" goto :ClassicBoot512To4096
if /i "%MCU%"=="atmega328p" goto :ClassicBoot512To4096
if /i "%MCU%"=="atmega16" goto :ClassicBoot512To4096
if /i "%MCU%"=="atmega32" goto :ClassicBoot512To4096
if /i "%MCU%"=="atmega64" goto :ClassicBoot1024To8192
if /i "%MCU%"=="atmega128" goto :ClassicBoot1024To8192
if /i "%MCU%"=="atmega169p" goto :ClassicBoot512To4096
if /i "%MCU%"=="atmega644p" goto :ClassicBoot512To4096
if /i "%MCU%"=="atmega1284p" goto :ClassicBoot512To4096
exit /b 0

:ClassicBoot256To2048
set "PROFILE_BOOT_AUTO_SUPPORTED=yes"
set "PROFILE_BOOT_SIZES=256 512 1024 2048"
set "PROFILE_LOCK_LAYOUT=classic"
exit /b 0

:ClassicBoot512To4096
set "PROFILE_BOOT_AUTO_SUPPORTED=yes"
set "PROFILE_BOOT_SIZES=512 1024 2048 4096"
set "PROFILE_LOCK_LAYOUT=classic"
exit /b 0

:ClassicBoot1024To8192
set "PROFILE_BOOT_AUTO_SUPPORTED=yes"
set "PROFILE_BOOT_SIZES=1024 2048 4096 8192"
set "PROFILE_LOCK_LAYOUT=classic"
exit /b 0

:McuMissing
set "FAIL_MESSAGE=MCU cannot be blank. Enter an avr-gcc device name or use prompt."
exit /b 1

:PromptMcu
echo.
echo     Common 8-bit AVR devices:
echo.
echo     1  ATmega8          4  ATtiny13         7  ATmega128
echo     2  ATmega88         5  ATmega16         8  ATmega169P
echo     3  ATmega328P       6  ATmega32         9  Custom
echo.
choice /n /c 123456789 /m "Select an MCU: "
if errorlevel 9 goto :PromptMcuCustom
if errorlevel 8 goto :PromptMcuAtmega169p
if errorlevel 7 goto :PromptMcuAtmega128
if errorlevel 6 goto :PromptMcuAtmega32
if errorlevel 5 goto :PromptMcuAtmega16
if errorlevel 4 goto :PromptMcuAttiny13
if errorlevel 3 goto :PromptMcuAtmega328p
if errorlevel 2 goto :PromptMcuAtmega88
if errorlevel 1 goto :PromptMcuAtmega8
exit /b 1

:PromptMcuAtmega169p
set "MCU=atmega169p"
exit /b 0

:PromptMcuAtmega128
set "MCU=atmega128"
exit /b 0

:PromptMcuAtmega32
set "MCU=atmega32"
exit /b 0

:PromptMcuAtmega16
set "MCU=atmega16"
exit /b 0

:PromptMcuAttiny13
set "MCU=attiny13"
exit /b 0

:PromptMcuAtmega328p
set "MCU=atmega328p"
exit /b 0

:PromptMcuAtmega88
set "MCU=atmega88"
exit /b 0

:PromptMcuAtmega8
set "MCU=atmega8"
exit /b 0

:PromptMcuCustom
set "MCU="
set /p "MCU=Enter the avr-gcc MCU name: "
if not defined MCU exit /b 1
exit /b 0

:PrepareBootloaderLayout
if not defined BOOTLOADER_SIZE_BYTES goto :BootSizeMissing
set /a BOOT_SIZE_TEST=%BOOTLOADER_SIZE_BYTES% >nul 2>&1
if errorlevel 1 goto :BootSizeInvalid
if %BOOT_SIZE_TEST% LEQ 0 goto :BootSizeInvalid
if defined PROFILE_BOOT_SIZES call :ValidateProfileBootSize
if defined PROFILE_BOOT_SIZES if errorlevel 1 exit /b 1

if /i not "%BOOT_START_ADDRESS%"=="auto" goto :ManualBootAddress
if /i not "%PROFILE_BOOT_AUTO_SUPPORTED%"=="yes" goto :BootAutoUnsupported
if not defined FLASH_BYTES_EFFECTIVE goto :BootFlashSizeMissing
set /a BOOT_START_DEC=%FLASH_BYTES_EFFECTIVE%-%BOOTLOADER_SIZE_BYTES% >nul 2>&1
if errorlevel 1 goto :BootLayoutInvalid
if %BOOT_START_DEC% LSS 0 goto :BootLayoutInvalid
call :FormatHexAddress "%BOOT_START_DEC%" BOOT_START_DISPLAY
if errorlevel 1 goto :BootAddressFormatFailed
set "BOOT_START_LINK=%BOOT_START_DISPLAY%"
exit /b 0

:ManualBootAddress
set /a BOOT_START_DEC=%BOOT_START_ADDRESS% >nul 2>&1
if errorlevel 1 goto :BootAddressInvalid
if %BOOT_START_DEC% LSS 0 goto :BootAddressInvalid
call :FormatHexAddress "%BOOT_START_DEC%" BOOT_START_DISPLAY
if errorlevel 1 goto :BootAddressFormatFailed
set "BOOT_START_LINK=%BOOT_START_DISPLAY%"
if defined FLASH_BYTES_EFFECTIVE if %BOOT_START_DEC% GEQ %FLASH_BYTES_EFFECTIVE% goto :BootAddressOutsideFlash
if defined FLASH_BYTES_EFFECTIVE set /a BOOT_END_DEC=%BOOT_START_DEC%+%BOOTLOADER_SIZE_BYTES% >nul 2>&1
if defined FLASH_BYTES_EFFECTIVE if %BOOT_END_DEC% GTR %FLASH_BYTES_EFFECTIVE% goto :BootRegionOutsideFlash
exit /b 0

:ValidateProfileBootSize
for %%S in (%PROFILE_BOOT_SIZES%) do if "%BOOTLOADER_SIZE_BYTES%"=="%%S" exit /b 0
set "FAIL_MESSAGE=BOOTLOADER_SIZE_BYTES %BOOTLOADER_SIZE_BYTES% is not in the verified list for %MCU_DISPLAY%: %PROFILE_BOOT_SIZES%"
exit /b 1

:BootAutoUnsupported
set "FAIL_MESSAGE=Automatic bootloader placement is not verified for %MCU_DISPLAY%. Enter BOOT_START_ADDRESS manually."
exit /b 1

:FormatHexAddress
set "FDX_HEX_RESULT="
where powershell.exe >nul 2>&1
if errorlevel 1 exit /b 1
for /f "delims=" %%H in ('powershell.exe -NoProfile -Command "'0x{0:X}' -f [int64]%~1" 2^>nul') do set "FDX_HEX_RESULT=%%H"
if not defined FDX_HEX_RESULT exit /b 1
set "%~2=%FDX_HEX_RESULT%"
set "FDX_HEX_RESULT="
exit /b 0

:BootAddressFormatFailed
set "FAIL_MESSAGE=Could not format the bootloader start address as hexadecimal. PowerShell is required for bootloader placement."
exit /b 1

:BootSizeMissing
set "FAIL_MESSAGE=BOOTLOADER_SIZE_BYTES cannot be blank in bootloader mode."
exit /b 1

:BootSizeInvalid
set "FAIL_MESSAGE=BOOTLOADER_SIZE_BYTES must be a positive integer: %BOOTLOADER_SIZE_BYTES%"
exit /b 1

:BootFlashSizeMissing
set "FAIL_MESSAGE=Automatic boot address requires known flash capacity. Set FLASH_SIZE_BYTES or BOOT_START_ADDRESS."
exit /b 1

:BootLayoutInvalid
set "FAIL_MESSAGE=Bootloader size is larger than the configured flash capacity."
exit /b 1

:BootAddressInvalid
set "FAIL_MESSAGE=BOOT_START_ADDRESS is not a valid decimal or hexadecimal address: %BOOT_START_ADDRESS%"
exit /b 1

:BootAddressOutsideFlash
set "FAIL_MESSAGE=BOOT_START_ADDRESS is outside the configured flash capacity: %BOOT_START_ADDRESS%"
exit /b 1

:BootRegionOutsideFlash
set "FAIL_MESSAGE=The configured bootloader region extends beyond the device flash capacity."
exit /b 1


::#############################################################################
::### Firmware Naming
::#############################################################################

:PrepareMcuFileTag
set "MCU_FILE_TAG=%MCU%"
if /i "%MCU:~0,6%"=="atmega" set "MCU_FILE_TAG=Atmega%MCU:~6%"
if /i "%MCU:~0,6%"=="attiny" set "MCU_FILE_TAG=Attiny%MCU:~6%"
if /i "%MCU:~0,7%"=="atxmega" set "MCU_FILE_TAG=Atxmega%MCU:~7%"
if /i "%MCU:~0,4%"=="at90" set "MCU_FILE_TAG=AT90%MCU:~4%"
if /i "%MCU:~0,3%"=="ata" set "MCU_FILE_TAG=ATA%MCU:~3%"
if /i "%MCU:~0,3%"=="avr" set "MCU_FILE_TAG=AVR%MCU:~3%"
exit /b 0

:PrepareFirmwareFileNames
set "FIRMWARE_FILE_BASE=%HEX_PREFIX%_%OUTPUT_NAME%"
set "FIRMWARE_FILE_BASE=%FIRMWARE_FILE_BASE%_%MCU_FILE_TAG%"
set "FIRMWARE_HEX_NAME=%FIRMWARE_FILE_BASE%.hex"
set "FIRMWARE_EEP_NAME=%FIRMWARE_FILE_BASE%.EEPROM.hex"
set "HEX_PATH=%OUTPUT_ROOT_ABS%\%FIRMWARE_HEX_NAME%"
set "EEP_PATH=%OUTPUT_ROOT_ABS%\%FIRMWARE_EEP_NAME%"
exit /b 0

::#############################################################################
::### Toolchain and Option Preparation
::#############################################################################

:ConfigureToolchain
call :SetAvrToolPath "avr-gcc.exe" C_COMPILER
call :SetAvrToolPath "avr-g++.exe" CPP_COMPILER
call :SetAvrToolPath "avr-objcopy.exe" OBJCOPY_TOOL
call :SetAvrToolPath "avr-objdump.exe" OBJDUMP_TOOL
call :SetAvrToolPath "avr-size.exe" SIZE_TOOL
call :SetAvrToolPath "avr-nm.exe" NM_TOOL
call :SetAvrToolPath "avr-readelf.exe" READELF_TOOL
call :SetAvrToolPath "avr-ar.exe" AR_TOOL
call :SetAvrToolPath "avr-ranlib.exe" RANLIB_TOOL
call :SetAvrToolPath "avr-gdb.exe" GDB_TOOL

if /i "%NEED_BUILD_TOOLS%"=="yes" set "NEED_C_COMPILER=yes"
if /i "%NEED_BUILD_TOOLS%"=="yes" set "NEED_CPP_COMPILER=yes"
if /i "%NEED_BUILD_TOOLS%"=="yes" set "NEED_OBJCOPY_TOOL=yes"
if /i "%NEED_BUILD_TOOLS%"=="yes" set "NEED_SIZE_TOOL=yes"

if /i "%NEED_C_COMPILER%"=="yes" call :RequireAvrTool "%C_COMPILER%" "AVR C compiler"
if /i "%NEED_C_COMPILER%"=="yes" if errorlevel 1 exit /b 1
if /i "%NEED_CPP_COMPILER%"=="yes" call :RequireAvrTool "%CPP_COMPILER%" "AVR C++ compiler"
if /i "%NEED_CPP_COMPILER%"=="yes" if errorlevel 1 exit /b 1
if /i "%NEED_OBJCOPY_TOOL%"=="yes" call :RequireAvrTool "%OBJCOPY_TOOL%" "AVR object converter"
if /i "%NEED_OBJCOPY_TOOL%"=="yes" if errorlevel 1 exit /b 1
if /i "%NEED_SIZE_TOOL%"=="yes" call :RequireAvrTool "%SIZE_TOOL%" "AVR size utility"
if /i "%NEED_SIZE_TOOL%"=="yes" if errorlevel 1 exit /b 1
if /i "%NEED_OBJDUMP_TOOL%"=="yes" call :RequireAvrTool "%OBJDUMP_TOOL%" "AVR object-dump utility"
if /i "%NEED_OBJDUMP_TOOL%"=="yes" if errorlevel 1 exit /b 1
if /i "%NEED_NM_TOOL%"=="yes" call :RequireAvrTool "%NM_TOOL%" "AVR symbol utility"
if /i "%NEED_NM_TOOL%"=="yes" if errorlevel 1 exit /b 1

set "COMPILER_VERSION="
set "COMPILER_TARGET="
set "TOOLCHAIN_DISPLAY=AVR GCC - not required for this action"
call :CheckAvrToolAvailable "%C_COMPILER%"
if /i "%AVR_TOOL_AVAILABLE%"=="yes" for /f "delims=" %%V in ('"%C_COMPILER%" -dumpfullversion -dumpversion 2^>nul') do if not defined COMPILER_VERSION set "COMPILER_VERSION=%%V"
if /i "%AVR_TOOL_AVAILABLE%"=="yes" for /f "delims=" %%V in ('"%C_COMPILER%" -dumpmachine 2^>nul') do if not defined COMPILER_TARGET set "COMPILER_TARGET=%%V"
if defined COMPILER_VERSION set "TOOLCHAIN_DISPLAY=AVR GCC %COMPILER_VERSION%"
if /i "%AVR_TOOL_AVAILABLE%"=="yes" if not defined COMPILER_VERSION set "TOOLCHAIN_DISPLAY=AVR GCC"

set "POWERSHELL_TOOL="
if /i not "%NEED_BUILD_TOOLS%"=="yes" exit /b 0
where powershell.exe >nul 2>&1
if not errorlevel 1 set "POWERSHELL_TOOL=powershell.exe"
if defined POWERSHELL_TOOL exit /b 0
where pwsh.exe >nul 2>&1
if not errorlevel 1 set "POWERSHELL_TOOL=pwsh.exe"
exit /b 0

:CheckAvrToolAvailable
set "AVR_TOOL_AVAILABLE=no"
if defined AVR_TOOLCHAIN_BIN if exist "%~1" set "AVR_TOOL_AVAILABLE=yes"
if defined AVR_TOOLCHAIN_BIN exit /b 0
where "%~1" >nul 2>&1
if not errorlevel 1 set "AVR_TOOL_AVAILABLE=yes"
exit /b 0

:SetAvrToolPath
if not defined AVR_TOOLCHAIN_BIN goto :SetAvrToolFromPath
set "%~2=%AVR_TOOLCHAIN_BIN%\%~1"
exit /b 0

:SetAvrToolFromPath
set "%~2=%~1"
exit /b 0

:RequireAvrTool
if defined AVR_TOOLCHAIN_BIN goto :RequireAvrToolFile
where "%~1" >nul 2>&1
if not errorlevel 1 exit /b 0
set "FAIL_MESSAGE=Missing %~2 on Windows PATH: %~1"
exit /b 1

:RequireAvrToolFile
if exist "%~1" exit /b 0
set "FAIL_MESSAGE=Missing %~2: %~1"
exit /b 1

:PrepareBuildOptions
set "C_STANDARD_OPTION="
set "CPP_STANDARD_OPTION="
if defined C_STANDARD set "C_STANDARD_OPTION=-std=%C_STANDARD%"
if defined CPP_STANDARD set "CPP_STANDARD_OPTION=-std=%CPP_STANDARD%"

set "DEFINE_OPTIONS="
call :AppendDefineList "%DEFINES%"

set "INCLUDE_OPTIONS="
call :AppendIncludeList "%INCLUDE_DIRS%"

set "LIBRARY_DIR_OPTIONS="
call :AppendLibraryDirectoryList "%LIBRARY_DIRS%"

set "LIBRARY_OPTIONS="
call :AppendLibraryList "%LIBRARIES%"

set "PROFILE_COMPILE_OPTIONS=%APPLICATION_COMPILE_OPTIONS%"
set "PROFILE_LINK_OPTIONS=%APPLICATION_LINK_OPTIONS%"
if /i "%BUILD_TYPE%"=="bootloader" set "PROFILE_COMPILE_OPTIONS=%BOOT_COMPILE_OPTIONS%"
if /i "%BUILD_TYPE%"=="bootloader" set "PROFILE_LINK_OPTIONS=%BOOT_LINK_OPTIONS%"
if /i "%BUILD_TYPE%"=="bootloader" if /i "%BOOT_NO_JUMP_TABLES%"=="yes" set "PROFILE_COMPILE_OPTIONS=%PROFILE_COMPILE_OPTIONS% -fno-jump-tables"
if /i "%BUILD_TYPE%"=="bootloader" set "PROFILE_LINK_OPTIONS=%PROFILE_LINK_OPTIONS% -Wl,--section-start=.text=%BOOT_START_LINK%"

if /i not "%BUILD_TYPE%"=="bootloader" if defined CUSTOM_SECTION_NAME if defined CUSTOM_SECTION_ADDRESS set "PROFILE_LINK_OPTIONS=%PROFILE_LINK_OPTIONS% -Wl,--section-start=%CUSTOM_SECTION_NAME%=%CUSTOM_SECTION_ADDRESS%"
exit /b 0

:AppendDefineList
if "%~1"=="" exit /b 0
for /f "tokens=1* delims=;" %%A in ("%~1") do (
    call :AppendDefine "%%~A"
    call :AppendDefineList "%%~B"
)
exit /b 0

:AppendDefine
if "%~1"=="" exit /b 0
set "DEFINE_OPTIONS=%DEFINE_OPTIONS% -D%~1"
exit /b 0

:AppendIncludeList
if "%~1"=="" exit /b 0
for /f "tokens=1* delims=;" %%A in ("%~1") do (
    call :AppendInclude "%%~A"
    call :AppendIncludeList "%%~B"
)
exit /b 0

:AppendInclude
if "%~1"=="" exit /b 0
set "INCLUDE_OPTIONS=%INCLUDE_OPTIONS% -I"%~1""
exit /b 0

:AppendLibraryDirectoryList
if "%~1"=="" exit /b 0
for /f "tokens=1* delims=;" %%A in ("%~1") do (
    call :AppendLibraryDirectory "%%~A"
    call :AppendLibraryDirectoryList "%%~B"
)
exit /b 0

:AppendLibraryDirectory
if "%~1"=="" exit /b 0
set "LIBRARY_DIR_OPTIONS=%LIBRARY_DIR_OPTIONS% -L"%~1""
exit /b 0

:AppendLibraryList
if "%~1"=="" exit /b 0
for /f "tokens=1* delims=;" %%A in ("%~1") do (
    call :AppendLibrary "%%~A"
    call :AppendLibraryList "%%~B"
)
exit /b 0

:AppendLibrary
if "%~1"=="" exit /b 0
set "LIBRARY_OPTIONS=%LIBRARY_OPTIONS% -l%~1"
exit /b 0

:: Resolve the named classic-AVR lock mode into the byte written by AVRDUDE.
:ResetLockState
set "LOCK_MODE_EFFECTIVE=unlocked"
set "LOCK_MODE_DISPLAY=Not evaluated for this action"
set "LOCK_VALUE_EFFECTIVE="
set "LOCK_WRITE_REQUIRED=no"
set "LOCK_WRITE_SAFE=yes"
exit /b 0

:ResolveLockMode
call :ResetLockState
if /i "%BUILD_TYPE%"=="bootloader" set "LOCK_MODE_EFFECTIVE=bootProtect"
if /i not "%BUILD_TYPE%"=="bootloader" set "LOCK_MODE_EFFECTIVE=%APPLICATION_LOCK_MODE%"

if /i "%LOCK_MODE_EFFECTIVE%"=="unlocked" goto :LockModeUnlocked
if /i "%LOCK_MODE_EFFECTIVE%"=="bootProtect" set "LOCK_MODE_DISPLAY=Bootloader Write-Protection"
if /i "%LOCK_MODE_EFFECTIVE%"=="appProtect" set "LOCK_MODE_DISPLAY=Application Section Protection"
if /i "%LOCK_MODE_EFFECTIVE%"=="fullLock" set "LOCK_MODE_DISPLAY=Full Lock-Down"
if not defined LOCK_MODE_DISPLAY goto :LockModeInvalid
set "LOCK_WRITE_REQUIRED=yes"

if /i not "%PROFILE_LOCK_LAYOUT%"=="classic" goto :LockModeUnverified
if /i "%LOCK_MODE_EFFECTIVE%"=="bootProtect" set "LOCK_VALUE_EFFECTIVE=0xEF"
if /i "%LOCK_MODE_EFFECTIVE%"=="appProtect" set "LOCK_VALUE_EFFECTIVE=0xFB"
if /i "%LOCK_MODE_EFFECTIVE%"=="fullLock" set "LOCK_VALUE_EFFECTIVE=0xC0"
exit /b 0

:LockModeUnlocked
set "LOCK_MODE_DISPLAY=Fully Unlocked - no lock write"
set "LOCK_WRITE_REQUIRED=no"
exit /b 0

:LockModeUnverified
set "LOCK_WRITE_SAFE=no"
exit /b 0

:LockModeInvalid
set "FAIL_MESSAGE=Unsupported lock mode: %LOCK_MODE_EFFECTIVE%"
exit /b 1

:LocateAvrdude
set "AVRDUDE_TOOL="
set "AVRDUDE_CONFIG_OPTION="
if defined AVRDUDE_DIR set "AVRDUDE_TOOL=%AVRDUDE_DIR%\avrdude.exe"
if not defined AVRDUDE_DIR set "AVRDUDE_TOOL=avrdude.exe"
if defined AVRDUDE_DIR if not exist "%AVRDUDE_TOOL%" goto :AvrdudeMissing
if not defined AVRDUDE_DIR where "%AVRDUDE_TOOL%" >nul 2>&1
if not defined AVRDUDE_DIR if errorlevel 1 goto :AvrdudeMissing

if not defined AVRDUDE_CONF if defined AVRDUDE_DIR if exist "%AVRDUDE_DIR%\avrdude.conf" set "AVRDUDE_CONF=%AVRDUDE_DIR%\avrdude.conf"
if defined AVRDUDE_CONF if not exist "%AVRDUDE_CONF%" goto :AvrdudeConfMissing
if defined AVRDUDE_CONF set "AVRDUDE_CONFIG_OPTION=-C "%AVRDUDE_CONF%""
exit /b 0

:PrepareAvrdude
set "AVRDUDE_BASE_OPTIONS="
if /i not "%NEED_AVRDUDE%"=="yes" exit /b 0
call :LocateAvrdude
if errorlevel 1 exit /b 1
if not defined AVRDUDE_PART_EFFECTIVE if /i "%AVRDUDE_PART%"=="auto" call :ResolveAvrdudePartFromInstalledList
if not defined AVRDUDE_PART_EFFECTIVE goto :AvrdudePartMissing
if not defined PROGRAMMER goto :ProgrammerMissing

call :ResolveProgrammerConnection
if errorlevel 1 exit /b 1
set "AVRDUDE_BASE_OPTIONS=%AVRDUDE_CONFIG_OPTION% -p %AVRDUDE_PART_EFFECTIVE% -c %PROGRAMMER%"
if defined PROGRAMMER_PORT_EFFECTIVE set "AVRDUDE_BASE_OPTIONS=%AVRDUDE_BASE_OPTIONS% -P %PROGRAMMER_PORT_EFFECTIVE%"
if defined PROGRAMMER_BAUD_EFFECTIVE set "AVRDUDE_BASE_OPTIONS=%AVRDUDE_BASE_OPTIONS% -b %PROGRAMMER_BAUD_EFFECTIVE%"
if defined AVRDUDE_OPTIONS set "AVRDUDE_BASE_OPTIONS=%AVRDUDE_BASE_OPTIONS% %AVRDUDE_OPTIONS%"

set "EFFECTIVE_SERIAL_RESET=no"
if /i "%SERIAL_AUTO_RESET%"=="yes" set "EFFECTIVE_SERIAL_RESET=yes"
if /i "%SERIAL_AUTO_RESET%"=="auto" if /i "%PROGRAMMER%"=="butterfly" set "EFFECTIVE_SERIAL_RESET=yes"
if /i "%SERIAL_AUTO_RESET%"=="auto" if /i "%PROGRAMMER%"=="avr109" set "EFFECTIVE_SERIAL_RESET=yes"
exit /b 0

:ResolveProgrammerConnection
set "PROGRAMMER_CONNECTION_DISPLAY=USB"
set "PROGRAMMER_PORT_EFFECTIVE="
set "PROGRAMMER_BAUD_EFFECTIVE="
if /i "%PROGRAMMER_CONNECTION%"=="usb" exit /b 0
set "PROGRAMMER_CONNECTION_DISPLAY=UART"
if not defined PROGRAMMER_PORT goto :ProgrammerPortMissing
if not defined PROGRAMMER_BAUD goto :ProgrammerBaudMissing
set "PROGRAMMER_PORT_EFFECTIVE=%PROGRAMMER_PORT%"
set "PROGRAMMER_BAUD_EFFECTIVE=%PROGRAMMER_BAUD%"
exit /b 0

:ProgrammerPortMissing
set "FAIL_MESSAGE=PROGRAMMER_PORT cannot be blank when PROGRAMMER_CONNECTION=uart."
exit /b 1

:ProgrammerBaudMissing
set "FAIL_MESSAGE=PROGRAMMER_BAUD cannot be blank when PROGRAMMER_CONNECTION=uart."
exit /b 1

:: Match an avr-gcc MCU name to the full device names reported by installed AVRDUDE.

:ResolveAvrdudePartFromInstalledList
for /f "tokens=1,2,*" %%A in ('""%AVRDUDE_TOOL%" %AVRDUDE_CONFIG_OPTION% -p ? 2^>^&1"') do if "%%B"=="=" call :CheckAvrdudePartMatch "%%A" "%%C"
exit /b 0

:CheckAvrdudePartMatch
if defined AVRDUDE_PART_EFFECTIVE exit /b 0
if /i "%~2"=="%MCU%" set "AVRDUDE_PART_EFFECTIVE=%~1"
if /i "%~2"=="%MCU_DISPLAY%" set "AVRDUDE_PART_EFFECTIVE=%~1"
exit /b 0

:AvrdudeMissing
set "FAIL_MESSAGE=Missing AVRDUDE executable: %AVRDUDE_TOOL%"
exit /b 1

:AvrdudeConfMissing
set "FAIL_MESSAGE=Configured AVRDUDE file does not exist: %AVRDUDE_CONF%"
exit /b 1

:AvrdudePartMissing
set "FAIL_MESSAGE=AVRDUDE_PART=auto could not match MCU %MCU% in the installed AVRDUDE list. Enter the part ID manually."
exit /b 1

:ProgrammerMissing
set "FAIL_MESSAGE=PROGRAMMER cannot be blank for AVRDUDE actions."
exit /b 1

::#############################################################################
::### Incremental Object Cache
::#############################################################################

:PrepareObjectCache
set "FDX_SIG_01_COMPILER_BIN=%AVR_TOOLCHAIN_BIN%"
set "FDX_SIG_02_C_COMPILER=%C_COMPILER%"
set "FDX_SIG_03_CPP_COMPILER=%CPP_COMPILER%"
set "FDX_SIG_04_COMPILER_VERSION=%COMPILER_VERSION%"
set "FDX_SIG_05_BUILD_TYPE=%BUILD_TYPE%"
set "FDX_SIG_06_MCU=%MCU%"
set "FDX_SIG_08_PROJECT_LANGUAGE=%PROJECT_LANGUAGE%"
set "FDX_SIG_09_C_STANDARD=%C_STANDARD%"
set "FDX_SIG_10_CPP_STANDARD=%CPP_STANDARD%"
set "FDX_SIG_11_COMMON_OPTIONS=%COMMON_COMPILE_OPTIONS%"
set "FDX_SIG_12_C_OPTIONS=%C_COMPILE_OPTIONS%"
set "FDX_SIG_13_CPP_OPTIONS=%CPP_COMPILE_OPTIONS%"
set "FDX_SIG_14_ASM_OPTIONS=%ASM_COMPILE_OPTIONS%"
set "FDX_SIG_15_PROFILE_COMPILE=%PROFILE_COMPILE_OPTIONS%"
set "FDX_SIG_16_DEFINES=%DEFINES%"
set "FDX_SIG_17_INCLUDE_DIRS=%INCLUDE_DIRS%"
set "FDX_SIG_18_SOURCE_DIRS=%SOURCE_DIRS%"
set "FDX_SIG_19_COMPILE_ASSEMBLY=%COMPILE_ASSEMBLY%"
set "FDX_SIG_20_BOOT_START=%BOOT_START_LINK%"
set "FDX_SIG_21_BOOT_SIZE=%BOOTLOADER_SIZE_BYTES%"
set "FDX_SIG_22_CUSTOM_SECTION="
if /i not "%BUILD_TYPE%"=="bootloader" set "FDX_SIG_22_CUSTOM_SECTION=%CUSTOM_SECTION_NAME%=%CUSTOM_SECTION_ADDRESS%"
set "FDX_SIG_23_LINK_EXTERNAL=%LINK_EXTERNAL_OBJECTS%;%EXTERNAL_OBJECT_DIRS%;%EXTRA_OBJECTS%"
set "FDX_SIG_24_LINK_OPTIONS=%LIBRARY_DIRS%;%LIBRARIES%;%LINK_OPTIONS%;%PROFILE_LINK_OPTIONS%"

set FDX_SIG_>"%BUILD_SIGNATURE_TEMP%"
if errorlevel 1 goto :BuildSignatureCreateFailed

set "RESET_OBJECT_CACHE=no"
set "CACHE_REASON="
set "CACHE_STATUS_TEXT="
set "CACHE_WARNING_TEXT="
if /i "%RECOMPILE_ALL%"=="yes" set "RESET_OBJECT_CACHE=yes"
if /i "%RECOMPILE_ALL%"=="yes" set "CACHE_REASON=RECOMPILE_ALL=yes"
if not exist "%BUILD_SIGNATURE_FILE%" set "RESET_OBJECT_CACHE=yes"
if not exist "%BUILD_SIGNATURE_FILE%" set "CACHE_REASON=new or missing build signature"

if /i "%RESET_OBJECT_CACHE%"=="yes" goto :ResetObjectCache

fc /b "%BUILD_SIGNATURE_TEMP%" "%BUILD_SIGNATURE_FILE%" >nul 2>&1
if errorlevel 1 goto :BuildSignatureChanged
goto :KeepObjectCache

:BuildSignatureChanged
set "RESET_OBJECT_CACHE=yes"
set "CACHE_REASON=compiler or compile settings changed"

:ResetObjectCache
if /i not "%RESET_OBJECT_CACHE%"=="yes" goto :KeepObjectCache
if exist "%OBJECT_ROOT%" rmdir /s /q "%OBJECT_ROOT%"
if exist "%OBJECT_ROOT%" goto :ObjectCacheResetFailed
set "CACHE_STATUS_TEXT=Full rebuild - %CACHE_REASON%"
goto :StoreBuildSignature

:KeepObjectCache
set "CACHE_STATUS_TEXT=Incremental - unchanged objects will be reused"
if not defined POWERSHELL_TOOL set "CACHE_WARNING_TEXT=PowerShell was not found; existing objects will be recompiled."

:StoreBuildSignature
move /y "%BUILD_SIGNATURE_TEMP%" "%BUILD_SIGNATURE_FILE%" >nul 2>&1
if errorlevel 1 goto :BuildSignatureStoreFailed
if exist "%OBJECT_ROOT%\" exit /b 0
mkdir "%OBJECT_ROOT%" >nul 2>&1
if errorlevel 1 goto :ObjectDirectoryCreateFailed
exit /b 0

:BuildSignatureCreateFailed
set "FAIL_MESSAGE=Cannot create build signature: %BUILD_SIGNATURE_TEMP%"
exit /b 1

:ObjectCacheResetFailed
set "FAIL_MESSAGE=Cannot reset object cache: %OBJECT_ROOT%"
exit /b 1

:BuildSignatureStoreFailed
set "FAIL_MESSAGE=Cannot update build signature: %BUILD_SIGNATURE_FILE%"
exit /b 1

:ObjectDirectoryCreateFailed
set "FAIL_MESSAGE=Cannot create object directory: %OBJECT_ROOT%"
exit /b 1

:ShouldCompile
set "NEEDS_COMPILE=yes"
if /i "%RECOMPILE_ALL%"=="yes" exit /b 0
if not exist "%OBJECT_FILE%" exit /b 0
if not defined POWERSHELL_TOOL exit /b 0
if /i "%GENERATE_DEPENDENCIES%"=="no" goto :ShouldCompileSourceOnly
if not exist "%DEPENDENCY_FILE%" exit /b 0

set "FDX_DEP_FILE=%DEPENDENCY_FILE%"
set "FDX_OBJ_FILE=%OBJECT_FILE%"
"%POWERSHELL_TOOL%" -NoProfile -ExecutionPolicy Bypass -Command "$raw=[IO.File]::ReadAllText($env:FDX_DEP_FILE); $raw=$raw -replace '\\\r?\n',' '; $rule=($raw -split '\r?\n' | Where-Object { $_.Trim() } | Select-Object -First 1); if(-not $rule){exit 1}; $parts=$rule -split ':\s+',2; if($parts.Count -lt 2){exit 1}; $mark=[string][char]1; $body=$parts[1].Trim() -replace '\\ ',$mark; $files=$body -split '\s+'; $stamp=(Get-Item -LiteralPath $env:FDX_OBJ_FILE).LastWriteTimeUtc; foreach($file in $files){if(-not $file){continue}; $path=$file -replace $mark,' '; $path=$path -replace '\\#','#'; if(-not (Test-Path -LiteralPath $path)){exit 1}; if((Get-Item -LiteralPath $path).LastWriteTimeUtc -gt $stamp){exit 1}}; exit 0" >nul 2>&1
if errorlevel 1 exit /b 0
set "NEEDS_COMPILE=no"
exit /b 0

:ShouldCompileSourceOnly
set "FDX_SOURCE_FILE=%SOURCE_FILE%"
set "FDX_OBJ_FILE=%OBJECT_FILE%"
"%POWERSHELL_TOOL%" -NoProfile -ExecutionPolicy Bypass -Command "$src=(Get-Item -LiteralPath $env:FDX_SOURCE_FILE).LastWriteTimeUtc; $obj=(Get-Item -LiteralPath $env:FDX_OBJ_FILE).LastWriteTimeUtc; if($src -gt $obj){exit 1}; exit 0" >nul 2>&1
if errorlevel 1 exit /b 0
set "NEEDS_COMPILE=no"
exit /b 0


::#############################################################################
::### Source Discovery and Compilation
::#############################################################################

:ScanSourceList
if "%~1"=="" exit /b 0
for /f "tokens=1* delims=;" %%A in ("%~1") do (
    call :ScanSourceDirectory "%%~A"
    if errorlevel 1 exit /b 1
    call :ScanSourceList "%%~B"
    if errorlevel 1 exit /b 1
)
exit /b 0

:ScanSourceDirectory
if "%~1"=="" exit /b 0
for %%R in ("%~1") do set "SCAN_ROOT=%%~fR"
if not exist "%SCAN_ROOT%\" goto :SourceDirectoryMissing
if not "%SCAN_ROOT:~-1%"=="\" set "SCAN_ROOT=%SCAN_ROOT%\"
set /a SOURCE_ROOT_INDEX+=1
set "CURRENT_ROOT_INDEX=%SOURCE_ROOT_INDEX%"

for /r "%SCAN_ROOT%" %%F in (*.c *.cc *.cpp *.cxx) do (
    call :CompileSource "%%~fF"
    if errorlevel 1 exit /b 1
)
if /i not "%COMPILE_ASSEMBLY%"=="yes" exit /b 0
for /r "%SCAN_ROOT%" %%F in (*.s) do (
    call :CompileSource "%%~fF"
    if errorlevel 1 exit /b 1
)
exit /b 0

:SourceDirectoryMissing
set "FAIL_MESSAGE=Configured source directory does not exist: %~1"
exit /b 1

:CompileSource
call :IsExcluded "%~1"
if "%IS_EXCLUDED%"=="yes" exit /b 0
set "ACTIVE_SEEN_SOURCE_FILE=%SEEN_SOURCE_PLAN_FILE%"
if /i "%SOURCE_PHASE%"=="compile" set "ACTIVE_SEEN_SOURCE_FILE=%SEEN_SOURCE_COMPILE_FILE%"
call :RegisterUniquePath "%~f1" "%ACTIVE_SEEN_SOURCE_FILE%"
if /i "%IS_DUPLICATE_PATH%"=="yes" exit /b 0

set "SOURCE_FILE=%~f1"
set "SOURCE_EXTENSION=%~x1"
set "RELATIVE_SOURCE=%SOURCE_FILE%"
call set "RELATIVE_SOURCE=%%RELATIVE_SOURCE:%SCAN_ROOT%=%%"
set "OBJECT_FILE=%OBJECT_ROOT%\root%CURRENT_ROOT_INDEX%\%RELATIVE_SOURCE%.o"
set "DEPENDENCY_FILE=%OBJECT_FILE%.d"
for %%O in ("%OBJECT_FILE%") do set "OBJECT_DIRECTORY=%%~dpO"

if exist "%OBJECT_DIRECTORY%\" goto :ObjectDirectoryReady
mkdir "%OBJECT_DIRECTORY%" >nul 2>&1
if errorlevel 1 goto :SourceObjectDirectoryFailed

:ObjectDirectoryReady
set "DISPLAY_SOURCE=%SOURCE_FILE%"
call set "DISPLAY_SOURCE=%%DISPLAY_SOURCE:%PROJECT_DIR%=%%"

if "%SOURCE_EXTENSION%"==".c" goto :CompileC
if "%SOURCE_EXTENSION%"==".C" goto :CompileCpp
if /i "%SOURCE_EXTENSION%"==".cc" goto :CompileCpp
if /i "%SOURCE_EXTENSION%"==".cpp" goto :CompileCpp
if /i "%SOURCE_EXTENSION%"==".cxx" goto :CompileCpp
if "%SOURCE_EXTENSION%"==".S" goto :CompilePreprocessedAsm
if /i "%SOURCE_EXTENSION%"==".s" goto :CompileAsm
exit /b 0

:SourceObjectDirectoryFailed
set "FAIL_MESSAGE=Cannot create object directory: %OBJECT_DIRECTORY%"
exit /b 1

:CompileC
if /i "%SOURCE_PHASE%"=="plan" set /a C_SOURCE_COUNT+=1
set "COMPILE_LABEL=CC"
set "ACTIVE_COMPILER=%C_COMPILER%"
set "ACTIVE_OPTIONS=%COMMON_COMPILE_OPTIONS% %PROFILE_COMPILE_OPTIONS% %C_STANDARD_OPTION% %C_COMPILE_OPTIONS%"
set "GENERATE_DEPENDENCIES=yes"
goto :RunCompileCommand

:CompileCpp
if /i "%SOURCE_PHASE%"=="plan" set /a CPP_SOURCE_COUNT+=1
if /i "%SOURCE_PHASE%"=="plan" set "HAS_CPP=1"
set "COMPILE_LABEL=CXX"
set "ACTIVE_COMPILER=%CPP_COMPILER%"
set "ACTIVE_OPTIONS=%COMMON_COMPILE_OPTIONS% %PROFILE_COMPILE_OPTIONS% %CPP_STANDARD_OPTION% %CPP_COMPILE_OPTIONS%"
set "GENERATE_DEPENDENCIES=yes"
goto :RunCompileCommand

:CompilePreprocessedAsm
if /i "%SOURCE_PHASE%"=="plan" set /a ASM_SOURCE_COUNT+=1
set "COMPILE_LABEL=ASM"
set "ACTIVE_COMPILER=%C_COMPILER%"
set "ACTIVE_OPTIONS=%COMMON_COMPILE_OPTIONS% %PROFILE_COMPILE_OPTIONS% %ASM_COMPILE_OPTIONS%"
set "GENERATE_DEPENDENCIES=yes"
goto :RunCompileCommand

:CompileAsm
if /i "%SOURCE_PHASE%"=="plan" set /a ASM_SOURCE_COUNT+=1
set "COMPILE_LABEL=ASM"
set "ACTIVE_COMPILER=%C_COMPILER%"
set "ACTIVE_OPTIONS=%COMMON_COMPILE_OPTIONS% %PROFILE_COMPILE_OPTIONS% %ASM_COMPILE_OPTIONS%"
set "GENERATE_DEPENDENCIES=no"
goto :RunCompileCommand

:RunCompileCommand
set "DEPENDENCY_OPTIONS="
if /i "%GENERATE_DEPENDENCIES%"=="yes" set "DEPENDENCY_OPTIONS=-MMD -MF "%DEPENDENCY_FILE%" -MT "%OBJECT_FILE%""

call :ShouldCompile
if errorlevel 1 exit /b 1
if /i "%SOURCE_PHASE%"=="plan" goto :PlanSourceObject
if /i "%NEEDS_COMPILE%"=="no" goto :AddCompiledObject

if exist "%OBJECT_FILE%" del /q "%OBJECT_FILE%" >nul 2>&1
if exist "%DEPENDENCY_FILE%" del /q "%DEPENDENCY_FILE%" >nul 2>&1
if /i "%SHOW_COMMANDS%"=="yes" echo         "%ACTIVE_COMPILER%" -mmcu=%MCU% %ACTIVE_OPTIONS% %DEFINE_OPTIONS% %INCLUDE_OPTIONS% %DEPENDENCY_OPTIONS% -c "%SOURCE_FILE%" -o "%OBJECT_FILE%"
"%ACTIVE_COMPILER%" -mmcu=%MCU% %ACTIVE_OPTIONS% %DEFINE_OPTIONS% %INCLUDE_OPTIONS% %DEPENDENCY_OPTIONS% -c "%SOURCE_FILE%" -o "%OBJECT_FILE%"
set "COMPILE_EXIT_CODE=%ERRORLEVEL%"
if not "%COMPILE_EXIT_CODE%"=="0" goto :CompileCommandFailed
goto :AddCompiledObject

:PlanSourceObject
call :RegisterUniqueLinkInput "%OBJECT_FILE%"
if /i "%IS_DUPLICATE_PATH%"=="yes" exit /b 0
set /a SOURCE_COUNT+=1
set /a LINK_INPUT_COUNT+=1
>>"%SOURCE_DISPLAY_FILE%" echo(%DISPLAY_SOURCE%
if /i "%NEEDS_COMPILE%"=="no" goto :PlanReusableObject
set /a COMPILED_OBJECT_COUNT+=1
>>"%COMPILE_DISPLAY_FILE%" echo(%DISPLAY_SOURCE%
exit /b 0

:PlanReusableObject
set /a REUSED_OBJECT_COUNT+=1
exit /b 0

:CompileCommandFailed
set "FAIL_TITLE=Compilation Failed"
set "FAIL_MESSAGE=Compilation failed: %DISPLAY_SOURCE%"
set "FAIL_EXIT_CODE=%COMPILE_EXIT_CODE%"
exit /b 1

:AddCompiledObject
call :RegisterUniqueLinkInput "%OBJECT_FILE%"
if /i "%IS_DUPLICATE_PATH%"=="yes" exit /b 0
:: GCC response files treat backslashes as escape characters; use forward slashes.
set "RSP_OBJECT_FILE=%OBJECT_FILE:\=/%"
>>"%OBJECT_LIST_FILE%" echo "%RSP_OBJECT_FILE%"
exit /b 0


::#############################################################################
::### External Objects
::#############################################################################

:ScanExternalObjectList
if "%~1"=="" exit /b 0
for /f "tokens=1* delims=;" %%A in ("%~1") do (
    call :ScanExternalObjectDirectory "%%~A"
    if errorlevel 1 exit /b 1
    call :ScanExternalObjectList "%%~B"
    if errorlevel 1 exit /b 1
)
exit /b 0

:ScanExternalObjectDirectory
if "%~1"=="" exit /b 0
for %%R in ("%~1") do set "EXTERNAL_SCAN_ROOT=%%~fR"
if not exist "%EXTERNAL_SCAN_ROOT%\" goto :ExternalObjectDirectoryMissing
for /r "%EXTERNAL_SCAN_ROOT%" %%F in (*.o *.obj) do (
    call :AddScannedObject "%%~fF"
    if errorlevel 1 exit /b 1
)
exit /b 0

:ExternalObjectDirectoryMissing
set "FAIL_MESSAGE=Configured external object directory does not exist: %~1"
exit /b 1

:AddScannedObject
call :IsExcluded "%~1"
if "%IS_EXCLUDED%"=="yes" exit /b 0
call :RegisterUniqueLinkInput "%~f1"
if /i "%IS_DUPLICATE_PATH%"=="yes" exit /b 0
if /i "%SOURCE_PHASE%"=="plan" goto :PlanScannedObject
set "RSP_OBJECT_FILE=%~f1"
set "RSP_OBJECT_FILE=%RSP_OBJECT_FILE:\=/%"
>>"%OBJECT_LIST_FILE%" echo "%RSP_OBJECT_FILE%"
exit /b 0

:PlanScannedObject
set /a EXTERNAL_OBJECT_COUNT+=1
set /a LINK_INPUT_COUNT+=1
exit /b 0

:AddExplicitObjectList
if "%~1"=="" exit /b 0
for /f "tokens=1* delims=;" %%A in ("%~1") do (
    call :AddExplicitObject "%%~A"
    if errorlevel 1 exit /b 1
    call :AddExplicitObjectList "%%~B"
    if errorlevel 1 exit /b 1
)
exit /b 0

:AddExplicitObject
if "%~1"=="" exit /b 0
if not exist "%~1" goto :ExplicitObjectMissing
for %%F in ("%~1") do set "EXPLICIT_OBJECT=%%~fF"
call :RegisterUniqueLinkInput "%EXPLICIT_OBJECT%"
if /i "%IS_DUPLICATE_PATH%"=="yes" exit /b 0
if /i "%SOURCE_PHASE%"=="plan" goto :PlanExplicitObject
set "RSP_OBJECT_FILE=%EXPLICIT_OBJECT:\=/%"
>>"%OBJECT_LIST_FILE%" echo "%RSP_OBJECT_FILE%"
exit /b 0

:PlanExplicitObject
set /a EXTERNAL_OBJECT_COUNT+=1
set /a LINK_INPUT_COUNT+=1
exit /b 0

:ExplicitObjectMissing
set "FAIL_MESSAGE=Configured EXTRA_OBJECTS file does not exist: %~1"
exit /b 1


::#############################################################################
::### Duplicate Suppression
::#############################################################################

:RegisterUniqueLinkInput
set "ACTIVE_SEEN_LINK_FILE=%SEEN_LINK_PLAN_FILE%"
if /i "%SOURCE_PHASE%"=="compile" set "ACTIVE_SEEN_LINK_FILE=%SEEN_LINK_COMPILE_FILE%"
call :RegisterUniquePath "%~f1" "%ACTIVE_SEEN_LINK_FILE%"
exit /b 0

:RegisterUniquePath
set "IS_DUPLICATE_PATH=no"
if not exist "%~2" type nul >"%~2"
findstr /x /l /c:"%~f1" "%~2" >nul 2>&1
if not errorlevel 1 set "IS_DUPLICATE_PATH=yes"
if /i "%IS_DUPLICATE_PATH%"=="yes" exit /b 0
>>"%~2" echo(%~f1
exit /b 0

::#############################################################################
::### Source Exclusions
::#############################################################################

:IsExcluded
set "IS_EXCLUDED=no"
set "CHECK_PATH=%~f1"
set "EXCLUDE_ABSOLUTE=%OUTPUT_ROOT_ABS%\"
call :PathContainsDirectory "%CHECK_PATH%" "%EXCLUDE_ABSOLUTE%"
if not errorlevel 1 set "IS_EXCLUDED=yes"
if /i "%IS_EXCLUDED%"=="yes" exit /b 0
call :CheckExclusionList "%EXCLUDE_DIRS%"
exit /b 0

:CheckExclusionList
if /i "%IS_EXCLUDED%"=="yes" exit /b 0
if "%~1"=="" exit /b 0
for /f "tokens=1* delims=;" %%A in ("%~1") do (
    call :CheckOneExclusion "%%~A"
    call :CheckExclusionList "%%~B"
)
exit /b 0

:CheckOneExclusion
if /i "%IS_EXCLUDED%"=="yes" exit /b 0
if "%~1"=="" exit /b 0
set "EXCLUDE_ITEM=%~1"
set "EXCLUDE_ITEM=%EXCLUDE_ITEM:/=\%"
if "%EXCLUDE_ITEM:~1,1%"==":" goto :ExclusionAbsolute
if "%EXCLUDE_ITEM:~0,2%"=="\\" goto :ExclusionAbsolute
set "EXCLUDE_ITEM=%PROJECT_DIR%%EXCLUDE_ITEM%"

:ExclusionAbsolute
for %%P in ("%EXCLUDE_ITEM%") do set "EXCLUDE_ABSOLUTE=%%~fP"
if not "%EXCLUDE_ABSOLUTE:~-1%"=="\" set "EXCLUDE_ABSOLUTE=%EXCLUDE_ABSOLUTE%\"
call :PathContainsDirectory "%CHECK_PATH%" "%EXCLUDE_ABSOLUTE%"
if not errorlevel 1 set "IS_EXCLUDED=yes"
exit /b 0

:PathContainsDirectory
set "PREFIX_SOURCE=%~1"
set "PREFIX_REMOVE=%~2"
set "PREFIX_REMAINDER=%PREFIX_SOURCE%"
call set "PREFIX_REMAINDER=%%PREFIX_REMAINDER:%PREFIX_REMOVE%=%%"
if /i "%PREFIX_REMAINDER%"=="%PREFIX_SOURCE%" exit /b 1
exit /b 0


::#############################################################################
::### Linking and Firmware Generation
::#############################################################################

:SelectLinker
if /i "%PROJECT_LANGUAGE%"=="c" goto :SelectCLinker
if /i "%PROJECT_LANGUAGE%"=="cpp" goto :SelectCppLinker
if "%HAS_CPP%"=="1" goto :SelectCppLinker

:SelectCLinker
set "LINK_COMPILER=%C_COMPILER%"
set "LINKER_LABEL=C"
for %%T in ("%C_COMPILER%") do set "LINKER_PROGRAM=%%~nxT"
exit /b 0

:SelectCppLinker
set "LINK_COMPILER=%CPP_COMPILER%"
set "LINKER_LABEL=C++"
for %%T in ("%CPP_COMPILER%") do set "LINKER_PROGRAM=%%~nxT"
exit /b 0

:RemoveStaleFirmwareFiles
if exist "%ELF_PATH%" del /q "%ELF_PATH%" >nul 2>&1
if exist "%HEX_PATH%" del /q "%HEX_PATH%" >nul 2>&1
if exist "%EEP_PATH%" del /q "%EEP_PATH%" >nul 2>&1
if exist "%OUTPUT_ROOT_ABS%\%HEX_PREFIX%_%OUTPUT_NAME%*.hex" del /q "%OUTPUT_ROOT_ABS%\%HEX_PREFIX%_%OUTPUT_NAME%*.hex" >nul 2>&1
if exist "%LSS_PATH%" del /q "%LSS_PATH%" >nul 2>&1
if exist "%MAP_PATH%" del /q "%MAP_PATH%" >nul 2>&1
if exist "%SYMBOL_PATH%" del /q "%SYMBOL_PATH%" >nul 2>&1
exit /b 0

:AddMapOptionToResponse
set "RSP_MAP_PATH=%MAP_PATH:\=/%"
>>"%OBJECT_LIST_FILE%" echo "-Wl,-Map,%RSP_MAP_PATH%"
exit /b 0

:LinkFirmware
if /i "%CREATE_MAP_FILE%"=="yes" call :AddMapOptionToResponse
if /i "%SHOW_COMMANDS%"=="yes" echo         "%LINK_COMPILER%" -mmcu=%MCU% @"%OBJECT_LIST_FILE%" -o "%ELF_PATH%" %LIBRARY_DIR_OPTIONS% %LIBRARY_OPTIONS% %PROFILE_LINK_OPTIONS% %LINK_OPTIONS%
"%LINK_COMPILER%" -mmcu=%MCU% @"%OBJECT_LIST_FILE%" -o "%ELF_PATH%" %LIBRARY_DIR_OPTIONS% %LIBRARY_OPTIONS% %PROFILE_LINK_OPTIONS% %LINK_OPTIONS%
set "LINK_EXIT_CODE=%ERRORLEVEL%"
if not "%LINK_EXIT_CODE%"=="0" goto :LinkCommandFailed
exit /b 0


:LinkCommandFailed
set "FAIL_TITLE=Linking Failed"
set "FAIL_MESSAGE=Linking failed: %OUTPUT_NAME%.elf"
set "FAIL_EXIT_CODE=%LINK_EXIT_CODE%"
exit /b 1

:CreateFirmwareFiles
echo     [ELF] %OUTPUT_NAME%.elf

if /i "%SHOW_COMMANDS%"=="yes" echo         "%OBJCOPY_TOOL%" -O ihex -R .eeprom "%ELF_PATH%" "%HEX_PATH%"
"%OBJCOPY_TOOL%" -O ihex -R .eeprom "%ELF_PATH%" "%HEX_PATH%"
set "OBJCOPY_EXIT_CODE=%ERRORLEVEL%"
if not "%OBJCOPY_EXIT_CODE%"=="0" goto :HexCreateFailed
echo     [HEX] %FIRMWARE_HEX_NAME%

call :ReadEepromImageSize
if errorlevel 1 exit /b 1
if /i "%CREATE_EEPROM_FILE%"=="yes" call :CreateEepromFile
if /i "%CREATE_EEPROM_FILE%"=="yes" if errorlevel 1 exit /b 1
if /i "%CREATE_EEPROM_FILE%"=="no" if not "%EEPROM_IMAGE_BYTES%"=="0" echo     Warning: initialized EEPROM data exists, but CREATE_EEPROM_FILE=no.
if /i "%CREATE_LSS%"=="yes" call :CreateLss
if /i "%CREATE_LSS%"=="yes" if errorlevel 1 exit /b 1
if /i "%CREATE_SYMBOL_REPORT%"=="yes" call :CreateSymbolReport
if /i "%CREATE_SYMBOL_REPORT%"=="yes" if errorlevel 1 exit /b 1
if /i "%CREATE_MAP_FILE%"=="yes" if exist "%MAP_PATH%" echo     [MAP] %OUTPUT_NAME%.map
exit /b 0

:HexCreateFailed
set "FAIL_TITLE=Firmware Conversion Failed"
set "FAIL_MESSAGE=Failed to create flash HEX file: %HEX_PATH%"
set "FAIL_EXIT_CODE=%OBJCOPY_EXIT_CODE%"
exit /b 1

:ReadEepromImageSize
set "EEPROM_IMAGE_BYTES=0"
set "EEPROM_SIZE_TEMP=%OUTPUT_DIR_ABS%\eeprom_size.tmp"
if exist "%EEPROM_SIZE_TEMP%" del /q "%EEPROM_SIZE_TEMP%" >nul 2>&1
"%SIZE_TOOL%" -A "%ELF_PATH%" >"%EEPROM_SIZE_TEMP%" 2>nul
set "EEPROM_SIZE_EXIT_CODE=%ERRORLEVEL%"
if not "%EEPROM_SIZE_EXIT_CODE%"=="0" goto :ReadEepromImageSizeFailed
for /f "usebackq tokens=1,2" %%E in ("%EEPROM_SIZE_TEMP%") do if /i "%%E"==".eeprom" set "EEPROM_IMAGE_BYTES=%%F"
del /q "%EEPROM_SIZE_TEMP%" >nul 2>&1
exit /b 0

:ReadEepromImageSizeFailed
if exist "%EEPROM_SIZE_TEMP%" del /q "%EEPROM_SIZE_TEMP%" >nul 2>&1
set "FAIL_TITLE=Firmware Inspection Failed"
set "FAIL_MESSAGE=Failed to inspect EEPROM data in: %ELF_PATH%"
set "FAIL_EXIT_CODE=%EEPROM_SIZE_EXIT_CODE%"
exit /b 1

:CreateEepromFile
if exist "%EEP_PATH%" del /q "%EEP_PATH%" >nul 2>&1
if not defined EEPROM_IMAGE_BYTES call :ReadEepromImageSize
if "%EEPROM_IMAGE_BYTES%"=="0" exit /b 0
if /i "%SHOW_COMMANDS%"=="yes" echo         "%OBJCOPY_TOOL%" -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0 --no-change-warnings "%ELF_PATH%" "%EEP_PATH%"
"%OBJCOPY_TOOL%" -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0 --no-change-warnings "%ELF_PATH%" "%EEP_PATH%"
if errorlevel 1 goto :EepromCreateFailed
echo     [EEPROM] %FIRMWARE_EEP_NAME%
exit /b 0

:EepromCreateFailed
set "FAIL_TITLE=Firmware Conversion Failed"
set "FAIL_MESSAGE=Failed to create EEPROM HEX file: %EEP_PATH%"
set "FAIL_EXIT_CODE=%ERRORLEVEL%"
exit /b 1

:CreateLss
call :RequireAvrTool "%OBJDUMP_TOOL%" "AVR object-dump utility"
if errorlevel 1 exit /b 1
if /i "%SHOW_COMMANDS%"=="yes" echo         "%OBJDUMP_TOOL%" -h -S "%ELF_PATH%" ^> "%LSS_PATH%"
"%OBJDUMP_TOOL%" -h -S "%ELF_PATH%" >"%LSS_PATH%"
if errorlevel 1 goto :LssCreateFailed
echo     [LSS] %OUTPUT_NAME%.lss.txt
exit /b 0

:LssCreateFailed
set "FAIL_TITLE=Firmware Report Failed"
set "FAIL_MESSAGE=Failed to create LSS file: %LSS_PATH%"
set "FAIL_EXIT_CODE=%ERRORLEVEL%"
exit /b 1

:CreateSymbolReport
call :RequireAvrTool "%NM_TOOL%" "AVR symbol utility"
if errorlevel 1 exit /b 1
if /i "%SHOW_COMMANDS%"=="yes" echo         "%NM_TOOL%" --print-size --size-sort --radix=d "%ELF_PATH%" ^> "%SYMBOL_PATH%"
"%NM_TOOL%" --print-size --size-sort --radix=d "%ELF_PATH%" >"%SYMBOL_PATH%"
if errorlevel 1 goto :SymbolCreateFailed
echo     [SYM] %OUTPUT_NAME%.symbols.txt
exit /b 0

:SymbolCreateFailed
set "FAIL_TITLE=Firmware Report Failed"
set "FAIL_MESSAGE=Failed to create symbol report: %SYMBOL_PATH%"
set "FAIL_EXIT_CODE=%ERRORLEVEL%"
exit /b 1

:ShowFirmwareSize
if not exist "%ELF_PATH%" goto :ExistingElfMissing
set "SIZE_VALUES_FOUND="
set "SIZE_TEXT="
set "SIZE_DATA="
set "SIZE_BSS="
set "SIZE_DEC="
set "SIZE_HEX="
set "SIZE_SUMMARY_TEMP=%OUTPUT_DIR_ABS%\firmware_size.tmp"
if exist "%SIZE_SUMMARY_TEMP%" del /q "%SIZE_SUMMARY_TEMP%" >nul 2>&1
"%SIZE_TOOL%" "%ELF_PATH%" >"%SIZE_SUMMARY_TEMP%" 2>nul
set "SIZE_READ_EXIT_CODE=%ERRORLEVEL%"
if not "%SIZE_READ_EXIT_CODE%"=="0" goto :SizeReadFailed
for /f "usebackq skip=1 tokens=1-5" %%A in ("%SIZE_SUMMARY_TEMP%") do call :CaptureFirmwareSize "%%A" "%%B" "%%C" "%%D" "%%E"
del /q "%SIZE_SUMMARY_TEMP%" >nul 2>&1
if not defined SIZE_VALUES_FOUND goto :SizeReadFailed

set /a FLASH_USED=%SIZE_TEXT%+%SIZE_DATA%
set /a SRAM_USED=%SIZE_DATA%+%SIZE_BSS%
call :ReadEepromImageSize
if errorlevel 1 exit /b 1
set "EEPROM_USED=%EEPROM_IMAGE_BYTES%"

echo.
echo     Firmware size:
echo     -----------------------------------------------
echo(    text    data     bss     dec     hex
set "PRINT_TEXT=        %SIZE_TEXT%"
set "PRINT_DATA=        %SIZE_DATA%"
set "PRINT_BSS=        %SIZE_BSS%"
set "PRINT_DEC=        %SIZE_DEC%"
set "PRINT_HEX=        %SIZE_HEX%"
echo(%PRINT_TEXT:~-8%%PRINT_DATA:~-8%%PRINT_BSS:~-8%%PRINT_DEC:~-8%%PRINT_HEX:~-8%
echo.
if defined FLASH_BYTES_EFFECTIVE call :PrintMemoryCapacity "Flash" "%FLASH_USED%" "%FLASH_BYTES_EFFECTIVE%"
if defined SRAM_BYTES_EFFECTIVE call :PrintMemoryCapacity "SRAM" "%SRAM_USED%" "%SRAM_BYTES_EFFECTIVE%"
if defined EEPROM_BYTES_EFFECTIVE call :PrintMemoryCapacity "EEPROM" "%EEPROM_USED%" "%EEPROM_BYTES_EFFECTIVE%"

if /i "%BUILD_TYPE%"=="bootloader" call :ValidateAndPrintBootloaderSize
if /i "%BUILD_TYPE%"=="bootloader" if errorlevel 1 exit /b 1
exit /b 0

:CaptureFirmwareSize
if defined SIZE_VALUES_FOUND exit /b 0
set "SIZE_VALUES_FOUND=yes"
set "SIZE_TEXT=%~1"
set "SIZE_DATA=%~2"
set "SIZE_BSS=%~3"
set "SIZE_DEC=%~4"
set "SIZE_HEX=%~5"
exit /b 0

:PrintMemoryCapacity
if "%~3"=="0" exit /b 0
setlocal
set "MEMORY_LABEL=Flash: "
if /i "%~1"=="SRAM" set "MEMORY_LABEL=SRAM : "
if /i "%~1"=="EEPROM" set "MEMORY_LABEL=EEPROM:"
set "MEMORY_USED=%~2        "
set "MEMORY_TOTAL=%~3        "
set /a MEMORY_PERCENT_X10=(%~2*1000)/%~3
set /a MEMORY_PERCENT_WHOLE=MEMORY_PERCENT_X10/10
set /a MEMORY_PERCENT_FRACTION=MEMORY_PERCENT_X10%%10
echo     %MEMORY_LABEL% %MEMORY_USED:~0,8%bytes  / %MEMORY_TOTAL:~0,8%bytes  %MEMORY_PERCENT_WHOLE%.%MEMORY_PERCENT_FRACTION%%%
endlocal & exit /b 0

:MeasureBootloaderRegionUsage
set "BOOT_REGION_USED="
set "CUSTOM_SECTION_USED=0"
set "BOOT_LOAD_SECTION_COUNT="
set "BOOT_SECTION_EXIT_CODE="
set "BOOT_USAGE_EXIT_CODE="
set "BOOT_SECTION_TEMP=%OUTPUT_DIR_ABS%\boot_sections.tmp"
set "BOOT_USAGE_TEMP=%OUTPUT_DIR_ABS%\boot_usage.tmp"
if exist "%BOOT_SECTION_TEMP%" del /q "%BOOT_SECTION_TEMP%" >nul 2>&1
if exist "%BOOT_USAGE_TEMP%" del /q "%BOOT_USAGE_TEMP%" >nul 2>&1
if not defined POWERSHELL_TOOL goto :BootRegionPowerShellMissing
"%OBJDUMP_TOOL%" -h "%ELF_PATH%" >"%BOOT_SECTION_TEMP%" 2>nul
set "BOOT_SECTION_EXIT_CODE=%ERRORLEVEL%"
if not "%BOOT_SECTION_EXIT_CODE%"=="0" goto :BootRegionInspectionFailed
set "FDX_BOOT_SECTION_FILE=%BOOT_SECTION_TEMP%"
set "FDX_BOOT_START=%BOOT_START_DEC%"
set "FDX_BOOT_SIZE=%BOOTLOADER_SIZE_BYTES%"
set "FDX_CUSTOM_SECTION="
"%POWERSHELL_TOOL%" -NoProfile -ExecutionPolicy Bypass -Command "$lines=Get-Content -LiteralPath $env:FDX_BOOT_SECTION_FILE; $bootStart=[int64]$env:FDX_BOOT_START; $bootEnd=$bootStart+[int64]$env:FDX_BOOT_SIZE; $custom=$env:FDX_CUSTOM_SECTION; $bootUsed=0L; $customUsed=0L; $loadCount=0; for($i=0;$i -lt $lines.Count;$i++){ $m=[regex]::Match($lines[$i], '^\s*\d+\s+(\S+)\s+([0-9A-Fa-f]+)\s+([0-9A-Fa-f]+)\s+([0-9A-Fa-f]+)\s+'); if(-not $m.Success){continue}; $flags=if($i+1 -lt $lines.Count){$lines[$i+1]}else{''}; if($flags -notmatch '\bCONTENTS\b' -or $flags -notmatch '\bALLOC\b' -or $flags -notmatch '\bLOAD\b'){continue}; $loadCount++; $name=$m.Groups[1].Value; $size=[Convert]::ToInt64($m.Groups[2].Value,16); $lma=[Convert]::ToInt64($m.Groups[4].Value,16); if($size -le 0){continue}; $sectionEnd=$lma+$size; $overlapStart=[Math]::Max($lma,$bootStart); $overlapEnd=[Math]::Min($sectionEnd,$bootEnd); if($overlapEnd -gt $overlapStart){$bootUsed += $overlapEnd-$overlapStart}; if($custom -and $name -ceq $custom){$customUsed += $size} }; Write-Output ('BOOT_USED='+$bootUsed); Write-Output ('CUSTOM_USED='+$customUsed); Write-Output ('LOAD_COUNT='+$loadCount)" >"%BOOT_USAGE_TEMP%" 2>nul
set "BOOT_USAGE_EXIT_CODE=%ERRORLEVEL%"
if not "%BOOT_USAGE_EXIT_CODE%"=="0" goto :BootRegionInspectionFailed
for /f "usebackq tokens=1,2 delims==" %%A in ("%BOOT_USAGE_TEMP%") do call :CaptureBootRegionUsage "%%A" "%%B"
del /q "%BOOT_SECTION_TEMP%" >nul 2>&1
del /q "%BOOT_USAGE_TEMP%" >nul 2>&1
set "FDX_BOOT_SECTION_FILE="
set "FDX_BOOT_START="
set "FDX_BOOT_SIZE="
set "FDX_CUSTOM_SECTION="
if not defined BOOT_REGION_USED goto :BootRegionInspectionFailedClean
if not defined BOOT_LOAD_SECTION_COUNT goto :BootRegionInspectionFailedClean
if "%BOOT_LOAD_SECTION_COUNT%"=="0" goto :BootRegionInspectionFailedClean
exit /b 0

:CaptureBootRegionUsage
if /i "%~1"=="BOOT_USED" set "BOOT_REGION_USED=%~2"
if /i "%~1"=="CUSTOM_USED" set "CUSTOM_SECTION_USED=%~2"
if /i "%~1"=="LOAD_COUNT" set "BOOT_LOAD_SECTION_COUNT=%~2"
exit /b 0

:BootRegionPowerShellMissing
set "FAIL_TITLE=Bootloader Layout Failed"
set "FAIL_MESSAGE=PowerShell is required to inspect loadable sections inside the reserved boot region."
exit /b 1

:BootRegionInspectionFailed
if exist "%BOOT_SECTION_TEMP%" del /q "%BOOT_SECTION_TEMP%" >nul 2>&1
if exist "%BOOT_USAGE_TEMP%" del /q "%BOOT_USAGE_TEMP%" >nul 2>&1
set "FDX_BOOT_SECTION_FILE="
set "FDX_BOOT_START="
set "FDX_BOOT_SIZE="
set "FDX_CUSTOM_SECTION="

:BootRegionInspectionFailedClean
if not defined BOOT_USAGE_EXIT_CODE set "BOOT_USAGE_EXIT_CODE=1"
if "%BOOT_USAGE_EXIT_CODE%"=="0" set "BOOT_USAGE_EXIT_CODE=1"
set "FAIL_TITLE=Bootloader Layout Failed"
set "FAIL_MESSAGE=Could not inspect loadable sections in the reserved boot region: %ELF_PATH%"
set "FAIL_EXIT_CODE=%BOOT_USAGE_EXIT_CODE%"
exit /b 1

:ValidateAndPrintBootloaderSize
call :MeasureBootloaderRegionUsage
if errorlevel 1 exit /b 1
set /a BOOT_RESERVED_FREE=%BOOTLOADER_SIZE_BYTES%-%BOOT_REGION_USED%
echo.
echo     Bootloader:
echo     -----------------------------------------------
echo     Bootloader size:    %BOOTLOADER_SIZE_BYTES% bytes
echo     Start address:      %BOOT_START_DISPLAY%
echo     Boot region used:   %BOOT_REGION_USED% bytes
echo     Bootloader free:    %BOOT_RESERVED_FREE% bytes
if %BOOT_REGION_USED% EQU 0 goto :BootloaderRegionEmpty
if %BOOT_REGION_USED% GTR %BOOTLOADER_SIZE_BYTES% goto :BootloaderTooLarge
exit /b 0

:BootloaderRegionEmpty
set "FAIL_TITLE=Bootloader Layout Failed"
set "FAIL_MESSAGE=No loadable firmware bytes were found in the reserved boot region beginning at %BOOT_START_DISPLAY%."
exit /b 1

:BootloaderTooLarge
set "FAIL_TITLE=Bootloader Size Failed"
set "FAIL_MESSAGE=Boot region uses %BOOT_REGION_USED% bytes but only %BOOTLOADER_SIZE_BYTES% bytes are reserved."
exit /b 1

:SizeReadFailed
if defined SIZE_SUMMARY_TEMP if exist "%SIZE_SUMMARY_TEMP%" del /q "%SIZE_SUMMARY_TEMP%" >nul 2>&1
if not defined SIZE_READ_EXIT_CODE set "SIZE_READ_EXIT_CODE=1"
if "%SIZE_READ_EXIT_CODE%"=="0" set "SIZE_READ_EXIT_CODE=1"
set "FAIL_TITLE=Firmware Report Failed"
set "FAIL_MESSAGE=Firmware size could not be read from: %ELF_PATH%"
set "FAIL_EXIT_CODE=%SIZE_READ_EXIT_CODE%"
exit /b 1

:DeleteObjectCache
if exist "%OBJECT_ROOT%" rmdir /s /q "%OBJECT_ROOT%"
exit /b 0


::#############################################################################
::### AVRDUDE Upload, Verification, and Probe
::#############################################################################

:UploadFirmware
if not exist "%HEX_PATH%" goto :ExistingHexMissing
call :PrepareEepromUpload
if errorlevel 1 exit /b 1
call :EnsureLockWriteSafe
if errorlevel 1 exit /b 1
:UploadAttempt
call :PrintUploadHeader
call :PerformSerialReset
if errorlevel 1 exit /b 1
pushd "%OUTPUT_ROOT_ABS%" >nul
if errorlevel 1 goto :AvrdudeOutputFolderFailed
if /i "%SHOW_COMMANDS%"=="yes" echo         "%AVRDUDE_TOOL%" %AVRDUDE_BASE_OPTIONS% -U flash:w:"%FIRMWARE_HEX_NAME%":i %EEPROM_UPLOAD_OPTION%
"%AVRDUDE_TOOL%" %AVRDUDE_BASE_OPTIONS% -U flash:w:"%FIRMWARE_HEX_NAME%":i %EEPROM_UPLOAD_OPTION%
set "AVRDUDE_EXIT_CODE=%ERRORLEVEL%"
popd >nul
if "%AVRDUDE_EXIT_CODE%"=="0" goto :UploadCompleted

:RetryUpload
timeout 5
goto :UploadAttempt

:UploadCompleted
call :WriteConfiguredLock
if errorlevel 1 exit /b 1
echo.
echo *******************************************************************************
echo *****                    Firmware Uploaded Successfully                   *****
echo *******************************************************************************
exit /b 0

:AvrdudeOutputFolderFailed
set "FAIL_TITLE=Output Folder Failed"
set "FAIL_MESSAGE=AVRDUDE could not enter output folder: %OUTPUT_ROOT_ABS%"
exit /b 1

:PrepareEepromUpload
set "EEPROM_UPLOAD_OPTION="
set "EEPROM_UPLOAD_DISPLAY=Not uploaded"
if /i "%UPLOAD_EEPROM%"=="no" exit /b 0
if /i "%UPLOAD_EEPROM%"=="yes" if not exist "%EEP_PATH%" goto :RequiredEepromMissing
if not exist "%EEP_PATH%" exit /b 0
set "EEPROM_UPLOAD_OPTION=-U eeprom:w:"%FIRMWARE_EEP_NAME%":i"
set "EEPROM_UPLOAD_DISPLAY=%FIRMWARE_EEP_NAME%"
exit /b 0

:PrepareEepromVerify
set "EEPROM_VERIFY_OPTION="
set "EEPROM_VERIFY_DISPLAY=Not verified"
if /i "%UPLOAD_EEPROM%"=="no" exit /b 0
if /i "%UPLOAD_EEPROM%"=="yes" if not exist "%EEP_PATH%" goto :RequiredEepromMissing
if not exist "%EEP_PATH%" exit /b 0
set "EEPROM_VERIFY_OPTION=-U eeprom:v:"%FIRMWARE_EEP_NAME%":i"
set "EEPROM_VERIFY_DISPLAY=%FIRMWARE_EEP_NAME%"
exit /b 0

:RequiredEepromMissing
set "FAIL_MESSAGE=UPLOAD_EEPROM=yes requires an EEPROM image: %EEP_PATH%"
exit /b 1

:EnsureLockWriteSafe
if /i not "%LOCK_WRITE_REQUIRED%"=="yes" exit /b 0
if /i "%LOCK_WRITE_SAFE%"=="yes" exit /b 0
set "FAIL_MESSAGE=%LOCK_MODE_DISPLAY% is not verified for %MCU_DISPLAY%. Use a verified classic MCU profile or select unlocked application mode."
exit /b 1

:WriteConfiguredLock
if /i not "%LOCK_WRITE_REQUIRED%"=="yes" exit /b 0
echo.
echo     Lock mode:   %LOCK_MODE_DISPLAY%
echo     Lock byte:   %LOCK_VALUE_EFFECTIVE%
if /i "%SHOW_COMMANDS%"=="yes" echo         "%AVRDUDE_TOOL%" %AVRDUDE_BASE_OPTIONS% -u -U lock:w:%LOCK_VALUE_EFFECTIVE%:m
"%AVRDUDE_TOOL%" %AVRDUDE_BASE_OPTIONS% -u -U lock:w:%LOCK_VALUE_EFFECTIVE%:m
set "AVRDUDE_EXIT_CODE=%ERRORLEVEL%"
if not "%AVRDUDE_EXIT_CODE%"=="0" goto :LockWriteFailed
exit /b 0

:LockWriteFailed
set "FAIL_TITLE=Lock Write Failed"
set "FAIL_MESSAGE=Firmware uploaded, but writing %LOCK_MODE_DISPLAY% byte %LOCK_VALUE_EFFECTIVE% failed."
set "FAIL_EXIT_CODE=%AVRDUDE_EXIT_CODE%"
exit /b 1

:VerifyFirmware
if not exist "%HEX_PATH%" goto :ExistingHexMissing
call :PrepareEepromVerify
if errorlevel 1 exit /b 1
call :PrintVerifyHeader
call :PerformSerialReset
if errorlevel 1 exit /b 1
pushd "%OUTPUT_ROOT_ABS%" >nul
if errorlevel 1 goto :AvrdudeOutputFolderFailed
if /i "%SHOW_COMMANDS%"=="yes" echo         "%AVRDUDE_TOOL%" %AVRDUDE_BASE_OPTIONS% -U flash:v:"%FIRMWARE_HEX_NAME%":i %EEPROM_VERIFY_OPTION%
"%AVRDUDE_TOOL%" %AVRDUDE_BASE_OPTIONS% -U flash:v:"%FIRMWARE_HEX_NAME%":i %EEPROM_VERIFY_OPTION%
set "AVRDUDE_EXIT_CODE=%ERRORLEVEL%"
popd >nul
if not "%AVRDUDE_EXIT_CODE%"=="0" goto :VerifyFailed
echo.
echo *******************************************************************************
echo *****                    Firmware Verified Successfully                   *****
echo *******************************************************************************
exit /b 0

:VerifyFailed
set "FAIL_TITLE=Verification Failed"
set "FAIL_MESSAGE=AVRDUDE could not verify %FIRMWARE_HEX_NAME%."
set "FAIL_EXIT_CODE=%AVRDUDE_EXIT_CODE%"
exit /b 1

:ProbeDevice
call :PrintProbeHeader
call :PerformSerialReset
if errorlevel 1 exit /b 1
if /i "%SHOW_COMMANDS%"=="yes" echo         "%AVRDUDE_TOOL%" %AVRDUDE_BASE_OPTIONS% -v -n
"%AVRDUDE_TOOL%" %AVRDUDE_BASE_OPTIONS% -v -n
set "AVRDUDE_EXIT_CODE=%ERRORLEVEL%"
if not "%AVRDUDE_EXIT_CODE%"=="0" goto :ProbeFailed
exit /b 0

:ProbeFailed
set "FAIL_TITLE=Device Probe Failed"
set "FAIL_MESSAGE=AVRDUDE could not communicate with the selected MCU and programmer."
set "FAIL_EXIT_CODE=%AVRDUDE_EXIT_CODE%"
exit /b 1

:PerformSerialReset
if /i not "%EFFECTIVE_SERIAL_RESET%"=="yes" exit /b 0
if not defined PROGRAMMER_PORT_EFFECTIVE goto :SerialResetPortMissing
if not defined PROGRAMMER_BAUD_EFFECTIVE goto :SerialResetBaudMissing
echo     Serial reset: %PROGRAMMER_PORT_EFFECTIVE% at %PROGRAMMER_BAUD_EFFECTIVE% baud
mode %PROGRAMMER_PORT_EFFECTIVE% baud=%PROGRAMMER_BAUD_EFFECTIVE% parity=n data=8 rts=on dtr=on >nul 2>&1
if errorlevel 1 goto :SerialResetFailed
exit /b 0

:SerialResetPortMissing
set "FAIL_TITLE=Upload Failed"
set "FAIL_MESSAGE=Serial auto-reset requires PROGRAMMER_PORT."
exit /b 1

:SerialResetBaudMissing
set "FAIL_TITLE=Upload Failed"
set "FAIL_MESSAGE=Serial auto-reset requires PROGRAMMER_BAUD."
exit /b 1

:SerialResetFailed
set "FAIL_TITLE=Upload Failed"
set "FAIL_MESSAGE=Could not open %PROGRAMMER_PORT_EFFECTIVE% to trigger the bootloader reset."
set "FAIL_EXIT_CODE=%ERRORLEVEL%"
exit /b 1

:ExistingHexMissing
set "FAIL_MESSAGE=HEX file not found. Build the selected profile first: %HEX_PATH%"
exit /b 1


::#############################################################################
::### Cleaning
::#############################################################################

:CleanCurrentProfile
call :ValidateCleanPath "%OUTPUT_DIR_ABS%"
if errorlevel 1 exit /b 1
set "CLEAN_PROFILE_FOUND=no"
if exist "%OUTPUT_DIR_ABS%\" set "CLEAN_PROFILE_FOUND=yes"
if exist "%OUTPUT_ROOT_ABS%\%HEX_PREFIX%_%OUTPUT_NAME%*.hex" set "CLEAN_PROFILE_FOUND=yes"
if /i "%CLEAN_PROFILE_FOUND%"=="no" exit /b 0
call :PrintCleanHeader
if exist "%OUTPUT_DIR_ABS%\" echo     Removing: %OUTPUT_DIR_ABS%
if exist "%OUTPUT_DIR_ABS%\" rmdir /s /q "%OUTPUT_DIR_ABS%"
if exist "%OUTPUT_DIR_ABS%\" goto :CleanRemoveFailed
if exist "%OUTPUT_ROOT_ABS%\%HEX_PREFIX%_%OUTPUT_NAME%*.hex" echo     Removing: %OUTPUT_DIR%\%HEX_PREFIX%_%OUTPUT_NAME%*.hex
if exist "%OUTPUT_ROOT_ABS%\%HEX_PREFIX%_%OUTPUT_NAME%*.hex" del /q "%OUTPUT_ROOT_ABS%\%HEX_PREFIX%_%OUTPUT_NAME%*.hex" >nul 2>&1
if exist "%OUTPUT_ROOT_ABS%\%HEX_PREFIX%_%OUTPUT_NAME%*.hex" goto :CleanRemoveFailed
exit /b 0

:CleanAllOutput
call :ValidateCleanPath "%OUTPUT_ROOT_ABS%"
if errorlevel 1 exit /b 1
if not exist "%OUTPUT_ROOT_ABS%\" exit /b 0
call :PrintCleanHeader
echo     Removing: %OUTPUT_ROOT_ABS%
rmdir /s /q "%OUTPUT_ROOT_ABS%"
if errorlevel 1 goto :CleanRemoveFailed
exit /b 0

:ValidateCleanPath
set "CLEAN_TARGET=%~f1"
if not defined CLEAN_TARGET goto :CleanPathInvalid
set "PROJECT_DIR_NO_SLASH=%PROJECT_DIR:~0,-1%"
if /i "%CLEAN_TARGET%"=="%PROJECT_DIR_NO_SLASH%" goto :CleanProjectRefused
for %%D in ("%CLEAN_TARGET%") do set "OUTPUT_DRIVE_ROOT=%%~dD\"
if /i "%CLEAN_TARGET%"=="%OUTPUT_DRIVE_ROOT%" goto :CleanDriveRootRefused
exit /b 0

:CleanPathInvalid
set "FAIL_MESSAGE=Output cleaning path is empty or invalid."
exit /b 1

:CleanProjectRefused
set "FAIL_MESSAGE=Refusing to clean because the output path resolves to the project directory."
exit /b 1

:CleanDriveRootRefused
set "FAIL_MESSAGE=Refusing to clean because the output path resolves to a drive root."
exit /b 1

:CleanRemoveFailed
set "FAIL_MESSAGE=Could not remove output directory: %CLEAN_TARGET%"
exit /b 1


::#############################################################################
::### Display and Final Status
::#############################################################################

:PrintBuildHeader
title Flyandance 8-bit AVR C/C++ FDxAVRC IDE-Less Build %SCRIPT_VERSION%
echo ###############################################################################
echo #                                                                             #
echo #           Flyandance 8-bit AVR C/C++ FDxAVRC IDE-Less Build %SCRIPT_VERSION%            #
echo #                                                                             #
echo ###############################################################################
echo.
echo     Project:      %PROJECT_NAME%
if /i "%NEED_PROFILE_SELECTION%"=="yes" echo     Build type:   %PROFILE_DISPLAY%
echo.
if /i "%BUILD_TYPE%"=="bootloader" if defined BOOT_START_DISPLAY echo     Boot start:   %BOOT_START_DISPLAY%
if /i "%BUILD_TYPE%"=="bootloader" if defined BOOT_START_DISPLAY echo     Boot size:    %BOOTLOADER_SIZE_BYTES% bytes
if /i "%BUILD_TYPE%"=="bootloader" if defined BOOT_START_DISPLAY echo.
echo     MCU:          %MCU_DISPLAY%
echo.
if /i "%BUILD_TYPE%"=="bootloader" if /i "%NEED_FIRMWARE_NAMING%"=="yes" echo     Output:       %FIRMWARE_HEX_NAME%
echo     Toolchain:    %TOOLCHAIN_DISPLAY%
if defined DEFINES echo     Defines:      %DEFINES%
if not defined DEFINES echo     Defines:      None
exit /b 0

:PrintCompileHeader
echo.
echo ===============================================================================
echo =====^>^>                      Compiling Source Files                     ^<^<=====
echo ===============================================================================
echo.
if defined CACHE_STATUS_TEXT echo     Build mode: %CACHE_STATUS_TEXT%
if defined CACHE_WARNING_TEXT echo     Warning:    %CACHE_WARNING_TEXT%
echo.
exit /b 0

:PrintLinkHeader
echo.
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo +++++^>^>                         Linking AVR ELF                         ^<^<+++++
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo.
echo     Driver:       %LINKER_LABEL% - %LINKER_PROGRAM%
echo     MCU:          %MCU%
if defined LIBRARY_DIRS echo     Library dirs: %LIBRARY_DIRS%
if defined LIBRARIES echo     Libraries:    %LIBRARIES%
if not defined LIBRARIES echo     Libraries:    None
if defined PROFILE_LINK_OPTIONS echo     Profile:      %PROFILE_LINK_OPTIONS%
if defined LINK_OPTIONS echo     Options:      %LINK_OPTIONS%
if not defined LINK_OPTIONS echo     Options:      Compiler defaults
echo.
exit /b 0

:PrintFirmwareFilesHeader
echo.
echo -------------------------------------------------------------------------------
echo -----^>^>                     Creating Firmware Files                     ^<^<-----
echo -------------------------------------------------------------------------------
echo.
exit /b 0

:PrintUploadHeader
echo.
echo ===============================================================================
echo *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
echo *--*^>^>                         Uploading Firmware                        ^<^<*--*
echo *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
echo.
exit /b 0

:PrintVerifyHeader
echo.
echo ===============================================================================
echo *****^>^>                       Verifying Firmware                        ^<^<*****
echo ===============================================================================
echo.
echo     Flash:       %FIRMWARE_HEX_NAME%
echo     EEPROM:      %EEPROM_VERIFY_DISPLAY%
echo     Connection:  %PROGRAMMER_CONNECTION_DISPLAY%
echo     Programmer:  %PROGRAMMER%
echo     Part:        %AVRDUDE_PART_EFFECTIVE%
if defined PROGRAMMER_PORT_EFFECTIVE echo     Port:        %PROGRAMMER_PORT_EFFECTIVE%
if not defined PROGRAMMER_PORT_EFFECTIVE echo     Port:        Not used
if defined PROGRAMMER_BAUD_EFFECTIVE echo     Baud:        %PROGRAMMER_BAUD_EFFECTIVE%
if not defined PROGRAMMER_BAUD_EFFECTIVE echo     Baud:        Not used
echo.
exit /b 0

:PrintProbeHeader
echo.
echo ###############################################################################
echo ####^>^>                         Probing AVR Device                        ^<^<####
echo ###############################################################################
echo.
echo     Programmer:  %PROGRAMMER%
echo     Part:        %AVRDUDE_PART_EFFECTIVE%
if defined PROGRAMMER_PORT_EFFECTIVE echo     Port:        %PROGRAMMER_PORT_EFFECTIVE%
if not defined PROGRAMMER_PORT_EFFECTIVE echo     Port:        Not used
if defined PROGRAMMER_BAUD_EFFECTIVE echo     Baud:        %PROGRAMMER_BAUD_EFFECTIVE%
if not defined PROGRAMMER_BAUD_EFFECTIVE echo     Baud:        Not used
echo.
exit /b 0

:PrintCleanHeader
echo.
echo -------------------------------------------------------------------------------
echo -----^>^>                         Cleaning Output                         ^<^<-----
echo -------------------------------------------------------------------------------
echo.
exit /b 0

:PrepareDisplayDetails
call :PrepareLanguageDescription
call :PrepareStandardDescriptions
set "COMMON_OPTIONS_DISPLAY=%COMMON_COMPILE_OPTIONS%"
if not defined COMMON_OPTIONS_DISPLAY set "COMMON_OPTIONS_DISPLAY=Compiler defaults"
exit /b 0

:PrepareLanguageDescription
if /i "%PROJECT_LANGUAGE%"=="c" set "LANGUAGE_DESCRIPTION=Forced C linking"
if /i "%PROJECT_LANGUAGE%"=="cpp" set "LANGUAGE_DESCRIPTION=Forced C++ linking"
if /i not "%PROJECT_LANGUAGE%"=="auto" exit /b 0
if not "%C_SOURCE_COUNT%"=="0" if not "%CPP_SOURCE_COUNT%"=="0" set "LANGUAGE_DESCRIPTION=Auto-detect - mixed C and C++ AVR project"
if not "%C_SOURCE_COUNT%"=="0" if "%CPP_SOURCE_COUNT%"=="0" set "LANGUAGE_DESCRIPTION=Auto-detect - C AVR project"
if "%C_SOURCE_COUNT%"=="0" if not "%CPP_SOURCE_COUNT%"=="0" set "LANGUAGE_DESCRIPTION=Auto-detect - C++ AVR project"
if "%C_SOURCE_COUNT%"=="0" if "%CPP_SOURCE_COUNT%"=="0" set "LANGUAGE_DESCRIPTION=Auto-detect - assembly or object-only AVR project"
exit /b 0

:PrepareStandardDescriptions
set "C_STANDARD_DISPLAY="
set "CPP_STANDARD_DISPLAY="
if defined C_STANDARD set "C_STANDARD_DISPLAY=%C_STANDARD% - configured"
if defined CPP_STANDARD set "CPP_STANDARD_DISPLAY=%CPP_STANDARD% - configured"
if not defined C_STANDARD call :DetectCStandard
if not defined CPP_STANDARD call :DetectCppStandard
if not defined C_STANDARD_DISPLAY set "C_STANDARD_DISPLAY=Compiler default"
if not defined CPP_STANDARD_DISPLAY set "CPP_STANDARD_DISPLAY=Compiler default"
exit /b 0

:DetectCStandard
set "C_STANDARD_MACRO="
for /f "tokens=3" %%V in ('echo. ^| "%C_COMPILER%" -mmcu=%MCU% -dM -E -x c - 2^>nul ^| findstr /b /c:"#define __STDC_VERSION__"') do if not defined C_STANDARD_MACRO set "C_STANDARD_MACRO=%%V"
if not defined C_STANDARD_MACRO set "C_STANDARD_DISPLAY=GNU C90/C89 - compiler default"
if "%C_STANDARD_MACRO%"=="199409L" set "C_STANDARD_DISPLAY=GNU C94 - compiler default"
if "%C_STANDARD_MACRO%"=="199901L" set "C_STANDARD_DISPLAY=GNU C99 - compiler default"
if "%C_STANDARD_MACRO%"=="201112L" set "C_STANDARD_DISPLAY=GNU C11 - compiler default"
if "%C_STANDARD_MACRO%"=="201710L" set "C_STANDARD_DISPLAY=GNU C17 - compiler default"
if "%C_STANDARD_MACRO%"=="202000L" set "C_STANDARD_DISPLAY=GNU C23 draft - compiler default"
if "%C_STANDARD_MACRO%"=="202311L" set "C_STANDARD_DISPLAY=GNU C23 - compiler default"
exit /b 0

:DetectCppStandard
set "CPP_STANDARD_MACRO="
for /f "tokens=3" %%V in ('echo. ^| "%CPP_COMPILER%" -mmcu=%MCU% -dM -E -x c++ - 2^>nul ^| findstr /b /c:"#define __cplusplus"') do if not defined CPP_STANDARD_MACRO set "CPP_STANDARD_MACRO=%%V"
if "%CPP_STANDARD_MACRO%"=="199711L" set "CPP_STANDARD_DISPLAY=GNU C++98 - compiler default"
if "%CPP_STANDARD_MACRO%"=="201103L" set "CPP_STANDARD_DISPLAY=GNU C++11 - compiler default"
if "%CPP_STANDARD_MACRO%"=="201402L" set "CPP_STANDARD_DISPLAY=GNU C++14 - compiler default"
if "%CPP_STANDARD_MACRO%"=="201703L" set "CPP_STANDARD_DISPLAY=GNU C++17 - compiler default"
if "%CPP_STANDARD_MACRO%"=="202002L" set "CPP_STANDARD_DISPLAY=GNU C++20 - compiler default"
if "%CPP_STANDARD_MACRO%"=="202302L" set "CPP_STANDARD_DISPLAY=GNU C++23 - compiler default"
exit /b 0

:PrintSourceSummary
echo     ------------------------------------------------------------
call :PrintPipeList "Source" "%SOURCE_DISPLAY_FILE%"
echo.
echo     Sources:  C=%C_SOURCE_COUNT%  C++=%CPP_SOURCE_COUNT%  ASM=%ASM_SOURCE_COUNT%  External=%EXTERNAL_OBJECT_COUNT%
echo     Objects:  To compile=%COMPILED_OBJECT_COUNT%  Reuse=%REUSED_OBJECT_COUNT%
if not "%EXTERNAL_OBJECT_COUNT%"=="0" echo     External objects: %EXTERNAL_OBJECT_COUNT%
echo.
echo     Options:  %COMMON_OPTIONS_DISPLAY%
if defined PROFILE_COMPILE_OPTIONS echo     Profile:   %PROFILE_COMPILE_OPTIONS%
if defined INCLUDE_DIRS if /i not "%INCLUDE_DIRS%"=="include" echo     Includes: %INCLUDE_DIRS%
if /i "%INCLUDE_DIRS%"=="include" if exist "include\" echo     Includes: include
if not "%C_SOURCE_COUNT%"=="0" if defined C_COMPILE_OPTIONS echo     C options: %C_COMPILE_OPTIONS%
if not "%CPP_SOURCE_COUNT%"=="0" if defined CPP_COMPILE_OPTIONS echo     C++ options: %CPP_COMPILE_OPTIONS%
if not "%ASM_SOURCE_COUNT%"=="0" if defined ASM_COMPILE_OPTIONS echo     ASM options: %ASM_COMPILE_OPTIONS%
echo     Linker:   %LINKER_LABEL% - %LINKER_PROGRAM%
echo.
echo     Firmware:     %PROFILE_DISPLAY%
echo     Language:     %LANGUAGE_DESCRIPTION%
if not "%C_SOURCE_COUNT%"=="0" echo     C standard:   %C_STANDARD_DISPLAY%
if not "%CPP_SOURCE_COUNT%"=="0" echo     C++ standard: %CPP_STANDARD_DISPLAY%
echo.
echo     ------------------------------------------------------------
call :PrintPipeList "Compiling" "%COMPILE_DISPLAY_FILE%"
echo.
exit /b 0

:PrintPipeList
setlocal EnableDelayedExpansion
set "PRINT_LABEL=%~1"
set "PRINT_FILE=%~2"
set "PRINT_PREFIX=    [!PRINT_LABEL!]  "
set "PRINT_CONTINUATION=              "
if /i "!PRINT_LABEL!"=="Compiling" set "PRINT_PREFIX=    [Compiling]   "
if /i "!PRINT_LABEL!"=="Compiling" set "PRINT_CONTINUATION=                  "
set "PRINT_LINE="
set /a PRINT_ITEM_COUNT=0
set /a PRINT_TOTAL_COUNT=0
for /f "usebackq delims=" %%F in ("!PRINT_FILE!") do (
    set /a PRINT_TOTAL_COUNT+=1
    set /a PRINT_ITEM_COUNT+=1
    if defined PRINT_LINE (
        set "PRINT_LINE=!PRINT_LINE! ^| %%F"
    ) else (
        set "PRINT_LINE=%%F"
    )
    if !PRINT_ITEM_COUNT! GEQ 3 (
        if !PRINT_TOTAL_COUNT! EQU 3 (
            echo(!PRINT_PREFIX!!PRINT_LINE!
        ) else (
            echo(!PRINT_CONTINUATION!!PRINT_LINE!
        )
        set "PRINT_LINE="
        set /a PRINT_ITEM_COUNT=0
    )
)
if !PRINT_TOTAL_COUNT! EQU 0 (
    if /i "!PRINT_LABEL!"=="Compiling" echo(!PRINT_PREFIX!None - all source objects are current
    if /i not "!PRINT_LABEL!"=="Compiling" echo(!PRINT_PREFIX!None
    endlocal & exit /b 0
)
if defined PRINT_LINE (
    if !PRINT_TOTAL_COUNT! LEQ 3 (
        echo(!PRINT_PREFIX!!PRINT_LINE!
    ) else (
        echo(!PRINT_CONTINUATION!!PRINT_LINE!
    )
)
endlocal & exit /b 0

:ListInstalledMcus
call :SetAvrToolPath "avr-gcc.exe" C_COMPILER
call :RequireAvrTool "%C_COMPILER%" "AVR C compiler"
if errorlevel 1 exit /b 1
if defined AVR_TOOLCHAIN_BIN for %%R in ("%AVR_TOOLCHAIN_BIN%\..") do set "AVR_TOOLCHAIN_ROOT=%%~fR"
if not defined AVR_TOOLCHAIN_ROOT for %%R in ("%C_COMPILER%\..\..") do set "AVR_TOOLCHAIN_ROOT=%%~fR"
set "MCU_LIST_FOUND=no"
set "MCU_LIST_SEEN=%TEMP%\FDxAVRC_MCU_%RANDOM%_%RANDOM%.txt"
>"%MCU_LIST_SEEN%" type nul
echo.
echo     MCU names installed with this AVR-GCC toolchain:
echo.
for /r "%AVR_TOOLCHAIN_ROOT%" %%F in (specs-*) do if exist "%%~fF" call :PrintMcuSpecName "%%~nxF"
if /i "%MCU_LIST_FOUND%"=="no" echo     No specs-* device files were found under %AVR_TOOLCHAIN_ROOT%.
if exist "%MCU_LIST_SEEN%" del /q "%MCU_LIST_SEEN%" >nul 2>&1
exit /b 0

:PrintMcuSpecName
set "MCU_SPEC_NAME=%~1"
set "MCU_SPEC_NAME=%MCU_SPEC_NAME:~6%"
findstr /x /l /c:"%MCU_SPEC_NAME%" "%MCU_LIST_SEEN%" >nul 2>&1
if not errorlevel 1 exit /b 0
>>"%MCU_LIST_SEEN%" echo(%MCU_SPEC_NAME%
echo     %MCU_SPEC_NAME%
set "MCU_LIST_FOUND=yes"
exit /b 0

:CheckConfiguration
set "CHECK_SOURCE=%TEMP%\FDxAVRC_Check_%RANDOM%_%RANDOM%.c"
set "CHECK_ELF=%TEMP%\FDxAVRC_Check_%RANDOM%_%RANDOM%.elf"
>"%CHECK_SOURCE%" echo #include ^<avr/io.h^>
>>"%CHECK_SOURCE%" echo int main^(void^) { return 0; }
"%C_COMPILER%" -mmcu=%MCU% "%CHECK_SOURCE%" -o "%CHECK_ELF%"
set "CHECK_EXIT_CODE=%ERRORLEVEL%"
if exist "%CHECK_SOURCE%" del /q "%CHECK_SOURCE%" >nul 2>&1
if exist "%CHECK_ELF%" del /q "%CHECK_ELF%" >nul 2>&1
if not "%CHECK_EXIT_CODE%"=="0" goto :CheckCompilerFailed

echo.
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo +++++^>^>                     Configuration Check Passed                 ^<^<+++++
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo.
echo     Compiler MCU:      %MCU% - supported by the installed toolchain
echo     AVRDUDE part:      %AVRDUDE_PART_EFFECTIVE% - matched or configured
if defined FLASH_BYTES_EFFECTIVE echo     Flash capacity:    %FLASH_BYTES_EFFECTIVE% bytes
if defined SRAM_BYTES_EFFECTIVE echo     SRAM capacity:     %SRAM_BYTES_EFFECTIVE% bytes
if defined EEPROM_BYTES_EFFECTIVE echo     EEPROM capacity:   %EEPROM_BYTES_EFFECTIVE% bytes
if not defined FLASH_BYTES_EFFECTIVE echo     Memory profile:    Not built in; manual capacities are optional
echo     Connection:        %PROGRAMMER_CONNECTION_DISPLAY%
echo     Programmer:        %PROGRAMMER%
if defined PROGRAMMER_PORT_EFFECTIVE echo     Port:              %PROGRAMMER_PORT_EFFECTIVE%
if not defined PROGRAMMER_PORT_EFFECTIVE echo     Port:              Not used
if defined PROGRAMMER_BAUD_EFFECTIVE echo     Baud:              %PROGRAMMER_BAUD_EFFECTIVE%
if not defined PROGRAMMER_BAUD_EFFECTIVE echo     Baud:              Not used
if /i "%BUILD_TYPE%"=="bootloader" echo     Boot placement:     %BOOT_START_DISPLAY% - %BOOTLOADER_SIZE_BYTES% bytes reserved
if /i "%LOCK_WRITE_REQUIRED%"=="yes" if /i "%LOCK_WRITE_SAFE%"=="yes" echo     Lock handling:      %LOCK_MODE_DISPLAY% - %LOCK_VALUE_EFFECTIVE%
if /i "%LOCK_WRITE_REQUIRED%"=="yes" if /i not "%LOCK_WRITE_SAFE%"=="yes" echo     Lock handling:      Blocked - lock layout is not verified
if /i not "%LOCK_WRITE_REQUIRED%"=="yes" echo     Lock handling:      No lock-byte write
echo.
exit /b 0

:CheckCompilerFailed
set "FAIL_MESSAGE=The installed AVR toolchain could not compile and link a minimal program for MCU %MCU%."
set "FAIL_EXIT_CODE=%CHECK_EXIT_CODE%"
exit /b 1

:ShowHelp
echo Flyandance 8-bit AVR C/C++ FDxAVRC IDE-Less Build %SCRIPT_VERSION%
echo.
echo Usage:
echo     %~nx0                 Build, then follow AUTO_UPLOAD.
echo     %~nx0 build           Incremental build without uploading.
echo     %~nx0 rebuild         Clean the selected profile and rebuild everything.
echo     %~nx0 clean           Delete the selected app or boot output.
echo     %~nx0 clean-all       Delete the complete configured output folder.
echo     %~nx0 upload          Upload the existing HEX file.
echo     %~nx0 build-upload    Build, then upload.
echo     %~nx0 verify          Verify the existing HEX against the MCU.
echo     %~nx0 probe           Connect and display AVRDUDE device information.
echo     %~nx0 size            Display size information from the existing ELF.
echo     %~nx0 lss             Regenerate the listing from the existing ELF.
echo     %~nx0 symbols         Regenerate the symbol-size report from the ELF.
echo     %~nx0 check           Validate MCU, toolchain, AVRDUDE match, programmer, and profile.
echo     %~nx0 list-mcus       List MCU names installed with AVR-GCC.
echo     %~nx0 list-parts      List AVRDUDE part IDs.
echo     %~nx0 list-programmers List AVRDUDE programmer IDs.
echo     %~nx0 help            Show this help.
echo.
echo Edit Primary Project Settings near the top of this file.
echo A detailed option reference is included at the end of the script.
goto :FinishSuccess

:SetStage
set "CURRENT_STAGE=%~1"
call :WriteStage "%CURRENT_STAGE%"
exit /b 0

:WriteStage
if not defined FDX_STATUS_FILE exit /b 0
>"%FDX_STATUS_FILE%" echo %~1
exit /b 0

:BuildFailed
echo.
echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
call :PrintFailureTitle
echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
echo.
if defined FAIL_MESSAGE echo     Error:     %FAIL_MESSAGE%
if defined CURRENT_STAGE echo     Stage:     %CURRENT_STAGE%
if defined FAIL_EXIT_CODE echo     Exit code: %FAIL_EXIT_CODE%
echo.
echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
call :WriteStage "FAILURE_REPORTED"
if exist "%OBJECT_LIST_FILE%" del /q "%OBJECT_LIST_FILE%" >nul 2>&1
if defined BOOT_LINK_TEMP if exist "%BOOT_LINK_TEMP%" del /q "%BOOT_LINK_TEMP%" >nul 2>&1
call :DeleteTemporaryLists
if /i "%PUSHD_ACTIVE%"=="yes" popd >nul 2>&1
exit /b 1

:PrintFailureTitle
if /i "%FAIL_TITLE%"=="Compilation Failed" goto :FailureTitleCompilation
if /i "%FAIL_TITLE%"=="Linking Failed" goto :FailureTitleLinking
if /i "%FAIL_TITLE%"=="Upload Failed" goto :FailureTitleUpload
if /i "%FAIL_TITLE%"=="Verification Failed" goto :FailureTitleVerification
if /i "%FAIL_TITLE%"=="Device Probe Failed" goto :FailureTitleProbe
if /i "%FAIL_TITLE%"=="Firmware Conversion Failed" goto :FailureTitleConversion
if /i "%FAIL_TITLE%"=="Bootloader Size Failed" goto :FailureTitleBootSize
if /i "%FAIL_TITLE%"=="Bootloader Layout Failed" goto :FailureTitleBootLayout
if /i "%FAIL_TITLE%"=="Lock Write Failed" goto :FailureTitleLock
if /i "%FAIL_TITLE%"=="Firmware Report Failed" goto :FailureTitleReport
echo xxxxx                             Build Failed                            xxxxx
exit /b 0

:FailureTitleCompilation
echo xxxxx                          Compilation Failed                         xxxxx
exit /b 0

:FailureTitleLinking
echo xxxxx                            Linking Failed                           xxxxx
exit /b 0

:FailureTitleUpload
echo xxxxx                             Upload Failed                           xxxxx
exit /b 0

:FailureTitleVerification
echo xxxxx                         Verification Failed                         xxxxx
exit /b 0

:FailureTitleProbe
echo xxxxx                         Device Probe Failed                         xxxxx
exit /b 0

:FailureTitleConversion
echo xxxxx                      Firmware Conversion Failed                     xxxxx
exit /b 0

:FailureTitleBootSize
echo xxxxx                       Bootloader Size Failed                        xxxxx
exit /b 0

:FailureTitleBootLayout
echo xxxxx                      Bootloader Layout Failed                       xxxxx
exit /b 0

:FailureTitleLock
echo xxxxx                         Lock Write Failed                           xxxxx
exit /b 0

:FailureTitleReport
echo xxxxx                       Firmware Report Failed                        xxxxx
exit /b 0

:DeleteTemporaryLists
if defined SOURCE_DISPLAY_FILE if exist "%SOURCE_DISPLAY_FILE%" del /q "%SOURCE_DISPLAY_FILE%" >nul 2>&1
if defined COMPILE_DISPLAY_FILE if exist "%COMPILE_DISPLAY_FILE%" del /q "%COMPILE_DISPLAY_FILE%" >nul 2>&1
if defined SEEN_SOURCE_PLAN_FILE if exist "%SEEN_SOURCE_PLAN_FILE%" del /q "%SEEN_SOURCE_PLAN_FILE%" >nul 2>&1
if defined SEEN_SOURCE_COMPILE_FILE if exist "%SEEN_SOURCE_COMPILE_FILE%" del /q "%SEEN_SOURCE_COMPILE_FILE%" >nul 2>&1
if defined SEEN_LINK_PLAN_FILE if exist "%SEEN_LINK_PLAN_FILE%" del /q "%SEEN_LINK_PLAN_FILE%" >nul 2>&1
if defined SEEN_LINK_COMPILE_FILE if exist "%SEEN_LINK_COMPILE_FILE%" del /q "%SEEN_LINK_COMPILE_FILE%" >nul 2>&1
exit /b 0

:FinishSuccess
call :DeleteTemporaryLists
call :WriteStage "SUCCESS"
if /i "%PUSHD_ACTIVE%"=="yes" popd >nul 2>&1
exit /b 0


::#############################################################################
::#############################################################################
::###                                                                       ###
::###                  SCRIPT USAGE AND OPTION REFERENCE                    ###
::###                                                                       ###
::#############################################################################
::#############################################################################
:: This appendix is documentation only. Normal execution exits before this text.
::
::========== Quick Start =======================================================
:: Place this batch file in the project root. Edit the settings near the top,
:: then double-click it. The default action builds and follows AUTO_UPLOAD.
::
:: Application:
::     set "MCU=atmega88"
::     set "BUILD_TYPE=application"
::     set "AUTO_UPLOAD=yes"
::
:: Bootloader:
::     set "MCU=atmega16"
::     set "BUILD_TYPE=bootloader"
::     set "BOOTLOADER_SIZE_BYTES=1024"
::     set "BOOT_START_ADDRESS=auto"
::     set "LINK_OPTIONS=-Wl,--gc-sections -nostartfiles"
::
:: The script does not inspect or parse source-file contents. Project macros may
:: be defined normally in source code or supplied through DEFINES.
::
::========== Actions ===========================================================
:: No argument        Build, then follow AUTO_UPLOAD.
:: build              Incremental build without uploading.
:: rebuild            Clean the selected app or boot profile, then rebuild.
:: clean              Delete the selected app or boot output.
:: clean-all          Delete the complete OUTPUT_DIR.
:: upload             Upload the existing Flash HEX and selected EEPROM image.
:: build-upload       Build, then upload regardless of AUTO_UPLOAD.
:: verify             Verify existing images against the connected MCU.
:: probe              Connect through AVRDUDE and display device information.
:: size               Display sizes from the existing ELF.
:: lss                Regenerate the LSS report from the existing ELF.
:: symbols            Regenerate the symbol report from the existing ELF.
:: check              Validate toolchain, MCU, AVRDUDE, programmer, and profile.
:: list-mcus          List MCU targets installed with AVR-GCC.
:: list-parts         List device IDs installed with AVRDUDE.
:: list-programmers   List programmer IDs installed with AVRDUDE.
:: help               Display the command summary.
::
::========== List Setting Format ===============================================
:: Semicolon-separated settings preserve their written order:
::     set "DEFINES=DEBUG;BUFFER_SIZE=128"
::     set "INCLUDE_DIRS=include;drivers"
::     set "LIBRARY_DIRS=lib;vendor\lib"
::     set "LIBRARIES=mydriver;m"
:: Empty entries are ignored. Do not add -D, -I, -L, or -l to these list values.
::
::========== Toolchain Paths ===================================================
:: AVR_TOOLCHAIN_BIN points to the folder containing avr-gcc.exe, avr-g++.exe,
:: avr-objcopy.exe, avr-size.exe, and the other AVR GNU tools. Blank uses PATH.
:: AVRDUDE_DIR points to the folder containing avrdude.exe. Blank uses PATH.
:: AVRDUDE_CONF is optional; blank uses AVRDUDE_DIR\avrdude.conf when present.
::
::========== MCU and Device Profile ============================================
:: MCU is passed directly as -mmcu=<name>. Common examples in the setting comment:
:: atmega8, atmega88, atmega168, atmega328p, atmega16, atmega32, attiny10,
:: attiny13, attiny85, atmega64, atmega128, and atmega169p.
::
:: A built-in profile can supply Flash, SRAM, EEPROM, AVRDUDE part ID, valid
:: classic boot sizes, and a verified classic lock-byte layout. Other installed
:: AVR-GCC devices can still compile. Manual capacities can be supplied when the
:: script has no built-in profile.
::
:: AVRDUDE_PART=auto matches the full MCU name against AVRDUDE's installed part
:: list and retrieves its existing -p ID. It does not generate an ID by formula.
::
::========== Definitions =======================================================
:: DEFINES creates compiler -D options. Examples:
::     DEBUG                  becomes -DDEBUG
::     BUFFER_SIZE=128        becomes -DBUFFER_SIZE=128
::
:: The build script does not scan source files for macro definitions.
::
::========== Application and Bootloader Builds ================================
:: BUILD_TYPE=application keeps normal .text placement and permits the optional
:: application custom section. BUILD_TYPE=bootloader relocates .text to the boot
:: start address and ignores CUSTOM_SECTION_NAME and CUSTOM_SECTION_ADDRESS.
::
:: BOOTLOADER_SIZE_BYTES accepts 512, 1024, 2048, or 4096 when the selected
:: profile supports that size. BOOT_START_ADDRESS=auto calculates:
::     flash capacity - reserved bootloader size
:: The result is converted to explicit hexadecimal before it reaches the linker.
:: A manual address such as 0x7C00 can be used when automatic placement is not
:: available. Device BOOTSZ and BOOTRST fuses must agree with the compiled layout;
:: this script does not program those fuses.
::
:: BOOT_NO_JUMP_TABLES=yes adds -fno-jump-tables to bootloader compilation.
:: BOOT_COMPILE_OPTIONS and BOOT_LINK_OPTIONS apply only to bootloader builds.
:: APPLICATION_COMPILE_OPTIONS and APPLICATION_LINK_OPTIONS apply only to
:: application builds.
::
:: -nostartfiles is not implied by bootloader mode. Add it to LINK_OPTIONS only
:: when the project supplies its own entry code and does not use the normal startup
:: object that calls main().
::
::========== Automatic Upload and Programmer ===================================
:: AUTO_UPLOAD=yes uploads after the default build. no builds only. The explicit
:: build command never uploads; build-upload always uploads.
::
:: PROGRAMMER_CONNECTION=usb omits AVRDUDE -P and -b. uart adds PROGRAMMER_PORT
:: and PROGRAMMER_BAUD. PROGRAMMER is the AVRDUDE -c ID.
::
:: Programmer IDs listed in the setting comments:
:: usbasp      USBasp protocol; normally use PROGRAMMER_CONNECTION=usb.
:: butterfly   Serial boot protocol; normally use uart and a COM port.
:: avr109      Serial AVR109 protocol; normally use uart and a COM port.
:: avr910      Serial AVR910 protocol; normally use uart and a COM port.
:: stk500v2    Serial STK500v2 protocol; normally use uart and a COM port.
:: stk500v1    Serial STK500v1 protocol; normally use uart and a COM port.
::
:: PROGRAMMER_PORT is normally COM3 or another Windows COM port for UART devices.
:: PROGRAMMER_BAUD may use 2000000, 1000000, 500000, 250000, 230400, 115200,
:: 57600, 38400, or 19200 when supported by the programmer firmware and adapter.
::
:: SERIAL_AUTO_RESET=auto enables the serial reset path for butterfly and avr109.
:: yes always attempts it; no never attempts it. USBasp normally does not need it.
:: A failed upload waits for a key press, then tries the upload again.
::
:: AVRDUDE_OPTIONS appends advanced options unchanged:
:: -F                    Override a signature mismatch; use only when deliberate.
:: -x devcode=0x11       Pass an extended programmer parameter when supported.
:: -B 1.0                Example USBasp bit-clock period control.
::
::========== EEPROM Upload =====================================================
:: UPLOAD_EEPROM=no never writes or verifies EEPROM. yes requires the current
:: *.EEPROM.hex image. auto includes EEPROM only when the current image exists.
:: AVRDUDE verifies written memory by default; the verify action performs a
:: separate comparison without rebuilding.
::
::========== Lock Byte After Upload ============================================
:: APPLICATION_LOCK_MODE applies to application uploads:
:: unlocked      Do not write a lock byte.
:: bootProtect   Use 0xEF only for verified classic profiles.
:: appProtect    Use 0xFB only for verified classic profiles.
:: fullLock      Use 0xC0 only for verified classic profiles.
::
:: Bootloader uploads request bootProtect automatically only when the profile's
:: classic lock layout is verified. Lock bytes are not clock, BOOTSZ, BOOTRST,
:: brown-out, or oscillator fuses. An erased lock byte cannot normally be restored
:: to unlocked by writing 0xFF; a chip erase is generally required.
::
::========== Common Compiler Options ===========================================
:: COMMON_COMPILE_OPTIONS applies to C, C++, and assembly driver invocations.
:: C_COMPILE_OPTIONS applies only to C. CPP_COMPILE_OPTIONS applies only to C++.
:: ASM_COMPILE_OPTIONS applies only to .s and .S sources.
::
:: Optimization and code generation:
:: -Os                      Optimize for small code size.
:: -O0                      Disable optimization.
:: -Og                      Debug-oriented optimization when supported.
:: -O1, -O2, -O3            Increasing optimization levels; measure the result.
:: -flto                    Enable link-time optimization; rebuild all objects.
:: -ffunction-sections      Place each function in a separate section.
:: -fdata-sections          Place each data object in a separate section.
:: -fno-jump-tables        Prevent compiler-generated jump tables.
:: -mcall-prologues         Share selected prologue/epilogue sequences.
::
:: General diagnostics:
:: -g                       Add debug information to ELF and LSS output.
:: -Wall                    Enable the main useful warning set.
:: -Wextra                  Enable additional warnings.
:: -Wpedantic               Warn about non-standard language extensions.
:: -Werror                  Treat enabled compiler warnings as errors.
::
:: C diagnostics:
:: -Wstrict-prototypes      Warn when a function declaration lacks parameter types.
:: -Wmissing-prototypes     Warn when a global function lacks a prior prototype.
:: -Wold-style-definition   Warn about old K&R-style function definitions.
:: -Wshadow                 Warn when a declaration hides another name.
:: -Wconversion             Warn about potentially value-changing conversions.
::
:: C++ runtime and size controls:
:: -fno-exceptions          Remove exception support when the code does not use it.
:: -fno-rtti                Remove run-time type information when unused.
:: -fno-threadsafe-statics  Remove guarded local-static initialization support.
:: -fno-use-cxa-atexit      Avoid __cxa_atexit registration for static destructors.
::
:: C++ diagnostics:
:: -Wold-style-cast         Warn about C-style casts in C++.
:: -Wnon-virtual-dtor       Warn about polymorphic classes without virtual destructors.
:: -Woverloaded-virtual     Warn when a derived declaration hides a virtual function.
::
:: GNU assembly controls:
:: -g                       Add debug information.
:: -Wa,--gstabs             Ask the assembler to emit STABS line information.
:: -x assembler-with-cpp    Force preprocessed GNU assembly input.
::
::========== Language Standards ================================================
:: C_STANDARD and CPP_STANDARD are passed as -std=<value>. Blank uses the
:: installed compiler default. Examples from the settings:
:: C:   c11, c17, gnu11, gnu17
:: C++: c++11, c++14, gnu++17
:: Older AVR-GCC releases may not support newer standard names.
::
::========== Linker Options ====================================================
:: LINK_OPTIONS is appended to every link. Application and bootloader profile
:: linker options are appended afterward. Libraries and library paths should
:: normally use LIBRARIES and LIBRARY_DIRS instead of manual -l or -L options.
::
:: Startup and runtime control:
:: -nostartfiles             Omit startup objects; keep default libraries.
:: -nodefaultlibs            Keep startup objects; omit automatic libraries.
:: -nostdlib                 Omit startup objects and automatic libraries.
::
:: Section and report controls:
:: -Wl,--gc-sections         Remove unreachable function and data sections.
:: -Wl,--relax               Relax eligible AVR calls, jumps, and addresses.
:: -Wl,--print-memory-usage  Print the linker's memory-region table.
:: -Wl,--cref                Add a symbol cross-reference table to the map file.
::
:: Symbol and strictness controls:
:: -Wl,--undefined=symbol    Force a symbol to be treated as referenced.
:: -Wl,--defsym,name=value   Create an absolute numeric linker symbol.
:: -Wl,--warn-common         Warn about conflicting common symbols.
:: -Wl,--fatal-warnings      Convert linker warnings into link failures.
::
:: CREATE_MAP_FILE adds the map-file option automatically. Bootloader mode adds
:: only its .text relocation; application mode may add the configured custom
:: section placement. LINK_OPTIONS remains user-controlled.
::
::========== Includes, Libraries, and Objects ==================================
:: INCLUDE_DIRS adds compiler -I search folders. Example: include;drivers.
:: LIBRARY_DIRS adds linker -L search folders. Example: lib;vendor\lib.
:: LIBRARIES adds -l names in written order and omits the lib prefix and .a suffix:
::     m              links libm.a for math functions.
::     mydriver       links libmydriver.a from a configured library folder.
::     m;mydriver     links libm.a first, then libmydriver.a.
:: libc, libgcc, and the selected MCU support are normally linked automatically.
::
:: EXTRA_OBJECTS links named .o, .obj, and .a files directly. LINK_EXTERNAL_OBJECTS
:: controls recursive scanning of EXTERNAL_OBJECT_DIRS. OUTPUT_DIR is always
:: excluded from that scan. Duplicate absolute object paths are suppressed.
::
::========== Source and Output Settings ========================================
:: PROJECT_LANGUAGE selects the final linker driver only:
:: auto    Use avr-g++ when any C++ source exists; otherwise use avr-gcc.
:: c       Force avr-gcc as the final linker driver.
:: cpp     Force avr-g++ as the final linker driver.
:: Individual source extensions still select their own compiler.
::
:: SOURCE_DIRS is recursive and semicolon-separated. [.] scans the project root
:: and every subfolder. Example: src;common scans only those source trees.
:: EXCLUDE_DIRS removes additional project-relative or absolute folders.
:: OUTPUT_DIR is always excluded from source and external-object scans.
:: Overlapping source roots are normalized and deduplicated.
::
:: Supported source extensions:
:: .c                 C through avr-gcc.
:: .cc, .cpp, .cxx    C++ through avr-g++.
:: .s                 GNU assembly.
:: .S                 GNU assembly preprocessed by the C preprocessor.
:: COMPILE_ASSEMBLY=no ignores both .s and .S files.
::
:: OUTPUT_NAME sets the firmware base name. Blank uses the project-folder name.
:: OUTPUT_DIR defaults to _Output. Application build files use its app subfolder;
:: bootloader build files use its boot subfolder. Flash and EEPROM HEX images are
:: placed directly in OUTPUT_DIR with APP_ or BOOT_ prefixes.
::
::========== Incremental Build Settings ========================================
:: RECOMPILE_ALL=no reuses an object when its source and dependency headers are
:: unchanged. yes compiles every discovered source. The build signature includes
:: toolchain, compiler, MCU, build type, detected clock, standards, definitions,
:: include folders, compile options, linker options, libraries, custom section,
:: source roots, assembly mode, and external-object settings. A relevant change
:: forces a full rebuild.
::
:: DELETE_OBJECTS=no keeps objects and dependency files for incremental builds.
:: yes removes that cache after a successful link.
::
::========== Application Custom Section ========================================
:: CUSTOM_SECTION_NAME and CUSTOM_SECTION_ADDRESS apply only to application mode.
:: The default places FD_App_Start_Add at 0x0. The source must explicitly place
:: code or data into that named section. Blank CUSTOM_SECTION_NAME disables the
:: placement. Bootloader builds ignore both settings completely.
::
::========== Manual Device Capacity ============================================
:: FLASH_SIZE_BYTES overrides profile Flash capacity. Common values listed in the
:: setting are 512 through 262144 bytes.
:: SRAM_SIZE_BYTES overrides profile SRAM capacity. Common values listed are 32
:: through 16384 bytes.
:: EEPROM_SIZE_BYTES overrides profile EEPROM capacity. Use 0 for no EEPROM;
:: common values listed are 0 through 4096 bytes.
:: Blank values retain built-in profile data or leave the capacity unknown.
::
::========== Generated Files and Display =======================================
:: KEEP_ELF=yes retains the linked ELF; no deletes it after reports are created.
:: CREATE_LSS=yes creates *.lss.txt through avr-objdump.
:: CREATE_MAP_FILE=yes creates *.map through the linker.
:: CREATE_EEPROM_FILE=yes creates *.EEPROM.hex only when initialized .eeprom data
:: exists. A stale EEPROM image is removed when the current build has none.
:: CREATE_SYMBOL_REPORT=yes creates *.symbols.txt through avr-nm.
:: SHOW_SIZE=yes displays Flash, SRAM, and EEPROM sizes. Application builds may
:: hide this report with no. Bootloader builds still validate their boot region.
:: SHOW_COMMANDS=yes prints full compiler, linker, converter, and AVRDUDE commands.
:: Successful builds and uploads close after five seconds. Errors always pause.
::
:: Generated files:
:: .elf             Linked image with sections and symbols.
:: .hex             Flash Intel HEX image.
:: .EEPROM.hex      Initialized EEPROM Intel HEX image.
:: .lss.txt         Source and disassembly listing.
:: .map             Linker map and optional cross-reference information.
:: .symbols.txt     Symbol-size report.
::
::========== Bootloader Size Validation ========================================
:: The validator reads loadable ELF sections and counts only bytes overlapping the
:: reserved boot region. Low-address application sections are not charged to the
:: bootloader. A bootloader is rejected when no loadable bytes occupy the reserved
:: region, when loadable bytes fall outside it, or when region usage exceeds the
:: reserved size.
::
::========== Action-Specific Tools =============================================
:: build/rebuild require the compiler, linker driver, avr-objcopy, avr-size, and
:: enabled report tools. upload/verify/probe require AVRDUDE, not the compiler.
:: size requires avr-size and an ELF. lss requires avr-objdump. symbols requires
:: avr-nm. check compiles and links a temporary minimal program for the MCU.
::
::========== Error Handling ====================================================
:: Tool output is printed directly once. No log files are created. A concise
:: stage-specific failure report follows, and failures always pause. The child CMD
:: wrapper also reports parser failures that would otherwise close the window.
::
::#############################################################################
::### End of Script Reference
::#############################################################################
