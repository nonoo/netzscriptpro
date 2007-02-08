;  This file is part of netZ Script Pro.
;
;  netZ Script Pro 2 � Nonoo 1999-2007
;  http://netz.nonoo.hu/
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

;ONSTARTUP
alias moduleload {
  if (!$script(events.mrc)) { .load -rs system\modules\events.mrc }
  if (!$script(mode.mrc)) { .load -rs system\modules\mode.mrc }
  if (!$script(addons.mrc)) { .load -rs system\modules\addons.mrc }
  if (!$script(whiteboard.mrc)) { .load -rs system\modules\whiteboard.mrc }
  if (!$script(setupdialog.mrc)) { .load -rs system\modules\setupdialog.mrc }
  if (!$script(setup.mrc)) { .load -rs system\modules\setup.mrc }
  if (!$script(update.mrc)) { .load -rs system\modules\update.mrc }
  if (!$script(checkmail.mrc)) { .load -rs system\modules\checkmail.mrc }
  if (!$script(telnet.mrc)) { .load -rs system\modules\telnet.mrc }
  if (!$script(dl.mrc)) { .load -rs system\modules\dl.mrc }

  if (!$alias(netzalias1.mrc)) { .load -a system\aliases\netzalias1.mrc }
  if (!$alias(netzalias2.mrc)) { .load -a system\aliases\netzalias2.mrc }
  if (!$alias(design.mrc)) { .load -a system\aliases\design.mrc }
  if (!$alias(winamp.mrc)) { .load -a system\aliases\winamp.mrc }
  if (!$alias(reset.mrc)) { .load -a system\aliases\reset.mrc }
  if (!$alias(mass.mrc)) { .load -a system\aliases\mass.mrc }
}

on *:START: {
  if (!$server) {
    moduleload
    ; hash tablakat elokeszitjuk
    .hmake dl_urllist 100
    .hmake data 100
    .hmake lastmsg 100
    .hmake patchfiles 30

    ; eddig nem letezo valtozokat inicializaljuk
    varcheck
    othercheck

    ; mirc ikon
    .timer 1 0 /dll system\netz.dll seticon
    .play -sc system\title.txt 100
    echo -sg  $+ $chr(32) $+  $+ $chr(32) $+  $+ $color(nick) $+ :[ netZ Script Pro v $+ %ver by Nonoo ]: :[ http://netz.nonoo.hu/ ]:
    echo $color(background) -sg -
    nevnap -s
    echo $color(background) -sg -
    echo $color(nick) -sg F2 - Kapcsol�d�s: %legutobbiszerver1

    %away_eredeti_nick = $me

    ; title updater
    .timerTitle -i 0 1 /title
    ; temp uritese
    var %a $findfile(system\temp,*.*,0,.remove $1-)
    ; szulinapom :)
    if ( 04/12/ isin $date ) { /echo $color(background) -sg - | /echo $color(highlight) -sg *** MA VAN NONOO SZ�LINAPJA! ;-))) *** }
    ; firstsetup elso inditaskor
    if (%nemvoltinditva == 1) { firstsetup | %nemvoltinditva = 0 }
    ; frissites keresese
    if (%autoupdate) { .timer 1 1 update -quiet }
    ; auto connect
    if (%autoconnect) {
      var %i 2
      ; az elso szervert az aktiv ablakba csatlakoztatjuk
      if (%autoconnect_servers) { /server %autoconnect_servers }
      ; tobbihez uj ablakokat nyitunk
      while (%i <= $numtok(%autoconnect_servers,32)) {
        /server -m $gettok(%autoconnect_servers,%i,32)
        inc %i 1
      }
    }
  }
}
;END

