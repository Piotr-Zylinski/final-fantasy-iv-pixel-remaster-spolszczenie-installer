> **Language Note / Uwaga językowa:** This document contains the exact same documentation in two languages: **English** (below) and **Polish** (further down). / Ten dokument zawiera dokładnie tę samą dokumentację w dwóch językach: **angielskim** (poniżej) oraz **polskim** (niżej).

---

# [ENGLISH VERSION] FINAL FANTASY IV Pixel Remaster - Polish Translation Installer (NSIS)

Source script for the automated installer of the Polish localization (`Spolszczenie PL`) for **FINAL FANTASY IV Pixel Remaster** (Steam, AppID 1173800). Built with **NSIS 3** (Nullsoft Scriptable Install System).

## What the installer does
1. Automatically detects the game folder via the Windows Registry (Steam uninstall key) or by scanning drives C:–Z: for `FINAL FANTASY IV.exe`.
2. Always shows the folder selection page with a **Browse...** button and a **Skanuj dyski** (scan drives) button; it refuses to continue if `FINAL FANTASY IV.exe` is not in the chosen folder.
3. If `.bak` files already exist (translation installed before), it asks whether to install again.
4. Creates `.bak` backups of the 8 original files (if they do not exist yet): `aa\catalog.json`, `aa\StandaloneWindows64\message_assets_all_eb950d54fa0ee06699dc6f3c6f5061e9.bundle` and `font_de/en/es/fr/it/pt.bundle` (all inside `FINAL FANTASY IV_Data\StreamingAssets`).
5. Copies the modified files: the text bundle (Polish text replacing the Brazilian Portuguese text assets), the matching `catalog.json`, and the game fonts with added Polish characters (ą ć ę ł ń ś ź ż).
6. Places a hidden uninstaller in `_spolszczenie_deinstalator`, creates a `Usunięcie spolszczenia` (*Remove Polish Translation*) shortcut in the game folder and an "Add or remove programs" entry. Uninstalling restores the original files from `.bak`.

The game language must be set to **Brazilian Portuguese** in the in-game settings (most important) and, if your version of the game offers it, also in Steam (Properties -> Language), because the translation replaces that language.

## How to build the executable
1. Install [NSIS 3](https://nsis.sourceforge.io/Download) (Windows) or `makensis` (e.g. `apt install nsis` on Linux).
2. Download the manual release of the mod and place the files next to the script like this (a `pliki` folder):
   - `pliki\catalog.json`
   - `pliki\StandaloneWindows64\message_assets_all_eb950d54fa0ee06699dc6f3c6f5061e9.bundle`
   - `pliki\font_de.bundle`, `font_en.bundle`, `font_es.bundle`, `font_fr.bundle`, `font_it.bundle`, `font_pt.bundle`
3. Compile: right-click `FF4PR_Instalator.nsi` -> **Compile NSIS Script**, or run `makensis FF4PR_Instalator.nsi`.
4. The result is `FF4PR_Spolszczenie_Instalator_v1.0.exe`.

The game data files are not stored in this repository (they derive from the game's own files); only the installer source is public.

---

# [POLISH VERSION / WERSJA POLSKA] FINAL FANTASY IV Pixel Remaster - Instalator Spolszczenia (NSIS)

*(To jest dokładne tłumaczenie powyższej dokumentacji angielskiej na język polski / Exact Polish translation of the English documentation above.)*

Skrypt źródłowy automatycznego instalatora polskiej wersji językowej (`Spolszczenie PL`) do gry **FINAL FANTASY IV Pixel Remaster** (Steam, AppID 1173800). Zbudowany w **NSIS 3** (Nullsoft Scriptable Install System).

## Co robi instalator
1. Automatycznie wykrywa folder gry w rejestrze Windows (wpis Steam) lub przez skanowanie dysków C:–Z: w poszukiwaniu `FINAL FANTASY IV.exe`.
2. Zawsze pokazuje ekran wyboru folderu z przyciskiem **Przeglądaj...** oraz **Skanuj dyski**; nie pozwala przejść dalej, jeśli w wybranym folderze nie ma `FINAL FANTASY IV.exe`.
3. Jeśli pliki `.bak` już istnieją (spolszczenie było instalowane), pyta, czy zainstalować ponownie.
4. Tworzy kopie zapasowe `.bak` 8 oryginalnych plików (jeśli jeszcze nie istnieją): `aa\catalog.json`, `aa\StandaloneWindows64\message_assets_all_eb950d54fa0ee06699dc6f3c6f5061e9.bundle` oraz `font_de/en/es/fr/it/pt.bundle` (wszystkie w `FINAL FANTASY IV_Data\StreamingAssets`).
5. Kopiuje zmodyfikowane pliki: paczkę tekstową (polski tekst w miejscu brazylijskiego portugalskiego), pasujący `catalog.json` oraz czcionki gry z dodanymi polskimi znakami (ą ć ę ł ń ś ź ż).
6. Umieszcza ukryty deinstalator w `_spolszczenie_deinstalator`, tworzy w folderze gry skrót `Usunięcie spolszczenia` oraz wpis w „Dodaj lub usuń programy”. Odinstalowanie przywraca oryginalne pliki z `.bak`.

Język gry musi być ustawiony na **portugalski brazylijski** w ustawieniach samej gry (to ma największe znaczenie) oraz, jeśli Twoja wersja gry ma taką opcję, także w Steam (Właściwości -> Język), ponieważ spolszczenie zastępuje właśnie ten język.

## Jak skompilować plik wykonywalny (.exe)
1. Zainstaluj [NSIS 3](https://nsis.sourceforge.io/Download) (Windows) lub `makensis` (np. `apt install nsis` w Linuksie).
2. Pobierz paczkę manualną moda i umieść pliki obok skryptu w folderze `pliki`:
   - `pliki\catalog.json`
   - `pliki\StandaloneWindows64\message_assets_all_eb950d54fa0ee06699dc6f3c6f5061e9.bundle`
   - `pliki\font_de.bundle`, `font_en.bundle`, `font_es.bundle`, `font_fr.bundle`, `font_it.bundle`, `font_pt.bundle`
3. Skompiluj: prawy przycisk na `FF4PR_Instalator.nsi` -> **Compile NSIS Script** albo polecenie `makensis FF4PR_Instalator.nsi`.
4. Wynik: `FF4PR_Spolszczenie_Instalator_v1.0.exe`.

Pliki danych gry nie są częścią repozytorium (pochodzą z plików gry); publiczny jest tylko kod źródłowy instalatora.
