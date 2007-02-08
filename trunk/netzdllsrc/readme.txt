netZ Script Pro mIRC pluginek (c) 2005-2007 Face, Nonoo

netz.dll
--------
A project Microsoft Visual C 2003-ban készült.

Használható függvények:

- beep <freki> <hossz> <beepek száma> <sleep>

  A megadott frekvencián csipog a PC speakeren a megadott hosszig. A sleep
  akkor lényeges, ha több mint 1x kell beepelni, ekkor a beepelések közötti
  szünetet lehet vele állítani.

- seticon

  A mIRC ikonját állítja át a netZ ikonjára.

- title <title>

  A mIRC ablak fejlécében cseréli ki a mIRC szöveget netZ Script Pro-ra.

- idle

  A legutóbbi egérmozgatás/billentyûleütés óta eltelt millisecundumok számát
  adja vissza.

- winamp <parancs>

  A parancs helyére az alábbiakat írhatjuk:

  - isplaying:
      1-el tér vissza, ha a Winamp épp zenét játszik le, egyébként 0-val.

  - GetCurrentWinampSongElapsedTime:
      Visszaadja hogy éppen hányadik másodpercnél jár a Winamp a lejátszásban.

  - GetCurrentWinampSong:
      Visszaadja az éppen Winampban lévõ szám elõadóját/címét.

  - GetCurrentWinampSongKbps:
      Visszaadja az éppen Winampban lévõ szám bitrátáját.

  - GetCurrentWinampSongKHz:
      Visszaadja az éppen Winampban lévõ szám mintavételezési frekijét.

  - GetCurrentWinampSongTotalTime:
      Visszaadja az éppen Winampban lévõ szám hosszát másodpercben.

  - GetCurrentWinampSongChannels:
      Visszaadja az éppen Winampban lévõ szám csatornáinak számát.

  - GetCurrentWinampSongFilename:
      Visszaadja az éppen Winampban lévõ szám elérési útját.

- enkod <szöveg>

  A megadott szöveget kódolja el uuencode-vel. Ugyanaz mint a mIRC $encode.

- dekod <szöveg>

  A megadott uuencode-val elkódolt szöveget dekódolja. Ugyanaz mint a mIRC
  $decode, azért kell, mert a mIRC alapból lockolja a $decodet.



Az OpenSSL library lefordítása: (www.openssl.org-ról tudod letölteni)

1. Tömötítsd ki az OpenSSL forrást valahova a vinyódra.

2. Töltsd le az ActiveState ActivePerl-t és telepítsd fel.

3. Hívj elõ egy cmd ablakot (start menuü->futtatásba: cmd), lépj be az openssl
   könyvtárba, majd add ki ezt:
     c:\perl\bin\perl Configure VC-WIN32 --prefix=c:/netzdllsrc/sslpop3/openssl

   Értelemszerûen add meg a perl.exe elérési útját a parancs elején, az
   sslpop3/openssl könyvtár elérési útját pedig a parancs végén. Ide fogja
   másolni a végén a leforgatott OpenSSL libet.

4. Ugyanebben a cmd ablakban indítsd el a VisualC bin alkönyvtárában található
   vcvars32.bat-ot. Nálam ez a
   "c:\Program Files (x86)\Microsoft Visual Studio .NET 2003\Vc7\bin"
   könyvtárban van. A biztonság kedvéért jobb, ha ezt a könyvtárat beteszed a
   PATH-ba (sajátgépre jobbkatt, tulajdonságok, haladó beállítások, alul
   környezeti változók gomb, alsó ablakban a rendszerváltozók között
   megkeresed a PATH-ot, majd editálod, a végére ; után beszúrod a rövid
   fájlneves elérési utat, pl. ez nálam c:\progra~2\micros~1.net\vc7\bin, de
   amúgy általában c:\progra~1\micros~1.net\vc7\bin szokott lenni Visual C
   2003 esetén.

5. Lépj vissza az OpenSSL könyvtárába, add ki a ms\do_masm parancsot.

6. Add ki az nmake -f ms\ntdll.mak parancsot.

7. Add ki az nmake -f ms\ntdll.mak install parancsot.

8. Kész. :)
