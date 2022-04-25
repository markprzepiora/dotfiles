$ProgressPreference = 'SilentlyContinue'

$DownloadsPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$DownloadsBootstrapPath = "$DownloadsPath\Bootstrap"

if(!(Test-Path -path "$DownloadsBootstrapPath")) {
  New-Item -ItemType directory -Path "$DownloadsBootstrapPath"
}

Invoke-WebRequest -Uri "https://downloads.1password.com/win/1PasswordSetup-latest.exe" -OutFile "$DownloadsBootstrapPath\1PasswordSetup-latest.exe"

& "$DownloadsBootstrapPath\1PasswordSetup-latest.exe" --silent
