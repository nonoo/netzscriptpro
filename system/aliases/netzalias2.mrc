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

;GETLOG
/getlog {
  if (!$1) { /echo $color(info2) -atng *** /getlog hiba: t�l kev�s param�ter. haszn�lat: /getlog [nick] | halt }
  var %wnd @getlog
  ; illegalis jelek kicserelese a filenevben
  var %logfn = $replace($1,$chr(124),_,\,_,/,_)
  %logfn = " $+ $logdir $+ $network $+ \ $+ %logfn $+ .log $+ "
  if ($exists(%logfn)) {
    /window -nh %wnd
    ; beolvassuk a log utolso x sorat egy tmp ablakba
    loadbuf %getlog_numlines -m %wnd %logfn
    ; a tmp ablakbol atmasolunk x-2 sort (session open sorok nem kellenek nekunk)
    var %i 1
    while (%i < $calc(%getlog_numlines - 2)) {
      if ($len($line(%wnd,%i)) > 1) && (Session Ident: $1 !isin $line(%wnd,%i)) {
        echo $color(normal) -ng $1 $line(%wnd,%i)
      }
      ; ures sor session closenal
      if (Session Close: isin $line(%wnd,%i)) {
        echo $color(background) -ng $1 -
      }
      inc %i
    }
    /window -c %wnd
  }
}
;END

;ISON2
/ison2 {
  ; ha valamejik csatin amejiken mi is benntvagyunk, bennt van a user akit keresunk, akkor trueval ter vissza
  if ($chan(0)) {
    var %i $chan(0)
    while (%i > 0) {
      if ($1 ison $chan(%i)) { return $true }
      dec %i 1
    }
  }
  return $false
}
;END

;FORGALOM
/forgalom {
  .disable #simastatslinkinfo
  .enable #forgalomstatslinkinfo
  /stats l
}
/szerverforgalom { /stats l }
;END

;LAG
/lagauto {
  if ($1 == on) { .timerLag $+ $cid 0 %lagdetect_auto_interval /detectlag | echo $color(info) -atngq *** Auto lag detektor bekapcsolva $laz($server) $server szerveren. (intervallum: %lagdetect_auto_interval sec.) | return }
  if ($1 == off) { .timerLag $+ $cid off | echo $color(info) -atngq *** Auto lag detektor kikapcsolva $laz($server) $server szerveren. | return }
  if ($timer(Lag $+ $cid).type) { echo $color(info) -atngq *** Auto lag detektor st�tusz: akt�v }
  else { echo $color(info) -atngq *** Auto lag detektor st�tusz: inakt�v }
}
/detectlag { if ($server != $null) { .raw notice $me : $+ $chr(254) $+ lag- $+ $ticks } }
/lag { %lagwindow = $active | /detectlag }
;END

;SPACE (space workaround)
/space {
  var %num = $1
  if (!$1) { %num = 1 }
  var %out 
  while (%num > 0) {
    %out = %out $+ $chr(32) $+ 
    dec %num 1
  }
  return %out
}
;END

