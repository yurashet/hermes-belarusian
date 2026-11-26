$ErrorActionPreference = "Stop"

$candidates = @(
  (Join-Path $env:LOCALAPPDATA "Programs\hermes-desktop\resources"),
  (Join-Path $env:ProgramFiles "hermes-desktop\resources")
)
if (${env:ProgramFiles(x86)}) {
  $candidates += (Join-Path ${env:ProgramFiles(x86)} "hermes-desktop\resources")
}

$resources = $candidates |
  Where-Object { Test-Path (Join-Path $_ "app.asar") } |
  Select-Object -First 1

if (-not $resources) {
  Write-Error "Не знойдзены Hermes One Desktop 0.7.9. Спачатку ўсталюйце яго."
  exit 1
}

$dest = Join-Path $resources "app.asar"
$backup = Join-Path $resources "app.asar.backup"
$src = Join-Path $PSScriptRoot "app.asar"

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
