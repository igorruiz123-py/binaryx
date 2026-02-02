param (
    [string]$Target = "all"
)

# ==== VARIÁVEIS (equivalentes ao Makefile) ====
$CC = "gcc"
$CFLAGS = "-Ilibs -Wall -Wextra"

$BIN_DIR = "output/bin"
$SRCS = @(
    "src/bin.c",
    "src/dec.c",
    "src/hexa.c",
    "src/main.c"
)

$TARGET = "$BIN_DIR/binaryx.exe"

# ==== FUNÇÕES ====

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

        Write-Host "Compilando $src"
        & $CC $CFLAGS -c $src -o $obj
        if ($LASTEXITCODE -ne 0) { exit 1 }

        $objs += $obj
    }

    Write-Host "Linkando $TARGET"
    & $CC $objs -o $TARGET
    if ($LASTEXITCODE -ne 0) { exit 1 }

    Write-Host "Build concluído com sucesso!" -ForegroundColor Green
}

function Clean {
    if (Test-Path "$BIN_DIR/*.o") {
        Remove-Item "$BIN_DIR/*.o" -Force
    }

    if (Test-Path $TARGET) {
        Remove-Item $TARGET -Force
    }

    Write-Host "Clean finalizado."
}

function Install {
    if (-not (Test-Path $TARGET)) {
        Write-Host "Executável não encontrado. Rode o build primeiro." -ForegroundColor Yellow
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
        Write-Host "binaryx instalado (PATH atualizado)."
        Write-Host "Reabra o terminal para usar `binaryx`."
    } else {
        Write-Host "binaryx já está instalado."
    }
}

function Uninstall {
    $binPath = (Resolve-Path $BIN_DIR).Path
    $oldPath = [Environment]::GetEnvironmentVariable("PATH", "User")

    if ($oldPath -like "*$binPath*") {
        $newPath = ($oldPath -split ';' | Where-Object { $_ -ne $binPath }) -join ';'
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Host "binaryx removido do PATH."
    } else {
        Write-Host "binaryx não está instalado."
    }
}

# ==== DISPATCH (equivalente aos targets do Make) ====

switch ($Target) {
    "all"       { Build }
    "clean"     { Clean }
    "install"   { Install }
    "uninstall" { Uninstall }
    default {
        Write-Host "Target inválido: $Target"
        Write-Host "Use: all | clean | install | uninstall"
    }
}