;N�VEL�/TOLDAL�K
/az {
  var %szo $1
  var %elsobetu
  var %i $len($1)
  :loop ; vegigmegyunk a szo betuin egesz addig amig nem talalunk egy ertelmes betut
  %elsobetu = $left($right(%szo,%i),1)
  dec %i 1
  ; ha csak irasjelekbol allt a szo, nem tudjuk eldonteni a nevelot
  if (%elsobetu == $null) { return A(z) }
  if ($asc(%elsobetu) < 65) || ($asc(%elsobetu) > 122) { goto loop }
  if ($asc(%elsobetu) > 90) && ($asc(%elsobetu) < 97) { goto loop }
  if (%elsobetu == a) || (%elsobetu == e) || (%elsobetu == u) || (%elsobetu == o) || (%elsobetu == i) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) {
    return Az
  }
  return A
}
/laz { ; lowercase /az
  var %szo $1
  var %elsobetu
  var %i $len($1)
  :loop ; vegigmegyunk a szo betuin egesz addig amig nem talalunk egy ertelmes betut
  %elsobetu = $left($right(%szo,%i),1) 
  dec %i 1
  ; ha csak irasjelekbol allt a szo, nem tudjuk eldonteni a nevelot
  if (%elsobetu == $null) { return a(z) }
  if ($asc(%elsobetu) < 65) || ($asc(%elsobetu) > 122) { goto loop }
  if ($asc(%elsobetu) > 90) && ($asc(%elsobetu) < 97) { goto loop }
  if (%elsobetu == a) || (%elsobetu == e) || (%elsobetu == u) || (%elsobetu == o) || (%elsobetu == i) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) || (%elsobetu == �) {
    return az
  }
  return a
}
/toldalek {
  var %mely 0
  var %magas 0
  if (a isin $1) || (u isin $1) || (o isin $1) || (� isin $1) || (� isin $1) || (� isin $1) { %mely = 1 }
  if (e isin $1) || (i isin $1) || (� isin $1) || (� isin $1) || (� isin $1) || (� isin $1) || (� isin $1) || (� isin $1) { %magas = 1 }
  if (%mely) && (%magas) { return $2 }
  if (%mely) { return $2 }
  return $3
}
;END

;BOTOP
/opme { /botop $1- }
/botop {
  if (!$1) { /echo $color(info2) -atng *** /botop: hiba: kev�s param�ter! haszn�lat: /botop [nick] | /halt }
  if ($1 = -c) { /write -c system\botpasses.ini | /echo $color(info) -atng *** /botop: jelsz�lista t�r�lve! | /return }
  var %passz $readini(system\botpasses.ini,$1,Pass)
  if (!%passz) {
    %passz = $$?*"Mi a jelszavad $laz($1) $1 botban?"
    if (!%passz) { /halt }
    %passz = $enkod(%passz)
    /writeini system\botpasses.ini $1 Pass %passz
  }
  .raw PRIVMSG $1 :OP $dekod(%passz)
  /echo $color(info) -atng *** Op k�r�s elk�ldve $1 $+ $toldalek($1,-nak,-nek) $+ .
}
; visszaadja a megadott bothoz tartozo jelszot, ha nincs meg jelszo akkor bekeri
/botop_get {
  if (!$1) { /echo $color(info2) -atng *** /botop_get: hiba: kev�s param�ter! haszn�lat: /botop_get [nick] | /halt }
  var %passz $readini(system\botpasses.ini,$1,Pass)
  if (!%passz) {
    return $$?*"Mi a jelszavad $laz($1) $1 botban?"
  }
  return $dekod(%passz)
}
;END

