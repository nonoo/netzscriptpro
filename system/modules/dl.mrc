;  This file is part of netZ Script Pro.
;
;  netZ Script Pro is free software; you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation; either version 2 of the License, or
;  (at your option) any later version.
;
;  netZ Script Pro is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License
;  along with netZ Script Pro; if not, write to the Free Software
;  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

;DL
dialog dl {
  title "netZ Downloader"
  size -1 -1 541 277
  option pixels notheme
  box "", 1, 0 -2 540 278
  list 10, 14 158 418 116, vsbar
  text "Inicializálás...", 2, 17 18 77 17
  text "", 3, 97 18 301 17
  text "", 4, 401 18 31 17, right
  edit "", 5, 16 51 416 80, read multi vsbar
  button "OK", 6, 438 105 86 25, disable ok
  text "0 várakozó a letöltési sorban", 7, 15 256 195 17
  text "", 8, 359 137 71 17, right
  text "", 9, 18 37 413 11, right
  text "A netZ Downloaderrel eddig letöltött adatmennyiség:", 11, 437 18 86 55, center
  text "", 12, 437 78 86 17, center
  button "Fel", 13, 438 172 86 17
  button "Le", 14, 438 190 86 17
  button "Töröl", 15, 438 214 86 17
  button "Összes törlése", 16, 438 238 86 17
  text "Hátralévõ idõ:", 17, 122 137 70 17
  text "", 18, 195 137 81 17
  text "Méret:", 19, 16 137 34 17
  text "", 20, 56 137 58 17
  text "Sebesség:", 21, 280 137 74 17
}
; a dialoghoz megnyitunk egy switchbar buttont is
on 1:CLOSE:@Downloader: {
  /dialog -k dl
}
on 1:ACTIVE:@Downloader: {
  if (!$dialog(dl)) {
    /window -c @Downloader
    halt
  }
  /window -n @Downloader
  /dialog -v dl
}
on *:DIALOG:dl:init:*: {
  /window -nk0 @Downloader
  /dll system\mdx.dll SetMircVersion $version
  /dll system\mdx.dll MarkDialog $dname
  /dll system\mdx.dll SetControlMDX $dname 9 ProgressBar smooth > system\ctl_gen.mdx
  did -a $dname 9 BarColor $rgb(255,0,255)
  did -a $dname 9 BGColor 0
}
on *:DIALOG:dl:close:*: {
  ; updatehez szukseges dolgok unsetelese
  unset %patchneeded %dl_noclose

  dl_close
}
; ok gomb katt
on *:DIALOG:dl:sclick:6: {
  ; ha update letoltes elott allunk
  if ($did(6) == Update) {
    did -ra dl 6 OK | unset %dl_noclose
    if (%patchneeded != $null) { /dl %patchneeded }
    else { echo $color(info2) -atng *** Hiba az update fájlban, nem található a szükséges frissítés! }
    halt
  }
  /window -c @Downloader
}
; torol gomb katt
on *:DIALOG:dl:sclick:15: {
  if ($did(10).seltext) {
    ; ha epp a letoltes alatt allot vesszuk ki
    if ($did(10).seltext == %dl_geturl) { dl_done | halt }

    urlremove $did(10).seltext
    /dl_dialog_update
  }
}
; osszes torlese gomb katt
on *:DIALOG:dl:sclick:16: { .dlc }
; fel gomb katt
on *:DIALOG:dl:sclick:13: {
  if ($did(10,1).sel == 1) { halt }
  var %url1 = $hget(dl_urllist,$did(10,1).sel)
  var %url2 = $hget(dl_urllist,$calc($did(10,1).sel - 1))
  .hadd dl_urllist $calc($did(10,1).sel - 1) %url1
  .hadd dl_urllist $did(10,1).sel %url2
  dl_dialog_update
}
; le gomb katt
on *:DIALOG:dl:sclick:14: {
  if ($did(10,1).sel == $hget(dl_urllist,0).item) { halt }
  var %url1 = $hget(dl_urllist,$did(10,1).sel)
  var %url2 = $hget(dl_urllist,$calc($did(10,1).sel + 1))
  .hadd dl_urllist $calc($did(10,1).sel + 1) %url1
  .hadd dl_urllist $did(10,1).sel %url2
  dl_dialog_update
}

