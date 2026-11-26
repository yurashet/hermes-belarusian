$ErrorActionPreference = "Stop"

$resources = Join-Path $env:LOCALAPPDATA "Programs\hermes-desktop\resources"
$dest = Join-Path $resources "app.asar"
$backup = Join-Path $resources "app.asar.backup"
$src = Join-Path $PSScriptRoot "app.asar"

if (-not (Test-Path $dest)) {
  Write-Error "Не знойдзены Hermes One Desktop у $resources. Спачатку ўсталюйце версію 0.7.9."
  exit 1
}
if (-not (Test-Path $src)) {
  Write-Error "Пакладзіце app.asar побач са скрыптам (у тую ж папку)."
  exit 1
}

Get-Process hermes-agent -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

if (-not (Test-Path $backup)) {
  Copy-Item $dest $backup -Force
  Write-Host "Рэзервовая копія: $backup"
}

Copy-Item $src $dest -Force
Write-Host "Гатова! Запусціце Hermes One і выберыце: Налады -> Мова -> Беларуская."