;TITLE
/title {
  var %tiit = netZ Script Pro %ver
  if ($away) { %tiit = %tiit %titlebar_bal $+ Away $+ %titlebar_jobb }
  if (%checkmail) && (%checkmail_lastnum > 0) {
    %tiit = %tiit %titlebar_bal $+ Email: %checkmail_lastnum $+ %titlebar_jobb
  }
  if ($timer(lag $+ $cid).type) {
    var %lag = $hget(data,$cid $+ lag)
    if (%lag) {
      if (%lagdetect_titlebarban_csik) {
        ; lagcsik
        var %lagcsik
        var %lagcsikpos = $round($calc((%lag / 5)*10),0)
        var %i = 0
        while (%i < 10) {
          if (%i < %lagcsikpos) { %lagcsik = %lagcsik $+ $chr(124) }
          else { %lagcsik = %lagcsik $+ _ }
          inc %i 1
        }
        %tiit = %tiit %titlebar_bal $+ Lag: %lagcsik $+ %titlebar_jobb
      }
      else { %tiit = %tiit %titlebar_bal $+ Lag: %lag sec. $+ %titlebar_jobb }
    }
  }
  if (%itime_kijelzes_titlebarban) { %tiit = %tiit %titlebar_bal $+ iTime: @ $+ $itime(q) $+ %titlebar_jobb }
  if (%winamp_kijelzes_titlebarban) {
    ; regi vindoz alatt nem megy
    if ($os != 95) && ($os != 98) && ($os != me) {
      var %wp $dll(system/netz.dll, winamp, GetCurrentWinampSong)
      if (%wp) && ($dll(system\netz.dll, winamp, isplaying)) {
        %tiit = %tiit %titlebar_bal $+ Winamp: %wp $+ %titlebar_jobb
      }
    }
  }
  if ( %tiit != $titlebar ) || ( $null isin $titlebar ) { /titlebar %tiit | /dll system\netz.dll title %tiit }

  ; skype
  if ( (%skype_hasznalat) && ($calc($ctime - %skype_lastchange) > %skype_delay) ) {
    %skype_moodtext = $null
    if ( $away && %skype_away_kijelzes ) {
      %skype_moodtext = %skype_away_szoveg
      if (%skype_awaymsg_kiiras) {
        %skype_moodtext = %skype_moodtext $awaymsg
      }
    }
    if (%skype_msg1 != $null) {
      if (%skype_moodtext != $null ) {
        %skype_moodtext = %skype_moodtext %skype_separator
      }
      %skype_moodtext = %skype_moodtext %skype_msg1
    }
    if (%skype_winamp_kijelzes) {
      var %wp $getwpforskype
      if (%wp != $null) {
        if (%skype_moodtext != $null ) {
          %skype_moodtext = %skype_moodtext %skype_separator
        }

        %skype_moodtext = %skype_moodtext %wp
      }
    }
    if (%skype_msg2 != $null) {
      if (%skype_moodtext != $null ) {
        %skype_moodtext = %skype_moodtext %skype_separator
      }
      %skype_moodtext = %skype_moodtext %skype_msg2
    }

    if (%skype_moodtext != %skype_oldmoodtext ) {
      /dll system/netz.dll skypesendmsg set profile mood_text %skype_moodtext

      if (%skype_away_follow) {
        if ($away) {
          /dll system/netz.dll skypesendmsg set userstatus %skype_away_mod
        }
        else {
          /dll system/netz.dll skypesendmsg set userstatus online
        }
      }
      %skype_lastchange = $ctime
    }
    %skype_oldmoodtext = %skype_moodtext
  }
  ; bitlbee
  if ( (%bitlbee_hasznalat) && ($calc($ctime - %bitlbee_lastchange) > %bitlbee_delay) ) {
    %bitlbee_moodtext = $null
    if ( $away && %bitlbee_away_kijelzes ) {
      %bitlbee_moodtext = %bitlbee_away_szoveg
      if (%bitlbee_awaymsg_kiiras) {
        %bitlbee_moodtext = %bitlbee_moodtext $awaymsg
      }
    }
    if (%bitlbee_msg1 != $null) {
      if (%bitlbee_moodtext != $null ) {
        %bitlbee_moodtext = %bitlbee_moodtext %bitlbee_separator
      }
      %bitlbee_moodtext = %bitlbee_moodtext %bitlbee_msg1
    }
    if (%bitlbee_winamp_kijelzes) {
      var %wp $getwpforskype
      if (%wp != $null) {
        if (%bitlbee_moodtext != $null ) {
          %bitlbee_moodtext = %bitlbee_moodtext %bitlbee_separator
        }

        %bitlbee_moodtext = %bitlbee_moodtext %wp
      }
    }
    if (bitlbee_msg2 != $null) {
      if (%bitlbee_moodtext != $null ) {
        %bitlbee_moodtext = %bitlbee_moodtext %bitlbee_separator
      }
      %bitlbee_moodtext = %bitlbee_moodtext %bitlbee_msg2
    }

    if (%bitlbee_moodtext != %bitlbee_oldmoodtext ) {
      /scon -at1 if ($chan(&bitlbee)) { .raw privmsg &bitlbee :psm 0 " $+ %bitlbee_moodtext $+ " }
      %bitlbee_lastchange = $ctime
    }
    %bitlbee_oldmoodtext = %bitlbee_moodtext
  }

  ; autoaway
  if (%autoaway_hasznalat) {
    ; regi vindoz alatt nem megy
    if ($os == 95) || ($os == 98) || ($os == me) { return }

    if ($round($calc($dll(system\netz.dll,idle,0) / 1000),0) > $calc(%autoaway_ido * 60)) && (!$away) {
      /autoaway
    }
  }
}
;END

