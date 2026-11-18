; Instalator spolszczenia FINAL FANTASY IV Pixel Remaster (NSIS 3, Unicode)
; Autor: Piopal. Kod na licencji MIT.
Unicode true
!include "MUI2.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"

!define GAMENAME   "FINAL FANTASY IV"
!define GAMEEXE    "FINAL FANTASY IV.exe"
!define DATADIR    "FINAL FANTASY IV_Data"
!define STEAMAPPID "1173800"
!define STEAMFOLDER "FINAL FANTASY IV PR"
!define BUNDLE     "message_assets_all_eb950d54fa0ee06699dc6f3c6f5061e9.bundle"
!define VERSION    "1.0"
!define UNKEY      "Software\Microsoft\Windows\CurrentVersion\Uninstall\FF4PR_Spolszczenie_PL"

Name "${GAMENAME} Pixel Remaster - Spolszczenie"
OutFile "FF4PR_Spolszczenie_Instalator_v${VERSION}.exe"
InstallDir ""
RequestExecutionLevel admin
ShowInstDetails show
BrandingText "Spolszczenie ${GAMENAME} PR v${VERSION} - Piopal"

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_TEXT "Spolszczenie zostało zainstalowane.$\r$\n$\r$\nPamiętaj: język gry musi być ustawiony na portugalski brazylijski (Português / Brasil) w ustawieniach gry oraz, jeśli jest taka opcja, także w Steam (Właściwości gry -> Język)."
!define MUI_UNCONFIRMPAGE_TEXT_TOP "Po deinstalacji powróci oryginalna wersja językowa gry (tekst portugalski)."

Var Dialog
Var DirEdit
Var ScanBtn
Var GameDir

Page custom GamePageCreate GamePageLeave
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "Polish"

; ---------- wykrywanie folderu gry ----------
Function CheckDir ; wejście: $0 = folder; wyjście: $1 = 1/0
  StrCpy $1 0
  IfFileExists "$0\${GAMEEXE}" 0 +2
    StrCpy $1 1
FunctionEnd

Function ScanDrives ; wyjście: $R9 = folder lub ""
  StrCpy $R9 ""
  StrCpy $R0 67 ; 'C'
  ${Do}
    IntFmt $R1 "%c" $R0
    StrCpy $R2 "$R1:\"
    IfFileExists "$R2*.*" 0 next
    StrCpy $0 "$R2Program Files (x86)\Steam\steamapps\common\${STEAMFOLDER}"
    Call CheckDir
    ${If} $1 == 1
      StrCpy $R9 $0
      Return
    ${EndIf}
    StrCpy $0 "$R2Program Files\Steam\steamapps\common\${STEAMFOLDER}"
    Call CheckDir
    ${If} $1 == 1
      StrCpy $R9 $0
      Return
    ${EndIf}
    StrCpy $0 "$R2Steam\steamapps\common\${STEAMFOLDER}"
    Call CheckDir
    ${If} $1 == 1
      StrCpy $R9 $0
      Return
    ${EndIf}
    StrCpy $0 "$R2SteamLibrary\steamapps\common\${STEAMFOLDER}"
    Call CheckDir
    ${If} $1 == 1
      StrCpy $R9 $0
      Return
    ${EndIf}
    StrCpy $0 "$R2Games\Steam\steamapps\common\${STEAMFOLDER}"
    Call CheckDir
    ${If} $1 == 1
      StrCpy $R9 $0
      Return
    ${EndIf}
    StrCpy $0 "$R2Games\SteamLibrary\steamapps\common\${STEAMFOLDER}"
    Call CheckDir
    ${If} $1 == 1
      StrCpy $R9 $0
      Return
    ${EndIf}
    next:
    IntOp $R0 $R0 + 1
  ${LoopUntil} $R0 > 90 ; 'Z'
FunctionEnd

