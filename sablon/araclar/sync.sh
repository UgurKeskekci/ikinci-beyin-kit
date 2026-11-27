#!/bin/sh
# İkinci beyin senkronu (Mac, Linux, Windows'ta Git Bash):
#   değişiklikleri commit eder -> öbür bilgisayarın yazdıklarını çeker -> gönderir.
# Remote yoksa yalnız commit eder. Repo herkese açıksa göndermez.
set -eu
cd "$(dirname "$0")/.."
git config core.hooksPath .githooks

git add -A
if ! git diff --cached --quiet; then
  ad=${COMPUTERNAME:-$(hostname 2>/dev/null | cut -d. -f1)}
  git commit -q -m "sync($ad): $(date '+%Y-%m-%d %H:%M')"
fi

remote=$(git remote | head -n 1)
if [ -z "$remote" ]; then
  echo "✅ Commit edildi. Remote yok, beyin yalnız bu bilgisayarda."
  exit 0
fi
url=$(git remote get-url "$remote")

# Beyin her zaman gizli bir repoda durur.
case "$url" in
  *ikinci-beyin-kit*)
    echo "⛔ Remote bu kitin kendisi ($url). Beyninizi kendi gizli reponuza bağlayın:"
    echo "   git remote set-url $remote <gizli-repo-adresiniz>"
    exit 1 ;;
esac
case "$url" in
  *github.com[:/]*)
    yol=$(printf '%s' "$url" | sed -E 's#^.*github\.com[:/]##; s#/$##; s#\.git$##')
    if command -v curl >/dev/null 2>&1; then
      # Giriş yapmadan sorulan GitHub API'si yalnız herkese açık repoyu görür (200); gizli repo 404 döner.
      kod=$(curl -s -o /dev/null -m 10 -w '%{http_code}' "https://api.github.com/repos/$yol" || true)
      if [ "$kod" = 200 ]; then
        echo "⛔ $yol herkese açık görünüyor. Beyin gizli bir repoda durmalı, gönderilmedi."
        echo "   GitHub'da repo ayarlarından Private yapın, sonra tekrar çalıştırın."
        exit 1
      fi
    fi ;;
esac

dal=$(git rev-parse --abbrev-ref HEAD)
set +e
git ls-remote --exit-code --heads "$remote" "$dal" >/dev/null 2>&1
durum=$?
set -e
case "$durum" in
  0)
    if ! git pull --rebase -q "$remote" "$dal"; then
      echo "⚠️  Çekerken çakışma oldu. Claude'a şunu söyleyin:"
      echo "   \"beyin senkronunda çakışma var, iki tarafı da koruyarak çöz\""
      exit 1
    fi ;;
  2) ;;  # remote'ta bu dal henüz yok: ilk gönderim
  *)
    echo "⚠️  Remote'a ulaşılamadı ($url). Commit bu bilgisayarda duruyor; internet gelince tekrar çalıştırın."
    exit 1 ;;
esac
git push -q -u "$remote" "$dal"
echo "✅ Beyin senkron."