;BAN KEZEL�S
/unban {
  if (!$1) { /echo $color(info2) -atng *** /unban: hiba: kev�s param�ter! haszn�lat: /unban (csati) [hostmask] | /halt }
  if ($1 ischan) {
    if (!$2) { /echo $color(info2) -atng *** /unban: hiba: kev�s param�ter! haszn�lat: /unban (csati) [hostmask] | /halt }
    /mode $1 -b $2 | halt
  }
  if ($active !ischan) { echo $color(info2) -atng *** /unban hiba: a parancsot csati ablakban haszn�ld, vagy add meg melyik csatira vonatkozzon! | halt }
  /mode $active -b $1
}
/banlist {
  if (!$1) && ($active !ischan) { echo $color(info2) -atng *** /banlist hiba: a parancsot csati ablakban haszn�ld, vagy add meg melyik csatira vonatkozzon! | halt }
  if (!$1) {
    if ($1 == Status Window) { echo $color(info2) -atng *** /banlist hiba: a parancsot csati ablakban haszn�ld, vagy add meg melyik csatira vonatkozzon! | halt }
    /mode $active +b
  }
  else { /mode $1 +b }
}
/reoplist {
  if (!$1) && ($active !ischan) { echo $color(info2) -atng *** /reoplist hiba: a parancsot csati ablakban haszn�ld, vagy add meg melyik csatira vonatkozzon! | halt }
  if (!$1) {
    if ($1 == Status Window) { echo $color(info2) -atng *** /reoplist hiba: a parancsot csati ablakban haszn�ld, vagy add meg melyik csatira vonatkozzon! | halt }
    /mode $active +R
  }
  else { /mode $1 +R }
}
;END

;ORIGNICK
/orignick {
  if ($1 == off) { /echo $color(info) -atngq *** OrigNick kikapcsolva. | .timerOrigNick $+ $cid off | return }
  if (!$1) {
    if ($timer(OrigNick $+ $cid).type) { /echo $color(info) -atngq *** OrigNick akt�v $laz(%orig_nick) %orig_nick nickre. Kikapcsol�s: /orignick off }
    else { /echo $color(info) -atngq *** OrigNick nem akt�v. }
    return
  }
  ; ha a kivant nick megegyezik a jelenlegivel
  if ($1 === $me) && ($status == connected) {
    if ($timer(OrigNick $+ $cid)) { /echo $color(info) -atngq *** OrigNick kikapcsolva. | .timerOrigNick $+ $cid off | return }
    /echo $color(info2) -atngq *** /orignick: hiba: a nicked jelenleg is $me $+ ! | return
  }
  /echo $color(info) -atngq *** OrigNick bekapcsolva ( $+ $1 $+ )
  %orig_nick = $1
  .timer 1 0 .nick %orig_nick
  .timerOrigNick $+ $cid 0 15 .nick %orig_nick
}
;END

