# Claude'un genel ayarına bağlamak

Beyni her oturuma getiren şey Claude'un genel ayar dosyasına eklenen birkaç satır. Dosya:

- Mac ve Linux: `~/.claude/CLAUDE.md`
- Windows: `C:\Users\<ad>\.claude\CLAUDE.md`

Dosya yoksa oluşturun; varsa içindekini silmeyin, bloğu sonuna ekleyin. Beyin `~/ikinci-beyin`'de değilse
yolları değiştirin. İki bilgisayarda da aynı yolu kullanırsanız blok iki yerde aynı kalır.

## 1. Genel ayar bloğu

```markdown
<!-- ikinci-beyin:basla -->
# İkinci Beyin (kalıcı hafıza)

Kalıcı hafızam `~/ikinci-beyin` klasöründe. Hangi klasörde çalışırsan çalış önce buraya bak.

- Bir projede çalışırken önce `projeler/_index.md` içinden projenin kartını bul ve oku.
- Kalıcı bir şey öğrenince (proje durumu, karar, tercihim) ilgili dosyayı güncelle, sonra senkronla:
  `sh ~/ikinci-beyin/araclar/sync.sh` (Windows'ta `sh` yoksa `araclar\sync.ps1`).
- Neyin, ne zaman, nereye yazılacağı: `~/ikinci-beyin/AGENTS.md`. Şifre, anahtar, token yalnız
  `gizli/` klasörüne yazılır, başka yere asla.

@~/ikinci-beyin/ben/profil.md
@~/ikinci-beyin/ben/calisma-tarzi.md
@~/ikinci-beyin/projeler/_index.md
<!-- ikinci-beyin:bitir -->
```

`@` ile başlayan satırlar o dosyaları her oturuma olduğu gibi ekler. Bu yüzden bu üç dosya kısa kalır.

## 2. Oturum başında tazeleme (iki bilgisayar varsa)

Öbür bilgisayarda yazılanların oturum açılır açılmaz gelmesi için `~/.claude/settings.json`'a bir kanca
eklenir. Dosyadaki öteki ayarlar korunur, yalnız `hooks.SessionStart` listesine bu öğe girer:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          { "type": "command", "command": "git -C ~/ikinci-beyin pull --ff-only -q 2>/dev/null || true", "timeout": 15 }
        ]
      }
    ]
  }
}
```

## 3. İkinci bilgisayar

1. Beyni aynı yola klonlayın: `git clone <gizli-repo-adresiniz> ~/ikinci-beyin`
2. Klasörde kancayı açın: `git -C ~/ikinci-beyin config core.hooksPath .githooks`
3. Bu dosyadaki 1. bloğu ve 2. kancayı o bilgisayarda da ekleyin.

Klonladıktan sonra 2. ve 3. adımı Claude'a da yaptırabilirsiniz:
`~/ikinci-beyin/araclar/claude-genel-ayar.md dosyasına göre bu bilgisayarı bağla`.
`gizli/` klasörü git'le gelmez; o bilgisayarda da lazımsa kendiniz taşıyın.
