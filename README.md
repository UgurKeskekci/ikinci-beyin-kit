# İkinci Beyin Kit

Claude her yeni sohbette sizi baştan tanımaya başlıyor. Bu kit bunu bitirir: tek bir klasör ve birkaç
Markdown dosyası. Kim olduğunuz, nasıl çalışmayı sevdiğiniz ve her projede nerede kaldığınız burada
durur. Claude hangi klasörde açılırsa açılsın önce buraya bakar, öğrendiğini buraya yazar. İki
bilgisayar kullanıyorsanız klasör gizli bir GitHub reposuyla iki tarafta aynı kalır.

Kurulacak program yok: Python yok, veritabanı yok, Obsidian şart değil. Düz Markdown ve git.

```text
ikinci-beyin/
  AGENTS.md              Claude'a kurallar: neyi, ne zaman, nereye yazacak
  ben/
    profil.md            kimsiniz, ne iş yapıyorsunuz
    calisma-tarzi.md     "bunu hep böyle yap" dedikleriniz
  projeler/
    _index.md            tüm projeler, proje başına tek satır
    _sablon.md           proje kartı: ne yapıyoruz, nerede kaldık, kararlar, son yapılanlar
  bilgi/                 projeler arası dersler
  gizli/                 şifre ve anahtarlar: git'e girmez
  araclar/
    sync.sh              senkron: Mac, Linux, Windows (Git Bash)
    sync.ps1             senkron: Windows PowerShell
    claude-genel-ayar.md ~/.claude/CLAUDE.md'ye eklenen satırlar
```

## Nasıl çalışıyor

1. Claude'un genel ayar dosyasına (`~/.claude/CLAUDE.md`) birkaç satır eklenir: "önce buraya bak".
   Profiliniz, çalışma tarzınız ve proje listeniz her oturuma kendiliğinden gelir.
2. Bir projede çalışırken Claude önce o projenin kartını okur: ne yapıyoruz, nerede kaldık, ne karar verdik.
3. Bir karar verildiğinde, bir iş bittiğinde ya da "bunu hep böyle yap" dediğinizde Claude ilgili dosyayı
   günceller ve senkronlar. Sizin ayrıca bir şey yapmanız gerekmez.

## Kurulum

Gerekenler: [Claude Code](https://claude.com/claude-code) (masaüstü uygulamasının Code sekmesi ya da
terminal) ve git. İki bilgisayar için bir GitHub hesabı.

1. Claude Code'da boş bir klasör açın. Önerilen yer: `~/ikinci-beyin`.
2. Şunu yazın:

   ```text
   https://github.com/UgurKeskekci/ikinci-beyin-kit bu sistemi kur
   ```

3. Claude klasörleri oluşturur, genel ayara bağlar ve size sorular sorar: kimsiniz, hangi projeleriniz
   var, nasıl çalışmayı seversiniz. Cevapladıkça beyninizi kendisi doldurur. İsterseniz beyni GitHub'da
   gizli bir repoya da koyar.
4. Yeni bir oturum açıp sorun: `Beni tanıyor musun?` Projelerinizi ve kurallarınızı sayıyorsa kurulum tamam.

Claude'un izlediği adımlar [KURULUM.md](KURULUM.md) dosyasında. Elle kurmak isterseniz:
[Elle kurulum](#elle-kurulum).

## Örnek kullanım

Hangi klasörde açarsanız açın:

```text
Üzerinde çalıştığım projeler neler, nerede kalmıştık?
```

```text
Kahve sitesinde nerede kaldık, sıradaki iş ne?
```

```text
Fiyatlar hep TL olsun, emoji kullanma. Bunu beynime kaydet.
```

```text
Bugün yaptıklarımızı projenin kartına yaz ve senkronla.
```

İlk gün mucize beklemeyin. Kurmak beş dakika, Claude'un sizi tanıması kullandıkça oluyor: kartlar ve
kurallar doldukça cevaplar iyileşir.

## İki bilgisayar

Beyin GitHub'da **gizli** (private) bir repoda durur. Claude beyne yazdıktan sonra senkron betiğini
çalıştırır: betik değişiklikleri commit eder, öbür bilgisayarın yazdıklarını çeker, sonra gönderir.
Elle çalıştırmak için:

```bash
sh ~/ikinci-beyin/araclar/sync.sh
```

Windows PowerShell'de:

```powershell
powershell -ExecutionPolicy Bypass -File $HOME\ikinci-beyin\araclar\sync.ps1
```

İkinci bilgisayarda beyni aynı yola klonlayın, sonra Claude'a bağlatın:

```bash
git clone <gizli-repo-adresiniz> ~/ikinci-beyin
```

```text
~/ikinci-beyin/araclar/claude-genel-ayar.md dosyasına göre bu bilgisayarı bağla
```

## Gizli bilgiler

- Repo her zaman gizli kalır. Senkron betiği repo herkese açık görünürse göndermeyi durdurur.
- Şifre, anahtar, token, kart ve banka bilgisi yalnız `gizli/` klasörüne yazılır. Bu klasör git'e
  girmez, GitHub'a gitmez; kartlarda yalnız yeri yazılır (`anahtar: gizli/site.md`).
- `pre-commit` kancası şifre ya da anahtar benzeri bir değer başka bir dosyaya girerse commit'i durdurur.

## Başka yapay zeka araçları

Aynı beyni Codex ya da Gemini CLI da okuyabilir. Genel talimat dosyalarına (`~/.codex/AGENTS.md`,
`~/.gemini/GEMINI.md`) şunu ekleyin:

```text
Kalıcı hafızam ~/ikinci-beyin klasöründe. Her oturumun başında ben/profil.md, ben/calisma-tarzi.md ve
projeler/_index.md dosyalarını oku. Neyi, ne zaman, nereye yazacağın AGENTS.md'de.
```

## Elle kurulum

```bash
git clone --depth 1 https://github.com/UgurKeskekci/ikinci-beyin-kit /tmp/ikinci-beyin-kit
mkdir -p ~/ikinci-beyin
cp -R /tmp/ikinci-beyin-kit/sablon/. ~/ikinci-beyin/
rm -rf /tmp/ikinci-beyin-kit
cd ~/ikinci-beyin
git init -b main
git config core.hooksPath .githooks
```

Sonra `araclar/claude-genel-ayar.md`'deki bloğu `~/.claude/CLAUDE.md`'nin sonuna ekleyin, `ben/` ve
`projeler/` altındaki dosyaları doldurun ve `sh araclar/sync.sh` çalıştırın.

## Daha fazlası: AvenoxBeyin

Bu fikri açık kaynak olarak yapanlardan biri [AvenoxBeyin](https://github.com/avenoxai/avenoxbeyin); ben
de ondan esinlenerek kendi sistemimi kurdum. Avenox'unki tam bir sistem: Python ile kuruluyor, notlarda
arama yapan bir motoru var, Obsidian ile açılıyor, hazır skill'lerle geliyor. Bu kit bilerek daha küçük:
birkaç Markdown dosyası ve bir senkron betiği. Çok şey yapmasını istiyorsanız onu kurun.

Bu düzeni [YouTube kanalımda](https://www.youtube.com/@UgurKeskekciYazilim) anlatıyorum.

## Lisans

MIT