;AECHO
/aecho {
  if (!$3) { /echo $color(info2) -atng *** /aecho: hiba: kev�s param�ter! haszn�lat: /aecho [sz�n] [param�terek] [sz�veg] | /halt }
  var %nostatus
  if (--nostatus isin $3-) { %nostatus = 1 }

  if ($chan(0)) {
    var %i $chan(0)
    while (%i > 0) {
      /echo $1 $2 $chan(%i) $remove($3-,--nostatus)
      dec %i 1
    }
  }
  ; statusz ablakba is ha kell
  if (!%nostatus) { /echo $1 $2 $+ s $remove($3-,--nostatus) }
}
;END

;LIST�Z�SOK
/hosts {
  if (!$1) && ($active !ischan) { echo $color(info2) -atng *** /hosts hiba: a parancsot csati ablakban haszn�ld, vagy add meg melyik csatira vonatkozzon! | halt }
  var %csati
  if (!$1) { %csati = $active }
  else { %csati = $1- }
  .disable #simawho | .enable #hostscan
  /echo $color(background) -g %csati - | /echo $color(whois) -g %csati *** hostok list�z�sa $laz(%csati) %csati csatin...
  .who %csati
}
/servers {
  if (!$1) && ($active !ischan) { echo $color(info2) -atng *** /servers hiba: a parancsot csati ablakban haszn�ld, vagy add meg melyik csatira vonatkozzon! | halt }
  var %csati
  if (!$1) { %csati = $active }
  else { %csati = $1- }
  .disable #simawho | .enable #serverscan
  /echo $color(background) -g %csati - | /echo $color(whois) -g %csati *** irc szerverek list�z�sa $laz(%csati) %csati csatin...
  .who %csati
}
/idents {
  if (!$1) && ($active !ischan) { echo $color(info2) -atng *** /idents hiba: a parancsot csati ablakban haszn�ld, vagy add meg melyik csatira vonatkozzon! | halt }
  var %csati
  if (!$1) { %csati = $active }
  else { %csati = $1- }
  .disable #simawho | .enable #identscan
  /echo $color(background) -g %csati - | /echo $color(whois) -g %csati *** identek list�z�sa $laz(%csati) %csati csatin...
  .who %csati
}
/realnames {
  if (!$1) && ($active !ischan) { echo $color(info2) -atng *** /realnames hiba: a parancsot csati ablakban haszn�ld, vagy add meg melyik csatira vonatkozzon! | halt }
  var %csati
  if (!$1) { %csati = $active }
  else { %csati = $1- }
  .disable #simawho | .enable #realscan
  /echo $color(background) -g %csati - | /echo $color(whois) -g %csati *** real namek list�z�sa $laz(%csati) %csati csatin...
  .who %csati
}
;END

;PSYBNC
/psybnc {
  if ( $1 = erase ) { .quote eraseprivatelog | /echo $color(info) -atng *** psyBNC log t�r�lve. | /halt }
  if ( $1 = -youhave ) { if (!$?!="�zeneted van a psyBNC-ben! Elolvasod?") { /halt } }
  .raw playprivatelog
}
;END

;NEVNAP
/nevnap {
  if ($1) && (!$2) && ($1 != -s) { /echo $color(info2) -atng *** /nevnap hiba: t�l kev�s param�ter! haszn�lat: /nevnap (h�nap) (nap) | halt }
  if ($2) {
    %nevnap = $readini system\nevnapok.ini $1 $2
    var %honap $1
    var %nap $2
    tokenize 32 %nevnap
    unset %nevnap
    if ($0 > 1) { /echo $color(info) -atngq *** N�vnapok ( $+ %honap %nap $+ ): $1- }
    else { /echo $color(info) -atngq *** N�vnap ( $+ %honap %nap $+ ): $1- }
  }
  else {
    %nevnap = $readini system\nevnapok.ini $asctime(m) $asctime(d) 
    var %param $1
    tokenize 32 %nevnap
    unset %nevnap
    if (%param == -s) {
      if ($0 > 1) { /echo $color(info) -snq Mai n�vnap(ok): $1- }
      else { /echo $color(info) -snq Mai n�vnap: $1- }
    }
    else {
      if ($0 > 1) { /echo $color(info) -atngq *** A mai n�vnap(ok): $1- }
      else { /echo $color(info) -atngq *** A mai n�vnap: $1- }
    }
  }
}
;END