; letoltes hozzaadasa a letoltesi listaba / letoltes fojtatasa
alias /dl {
  if (!$1) && (!$hget(dl_urllist,1)) { /echo $color(info2) -atng *** /dl hiba: túl kevés paraméter! használat: /dl [-f urlfile|urlek] | halt }
  if ($1 == -f) && (!$2) { /echo $color(info2) -atng *** /dl hiba: túl kevés paraméter! használat: /dl [-f urlfile|urlek] | halt }
  ; ez azert mert az /update a /dl_importot hasznalja
  urlremove %update_url $+ %update_php
  %dl_quiet = 0
  ; aktivva tesszuk az ablakot
  if ($dialog(dl)) { /dialog -v dl }
  ; ha filebol olvassuk be az urleket
  if ($1 == -f) {
    if (!$exists($2)) { /echo $color(info2) -atng *** /dl hiba: $2 nem létezik! | halt }
    var %i 1
    var %s = $read($2,%i)
    while (%s) {
      /dl_import %s
      inc %i 1
      %s = $read($2,%i)
    }
  }
  else {
    ; atw.hu framek miatt
    if (atw.hu isin $1-) && (?site !isin $1-) && (users.atw.hu !isin $1-) {
      var %user = $remove($1-,http://)
      %user = $left(%user,$calc($pos(%user,.)-1))
      var %fajl = $remove($1-,http:// $+ %user $+ .atw.hu/)
      /dl_import http://users.atw.hu/ $+ $lower(%user) $+ / $+ %fajl
      return
    }
    /dl_import $1-
  }
}
alias /dl_import {
  ; vegigmegyunk a parametereken, egyesevel betesszuk oket a letoltesi sorba
  var %i $numtok($1-,32)
  var %vandllista 0
  if ($hget(dl_urllist,1)) { %vandllista = 1 }

  var %volt
  while (%i > 0) {
    ; ha mar valami bennvan a listaban, megegyszer nem tesszuk bele
    var %j = 0
    %volt = 0
    while (%j < $hget(dl_urllist,0).item) {
      inc %j 1
      if ($gettok($1-,%i,32) == $hget(dl_urllist,%j)) { %volt = 1 }
    }
    ; ha nincs bennt az url a listaban
    if (!%volt) {
      var %ujurl = $gettok($1-,%i,32)
      ; ha nincs az url elejen ://, http://-t teszunk oda
      if (:// !isin %ujurl) { %ujurl = http:// $+ %ujurl }
      ; csak ftpt, httpt, httpst tamogatunk
      if ($left(%ujurl,7) == http://) || ($left(%ujurl,6) == ftp://) || ($left(%ujurl,8) == https://) {
        ; ha meg nincs letoltesi lista, siman beleirjuk az urlt
        if (!%vandllista) {
          .hdel -w dl_urllist *
          .hadd dl_urllist $calc($hget(dl_urllist,0).item + 1) %ujurl
          %vandllista = 1
        }
        ; berakjuk az urlt a letoltesi lista elso hejere, az elsot az utolso elem utani hejre tesszuk
        else {
          var %tmp = $hget(dl_urllist,1)
          .hadd dl_urllist 1 %ujurl
          .hadd dl_urllist $calc($hget(dl_urllist,0).item + 1) %tmp
        }
      }
      else { echo $color(info2) -atng *** Ismeretlen protokoll (csak http://, https://, ftp:// lehet): %ujurl }
    }
    dec %i 1
  }
  /ujdl
}
; letoltesre varakozok torlese
alias /dlc {
  if ($hget(dl_urllist)) { .hdel -w dl_urllist * | /dl_done }
  /echo $color(info) -atngq *** Letöltési sor törölve.
}
alias /dl_dialog_update {
  ; letoltesi ablak letoltesi listajanak frissitese
  if (!%dl_quiet) {
    ; letoltesi ablak ha nincs megnyitva, megnyitjuk
    if (!$dialog(dl)) { /dialog -mrd dl dl }

    did -ra dl 12 $meret(%dl_letoltott_adatmennyiseg)
    did -ra dl 7 $hget(dl_urllist,0).item várakozó a letöltési sorban
    did -r dl 10
    var %i 0
    while (%i < $hget(dl_urllist,0).item) {
      inc %i 1
      did -a dl 10 $hget(dl_urllist,%i)
    }
  }
}
; kiveszi a megadott urlt a listabol
alias /urlremove {
  var %i = 1
  var %regidl_urllist_num = $hget(dl_urllist,0).item
  .hsave dl_urllist system\temp\urllist.tmp
  .hdel -w dl_urllist *
  .hmake regidl_urllist 100
  .hload regidl_urllist system\temp\urllist.tmp
  .remove system\temp\urllist.tmp

  while (%i <= %regidl_urllist_num) {
    if ($hget(regidl_urllist,%i) != $1) {
      .hadd dl_urllist $calc($hget(dl_urllist,0).item + 1) $hget(regidl_urllist,%i)
    }
    inc %i 1
  }
  .hfree regidl_urllist
}
; ha a letoltes befejezve
alias /dl_done {
  ; ha kepet, filmet, zenet toltottunk le, nezoke elinditasat felkinaljuk
  if (.jpg isin %dl_geturl) || (.jpeg isin %dl_geturl) || (.gif isin %dl_geturl) || (.png isin %dl_geturl) || (.bmp isin %dl_geturl) || (.mpg isin %dl_geturl) || (.mpeg isin %dl_geturl) || (.avi isin %dl_geturl) || (.wmv isin %dl_geturl) || (.mov isin %dl_geturl) || (.mp3 isin %dl_geturl) || (.wav isin %dl_geturl) || (.ogg isin %dl_geturl) || (.txt isin %dl_geturl) || (.pdf isin %dl_geturl) || (.exe isin %dl_geturl) || (.mpe isin %dl_geturl) {
    if ($exists(%dl_downloaddir $+ %dl_filename)) {
      echo $color(info) -atng *** netZ Downloader: F8 - %dl_filename megnyitása
      .hdel data $cid $+ doit $+ $replace($active,Status Window,status)
      .hadd data $cid $+ doit $+ $replace($active,Status Window,status) .timer 1 0 /run %dl_downloaddir $+ %dl_filename
    }
  }

  ; urllistabol kivesszuk a letoltott urlt
  /urlremove %dl_geturl
  %dl_geturl = $null

  /dl_dialog_update
  /ujdl
}
; /ujdl - fojtatja a letoltesi listaban levo urlek letolteset
alias /ujdl {
  ; ha nincs letoltes alatt levo url, a lista elso elemet vesszuk annak
  if (!%dl_geturl) { %dl_geturl = $hget(dl_urllist,1) }
  else { /dl_dialog_update | return }
  /dl_dialog_update

  ; ha nincs mit letolteni, vege a letoltesnek
  if (!%dl_geturl) { dl_close | return }

  ; %20-bol space
  %dl_filename = $replace($nopath(%dl_geturl),$chr(37) $+ 20,$chr(32))
  ; kerdojelbol alahuzasjel
  %dl_filename = $replace(%dl_filename,?,_)
  ; ha ftpvel van dolgunk
  if (ftp:// isin %dl_geturl) { %dl_ftp = 1 }
  else { %dl_ftp = 0 }
  %dl_port = $null
  ; hostot kivagjuk
  %dl_host = $remove(%dl_geturl,http://,ftp://,https://)
  if ($pos(%dl_host,/)) { %dl_host = $left(%dl_host,$calc($pos(%dl_host,/)-1)) }
  if (%dl_ftp) {
    ; ha esetleg megadtak az urlben a user:pass-t ftphez
    if (: isin %dl_host) && (@ isin %dl_host) {
      %dl_ftp_user = $left(%dl_host,$calc($pos(%dl_host,:)-1))
      %dl_ftp_pass = $left(%dl_host,$calc($pos(%dl_host,@)-1))
      %dl_ftp_pass = $remove(%dl_ftp_pass,%dl_ftp_user $+ :)
      %dl_host = $remove(%dl_host,%dl_ftp_user $+ : $+ %dl_ftp_pass $+ @)
    }
    else { %dl_ftp_user = anonymous | %dl_ftp_pass = $email }
    %dl_ftp_filepath = $remove(%dl_geturl,http://,https://,ftp://,%dl_ftp_user $+ : $+ %dl_ftp_pass $+ @,%dl_host)
  }

  ; ha esetleg megadtak az urlben a portot
  if (: isin %dl_host) {
    %dl_port = $right(%dl_host,$calc($len(%dl_host)-$pos(%dl_host,:)))
    %dl_host = $remove(%dl_host,: $+ %dl_port)
  }
  if (!%dl_quiet) {
    did -b dl 6 | dialog -v dl | did -ra dl 2 Kapcsolódás:
    if (%dl_port) { did -ra dl 3 %dl_host $+ : $+ %dl_port }
    else { did -ra dl 3 %dl_host }
  }

  ; listftphez
  if (%ftp_orig_downloaddir) {
    %dl_downloaddir = $left(%dl_geturl,$calc($pos(%dl_geturl,%listftpcwd) + $len(%listftpcwd)-1))
    %dl_downloaddir = $remove(%dl_geturl,%dl_downloaddir)
    %dl_downloaddir = $right(%dl_downloaddir,$calc($len(%dl_downloaddir)-1)))
    %dl_downloaddir = %ftp_orig_downloaddir $+ $left(%dl_downloaddir,$calc($pos(%dl_downloaddir,/)-1))) $+ \
  }

  %dl_fileiras = 0 | %dl_filemeret = 0 | %dl_hiba = 0 | %dl_headerkivagva = 0
  if (%dl_ftp) {
    if (!%dl_port) { %dl_port = 21 }
    if ($sock(ftpget).status == active) { sockwrite -n ftpget ABOR $+ $crlf $+ QUIT }
    sockclose ftpget | sockclose ftpdata | sockopen ftpget %dl_host %dl_port
  }
  else {
    if (!%dl_port) {
      if (https:// isin %dl_geturl) {
        %dl_port = 443
      }
      else {
        %dl_port = 80
      }
    }
    sockclose httpget
    if ((%dl_port == 443) || (https isin %dl_geturl)) {
      sockopen -e httpget %dl_host %dl_port
    }
    else {
      sockopen httpget %dl_host %dl_port
    }
  }
}
; valtozok pucolasa, letoltesi sor kiurult, letoltes vege
alias /dl_close {
  sockclose httpget
  if ($sock(ftpget).status == active) { sockwrite -n ftpget ABOR $+ $crlf $+ QUIT }
  sockclose ftpget | sockclose ftpdata
  if ($dialog(dl)) {
    did -r dl 8
    did -e dl 6
    did -r dl 18
    did -r dl 20
    .timerdl_speedmeter off
    .timerdl_meter off
    if (%dl_hiba) { %dl_noclose = 1 }
    ; bezarjuk a dialogot ha nem kell nyitva hagyni
    if (!%dl_noclose) {
      /dialog -x dl | /window -c @Downloader
    }
  }

  ; csak az update lekerese volt dl_quiet-tel
  if (%dl_quiet) { unset %patchneeded %dl_noclose }

  if (%ftp_orig_downloaddir) { %dl_downloaddir = %ftp_orig_downloaddir | unset %ftp_orig_downloaddir %listftpcwd }

  unset %dl_quiet %dl_geturl %dl_filename %dl_fileiras %dl_hiba %dl_filemeret %dl_host %dl_elozosize %dl_headerkivagva %dl_ftp %dl_port %dl_ftp_user %dl_ftp_pass %dl_resume %dl_ftp_filepath %dl_elozosize_meres %ftp_site_invite %dl_atvizsgalniredirectet
}
; sebessegmeres
alias /dl_speedmeter {
  var %ujsize = $file(%dl_downloaddir $+ %dl_filename).size
  if (%ujsize > 0) {
    var %sebesseg = $calc((%ujsize - %dl_elozosize))
    did -ra dl 8 $meret(%sebesseg) $+ /sec
    did -ra dl 18 $duration($calc((%dl_filemeret - %ujsize) / %sebesseg),3)
    %dl_elozosize = %ujsize
  }
}
; letoltott adatmennyiseg update
alias /dl_meter {
  var %fsize = $file(%dl_downloaddir $+ %dl_filename).size
  var %diff = $calc(%fsize - %dl_elozosize_meres)
  if (%diff > 0) { inc %dl_letoltott_adatmennyiseg %diff }
  %dl_elozosize_meres = %fsize

  var %szazalek $round($calc((%fsize / %dl_filemeret)*100),0)
  did -ra dl 4 %szazalek $+ % | /did -a dl 9 %szazalek 0 100
  did -ra dl 12 $meret(%dl_letoltott_adatmennyiseg)
}
on 1:sockopen:httpget: {
  if ($sockerr > 0) { if (!%dl_quiet) { did -a dl 5 Kapcsolódási hiba $laz(%dl_host) %dl_host $+ : $+ %dl_port hosthoz! ( $+ %dl_geturl $+ ) $+ $crlf | did -ra dl 2 Hiba: | did -ra dl 3 %dl_geturl | %dl_hiba = 1 } | dl_done | halt }
  ; eloszor a http headert kerjuk le
  if (!%dl_fileiras) {
    if (!%dl_quiet) { did -ra dl 2 HTTP header: | did -ra dl 3 %dl_geturl | did -ra dl 4 0% | did -r dl 9 | did -r dl 20 }
    if (https:// isin %dl_geturl) {
      var %dl_truncurl $remove(%dl_geturl,https:// $+ %dl_host)
      if (%dl_truncurl == $null) { %dl_truncurl = / }
      sockwrite -n httpget HEAD %dl_truncurl HTTP/1.0
    }
    else {
      sockwrite -n httpget HEAD %dl_geturl HTTP/1.0
    }
    var %referer = $left(%dl_geturl,$pos(%dl_geturl,$nopath(%dl_geturl)))
    sockwrite -n httpget Referer: %referer
    sockwrite -n httpget Host: %dl_host $+ : $+ %dl_port
    sockwrite -n httpget User-Agent: netZ Script Pro v $+ %ver
    sockwrite -n httpget Connection: close
    sockwrite -n httpget Accept: */* $+ $crlf $+ $crlf
  }
  else {
    ; nincs feluliras ha mar megvan a file
    if (%dl_filemeret == $file(%dl_downloaddir $+ %dl_filename).size) {
      ; ha update filet toltottunk le akkor vegrehajtjuk
      if (%update_url isin %dl_geturl) { %dl_noclose = 1 | /updateapply %dl_downloaddir $+ %dl_filename }
      dl_done
      return
    }

    ; celkonyvtar letezik-e
    if (!$exists(%dl_downloaddir)) { .mkdir %dl_downloaddir }
    if (!%dl_quiet) { did -ra dl 2 Letöltés alatt: | .timerdl_speedmeter 0 1 /dl_speedmeter | .timerdl_meter -m 0 100 /dl_meter | did -ra dl 20 $meret(%dl_filemeret) }
    if (https:// isin %dl_geturl) {
      var %dl_truncurl $remove(%dl_geturl,https:// $+ %dl_host)
      if (%dl_truncurl == $null) { %dl_truncurl = / }
      sockwrite -n httpget GET %dl_truncurl HTTP/1.0
    }
    else {
      sockwrite -n httpget GET %dl_geturl HTTP/1.0
    }
    ; resume eseten
    if (%dl_resume) { sockwrite -n httpget Range: bytes= $+ $file(%dl_downloaddir $+ %dl_filename).size $+ - | if (!%dl_quiet) { did -a dl 5 Letöltés (folytatás): %dl_filename $+ ... } }
    else {
      if (!%dl_filename) { %dl_filename = index.html }
      write -c " $+ %dl_downloaddir $+ %dl_filename $+ "
      if (!%dl_quiet) { did -a dl 5 Letöltés: %dl_filename $+ ... }
    }
    sockwrite -n httpget User-Agent: netZ Script Pro v $+ %ver
    var %referer = $left(%dl_geturl,$pos(%dl_geturl,$nopath(%dl_geturl)))
    sockwrite -n httpget Referer: %referer
    sockwrite -n httpget Host: %dl_host $+ : $+ %dl_port
    sockwrite -n httpget Connection: close
    sockwrite -n httpget Accept: */* $+ $crlf $+ $crlf
  }
}
on 1:sockclose:httpget: {
  sockclose httpget
  ; ha kell, atnezzuk a filet meta-tag redirect utan
  if (%dl_atvizsgalniredirectet) {
    unset %dl_atvizsgalniredirectet
    var %i 1
    var %tmp = $read(%dl_downloaddir $+ %dl_filename,%i)
    var %tmpfsize $calc($len(%tmp) + 2)
    while (</html> !isin %tmp) && (%tmpfsize < $file(%dl_downloaddir $+ %dl_filename).size) {
      ; kivagjuk az urlt amire ugranunk kell
      if (http-equiv="refresh" isin %tmp) {
        %tmp = $remove(%tmp,$left(%tmp,$calc($pos(%tmp,URL=) + 3)))
        %dl_hiba = 1
        ; toroljuk a letoltott html filet
        .remove " $+ %dl_downloaddir $+ %dl_filename $+ "
        /dl $left(%tmp,$calc($pos(%tmp,") - 1))
        goto kesz
      }
      inc %i 1
      %tmp = $read(%dl_downloaddir $+ %dl_filename,%i)
      inc %tmpfsize $calc($len(%tmp) + 2)
    }
  }
  :kesz

  ; ha kesz a letoltes
  if (%dl_fileiras) {
    if (!%dl_quiet) { did -a dl 5 kész. $+ $crlf | did -r dl 3 | did -r dl 4 | did -a dl 9 100 0 100 | did -ra dl 2 Kész. | did -r dl 18 | did -r dl 20 }
    ; ha valamilyen updatet toltottunk le
    if (%update_url isin %dl_geturl) { /updateapply %dl_downloaddir $+ %dl_filename }
    dl_done
    halt
  }
  ; header lekerese utan file letoltes megkezdese
  if (!%dl_fileiras) && (!%dl_hiba) {
    .timer 1 0 continuedl
    halt
  }
  dl_done
}
on 1:sockread:httpget: {
  ; header lekeres
  if (!%dl_fileiras) {
    var %temp
    :ujraolvas1
    sockread %temp
    if (!$sockbr) { return }
    tokenize 32 %temp
    ; hibavizsgalat
    if (HTTP/ isin $1) && ($2 != 200) && ($3 != OK) && ($2 != 302) {
      %dl_hiba = 1 | %dl_noclose = 1
      if (!%dl_quiet) {
        if ($2- == 404 Not Found) {
          did -o dl 5 $did(dl,5).lines Nincs %dl_filename a szerveren! ( $+ $2- $+ )
        }
        else {
          did -o dl 5 $did(dl,5).lines Http hiba: $2- ( $+ %dl_geturl $+ )
        }
        did -ra dl 2 Hiba: | did -r dl 4 | did -r dl 9 | did -r dl 18 | did -r dl 20
      }
    }
    ; meretet lekerdezzuk
    if (Content-Length isin $1) { %dl_filemeret = $2 }
    ; atiranyitas
    if (Location isin $1) {
      %dl_hiba = 1
      if (http:// !isin $2-) && (https:// !isin $2-) { /dl http:// $+ %dl_host $+ / $+ $2- }
      else { /dl $2- }
    }
    goto ujraolvas1
  }
  ; letoltes
  else {
    :ujraolvas2

    ; ha meg nem vagtuk ki a http headert
    if (!%dl_headerkivagva) {
      var %temp
      sockread %temp
      if ($sockbr == 0) { return }
      if ($len(%temp) == 0) { %dl_headerkivagva = 1 | goto ujraolvas2 }

      ; ha nem html filet toltunk le es van benne meta-tag redirect, letoltes utan atvizsgaljuk a filet a redirect utan
      if (Content-Type: text/html isin %temp) && (.htm !isin %dl_filename) && (.php !isin %dl_filename) { %dl_atvizsgalniredirectet = 1 }
    }
    else {
      var &temp
      sockread 565535 &temp
      if ($sockbr == 0) { return }
      bwrite " $+ %dl_downloaddir $+ %dl_filename $+ " -1 &temp
    }

    goto ujraolvas2
  }
}
; header lekerese utan file letoltes megkezdese init
; azert kell ez kulon fuggvenybe, hogy meg tudjuk hivni modalisan a dl_felulir dialogot
alias continuedl {
  if ( (!%dl_quiet) && ( $file(%dl_downloaddir $+ %dl_filename) != $null ) ) {
    ; ha letezik a file, megkerdezzuk a usert hogy mit akar
    $dialog( dl_felulir, dl_felulir, dl )
    if ( %dl_geturl == $null ) {
      ; a dialogot kiXeltek
      return
    }
  }

  %dl_fileiras = 1
  if ((%dl_port == 443) || (https isin %dl_geturl)) {
    sockopen -e httpget %dl_host %dl_port
  }
  else {
    sockopen httpget %dl_host %dl_port
  }
}
;END

; ftp kommunikacio
on 1:sockopen:ftpget: {
  if ($sockerr > 0) {
    if (!%dl_quiet) {
      did -a dl 5 Kapcsolódási hiba $laz(%dl_host) %dl_host $+ : $+ %dl_port hosthoz! ( $+ %dl_geturl $+ ) $+ $crlf
      did -ra dl 2 Hiba: | did -ra dl 3 %dl_geturl | %dl_hiba = 1
    }
    dl_done
    halt
  }
  if (!%dl_quiet) { did -ra dl 2 FTP init: | did -ra dl 3 %dl_geturl | did -ra dl 4 0% | did -r dl 9 | did -r dl 18 | did -r dl 20 }
}
on 1:sockread:ftpget: {
  var %temp
  :ujraolvas
  sockread %temp
  if (!$sockbr) { return }
  .tokenize 32 %temp
  if ($1 == 220) { sockwrite -n ftpget USER %dl_ftp_user }
  if ($1 == 331) { sockwrite -n ftpget PASS %dl_ftp_pass }
  if ($1 == 230) {
    ; site invite
    if (%ftp_site_invite) { sockwrite -n ftpget SITE INVITE %ftp_site_invite | dl_done }
    else { sockwrite -n ftpget SIZE %dl_ftp_filepath }
  }
  ; fajlmeret
  if ($1 == 213) {
    %dl_filemeret = $2

    ; resume kell-e?
    if (%dl_filemeret > $file(%dl_downloaddir $+ %dl_filename).size) && ($file(%dl_downloaddir $+ %dl_filename).size > 0) { %dl_resume = 1 }

    ; nincs feluliras ha mar megvan a file
    if (%dl_filemeret == $file(%dl_downloaddir $+ %dl_filename).size) {
      if (!%dl_quiet) { %dl_hiba = 1 | did -a dl 5 Letöltés: %dl_filename - nem írom felül a fájlt! $+ $crlf | did -ra dl 2 Kész. | did -r dl 4 | did -a dl 9 100 0 100 | did -r dl 3 |  did -r dl 18 | did -r dl 20 }
      dl_done
      return
    }
    if (!%dl_quiet) { did -ra dl 20 $meret(%dl_filemeret) }

    ; atvitel tipusa
    if ($right(%dl_filename,4) == .txt) || ($right(%dl_filename,4) == .htm) || ($right(%dl_filename,5) == .html) || ($right(%dl_filename,4) == .pas) || ($right(%dl_filename,2) == .c) || ($right(%dl_filename,4) == .cpp) || ($right(%dl_filename,2) == .h) || ($right(%dl_filename,4) == .bas) || ($right(%dl_filename,4) == .tex) || ($right(%dl_filename,4) == .inc) || ($right(%dl_filename,4) == .php) || ($right(%dl_filename,4) == .nfo) || ($right(%dl_filename,4) == .diz) {
      sockwrite -n ftpget TYPE A
    }
    else { sockwrite -n ftpget TYPE I }
  }
  if ($1 == 200) { sockwrite -n ftpget PASV }
  if ($1 == 227) {
    ; port kiszamitasa
    %dl_port = $5
    var %a = $gettok(%dl_port,5,44)
    var %b = $gettok(%dl_port,6,44)
    %dl_port = $calc(256 * %a + %b)

    ; ha resume van
    if (%dl_resume) { sockwrite -n ftpget REST $file(%dl_downloaddir $+ %dl_filename).size }
    ; ha nincs rogton toltunk is
    else { sockwrite -n ftpget RETR %dl_ftp_filepath | sockopen ftpdata %dl_host %dl_port }
  }
  ; resume van
  if ($1 == 350) { sockwrite -n ftpget RETR %dl_ftp_filepath | sockopen ftpdata %dl_host %dl_port }

  ; hibak
  if ($1 == 550) {
    %dl_hiba = 1
    if (!%dl_quiet) {
      if (Permission isin $1-) { did -o dl 5 $did(dl,5).lines Nincs jogosultság %dl_filename olvasásához! ( $+ $2- $+ ) }
      else { did -o dl 5 $did(dl,5).lines Nincs %dl_filename a szerveren! ( $+ $2- $+ ) }
      did -ra dl 2 Hiba: | did -r dl 4 | did -r dl 9 | did -r dl 18 | did -r dl 20
    }
    dl_done
  }
  if ($1 == 500) {
    %dl_hiba = 1
    if (!%dl_quiet) {
      did -o dl 5 $did(dl,5).lines FTP hiba: $2-
      did -ra dl 2 Hiba: | did -r dl 4 | did -r dl 9 | did -r dl 18 | did -r dl 20
    }
    dl_done
  }
  if ($1 == 530) {
    %dl_hiba = 1
    if (!%dl_quiet) {
      did -o dl 5 $did(dl,5).lines Hibás login/pass! ( $+ $2- $+ )
      did -ra dl 2 Hiba: | did -r dl 4 | did -r dl 9 | did -r dl 18 | did -r dl 20
    }
    dl_done
  }
  goto ujraolvas
}

; ftp adat kapcsolat
on 1:sockopen:ftpdata: {
  if ($sockerr > 0) { if (!%dl_quiet) { did -a dl 5 Kapcsolódási hiba $laz(%dl_host) %dl_host $+ : $+ %dl_port hosthoz! ( $+ %dl_geturl $+ ) $+ $crlf | did -ra dl 2 Hiba: | did -ra dl 3 %dl_geturl | %dl_hiba = 1 } | dl_done | halt }

  ; celkonyvtar letezik-e
  if (!$exists(%dl_downloaddir)) { .mkdir %dl_downloaddir }
  if (!%dl_quiet) { did -ra dl 2 Letöltés alatt: | .timerdl_speedmeter -m 0 500 /dl_speedmeter | .timerdl_meter -m 0 100 /dl_meter | did -ra dl 20 $meret(%dl_filemeret) }
  if (%dl_resume) { if (!%dl_quiet) { did -a dl 5 Letöltés (folytatás): %dl_filename $+ ... } }
  else {
    write -c " $+ %dl_downloaddir $+ %dl_filename $+ "
    if (!%dl_quiet) { did -a dl 5 Letöltés: %dl_filename $+ ... }
  }
}
; ami jon az adat kapcsolaton, irjuk ki vinyora
on 1:sockread:ftpdata: {
  var &temp
  :ujraolvas
  sockread -f 565535 &temp
  if (!$sockbr) { return }
  bwrite " $+ %dl_downloaddir $+ %dl_filename $+ " -1 &temp
  goto ujraolvas
}
; ha az adat kapcsolat bezarul, vege a letoltesnek
on 1:sockclose:ftpdata: {
  if (!%dl_quiet) { did -a dl 5 kész. $+ $crlf | did -r dl 3 | did -r dl 4 | did -a dl 9 100 0 100 | did -ra dl 2 Kész. | did -r dl 18 | did -r dl 20 }
  dl_done
}

;SITEINVITE
alias /sinv { /siteinvite $1- }
alias /siteinvite {
  if (!$1) { /echo $color(info2) -atng *** /siteinvite hiba: túl kevés paraméter! használat: /siteinvite [ftp://(user:pass@)host(:port)/] (nick) | halt }
  if (!$2) { %ftp_site_invite = $me }
  else { %ftp_site_invite = $2 }
  /dl $1
}
;END

;FELULIRDIALOG
dialog dl_felulir {
  title "netZ Downloader"
  size -1 -1 588 117
  option pixels notheme
  text "A fájl már létezik:", 1, 8 32 109 17, right
  button "Folytat", 2, 227 94 112 20
  button "Felülír", 3, 351 94 112 20
  button "Más néven ment", 4, 473 94 112 20
  text "Mérete:", 5, 52 51 65 17, right
  text "Letöltendõ fájl mérete:", 6, 5 68 113 17, right
  text "", 7, 122 32 460 17
  text "", 8, 122 51 460 17
  text "", 9, 122 68 460 17
  text "URL:", 10, 81 7 35 17, right
  text "", 11, 122 7 460 17
}
on *:DIALOG:dl_felulir:init:*: {
  did -ra $dname 7 %dl_downloaddir $+ %dl_filename
  did -ra $dname 8 $file(%dl_downloaddir $+ %dl_filename).size byte
  did -ra $dname 9 %dl_filemeret byte
  did -ra $dname 11 %dl_geturl
  if (%dl_filemeret <= $file(%dl_downloaddir $+ %dl_filename).size) {
    did -b $dname 2
  }
  /dialog -r $dname
}
on *:DIALOG:dl_felulir:close:*: {
  ; az ablakot kiXeltek, kivesszuk a jelenlegi urlt a letoltesi listabol
  /urlremove %dl_geturl
  %dl_geturl = $null

  /dl_dialog_update
  /ujdl
}
on *:DIALOG:dl_felulir:sclick:2: {
  %dl_resume = 1
  /dialog -x $dname
}
on *:DIALOG:dl_felulir:sclick:3: {
  .remove %dl_downloaddir $+ %dl_filename
  /dialog -x $dname
}
on *:DIALOG:dl_felulir:sclick:4: {
  var %i = 1
  var %fname = $replace( %dl_filename, $getextension( %dl_filename ), $null )
  while ( $file( %fname $+ . $+ %i $+ $getextension( %dl_filename ) ) != $null ) {
    inc %i
  }
  %dl_filename = %fname $+ . $+ %i $+ $getextension( %dl_filename )
  /dialog -x $dname
}
;END
