netZ Script Pro mIRC pluginek (c) 2005-2007 Face, Nonoo

netz.dll
--------
A project Microsoft Visual C 2003-ban k�sz�lt.

Haszn�lhat� f�ggv�nyek:

- beep <freki> <hossz> <beepek sz�ma> <sleep>

  A megadott frekvenci�n csipog a PC speakeren a megadott hosszig. A sleep
  akkor l�nyeges, ha t�bb mint 1x kell beepelni, ekkor a beepel�sek k�z�tti
  sz�netet lehet vele �ll�tani.

- seticon

  A mIRC ikonj�t �ll�tja �t a netZ ikonj�ra.

- title <title>

  A mIRC ablak fejl�c�ben cser�li ki a mIRC sz�veget netZ Script Pro-ra.

- idle

  A legut�bbi eg�rmozgat�s/billenty�le�t�s �ta eltelt millisecundumok sz�m�t
  adja vissza.

- winamp <parancs>

  A parancs hely�re az al�bbiakat �rhatjuk:

  - isplaying:
      1-el t�r vissza, ha a Winamp �pp zen�t j�tszik le, egy�bk�nt 0-val.

  - GetCurrentWinampSongElapsedTime:
      Visszaadja hogy �ppen h�nyadik m�sodpercn�l j�r a Winamp a lej�tsz�sban.

  - GetCurrentWinampSong:
      Visszaadja az �ppen Winampban l�v� sz�m el�ad�j�t/c�m�t.

  - GetCurrentWinampSongKbps:
      Visszaadja az �ppen Winampban l�v� sz�m bitr�t�j�t.

  - GetCurrentWinampSongKHz:
      Visszaadja az �ppen Winampban l�v� sz�m mintav�telez�si frekij�t.

  - GetCurrentWinampSongTotalTime:
      Visszaadja az �ppen Winampban l�v� sz�m hossz�t m�sodpercben.

  - GetCurrentWinampSongChannels:
      Visszaadja az �ppen Winampban l�v� sz�m csatorn�inak sz�m�t.

  - GetCurrentWinampSongFilename:
      Visszaadja az �ppen Winampban l�v� sz�m el�r�si �tj�t.

- enkod <sz�veg>

  A megadott sz�veget k�dolja el uuencode-vel. Ugyanaz mint a mIRC $encode.

- dekod <sz�veg>

  A megadott uuencode-val elk�dolt sz�veget dek�dolja. Ugyanaz mint a mIRC
  $decode, az�rt kell, mert a mIRC alapb�l lockolja a $decodet.



Az OpenSSL library leford�t�sa: (www.openssl.org-r�l tudod let�lteni)

1. T�m�t�tsd ki az OpenSSL forr�st valahova a viny�dra.

2. T�ltsd le az ActiveState ActivePerl-t �s telep�tsd fel.

3. H�vj el� egy cmd ablakot (start menu�->futtat�sba: cmd), l�pj be az openssl
   k�nyvt�rba, majd add ki ezt:
     c:\perl\bin\perl Configure VC-WIN32 --prefix=c:/netzdllsrc/sslpop3/openssl

   �rtelemszer�en add meg a perl.exe el�r�si �tj�t a parancs elej�n, az
   sslpop3/openssl k�nyvt�r el�r�si �tj�t pedig a parancs v�g�n. Ide fogja
   m�solni a v�g�n a leforgatott OpenSSL libet.

4. Ugyanebben a cmd ablakban ind�tsd el a VisualC bin alk�nyvt�r�ban tal�lhat�
   vcvars32.bat-ot. N�lam ez a
   "c:\Program Files (x86)\Microsoft Visual Studio .NET 2003\Vc7\bin"
   k�nyvt�rban van. A biztons�g kedv��rt jobb, ha ezt a k�nyvt�rat beteszed a
   PATH-ba (saj�tg�pre jobbkatt, tulajdons�gok, halad� be�ll�t�sok, alul
   k�rnyezeti v�ltoz�k gomb, als� ablakban a rendszerv�ltoz�k k�z�tt
   megkeresed a PATH-ot, majd edit�lod, a v�g�re ; ut�n besz�rod a r�vid
   f�jlneves el�r�si utat, pl. ez n�lam c:\progra~2\micros~1.net\vc7\bin, de
   am�gy �ltal�ban c:\progra~1\micros~1.net\vc7\bin szokott lenni Visual C
   2003 eset�n.

5. L�pj vissza az OpenSSL k�nyvt�r�ba, add ki a ms\do_masm parancsot.

6. Add ki az nmake -f ms\ntdll.mak parancsot.

7. Add ki az nmake -f ms\ntdll.mak install parancsot.

8. K�sz. :)