;NETZBEEP
/netzbeep {
  if (%udpbeep) {
    ; az asztali gepemen a 64 bites vindoz alatt nem megy a pc speaker, ezert
    ; a linux routeremre irtam egy kis programot, ami bejovo udp csomagokat figyel
    ; es a beerkezo csomagnak megfeleloen beepel a pc speakeren
    ; ha kell a forraskod irj emailt
    /sockudp udpbeep 192.168.1.1 62300 $1
    return
  }
  if ($1 == $null ) { /echo $color(info2) -atng *** /netzbeep hiba: t�l kev�s param�ter! haszn�lat: /netzbeep (pager/query/mail/highlight) vagy [freki] [hossz] [h�nyszor] [sz�net] | halt }
  if ($1 == pager) { .timer 1 0 /dll system\netz.dll beep 1000 100 5 50 | return }
  if ($1 == query) { .timer 1 0 /dll system\netz.dll beep 3000 10 2 80 | return }
  if ($1 == highlight) { .timer 1 0 /dll system\netz.dll beep 3000 10 2 80 | return }
  if ($1 == mail) { .timer 1 0 /dll system\netz.dll beep 1000 10 1 10 | return }
  if ($1 == ebreszto) {
    .timer 1 0 /dll system\netz.dll beep 1000 100 3 30
    .timer -m 1 700 /dll system\netz.dll beep 1000 100 3 30
    .timer -m 1 1400 /dll system\netz.dll beep 1000 100 3 30
    return
  }
  if ($4 == $null ) { /echo $color(info2) -atng *** /netzbeep hiba: t�l kev�s param�ter! haszn�lat: /netzbeep (pager/query/mail/highlight) vagy [freki] [hossz] [h�nyszor] [sz�net] | halt }
  .timer 1 0 /dll system\netz.dll beep $1 $2 $3 $4
}
;END

;GETEXTENSION
/getextension {
  if ( $1 == $null ) { /echo $color(info2) -atng *** /getextension hiba: t�l kev�s param�ter! haszn�lat: /getextension [f�jln�v] | halt }
  var %i = $calc( $len( $1 ) - 1 )
  while ( ( $mid( $1, %i, 1 ) != . ) && ( %i > 0 ) ) {
    dec %i
  }
  if ( %i == 0 ) {
    return $null
  }
  else {
    return $mid( $1, %i, $len( $1 ) - %i )
  }
}
;END

;�KEZETLESZED
/ekezetleszed {
  return $replace($1-,�,i,�,I,�,o,�,O,�,u,�,U,�,o,�,O,�,o,�,O,�,u,�,U,�,a,�,A,�,u,�,U,�,e,�,E)
}
;END

;TRIM
/trim {
  var %s = 1
  var %e = $len($1-)
  var %out
  while (%s < $len($1-) && $mid($1-,%s,1) == $chr(32)) {
    inc %s 1
  }
  while (%e > 0 && $mid($1-,%e,1) == $chr(32)) {
    dec %e 1
  }
  return $mid($1-,%s,$calc(%e - %s + 1))
}
;END

;EJFEL
/ejfel {
  ; minden kapcsolatra
  var %j $scon(0)
  while (%j > 0) {
    scon %j
    /aecho $color(highlight) -tnq *** �j nap: $fulldate
    scon -r
    dec %j 1
  }
  /nevnap
  if ( %ejfel_lastreport != $date ) {
    .timerEjfel -oi 00:01 1 0 /ejfel --init
    %ejfel_lastreport = $date
  }
  if ( $1 == --init ) {
    .timerEjfel -oi 00:00 1 0 /ejfel
  }
}
;END
