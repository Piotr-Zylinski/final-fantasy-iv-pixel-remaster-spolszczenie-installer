; =====================================================================
;  FINAL FANTASY IV Pixel Remaster - Spolszczenie (instalator Inno Setup 7)
;  Autor: Piopal (Piotr-Zylinski). Kod na licencji MIT.
;  Wariant angielski (od v1.2): spolszczenie zastępuje język English gry.
;  Aktualizuje wersje 1.0 i 1.1 (stary instalator NSIS) bez odinstalowywania.
;  Kompilacja: "C:\Program Files\Inno Setup 7\ISCC.exe" FF4PR_Instalator.iss
;  (obok skryptu folder "pliki" z 10 plikami spolszczenia - patrz README).
;  Zapisz jako UTF-8 z BOM.
; =====================================================================

#define GameName      "FINAL FANTASY IV"
#define GameExe       "FINAL FANTASY IV.exe"
#define DataDir       "FINAL FANTASY IV_Data"
#define SteamAppId    "1173800"
#define SteamFolder   "FINAL FANTASY IV PR"
#define TextBundle    "message_assets_all_eb950d54fa0ee06699dc6f3c6f5061e9.bundle"
#define MissBundle    "miss_sprite_assets_all_bfad4e62c8010fe65066042f5e85ad90.bundle"
#define HitBundle     "hit_sprite_assets_all_6380dd1917bb4b39bda7a83852ce0447.bundle"
#define ModVersion    "1.2"
#define Prefix        "FF4PR"

