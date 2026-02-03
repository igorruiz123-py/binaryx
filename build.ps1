param (
    [string]$Action = "all"
)

# ===== CONFIGURAÇÕES (equivalente ao Makefile) =====
$CC = "gcc"
$CFLAGS = @("-Ilibs", "-Wall", "-Wextra")

$BIN_DIR = "output/bin"
$SRCS = @(
    "src/bin.c",
    "src/dec.c",
    "src/hexa.c",
    "src/main.c"
)

$EXE_PATH = "$BIN_DIR/binaryx.exe"

# ===== FUNÇÕES =====

function Ensure-BinDir {
    if (-not (Test-Path $BIN_DIR)) {
        New-Item -ItemType Directory -Path $BIN_DIR | Out-Null
    }
}

function Build {
    Ensure-BinDir
    $objs = @()

    foreach ($src in $SRCS) {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($src)
        $obj = "$BIN_DIR/$name.o"

        Write-Host "Compiling $src"
        & $CC @CFLAGS -c $src -o $obj
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Erro on compilation." -ForegroundColor Red
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

    Write-Host "Build executed succesfully!" -ForegroundColor Green
}

function Clean {
    Remove-Item "$BIN_DIR/*.o" -ErrorAction SilentlyContinue
    Remove-Item $EXE_PATH -ErrorAction SilentlyContinue
    Write-Host "Clean executed succesfully!."
}

function Install {
    if (-not (Test-Path $EXE_PATH)) {
        Write-Host "Executable not found! Run build first." -ForegroundColor Yellow
        exit 1
    }

    $binPath = (Resolve-Path $BIN_DIR).Path
    $oldPath = [Environment]::GetEnvironmentVariable("PATH", "User")

    if ($oldPath -notlike "*$binPath*") {
        [Environment]::SetEnvironmentVariable(
            "PATH",
            "$oldPath;$binPath",
            "User"
        )
        Write-Host "binaryx installed at user PATH."
        Write-Host "Close and reopen the terminal to use `binaryx`."
    } else {
        Write-Host "binaryx is already on PATH."
    }
}

function Uninstall {
    $binPath = (Resolve-Path $BIN_DIR).Path
    $oldPath = [Environment]::GetEnvironmentVariable("PATH", "User")

    if ($oldPath -like "*$binPath*") {
        $newPath = ($oldPath -split ';' | Where-Object { $_ -ne $binPath }) -join ';'
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
