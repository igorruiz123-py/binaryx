param (
    [string]$Action = "all"
)

# ===== GARANTE EXECUÇÃO NA PASTA DO SCRIPT =====
$ROOT_DIR = $PSScriptRoot
Set-Location $ROOT_DIR

# ===== CRIA output/bin SE NÃO EXISTIR =====
$BIN_DIR = Join-Path $ROOT_DIR "output/bin"

if (-not (Test-Path $BIN_DIR)) {
    New-Item -ItemType Directory -Path $BIN_DIR -Force | Out-Null
}

# ===== CONFIGURAÇÕES (equivalente ao Makefile) =====
$CC = "gcc"
$CFLAGS = @("-Ilibs", "-Wall", "-Wextra")

$SRCS = @(
    "src/bin.c",
    "src/dec.c",
    "src/hexa.c",
    "src/main.c"
)

$EXE_PATH = Join-Path $BIN_DIR "binaryx.exe"

# ===== FUNÇÕES =====

function Build {
    $objs = @()

    foreach ($src in $SRCS) {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($src)
        $obj = Join-Path $BIN_DIR "$name.o"

        Write-Host "Compiling $src"
        & $CC @CFLAGS -c $src -o $obj
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error on compilation." -ForegroundColor Red
            exit 1
        }

        $objs += $obj
    }

    Write-Host "Linking $EXE_PATH"
    & $CC $objs -o $EXE_PATH
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error on linking." -ForegroundColor Red
        exit 1
    }

    Write-Host "Build executed successfully!" -ForegroundColor Green
}

function Clean {
    Remove-Item (Join-Path $BIN_DIR "*.o") -ErrorAction SilentlyContinue
    Remove-Item $EXE_PATH -ErrorAction SilentlyContinue
    Write-Host "Clean executed successfully!"
}

function Install {
    if (-not (Test-Path $EXE_PATH)) {
        Write-Host "Executable not found! Run build first." -ForegroundColor Yellow
        exit 1
    }

    $oldPath = [Environment]::GetEnvironmentVariable("PATH", "User")

    if ($oldPath -notlike "*$BIN_DIR*") {
        [Environment]::SetEnvironmentVariable(
            "PATH",
            "$oldPath;$BIN_DIR",
            "User"
        )
        Write-Host "binaryx installed in user PATH."
        Write-Host "Close and reopen the terminal to use `binaryx`."
    } else {
        Write-Host "binaryx is already on PATH."
    }
}

function Uninstall {
    $oldPath = [Environment]::GetEnvironmentVariable("PATH", "User")

    if ($oldPath -like "*$BIN_DIR*") {
        $newPath = ($oldPath -split ';' | Where-Object { $_ -ne $BIN_DIR }) -join ';'
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Host "binaryx removed from PATH."
    } else {
        Write-Host "binaryx is not installed."
    }
}

# ===== DISPATCH (targets) =====

switch ($Action) {
    "all"       { Build }
    "clean"     { Clean }
    "install"   { Install }
    "uninstall" { Uninstall }
    default {
        Write-Host "Invalid target: $Action"
        Write-Host "Use: all | clean | install | uninstall"
    }
}