Function FindGameDir ; wynik w $GameDir
  StrCpy $GameDir ""
  SetRegView 64
  ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Steam App ${STEAMAPPID}" "InstallLocation"
  SetRegView 32
  ${If} $0 != ""
    Call CheckDir
    ${If} $1 == 1
      StrCpy $GameDir $0
    ${EndIf}
  ${EndIf}
  ${If} $GameDir == ""
    ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Steam App ${STEAMAPPID}" "InstallLocation"
    ${If} $0 != ""
      Call CheckDir
      ${If} $1 == 1
        StrCpy $GameDir $0
      ${EndIf}
    ${EndIf}
  ${EndIf}
  ${If} $GameDir == ""
    Call ScanDrives
    StrCpy $GameDir $R9
  ${EndIf}
  ${If} $GameDir == ""
    StrCpy $GameDir "$PROGRAMFILES32\Steam\steamapps\common\${STEAMFOLDER}"
  ${EndIf}
FunctionEnd

Function .onInit
  Call FindGameDir
FunctionEnd

; ---------- strona wyboru folderu (zawsze widoczna) ----------
Function GamePageCreate
  !insertmacro MUI_HEADER_TEXT "Wybór folderu gry" "Wskaż główny folder gry ${GAMENAME} Pixel Remaster (z plikiem ${GAMEEXE})."
  nsDialogs::Create 1018
  Pop $Dialog
  ${If} $Dialog == error
    Abort
  ${EndIf}
  ${NSD_CreateLabel} 0 0 100% 24u "Instalator wykrył poniższy folder. Jeśli jest nieprawidłowy, użyj przycisku $\"Przeglądaj...$\" albo $\"Skanuj dyski$\"."
  Pop $0
  ${NSD_CreateText} 0 32u 75% 12u "$GameDir"
  Pop $DirEdit
  ${NSD_CreateButton} 77% 31u 23% 14u "Przeglądaj..."
  Pop $0
  ${NSD_OnClick} $0 BrowseClick
  ${NSD_CreateButton} 77% 50u 23% 14u "Skanuj dyski"
  Pop $ScanBtn
  ${NSD_OnClick} $ScanBtn ScanClick
  nsDialogs::Show
FunctionEnd

Function BrowseClick
  nsDialogs::SelectFolderDialog "Wskaż folder gry ${GAMENAME} Pixel Remaster" "$GameDir"
  Pop $0
  ${If} $0 != error
    ${NSD_SetText} $DirEdit $0
  ${EndIf}
FunctionEnd

Function ScanClick
  EnableWindow $ScanBtn 0
  ${NSD_SetText} $ScanBtn "Szukam..."
  Call ScanDrives
  ${NSD_SetText} $ScanBtn "Skanuj dyski"
  EnableWindow $ScanBtn 1
  ${If} $R9 != ""
    ${NSD_SetText} $DirEdit $R9
    MessageBox MB_OK|MB_ICONINFORMATION "Znaleziono folder z grą:$\r$\n$R9"
  ${Else}
    MessageBox MB_OK|MB_ICONSTOP "Nie znaleziono pliku ${GAMEEXE} w standardowych folderach. Wskaż katalog ręcznie przyciskiem Przeglądaj."
  ${EndIf}
FunctionEnd

Function GamePageLeave
  ${NSD_GetText} $DirEdit $GameDir
  StrCpy $0 $GameDir
  Call CheckDir
  ${If} $1 != 1
    MessageBox MB_OK|MB_ICONSTOP "W wybranym folderze nie znaleziono pliku ${GAMEEXE}.$\r$\nWskaż główny katalog gry ${GAMENAME} Pixel Remaster."
    Abort
  ${EndIf}
  IfFileExists "$GameDir\${DATADIR}\StreamingAssets\aa\catalog.json.bak" 0 ok
    MessageBox MB_YESNO|MB_ICONQUESTION "Spolszczenie zostało już zainstalowane w tej lokalizacji.$\r$\nCzy chcesz zainstalować je ponownie?" IDYES ok
    Abort
  ok:
FunctionEnd

!macro BackupFile F
  IfFileExists "${F}.bak" +2 0
    CopyFiles /SILENT "${F}" "${F}.bak"
!macroend
!macro RestoreFile F
  IfFileExists "${F}.bak" 0 +3
    Delete "${F}"
    Rename "${F}.bak" "${F}"
