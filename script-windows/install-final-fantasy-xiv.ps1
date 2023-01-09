$ProgressPreference = 'SilentlyContinue'

$DownloadsPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$DownloadsBootstrapPath = "$DownloadsPath\Bootstrap"

if(!(Test-Path -path "$DownloadsBootstrapPath")) {
  New-Item -ItemType directory -Path "$DownloadsBootstrapPath"
}

Invoke-WebRequest -Uri "https://download.finalfantasyxiv.com/inst/ffxivsetup.exe" -OutFile "$DownloadsBootstrapPath\ffxivsetup.exe"

& "$DownloadsBootstrapPath\ffxivsetup.exe" --silent
