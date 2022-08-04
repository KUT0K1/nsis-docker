!include "FileFunc.nsh"
!insertmacro GetSize

# Compilation only defines.
!define APP_NAME "hello-world-log"
!ifndef APP_VERSION
    !define APP_VERSION "0.0.0.1"
!endif

# Installer icons.
Icon ".\favicon.ico"
UninstallIcon ".\favicon.ico"

# Defines the installation folder.
InstallDir "C:\${APP_NAME}\"

# Installer name.
Name "${APP_NAME} ${APP_VERSION}"

# Installer file.
Outfile "${APP_NAME}-${APP_VERSION}.exe"

# Administration rights are required.
RequestExecutionLevel admin

# Executable information injected into the properties.
VIProductVersion "${APP_VERSION}"
VIAddVersionKey "Comments" "Installs a hello-world console application."
VIAddVersionKey "CompanyName" "AWD"
VIAddVersionKey "FileDescription" "${APP_NAME} installation executable."
VIAddVersionKey "FileVersion" "${APP_VERSION}"
VIAddVersionKey "LegalCopyright" "AWD"
VIAddVersionKey "LegalTrademarks" "${APP_NAME} is a trademark of AWD"
VIAddVersionKey "ProductName" "${APP_NAME}"
VIAddVersionKey "ProductVersion" "${APP_VERSION}"

# Default installation section.
Section
    LogSet on
    # Defines installation folder and configs.
    SetOutPath $INSTDIR

    # Installs files.
    File ".\hello-world.bat"
    File ".\favicon.ico"
    WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section "Windows Registry"
    LogSet on
    # Calculating installation size.
    ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2 
    IntFmt $0 "0x%08X" $0

    # Uninstaller registry.
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "EstimatedSize" $0
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoRepair" 1
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayIcon" '"$INSTDIR\favicon.ico"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayVersion" "${APP_VERSION}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "InstallLocation" '"$INSTDIR"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "QuietUninstallString" '"$INSTDIR\uninstall.exe" /S'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "Publisher" "AWD"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'
SectionEnd

# Section to start the app.
Section "App Start"
    LogSet on
    ExecWait '"$INSTDIR\hello-world.bat"'
SectionEnd

# Default uninstall section, fixed name.
Section "Uninstall"
    # LogSet on # Enabling log on uninstall will not delete the main folder!
    # Cleaning uninstaller registry.
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}\DisplayIcon"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}\DisplayName"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}\DisplayVersion"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}\EstimatedSize"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}\InstallLocation"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}\NoModify"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}\NoRepair"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}\QuietUninstallString"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}\Publisher"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}\UninstallString"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
    # Removes the entire installation folder.
    RMDir /r "$INSTDIR"
SectionEnd