[Setup]
; AppId inny niż klucz starego instalatora NSIS (FF4PR_Spolszczenie_PL), żeby nie było dwóch wpisów.
AppId={#Prefix}_Spolszczenie_PL_v2
AppName={#GameName} Pixel Remaster - Spolszczenie
AppVersion={#ModVersion}
AppVerName={#GameName} Pixel Remaster - Spolszczenie {#ModVersion}
AppPublisher=Piopal
AppPublisherURL=https://github.com/Piotr-Zylinski/final-fantasy-iv-pixel-remaster-spolszczenie-installer
VersionInfoVersion={#ModVersion}
VersionInfoDescription={#GameName} Pixel Remaster - Spolszczenie
DefaultDirName={code:FindGameDir}
UsePreviousAppDir=no
DisableDirPage=no
DirExistsWarning=no
DisableProgramGroupPage=yes
AppendDefaultDirName=no
PrivilegesRequired=admin
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
WizardStyle=modern
OutputDir=output
OutputBaseFilename={#Prefix}_Spolszczenie_Instalator_v{#ModVersion}
Compression=lzma2
SolidCompression=yes
UninstallFilesDir={app}\_spolszczenie_deinstalator
UninstallDisplayName={#GameName} Pixel Remaster - Spolszczenie
CreateUninstallRegKey=yes
SetupLogging=yes

[Languages]
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"

[Messages]
SelectDirLabel3=Wskaż główny folder gry {#GameName} Pixel Remaster (ten, w którym jest plik {#GameExe}). Instalator wykrył go automatycznie - jeśli jest nieprawidłowy, użyj przycisku „Przeglądaj...” albo „Skanuj dyski”.
FinishedHeadingLabel=Spolszczenie zostało zainstalowane
FinishedLabelNoIcons=Spolszczenie zastępuje angielską wersję językową gry {#GameName} Pixel Remaster.%n%nAby przywrócić oryginalny angielski tekst, użyj skrótu „Usunięcie spolszczenia” w folderze gry lub „Dodaj lub usuń programy”.
FinishedLabel=Spolszczenie zastępuje angielską wersję językową gry {#GameName} Pixel Remaster.%n%nAby przywrócić oryginalny angielski tekst, użyj skrótu „Usunięcie spolszczenia” w folderze gry lub „Dodaj lub usuń programy”.
ConfirmUninstall=Czy na pewno chcesz usunąć spolszczenie gry {#GameName} Pixel Remaster?%n%nPo usunięciu powróci oryginalna angielska wersja językowa gry.

[Dirs]
Name: "{app}\_spolszczenie_deinstalator"; Attribs: hidden

[Files]
; Pliki gry NIE są usuwane przez deinstalator (uninsneveruninstall) - oryginały przywraca kod z kopii .bak.
Source: "pliki\catalog.json"; DestDir: "{app}\{#DataDir}\StreamingAssets\aa"; Flags: ignoreversion uninsneveruninstall
Source: "pliki\StandaloneWindows64\{#TextBundle}"; DestDir: "{app}\{#DataDir}\StreamingAssets\aa\StandaloneWindows64"; Flags: ignoreversion uninsneveruninstall
Source: "pliki\StandaloneWindows64\{#MissBundle}"; DestDir: "{app}\{#DataDir}\StreamingAssets\aa\StandaloneWindows64"; Flags: ignoreversion uninsneveruninstall
Source: "pliki\StandaloneWindows64\{#HitBundle}"; DestDir: "{app}\{#DataDir}\StreamingAssets\aa\StandaloneWindows64"; Flags: ignoreversion uninsneveruninstall
Source: "pliki\font_de.bundle"; DestDir: "{app}\{#DataDir}\StreamingAssets"; Flags: ignoreversion uninsneveruninstall
Source: "pliki\font_en.bundle"; DestDir: "{app}\{#DataDir}\StreamingAssets"; Flags: ignoreversion uninsneveruninstall
Source: "pliki\font_es.bundle"; DestDir: "{app}\{#DataDir}\StreamingAssets"; Flags: ignoreversion uninsneveruninstall
Source: "pliki\font_fr.bundle"; DestDir: "{app}\{#DataDir}\StreamingAssets"; Flags: ignoreversion uninsneveruninstall
Source: "pliki\font_it.bundle"; DestDir: "{app}\{#DataDir}\StreamingAssets"; Flags: ignoreversion uninsneveruninstall
Source: "pliki\font_pt.bundle"; DestDir: "{app}\{#DataDir}\StreamingAssets"; Flags: ignoreversion uninsneveruninstall

[Icons]
Name: "{app}\Usunięcie spolszczenia"; Filename: "{uninstallexe}"; Comment: "Usuwa spolszczenie i przywraca oryginalną angielską wersję gry"

[Code]
const
  SumsFileName = 'sumy_kontrolne.txt';
  OldUnKey = 'Software\Microsoft\Windows\CurrentVersion\Uninstall\FF4PR_Spolszczenie_PL';
  OldUnExe = '_spolszczenie_deinstalator\unins_spolszczenie.exe';

var
  ScanButton: TNewButton;
  OutdatedFiles: String;
  UpdatedFromOld: Boolean;
  OldVersionText: String;

{ Windows API: zdjęcie atrybutów (ukryty plik starego deinstalatora NSIS) }
function SetFileAttributes(lpFileName: String; dwFileAttributes: LongWord): Boolean;
  external 'SetFileAttributesW@kernel32.dll stdcall';

{ ---------- lista podmienianych plików (ścieżki względem folderu gry) ---------- }
function ModFiles(): TArrayOfString;
var
  SA: String;
begin
  SA := '{#DataDir}\StreamingAssets\';
  SetArrayLength(Result, 10);
  Result[0] := SA + 'aa\catalog.json';
  Result[1] := SA + 'aa\StandaloneWindows64\{#TextBundle}';
  Result[2] := SA + 'aa\StandaloneWindows64\{#MissBundle}';
  Result[3] := SA + 'aa\StandaloneWindows64\{#HitBundle}';
  Result[4] := SA + 'font_de.bundle';
  Result[5] := SA + 'font_en.bundle';
  Result[6] := SA + 'font_es.bundle';
  Result[7] := SA + 'font_fr.bundle';
  Result[8] := SA + 'font_it.bundle';
  Result[9] := SA + 'font_pt.bundle';
end;

{ ---------- wykrywanie folderu gry ---------- }
function CheckGameDir(Dir: String): Boolean;
begin
  Result := (Dir <> '') and
            FileExists(AddBackslash(Dir) + '{#GameExe}') and
            FileExists(AddBackslash(Dir) + '{#DataDir}\StreamingAssets\aa\catalog.json');
end;

function SteamLibraryCandidate(LibPath: String): String;
begin
  Result := AddBackslash(LibPath) + 'steamapps\common\{#SteamFolder}';
end;

{ Biblioteki Steam z pliku libraryfolders.vdf (np. gra na innym dysku). }
function FindInSteamLibraries(): String;
var
  SteamPath, Line, Value: String;
  Lines: TArrayOfString;
  I, P: Integer;
begin
  Result := '';
  if not RegQueryStringValue(HKLM32, 'SOFTWARE\Valve\Steam', 'InstallPath', SteamPath) then
    if not RegQueryStringValue(HKCU, 'SOFTWARE\Valve\Steam', 'SteamPath', SteamPath) then
      Exit;
  StringChangeEx(SteamPath, '/', '\', True);
  if CheckGameDir(SteamLibraryCandidate(SteamPath)) then
  begin
    Result := SteamLibraryCandidate(SteamPath);
    Exit;
  end;
  if not LoadStringsFromFile(AddBackslash(SteamPath) + 'steamapps\libraryfolders.vdf', Lines) then
    Exit;
  for I := 0 to GetArrayLength(Lines) - 1 do
  begin
    Line := Trim(Lines[I]);
    if Pos('"path"', Lowercase(Line)) = 1 then
    begin
      Value := Copy(Line, 7, Length(Line));
      P := Pos('"', Value);
      if P > 0 then
      begin
        Value := Copy(Value, P + 1, Length(Value));
        P := Pos('"', Value);
        if P > 0 then
        begin
          Value := Copy(Value, 1, P - 1);
          StringChangeEx(Value, '\\', '\', True);
          if CheckGameDir(SteamLibraryCandidate(Value)) then
          begin
            Result := SteamLibraryCandidate(Value);
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

function ScanDrivesForGame(): String;
var
  DriveCode, I: Integer;
  RootPath, Candidate: String;
  SubFolders: TArrayOfString;
begin
  Result := '';
  SetArrayLength(SubFolders, 6);
  SubFolders[0] := 'Program Files (x86)\Steam\steamapps\common\{#SteamFolder}';
  SubFolders[1] := 'Program Files\Steam\steamapps\common\{#SteamFolder}';
  SubFolders[2] := 'Steam\steamapps\common\{#SteamFolder}';
  SubFolders[3] := 'SteamLibrary\steamapps\common\{#SteamFolder}';
  SubFolders[4] := 'Games\Steam\steamapps\common\{#SteamFolder}';
  SubFolders[5] := 'Games\SteamLibrary\steamapps\common\{#SteamFolder}';
  for DriveCode := Ord('C') to Ord('Z') do
  begin
    RootPath := Chr(DriveCode) + ':\';
    if DirExists(RootPath) then
      for I := 0 to GetArrayLength(SubFolders) - 1 do
      begin
        Candidate := RootPath + SubFolders[I];
        if CheckGameDir(Candidate) then
        begin
          Result := Candidate;
          Exit;
        end;
      end;
  end;
end;

function FindGameDir(Param: String): String;
var
  P: String;
begin
  if RegQueryStringValue(HKLM64, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App {#SteamAppId}', 'InstallLocation', P) and CheckGameDir(P) then
    Result := P
  else if RegQueryStringValue(HKLM32, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App {#SteamAppId}', 'InstallLocation', P) and CheckGameDir(P) then
    Result := P
  else
  begin
    Result := FindInSteamLibraries();
    if Result = '' then
      Result := ScanDrivesForGame();
    if Result = '' then
      Result := ExpandConstant('{commonpf32}\Steam\steamapps\common\{#SteamFolder}');
  end;
end;

{ ---------- przycisk "Skanuj dyski" ---------- }
procedure ScanButtonClick(Sender: TObject);
var
  Found: String;
begin
  ScanButton.Enabled := False;
  ScanButton.Caption := 'Szukam...';
  try
    Found := FindInSteamLibraries();
    if Found = '' then
      Found := ScanDrivesForGame();
    if Found <> '' then
    begin
      WizardForm.DirEdit.Text := Found;
      MsgBox('Znaleziono folder z grą:' + #13#10 + Found, mbInformation, MB_OK);
    end
    else
      MsgBox('Nie znaleziono gry {#GameName} Pixel Remaster w standardowych folderach Steam.' + #13#10 +
             'Wskaż katalog ręcznie przyciskiem „Przeglądaj...”.', mbError, MB_OK);
  finally
    ScanButton.Caption := 'Skanuj dyski';
    ScanButton.Enabled := True;
  end;
end;

procedure InitializeWizard();
begin
  ScanButton := TNewButton.Create(WizardForm);
  ScanButton.Parent := WizardForm.SelectDirPage;
  ScanButton.Width := WizardForm.DirBrowseButton.Width + ScaleX(25);
  ScanButton.Left := WizardForm.DirBrowseButton.Left + WizardForm.DirBrowseButton.Width - ScanButton.Width;
  ScanButton.Top := WizardForm.DirBrowseButton.Top + WizardForm.DirBrowseButton.Height + ScaleY(8);
  ScanButton.Height := WizardForm.DirBrowseButton.Height;
  ScanButton.Caption := 'Skanuj dyski';
  ScanButton.OnClick := @ScanButtonClick;
end;

{ ---------- wykrywanie starej wersji (instalator NSIS: 1.0 / 1.1) ---------- }
function OldRegVersion(): String;
begin
  Result := '';
  if not RegQueryStringValue(HKLM32, OldUnKey, 'DisplayVersion', Result) then
    if not RegQueryStringValue(HKLM64, OldUnKey, 'DisplayVersion', Result) then
      Result := '';
end;

function OldRegLocation(): String;
begin
  Result := '';
  if not RegQueryStringValue(HKLM32, OldUnKey, 'InstallLocation', Result) then
    if not RegQueryStringValue(HKLM64, OldUnKey, 'InstallLocation', Result) then
      Result := '';
end;

{ Zwraca True, jeśli w folderze Dir jest spolszczenie ze starego instalatora; Ver = numer wersji lub opis. }
function DetectOldNsis(Dir: String; var Ver: String): Boolean;
var
  Loc: String;
begin
  Result := FileExists(AddBackslash(Dir) + OldUnExe);
  if not Result then
  begin
    Loc := OldRegLocation();
    if (Loc <> '') and (CompareText(RemoveBackslash(Loc), RemoveBackslash(Dir)) = 0) then
      Result := True;
  end;
  if Result then
  begin
    Ver := OldRegVersion();
    if Ver = '' then
      Ver := '1.0 lub 1.1';
  end;
end;

{ ---------- walidacja folderu, aktualizacja i ponowna instalacja ---------- }
function NextButtonClick(CurPageID: Integer): Boolean;
var
  Dir, Ver: String;
begin
  Result := True;
  if CurPageID = wpSelectDir then
  begin
    Dir := WizardForm.DirEdit.Text;
    if not CheckGameDir(Dir) then
    begin
      MsgBox('Wybrany folder nie jest folderem gry {#GameName} Pixel Remaster.' + #13#10 +
             'Nie znaleziono pliku {#GameExe} lub folderu {#DataDir}.' + #13#10#13#10 +
             'Wskaż główny katalog gry (np. ...\steamapps\common\{#SteamFolder}).', mbError, MB_OK);
      Result := False;
      Exit;
    end;
    UpdatedFromOld := False;
    if DetectOldNsis(Dir, Ver) then
    begin
      UpdatedFromOld := True;
      OldVersionText := Ver;
      MsgBox('Wykryto spolszczenie w wersji ' + Ver + ' (stary instalator).' + #13#10 +
             'Zostanie zaktualizowane do {#ModVersion}; kopie oryginalnych plików zostaną zachowane.', mbInformation, MB_OK);
    end
    else if FileExists(AddBackslash(Dir) + '{#DataDir}\StreamingAssets\aa\catalog.json.bak') then
      if MsgBox('Spolszczenie zostało już zainstalowane w tej lokalizacji.' + #13#10 +
                'Czy chcesz zainstalować je ponownie?', mbConfirmation, MB_YESNO) = IDNO then
        Result := False;
  end;
end;

{ ---------- ekran końcowy ---------- }
procedure CurPageChanged(CurPageID: Integer);
begin
  if (CurPageID = wpFinished) and UpdatedFromOld then
    WizardForm.FinishedLabel.Caption := WizardForm.FinishedLabel.Caption + #13#10#13#10 +
      'Poprzednie wersje wymagały języka portugalskiego. Wersja {#ModVersion} zastępuje język angielski - ' +
      'ustaw w grze English (i w Steam).';
end;

{ ---------- usunięcie pozostałości po starym instalatorze NSIS ---------- }
procedure RemoveOldNsis(AppDir: String);
var
  OldExe: String;
begin
  OldExe := AppDir + '\' + OldUnExe;
  if FileExists(OldExe) then
  begin
    SetFileAttributes(OldExe, 128); { FILE_ATTRIBUTE_NORMAL }
    if not DeleteFile(OldExe) then
      Log('Nie udało się usunąć starego deinstalatora: ' + OldExe);
  end;
  RegDeleteKeyIncludingSubkeys(HKLM32, OldUnKey);
  RegDeleteKeyIncludingSubkeys(HKLM64, OldUnKey);
end;

{ ---------- kopie .bak i sumy kontrolne ---------- }
procedure BackupOriginal(FilePath: String);
begin
  { istniejące .bak (także z czasów NSIS) to oryginały gry - nie ruszamy }
  if FileExists(FilePath) and not FileExists(FilePath + '.bak') then
    if not CopyFile(FilePath, FilePath + '.bak', True) then
      Log('Nie udało się utworzyć kopii: ' + FilePath);
end;

procedure SaveChecksums(AppDir: String);
var
  Files, Lines: TArrayOfString;
  I: Integer;
begin
  Files := ModFiles();
  SetArrayLength(Lines, GetArrayLength(Files));
  for I := 0 to GetArrayLength(Files) - 1 do
    Lines[I] := Files[I] + '|' + GetSHA256OfFile(AppDir + '\' + Files[I]);
  SaveStringsToFile(AppDir + '\_spolszczenie_deinstalator\' + SumsFileName, Lines, False);
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  AppDir: String;
  Files: TArrayOfString;
  I: Integer;
begin
  AppDir := ExpandConstant('{app}');
  if CurStep = ssInstall then
  begin
    RemoveOldNsis(AppDir);
    Files := ModFiles();
    for I := 0 to GetArrayLength(Files) - 1 do
      BackupOriginal(AppDir + '\' + Files[I]);
  end
  else if CurStep = ssPostInstall then
    SaveChecksums(AppDir);
end;

{ ---------- deinstalacja: przywracanie oryginałów ---------- }
function SavedChecksum(Lines: TArrayOfString; RelPath: String): String;
var
  I, P: Integer;
begin
  Result := '';
  for I := 0 to GetArrayLength(Lines) - 1 do
  begin
    P := Pos('|', Lines[I]);
    if (P > 0) and (CompareText(Copy(Lines[I], 1, P - 1), RelPath) = 0) then
    begin
      Result := Copy(Lines[I], P + 1, Length(Lines[I]));
      Exit;
    end;
  end;
end;

procedure RestoreOriginals(AppDir: String);
var
  Files, Lines: TArrayOfString;
  I: Integer;
  Target, Saved: String;
  HaveSums: Boolean;
begin
  OutdatedFiles := '';
  HaveSums := LoadStringsFromFile(AppDir + '\_spolszczenie_deinstalator\' + SumsFileName, Lines);
  Files := ModFiles();
  for I := 0 to GetArrayLength(Files) - 1 do
  begin
    Target := AppDir + '\' + Files[I];
    if FileExists(Target + '.bak') then
    begin
      Saved := '';
      if HaveSums then
        Saved := SavedChecksum(Lines, Files[I]);
      if (not FileExists(Target)) or (Saved = '') or (CompareText(GetSHA256OfFile(Target), Saved) = 0) then
      begin
        { plik jest nadal plikiem spolszczenia - przywróć oryginał }
        DeleteFile(Target);
        if not RenameFile(Target + '.bak', Target) then
          Log('Nie udało się przywrócić: ' + Target);
      end
      else
      begin
        { plik zmieniony (np. aktualizacja gry przez Steam) - stara kopia jest nieaktualna }
        DeleteFile(Target + '.bak');
        OutdatedFiles := OutdatedFiles + #13#10 + '  ' + Files[I];
      end;
    end;
  end;
  DeleteFile(AppDir + '\_spolszczenie_deinstalator\' + SumsFileName);
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
    RestoreOriginals(ExpandConstant('{app}'))
  else if CurUninstallStep = usPostUninstall then
    if (OutdatedFiles <> '') and not UninstallSilent() then
      MsgBox('Spolszczenie zostało usunięte, ale część plików gry została w międzyczasie zmieniona ' +
             '(np. przez aktualizację gry w Steam), więc nie przywrócono ich starych kopii:' + OutdatedFiles + #13#10#13#10 +
             'Aby mieć pewność, że gra ma aktualne oryginalne pliki, w Steam kliknij prawym przyciskiem na grę -> ' +
             'Właściwości -> Zainstalowane pliki -> „Sprawdź integralność plików gry”.', mbInformation, MB_OK);
end;
