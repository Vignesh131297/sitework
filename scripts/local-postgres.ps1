<#
.SYNOPSIS
  Manages the portable PostgreSQL 17 used for local SiteWork development.
  Runs as the current user: no admin rights and no Windows service.

.DESCRIPTION
  init    One-time setup: creates the cluster, the "sitework" role and the
          sitework / sitework_test databases, then prints DATABASE_URL.
  start   Starts the server (needed again after a reboot).
  stop    Stops the server.
  status  Shows whether the server is running.

  Defaults can be overridden with SITEWORK_PG_HOME, SITEWORK_PG_DATA and SITEWORK_PG_PORT.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File scripts/local-postgres.ps1 start
#>
param(
  [Parameter(Mandatory = $true)]
  [ValidateSet('init', 'start', 'stop', 'status')]
  [string] $Command
)

$ErrorActionPreference = 'Stop'

$PgHome = if ($env:SITEWORK_PG_HOME) { $env:SITEWORK_PG_HOME } else { Join-Path $env:LOCALAPPDATA 'Programs\PostgreSQL\17' }
$PgData = if ($env:SITEWORK_PG_DATA) { $env:SITEWORK_PG_DATA } else { Join-Path $env:LOCALAPPDATA 'PostgreSQL\17\data' }
$Port = if ($env:SITEWORK_PG_PORT) { $env:SITEWORK_PG_PORT } else { '5432' }
$LogFile = Join-Path (Split-Path $PgData -Parent) 'postgres.log'
$Bin = Join-Path $PgHome 'bin'
$RepoRoot = Split-Path $PSScriptRoot -Parent
$SecretsFile = Join-Path $RepoRoot '.local\postgres-superuser.txt'

function Invoke-Pg([string] $Exe, [string[]] $Arguments) {
  & (Join-Path $Bin $Exe) @Arguments
  if ($LASTEXITCODE -ne 0) { throw "$Exe failed with exit code $LASTEXITCODE" }
}

function Test-Running {
  & (Join-Path $Bin 'pg_ctl.exe') -D $PgData status *> $null
  return $LASTEXITCODE -eq 0
}

function Start-Server {
  if (Test-Running) { Write-Host "PostgreSQL is already running on port $Port."; return }
  # Launched through ShellExecute (hidden window) so the server does not inherit this
  # console's output handles; otherwise anything capturing our output would hang
  # until PostgreSQL exits.
  $process = Start-Process -FilePath (Join-Path $Bin 'pg_ctl.exe') -WindowStyle Hidden -PassThru `
    -ArgumentList @('-D', "`"$PgData`"", '-l', "`"$LogFile`"", '-o', "`"-p $Port`"", '-w', 'start')
  $process.WaitForExit()
  if ($process.ExitCode -ne 0 -or -not (Test-Running)) { throw "PostgreSQL failed to start; see $LogFile" }
  Write-Host "PostgreSQL started on port $Port (log: $LogFile)."
}

function New-RandomSecret([int] $Length = 24) {
  $chars = [char[]](48..57 + 65..90 + 97..122)
  return -join (1..$Length | ForEach-Object { $chars | Get-Random })
}

if (-not (Test-Path (Join-Path $Bin 'postgres.exe'))) {
  throw "PostgreSQL binaries not found in $PgHome. See README.md (Local database)."
}

switch ($Command) {
  'init' {
    if (Test-Path (Join-Path $PgData 'PG_VERSION')) { throw "A cluster already exists in $PgData." }
    if (-not (Test-Path $SecretsFile)) {
      New-Item -ItemType Directory -Force -Path (Split-Path $SecretsFile) | Out-Null
      Set-Content -Path $SecretsFile -Encoding utf8 -Value "PostgreSQL superuser (local dev only)`r`nuser: postgres`r`npassword: $(New-RandomSecret)`r`nport: $Port"
    }
    $superPassword = ((Get-Content $SecretsFile | Where-Object { $_ -like 'password:*' }) -replace '^password:\s*', '').Trim()

    New-Item -ItemType Directory -Force -Path $PgData | Out-Null
    $pwFile = [System.IO.Path]::GetTempFileName()
    try {
      [System.IO.File]::WriteAllText($pwFile, $superPassword)
      Invoke-Pg 'initdb.exe' @('-D', $PgData, '-U', 'postgres', '-A', 'scram-sha-256', "--pwfile=$pwFile",
        '-E', 'UTF8', '--locale=C', '--locale-provider=builtin', '--builtin-locale=C.UTF-8')
    } finally {
      Remove-Item $pwFile -Force
    }

    Start-Server

    $appPassword = New-RandomSecret
    $env:PGPASSWORD = $superPassword
    try {
      Invoke-Pg 'psql.exe' @('-h', 'localhost', '-p', $Port, '-U', 'postgres', '-d', 'postgres', '-v', 'ON_ERROR_STOP=1', '-q',
        '-c', "CREATE ROLE sitework LOGIN CREATEDB PASSWORD '$appPassword';",
        '-c', 'CREATE DATABASE sitework OWNER sitework;',
        '-c', 'CREATE DATABASE sitework_test OWNER sitework;')
    } finally {
      Remove-Item Env:\PGPASSWORD
    }

    Write-Host ''
    Write-Host 'Created role "sitework" and databases "sitework", "sitework_test".'
    Write-Host 'Put these in backend/.env:'
    Write-Host "DATABASE_URL=postgresql://sitework:$appPassword@localhost:$Port/sitework?schema=public"
    Write-Host "TEST_DATABASE_URL=postgresql://sitework:$appPassword@localhost:$Port/sitework_test?schema=public"
  }
  'start' { Start-Server }
  'stop' {
    if (-not (Test-Running)) { Write-Host 'PostgreSQL is not running.'; return }
    Invoke-Pg 'pg_ctl.exe' @('-D', $PgData, '-m', 'fast', '-w', 'stop')
  }
  'status' {
    if (Test-Running) { Write-Host "PostgreSQL is running on port $Port (data: $PgData)." }
    else { Write-Host "PostgreSQL is not running. Start it with: scripts/local-postgres.ps1 start" }
  }
}
