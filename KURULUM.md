# Kurulum: Claude için talimat

Kullanıcı bu repoyu verip "bu sistemi kur" derse aşağıdakini sırayla yap. Kullanıcıyla onun dilinde,
kısa konuş. Bu repo bir şablondur: kullanıcının beyni ayrı bir klasör ve ayrı (gizli) bir repo olur.

## 1. Beyin klasörünü belirle

- Oturum boş bir klasörde açıldıysa beyin bu klasördür. Değilse kullanıcıya sor; öneri `~/ikinci-beyin`
  (iki bilgisayarda aynı yol olursa genel ayar iki yerde aynı kalır).
- Klasörde dosya varsa (gizli dosyalar dahil) hiçbir şeyin üzerine yazma, kullanıcıya sor.
- Beyin `~/ikinci-beyin`'de değilse 3. adımdaki bloğun ve 5. adımdaki kancanın yollarını ona göre düzelt.
- Bu kiti beyin klasörüne klonlama: kitin geçmişi, README'si ve remote'u beyne girmez. Yalnız `sablon/`
  içeriği kopyalanır.

## 2. Şablonu kopyala ve git'i başlat

```sh
kit=$(mktemp -d)
git clone --depth 1 https://github.com/UgurKeskekci/ikinci-beyin-kit "$kit"
cp -R "$kit/sablon/." "<BEYIN>/"
rm -rf "$kit"
cd "<BEYIN>"
git init -q -b main
git config core.hooksPath .githooks
```

`<BEYIN>` beyin klasörünün tam yolu. `sablon/.` gizli dosyaları da (`.gitignore`, `.githooks/`) taşır.

## 3. Genel ayara bağla

`araclar/claude-genel-ayar.md`'deki 1. bloğu `~/.claude/CLAUDE.md`'ye ekle:

- Dosya yoksa oluştur. Varsa içindekini silme, bloğu sonuna ekle. `ikinci-beyin:basla` işareti zaten
  varsa yalnız iki işaretin arasını değiştir.
- Beyin `~/ikinci-beyin`'de değilse bloktaki yolları düzelt (ev klasörü altındaysa `~/` ile yaz).
- Kullanıcıya hangi dosyaya ne eklediğini göster.

## 4. Tanış ve beyni doldur

Soruları ikişer üçer sor, hepsini birden değil. Cevap geldikçe dosyalara yaz.

1. Adın ne, ne iş yapıyorsun? Hangi dilde konuşalım; kod ve commit hangi dilde olsun?
2. Hangi bilgisayarları kullanıyorsun, projelerin hangi klasörlerde duruyor?
3. Şu an üzerinde çalıştığın projeler neler? Her biri için: ne, nerede (klasör, repo, site), nerede
   kaldın, sıradaki iş ne?
4. Nasıl çalışmamı istersin? Kısa mı uzun mu yazayım, ne zaman önce sorayım, kesinlikle yapmamamı
   istediğin bir şey var mı?
5. Başka bir yapay zekada birikmiş hafızan var mı? ChatGPT'ye "Hakkımda bildiğin her şeyi madde madde
   yaz" deyip cevabı buraya yapıştırabilirsin.

Nereye yazılır:

- Kim, iş, cihazlar, araçlar: `ben/profil.md`
- Tercihler: `ben/calisma-tarzi.md`, bugünün tarihiyle
- Her proje: `projeler/_sablon.md`'den `projeler/<kisa-ad>.md` ve `projeler/_index.md`'ye tek satır.
  Kullanıcı projenin klasörünü verdiyse önce oranın README'sine, CLAUDE.md'sine ve `git log -10`
  çıktısına bak, kartı oradan doldur, kullanıcıya yalnız eksik kalanı sor.
- `projeler/ornek-kahve-sitesi.md`'yi ve `_index.md`'deki örnek satırı sil. Şablonlardaki "(ör. ...)"
  yer tutucularını gerçek bilgiyle değiştir, cevabı olmayanı sil. Henüz içi boş bölüm başlıkları
  (ör. "Kararlar") kartta kalır.

Kurallar:

- Şifre, kart, banka bilgisi, token sorma. Kullanıcı kendisi verirse yalnız `gizli/` altına yaz.
- Bilmediğini uydurma; boş bırak.
- Dosyaları kısa tut: profil, çalışma tarzı ve proje listesi her oturuma girer.

Bitince `sh araclar/sync.sh` çalıştır (Windows PowerShell'de `araclar\sync.ps1`). Remote yoksa yalnız
commit eder.

## 5. Gizli GitHub reposu (önerilir)

Kullanıcıya sor: beyin GitHub'da gizli bir repoda dursun mu? İkinci bilgisayar ve yedek için gerekli.

- Evet ve `gh` kurulu, oturum açıksa: `gh repo create <ad> --private --source . --remote origin`, sonra
  `sh araclar/sync.sh`. Hiçbir zaman `--public` kullanma.
- `gh` yoksa: kullanıcı github.com/new adresinde **Private** bir repo açar ve adresini verir:
  `git remote add origin <adres>`, sonra `sh araclar/sync.sh`.
- Repo varsa `araclar/claude-genel-ayar.md`'deki 2. adımı (oturum başında tazeleme kancası) kullanıcıya
  sorup `~/.claude/settings.json`'a ekle. Önce dosyayı oku: aynı komut zaten varsa ekleme;
  `hooks.SessionStart` listesi varsa öğeyi ona ekle, yoksa oluştur. Öteki ayarlara dokunma, dosya geçerli
  JSON kalsın. Kancadaki yol beyin klasörünü göstersin.
- İkinci bilgisayar için `araclar/claude-genel-ayar.md`'deki 3. adımı kullanıcıya kısaca anlat.

## 6. Bitir

Kısa özet ver: beyin nerede, hangi dosyalar dolduruldu, GitHub reposu var mı. Sonra şunu söyle:
"Yeni bir oturum açıp 'Beni tanıyor musun?' diye sorun. Projelerinizi ve kurallarınızı sayıyorsa kurulum
tamam. Claude ilk oturumda beyin dosyalarını eklemek için izin sorarsa izin verin."
