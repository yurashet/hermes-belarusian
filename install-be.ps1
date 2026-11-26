param([switch]$Force)
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
  Write-Error "Не знойдзены Hermes One Desktop. Спачатку ўсталюйце версію 0.7.9."
  exit 1
}

$appDir = Split-Path $resources -Parent
$exe = Join-Path $appDir "hermes-agent.exe"
$ver = ""
if (Test-Path $exe) {
  $ver = (Get-Item $exe).VersionInfo.FileVersion
}
if ($ver -and -not $ver.StartsWith("0.7.9")) {
  Write-Error ("Патч прызначаны для версіі 0.7.9, а ўсталявана " + $ver +
    ". Абнавіцеся да 0.7.9 або збярыце з зыходнікаў: https://github.com/yurashet/hermes-belarusian")
  exit 1
}

$dest = Join-Path $resources "app.asar"
$backup = Join-Path $resources "app.asar.backup"
$src = Join-Path $PSScriptRoot "app.asar"

if (-not (Test-Path $src)) {
  Write-Error "Пакладзіце app.asar побач са скрыптам (у тую ж папку)."
  exit 1
}

if (Get-Process hermes-agent -ErrorAction SilentlyContinue) {
  if ($Force) {
    Get-Process hermes-agent -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
  } else {
    Write-Host "Зачыніце Hermes One цалкам (у тым ліку з трэя). Скрыпт чакае да 10 хвілін..."
    $deadline = (Get-Date).AddMinutes(10)
    while ((Get-Process hermes-agent -ErrorAction SilentlyContinue) -and
           ((Get-Date) -lt $deadline)) {
      Start-Sleep -Seconds 1
    }
    if (Get-Process hermes-agent -ErrorAction SilentlyContinue) {
      Write-Error "Hermes One не закрыты. Нічога не зменена."
      exit 1
    }
  }
}

if (-not (Test-Path $backup)) {
  Copy-Item $dest $backup -Force
  Write-Host ("Рэзервовая копія: " + $backup)
}

Copy-Item $src $dest -Force

$cfg = Join-Path $env:LOCALAPPDATA "hermes\desktop.json"
if (Test-Path $cfg) {
  try {
    if (-not (Test-Path ($cfg + ".backup"))) {
      Copy-Item $cfg ($cfg + ".backup") -Force
    }
    $json = Get-Content $cfg -Raw | ConvertFrom-Json
    $json.locale = "be"
    $text = $json | ConvertTo-Json -Depth 30
    [System.IO.File]::WriteAllText($cfg, $text, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "Мова ў канфігурацыі: be"
  } catch {
    Write-Warning "Не ўдалося запісаць locale у desktop.json. Выберыце мову ў Наладах уручную."
  }
}

if (Test-Path $exe) {
  Start-Process $exe
  Write-Host "Hermes One запушчаны."
}
Write-Host "Гатова! Праверце: Налады -> Мова -> Беларуская."
