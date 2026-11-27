# Ikinci beyin senkronu (Windows PowerShell):
#   degisiklikleri commit eder -> obur bilgisayarin yazdiklarini ceker -> gonderir.
# Remote yoksa yalniz commit eder. Repo herkese aciksa gondermez.
# Not: Windows PowerShell 5.1 BOM'suz UTF-8 dosyada Turkce karakteri bozar; bu dosya bilerek ASCII.
# Calistirmak: powershell -ExecutionPolicy Bypass -File araclar\sync.ps1
$ErrorActionPreference = "Continue"
Set-Location (Split-Path -Parent $PSScriptRoot)

function Stop-Sync([string]$Message) {
    Write-Host $Message
    exit 1
}

git config core.hooksPath .githooks

git add -A
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm"
    git commit -q -m "sync($env:COMPUTERNAME): $stamp"
    if ($LASTEXITCODE -ne 0) { Stop-Sync "Commit durdu (pre-commit kancasi sifre ya da anahtar bulmus olabilir, yukariya bakin)." }
}

$remote = git remote | Select-Object -First 1
if (-not $remote) {
    Write-Host "Commit edildi. Remote yok, beyin yalniz bu bilgisayarda."
    exit 0
}
$url = git remote get-url $remote

# Beyin her zaman gizli bir repoda durur.
if ($url -like "*ikinci-beyin-kit*") {
    Stop-Sync "Remote bu kitin kendisi ($url). Beyninizi kendi gizli reponuza baglayin: git remote set-url $remote <gizli-repo-adresiniz>"
}
if ($url -match 'github\.com[:/](.+?)(\.git)?/?$') {
    $repoPath = $Matches[1]
    if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
        # Giris yapmadan sorulan GitHub API'si yalniz herkese acik repoyu gorur (200); gizli repo 404 doner.
        $code = & curl.exe -s -o NUL -m 10 -w "%{http_code}" "https://api.github.com/repos/$repoPath"
        if ($code -eq "200") {
            Stop-Sync "$repoPath herkese acik gorunuyor. Beyin gizli bir repoda durmali, gonderilmedi. GitHub'da Private yapin, sonra tekrar calistirin."
        }
    }
}

$branch = git rev-parse --abbrev-ref HEAD
git ls-remote --exit-code --heads $remote $branch *> $null
$state = $LASTEXITCODE
if ($state -eq 0) {
    git pull --rebase -q $remote $branch
    if ($LASTEXITCODE -ne 0) {
        Stop-Sync "Cekerken cakisma oldu. Claude'a soyleyin: 'beyin senkronunda cakisma var, iki tarafi da koruyarak coz'"
    }
} elseif ($state -ne 2) {
    Stop-Sync "Remote'a ulasilamadi ($url). Commit bu bilgisayarda duruyor; internet gelince tekrar calistirin."
}

git push -q -u $remote $branch
if ($LASTEXITCODE -ne 0) { Stop-Sync "Gonderilemedi (git push)." }
Write-Host "Beyin senkron."