!macroend

; ---------- instalacja ----------
Section "Spolszczenie"
  StrCpy $INSTDIR $GameDir
  StrCpy $R8 "$INSTDIR\${DATADIR}\StreamingAssets"
  ; kopie zapasowe oryginałów (tylko jeśli jeszcze nie istnieją)
  !insertmacro BackupFile "$R8\aa\catalog.json"
  !insertmacro BackupFile "$R8\aa\StandaloneWindows64\${BUNDLE}"
  !insertmacro BackupFile "$R8\font_de.bundle"
  !insertmacro BackupFile "$R8\font_en.bundle"
  !insertmacro BackupFile "$R8\font_es.bundle"
  !insertmacro BackupFile "$R8\font_fr.bundle"
  !insertmacro BackupFile "$R8\font_it.bundle"
  !insertmacro BackupFile "$R8\font_pt.bundle"
  SetOutPath "$R8\aa"
  File "pliki\catalog.json"
  SetOutPath "$R8\aa\StandaloneWindows64"
  File "pliki\StandaloneWindows64\${BUNDLE}"
  SetOutPath "$R8"
  File "pliki\font_de.bundle"
  File "pliki\font_en.bundle"
  File "pliki\font_es.bundle"
  File "pliki\font_fr.bundle"
  File "pliki\font_it.bundle"
  File "pliki\font_pt.bundle"
  ; ukryty deinstalator + skrót
  CreateDirectory "$INSTDIR\_spolszczenie_deinstalator"
  WriteUninstaller "$INSTDIR\_spolszczenie_deinstalator\unins_spolszczenie.exe"
  SetFileAttributes "$INSTDIR\_spolszczenie_deinstalator\unins_spolszczenie.exe" HIDDEN
  SetFileAttributes "$INSTDIR\_spolszczenie_deinstalator" HIDDEN
  CreateShortCut "$INSTDIR\Usunięcie spolszczenia.lnk" "$INSTDIR\_spolszczenie_deinstalator\unins_spolszczenie.exe"
  WriteRegStr HKLM "${UNKEY}" "DisplayName" "${GAMENAME} Pixel Remaster - Spolszczenie"
  WriteRegStr HKLM "${UNKEY}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKLM "${UNKEY}" "Publisher" "Piopal"
  WriteRegStr HKLM "${UNKEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "${UNKEY}" "UninstallString" '"$INSTDIR\_spolszczenie_deinstalator\unins_spolszczenie.exe"'
  WriteRegDWORD HKLM "${UNKEY}" "NoModify" 1
  WriteRegDWORD HKLM "${UNKEY}" "NoRepair" 1
SectionEnd

; ---------- deinstalacja ----------
Section "Uninstall"
  ReadRegStr $0 HKLM "${UNKEY}" "InstallLocation"
  ${If} $0 == ""
    MessageBox MB_OK|MB_ICONSTOP "Nie znaleziono lokalizacji gry w rejestrze. Przywróć pliki .bak ręcznie lub użyj weryfikacji plików w Steam."
    Abort
  ${EndIf}
  StrCpy $R8 "$0\${DATADIR}\StreamingAssets"
  !insertmacro RestoreFile "$R8\aa\catalog.json"
  !insertmacro RestoreFile "$R8\aa\StandaloneWindows64\${BUNDLE}"
  !insertmacro RestoreFile "$R8\font_de.bundle"
  !insertmacro RestoreFile "$R8\font_en.bundle"
  !insertmacro RestoreFile "$R8\font_es.bundle"
  !insertmacro RestoreFile "$R8\font_fr.bundle"
  !insertmacro RestoreFile "$R8\font_it.bundle"
  !insertmacro RestoreFile "$R8\font_pt.bundle"
  Delete "$0\Usunięcie spolszczenia.lnk"
  DeleteRegKey HKLM "${UNKEY}"
  SetFileAttributes "$0\_spolszczenie_deinstalator" NORMAL
  Delete "$0\_spolszczenie_deinstalator\unins_spolszczenie.exe"
  RMDir "$0\_spolszczenie_deinstalator"
SectionEnd
