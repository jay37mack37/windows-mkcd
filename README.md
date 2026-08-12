<div align="center">

# 📁 windows-mkcd

### Create a directory and jump into it with one command.

[![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-0078D4?logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207-5391FE?logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![No Admin](https://img.shields.io/badge/Admin_Not_Required-brightgreen)](#-why-windows-mkcd)

```powershell
mkcd "My New Project"
# You are now inside .\My New Project
```

</div>

## ✨ Why windows-mkcd?

Typing `mkdir` followed by `cd` gets old.
`windows-mkcd` adds the familiar Linux-style `mkcd` command to PowerShell with a safe, portable installer.

- **One-click installation** - double-click `Install.cmd`
- **No administrator access** - only your user profile is changed
- **No hardcoded paths** - works across Windows machines and usernames
- **Safe and idempotent** - run the installer repeatedly without duplicate entries
- **Non-destructive** - existing PowerShell profile content is preserved
- **Space friendly** - directory names containing spaces work as expected
- **Clean uninstall** - removes only the section managed by windows-mkcd

## 🚀 Install

### One click

1. Download this repository using **Code > Download ZIP**.
2. Extract the ZIP.
3. Double-click **`Install.cmd`**.
4. Open a new PowerShell window and run `mkcd`.

### With Git

```powershell
git clone https://github.com/jay37mack37/windows-mkcd.git
cd windows-mkcd
.\Install-Mkcd.ps1
```

If script execution is restricted, use:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Install-Mkcd.ps1
```

> [!NOTE]
> Windows PowerShell 5.1 and PowerShell 7 use different profile files.
> Run the installer once from each shell if you want `mkcd` available in both.

## 🪄 Usage

Create and enter a new directory:

```powershell
mkcd project-name
```

Names containing spaces are supported:

```powershell
mkcd "My Awesome Project"
```

You can also enter an existing directory:

```powershell
mkcd existing-directory
```

## 🔍 What the installer does

The installer resolves `$PROFILE.CurrentUserCurrentHost` dynamically, creates the profile when needed, and adds a clearly marked managed block.
It never assumes a username, home directory, drive letter, or PowerShell edition.

```powershell
function mkcd {
    param([string] $Path)

    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location -LiteralPath $Path
}
```

## 🧹 Uninstall

Run this from the downloaded folder:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Uninstall-Mkcd.ps1
```

The uninstaller preserves everything else in your PowerShell profile.

## ✅ Test

The test suite installs against a temporary profile, checks repeat installation, exercises a path containing spaces, verifies profile preservation, and tests uninstallation.
It never modifies your real profile.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Test-Mkcd.ps1
```

## 🤝 Contributing

Issues and pull requests are welcome.
Please run `Test-Mkcd.ps1` before submitting changes.

## 📄 License

Released under the [MIT License](LICENSE).
