[Setup]
AppName=Velheim Launcher
AppPublisher=Velheim
UninstallDisplayName=Velheim
AppVersion=${project.version}
AppSupportURL=https://www.velheim.com
DefaultDirName={localappdata}\Velheim

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=x64
PrivilegesRequired=lowest

WizardSmallImageFile=${project.projectDir}/innosetup/runelite_small.bmp
SetupIconFile=${project.projectDir}/innosetup/runelite.ico
UninstallDisplayIcon={app}\Velheim.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${project.projectDir}
OutputBaseFilename=VelheimSetup

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${project.projectDir}\build\win-x64\Velheim.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "${project.projectDir}\build\win-x64\Velheim.jar"; DestDir: "{app}"
Source: "${project.projectDir}\build\win-x64\launcher_amd64.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "${project.projectDir}\build\win-x64\config.json"; DestDir: "{app}"
Source: "${project.projectDir}\build\win-x64\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs

[Icons]
; start menu
Name: "{userprograms}\Velheim\Velheim"; Filename: "{app}\Velheim.exe"
Name: "{userprograms}\Velheim\Velheim (configure)"; Filename: "{app}\Velheim.exe"; Parameters: "--configure"
Name: "{userprograms}\Velheim\Velheim (safe mode)"; Filename: "{app}\Velheim.exe"; Parameters: "--safe-mode"
Name: "{userdesktop}\Velheim"; Filename: "{app}\Velheim.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\Velheim.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\Velheim.exe"; Description: "&Open Velheim"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"
; previous shortcut
Type: files; Name: "{userprograms}\Velheim.lnk"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\Velheim\repository"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Registry]
Root: HKCU; Subkey: "Software\Classes\runelite-jav"; ValueType: string; ValueName: ""; ValueData: "URL:runelite-jav Protocol"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell\open"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\Velheim.exe"" ""%1"""; Flags: uninsdeletekey

[Code]
#include "upgrade.pas"
#include "usernamecheck.pas"
#include "dircheck.pas"