;FIRSTSETUP
alias /firstsetup { /dialog -mr firstsetup firstsetup }
dialog firstsetup {
  title ":[ netZ Script Pro ]:"
  size -1 -1 225 363
  option pixels notheme
  text "�dv�z�llek a netZ Script Proban!", 1, 30 12 164 20
  text "Itt l�thatod a legfontosabb be�ll�t�sokat. Ezeket k�s�bb is megv�ltoztathatod.", 2, 12 32 201 29
  text "Az idented a hostodhoz val� felhaszn�l� azonos�t�sra szolg�l. Alapb�l ez maradhat a kisbet�s nicked. Kapcsol�d�s ut�n az F2 lenyom�s�ra a script a kedvenc csatijaidra fog bel�pni.", 3, 12 72 201 67
  text "Nicked:", 4, 24 164 50 20
  edit "", 5, 95 160 100 20
  text "Idented:", 6, 24 184 50 20
  edit "", 7, 95 180 100 20
  text "Awaynicked:", 8, 24 204 60 20
  edit "", 9, 95 200 100 20
  text "Kedvenc", 10, 24 288 60 20
  text "csatijaid:", 11, 24 302 60 20
  edit "", 12, 95 298 100 20
  box "", 13, 2 324 222 39
  button "OK", 100, 5 334 215 25, ok
  box "", 14, 2 0 220 147
  check "Awayn�l ink�bb v�ltson az �ppen akt�v nick kisbet�s v�ltozat�ra", 15, 95 223 97 70, multi
}
on *:DIALOG:firstsetup:init:*: {
  /dialog -t firstsetup :[ netZ Script Pro %ver ]:
  if (%awaynick_kisbetusre) { did -b $dname 9 | did -c $dname 15 }
}
on *:DIALOG:firstsetup:edit:5: { /did -ra $dname 7 $lower($did(5)) | /did -ra $dname 9 $lower($did(5)) }
on *:DIALOG:firstsetup:sclick:15: {
  if ($did(15).state) { did -b $dname 9 }
  else { did -e $dname 9 }
}
on *:DIALOG:firstsetup:sclick:100: {
  if (!$did(12)) { %kedvenc_csatik = #qka }
  else { %kedvenc_csatik = $did(12) }
  %awaynick = $did(9)
  if (!%awaynick) { %awaynick = netz }
  if (!$did(5)) { .timer 1 0 .nick netZ | .timer 1 0 .anick [netZ] }
  else { .timer 1 0 .nick $did(5) | .timer 1 0 .anick $did(5) $+ _ }
  if (!$did(7)) { .identd on netzpro | .identd off | .emailaddr netzpro@ }
  else { .identd on $did(7) | .identd off | .emailaddr $did(7) $+ @ }
  if ($did(15).state) { %awaynick_kisbetusre = 1 }
  else { %awaynick_kisbetusre = 0 }
}
;END

;UZENET
dialog uzenet {
  title "�zenet a k�sz�t�nek"
  size -1 -1 454 246
  option pixels notheme
  text "�szrev�teleidet, javaslataidat, felfedezett bugokat, k�rd�seket vagy b�rmi m�st, ami eszedbe jut, itt tudsz k�ldeni a k�sz�t�nek. Vedd figyelembe hogy ez az opci� els�dlegesen a script tov�bbi fejl�d�s�nek el�seg�t�s�t szolg�lja, ez�rt k�rlek ne k�ldj felesleges megjegyz�seket (szobdlemagad, anyadpicsaja, ilyenek). K�szi!", 2, 5 6 443 56
  text "A script a szervernek csak a nicked, email c�med (ha megadod) �s az �zeneted k�ldi, semmi m�st nem. Ha megadod az email c�med, az esetlegesen felmer�l� k�rd�seidre v�laszt k�ld�nk!", 3, 5 67 442 42
  text "Email c�med:", 4, 5 121 75 17
  edit "", 5, 93 120 357 20
  text "�zeneted:", 6, 5 150 57 17
  edit "", 7, 93 148 357 95, vsbar return multi
  button "K�ld�s", 8, 7 216 74 23, ok flat default
}
alias /uzenet { dialog -mr uzenet uzenet }
alias /urlencode {
  ; vegigmegyunk az uzenet karakterein, a nem alfanumerikus karaktereket elkodoljuk
  var %i = 1
  var %msg $1-
  var %msg2
  while (%i <= $len(%msg)) {
    if ($right($left(%msg,%i),1) !isalnum) {
      ;      if ($right($left(%msg,%i),1) == $chr(1)) { %msg2 = %msg2 $+ $chr(37) $+ 0A }
      %msg2 = %msg2 $+ $chr(37) $+ $base($asc($right($left(%msg,%i),1)),10,16)
    }
    else { %msg2 = %msg2 $+ $right($left(%msg,%i),1) }
    inc %i 1
  }
  return %msg2
}
on *:DIALOG:uzenet:init:*: {
  did -a $dname 5 $email
}
on *:DIALOG:uzenet:sclick:8: {
  if ($did(5)) { var %email = &email= $+ $urlencode($did(5)) }
  var %i 1
  .hdel -w uzenet *
  ; attesszuk az uzenetet a hash tablaba
  while (%i <= $did(7).lines) {
    .hadd uzenet %i $urlencode($did(uzenet,7,%i))
    inc %i 1
  }
  if ($hget(uzenet,0).items == 0) { /echo $color(info2) -atng *** Nem adt�l meg �zenetet. | halt }
  %uzenetget = nick= $+ $me $+ %email $+ &msg=
  echo $color(info) -atng *** �zenet k�ld�se...
  sockclose uzenet | sockopen uzenet netz.nonoo.hu 80
}
on 1:sockclose:uzenet: { unset %figyeles | .hdel -w uzenet * }
on 1:sockopen:uzenet: {
  if ($sockerr > 0) { /echo $color(info2) -atng *** /uzenet: kapcsol�d�si hiba a netz.nonoo.hu szerverhez, az �zenetet nem siker�lt elk�ldeni! | unset %uzenetget | halt }
  var %clength = $len(%uzenetget)
  var %i = 1
  while (%i <= $hget(uzenet,0).item) {
    ; +3 a %0A miatt a sorok vegen
    inc %clength $calc($len($hget(uzenet,%i)) + 3)
    inc %i 1
  }
  sockwrite -n uzenet POST http://netz.nonoo.hu/uzenet.php HTTP/1.0 $+ $crlf $+ Accept: */* $+ $crlf $+ Accept-Language: hu $+ $crlf $+ Content-Type: application/x-www-form-urlencoded $+ $crlf $+ Content-Length: %clength $+ $crlf $+ Pragma: no-cache $+ $crlf $+ $crlf
  sockwrite uzenet %uzenetget
  ; soronkent visszaolvassuk az uzenetet a hash tablabol, kapasbol kuldjuk is
  var %i = 1
  while (%i <= $hget(uzenet,0).item) {
    sockwrite uzenet $hget(uzenet,%i) $+ $chr(37) $+ 0A
    inc %i 1
  }
  sockwrite -n uzenet
  unset %uzenetget
}
on 1:sockread:uzenet: {
  var %temp
  :ujraolvas
  sockread %temp
  if (!$sockbr) { return }
  if (HTTP/1. isin %temp) && ($gettok(%temp,3,32) != OK) && (!%figyeles) { /echo $color(info2) -atng *** /uzenet hiba: nem lehet elk�ldeni az �zenetet! ( $+ %temp $+ ) | sockclose uzenet }
  if (!%temp) && (!%figyeles) { %figyeles = 1 }
  if (%temp != ok) && (%figyeles) {
    if (%temp == servhiba) { /echo $color(info2) -atng *** /uzenet hiba: szerver hiba, pr�b�ld k�s�bb! }
    elseif (%temp == hiba) { /echo $color(info2) -atng *** /uzenet hiba: ne haszn�lj speci�lis karaktereket az �zenetedben! }
    else { /echo $color(info2) -atng *** /uzenet hiba: nem lehet elk�ldeni az �zenetet! ( $+ %temp $+ ) }
    sockclose uzenet | unset %figyeles
  }
  else { echo $color(info) -atng *** �zenet elk�ldve. K�szi! :) | unset %figyeles | sockclose uzenet }
  goto ujraolvas
}
;END
