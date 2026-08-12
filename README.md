# windows-mkcd

A portable, idempotent installer for an `mkcd` command in PowerShell on Windows.
The command creates a directory and changes into it.

## Install

Download or copy this folder to any Windows machine.
Double-click `Install.cmd` for a one-click installation.

Alternatively, open PowerShell in the folder and run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\Install-Mkcd.ps1
```

No administrator privileges are required.
The installer discovers the current user's PowerShell profile through `$PROFILE.CurrentUserCurrentHost`, creates it when necessary, preserves existing content, and avoids hardcoded usernames or paths.
Run the installer separately in Windows PowerShell 5.1 and PowerShell 7 if you want the command available in both, because they use different profile locations.

## Use

```powershell
mkcd project-name
mkcd "directory with spaces"
```

Existing directories are also supported, so `mkcd existing-directory` simply enters them.

## Uninstall

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\Uninstall-Mkcd.ps1
```

The uninstaller removes only the managed `windows-mkcd` section and preserves all other profile content.

## Test

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\Test-Mkcd.ps1
```

The test uses an isolated temporary profile and does not alter the user's real profile.
