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
  if (!$1) { /echo $color(info2) -atng *** /getlog hiba: túl kevés paraméter. használat: /getlog [nick] | halt }
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
  if ($timer(Lag $+ $cid).type) { echo $color(info) -atngq *** Auto lag detektor státusz: aktív }
  else { echo $color(info) -atngq *** Auto lag detektor státusz: inaktív }
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

;NÉVELÕ/TOLDALÉK
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
  if (%elsobetu == a) || (%elsobetu == e) || (%elsobetu == u) || (%elsobetu == o) || (%elsobetu == i) || (%elsobetu == á) || (%elsobetu == é) || (%elsobetu == ú) || (%elsobetu == ó) || (%elsobetu == í) || (%elsobetu == õ) || (%elsobetu == û) || (%elsobetu == ö) || (%elsobetu == ü) {
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
  if (%elsobetu == a) || (%elsobetu == e) || (%elsobetu == u) || (%elsobetu == o) || (%elsobetu == i) || (%elsobetu == á) || (%elsobetu == é) || (%elsobetu == ú) || (%elsobetu == ó) || (%elsobetu == í) || (%elsobetu == õ) || (%elsobetu == û) || (%elsobetu == ö) || (%elsobetu == ü) {
    return az
  }
  return a
}
/toldalek {
  var %mely 0
  var %magas 0
  if (a isin $1) || (u isin $1) || (o isin $1) || (á isin $1) || (ú isin $1) || (ó isin $1) { %mely = 1 }
  if (e isin $1) || (i isin $1) || (ü isin $1) || (ö isin $1) || (é isin $1) || (í isin $1) || (û isin $1) || (õ isin $1) { %magas = 1 }
  if (%mely) && (%magas) { return $2 }
  if (%mely) { return $2 }
  return $3
}
;END

;BOTOP
/opme { /botop $1- }
/botop {
  if (!$1) { /echo $color(info2) -atng *** /botop: hiba: kevés paraméter! használat: /botop [nick] | /halt }
  if ($1 = -c) { /write -c system\botpasses.ini | /echo $color(info) -atng *** /botop: jelszólista törölve! | /return }
  var %passz $readini(system\botpasses.ini,$1,Pass)
  if (!%passz) {
    %passz = $$?*"Mi a jelszavad $laz($1) $1 botban?"
    if (!%passz) { /halt }
    %passz = $enkod(%passz)
    /writeini system\botpasses.ini $1 Pass %passz
  }
  .raw PRIVMSG $1 :OP $dekod(%passz)
  /echo $color(info) -atng *** Op kérés elküldve $1 $+ $toldalek($1,-nak,-nek) $+ .
}
; visszaadja a megadott bothoz tartozo jelszot, ha nincs meg jelszo akkor bekeri
/botop_get {
  if (!$1) { /echo $color(info2) -atng *** /botop_get: hiba: kevés paraméter! használat: /botop_get [nick] | /halt }
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

;BAN KEZELÉS
/unban {
  if (!$1) { /echo $color(info2) -atng *** /unban: hiba: kevés paraméter! használat: /unban (csati) [hostmask] | /halt }
  if ($1 ischan) {
    if (!$2) { /echo $color(info2) -atng *** /unban: hiba: kevés paraméter! használat: /unban (csati) [hostmask] | /halt }
    /mode $1 -b $2 | halt
  }
  if ($active !ischan) { echo $color(info2) -atng *** /unban hiba: a parancsot csati ablakban használd, vagy add meg melyik csatira vonatkozzon! | halt }
  /mode $active -b $1
}
/banlist {
  if (!$1) && ($active !ischan) { echo $color(info2) -atng *** /banlist hiba: a parancsot csati ablakban használd, vagy add meg melyik csatira vonatkozzon! | halt }
  if (!$1) {
    if ($1 == Status Window) { echo $color(info2) -atng *** /banlist hiba: a parancsot csati ablakban használd, vagy add meg melyik csatira vonatkozzon! | halt }
    /mode $active +b
  }
  else { /mode $1 +b }
}
/reoplist {
  if (!$1) && ($active !ischan) { echo $color(info2) -atng *** /reoplist hiba: a parancsot csati ablakban használd, vagy add meg melyik csatira vonatkozzon! | halt }
  if (!$1) {
    if ($1 == Status Window) { echo $color(info2) -atng *** /reoplist hiba: a parancsot csati ablakban használd, vagy add meg melyik csatira vonatkozzon! | halt }
    /mode $active +R
  }
  else { /mode $1 +R }
}
;END

;ORIGNICK
/orignick {
  if ($1 == off) { /echo $color(info) -atng *** OrigNick kikapcsolva. | .timerOrigNick $+ $cid off | /halt }
  if (!$1) {
    if ($timer(OrigNick $+ $cid).type) { /echo $color(info) -atngq *** OrigNick aktív $laz(%orig_nick) %orig_nick nickre. Kikapcsolás: /orignick off }
    else { /echo $color(info) -atngq *** OrigNick nem aktív. }
    return
  }
  ; ha a kivant nick megegyezik a jelenlegivel
  if ($1 == $me) { /echo $color(info2) -atng *** /orignick: hiba: a nicked jelenleg is $me $+ ! | halt }
  /echo $color(info) -atng *** OrigNick bekapcsolva ( $+ $1 $+ )
  %orig_nick = $1
  .nick %orig_nick
  .timerOrigNick $+ $cid 0 15 .nick %orig_nick
}
;END

;AECHO
/aecho {
  if (!$3) { /echo $color(info2) -atng *** /aecho: hiba: kevés paraméter! használat: /aecho [szín] [paraméterek] [szöveg] | /halt }
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

;LISTÁZÁSOK
/hosts {
  if (!$1) && ($active !ischan) { echo $color(info2) -atng *** /hosts hiba: a parancsot csati ablakban használd, vagy add meg melyik csatira vonatkozzon! | halt }
  var %csati
  if (!$1) { %csati = $active }
  else { %csati = $1- }
  .disable #simawho | .enable #hostscan
  /echo $color(background) -g %csati - | /echo $color(whois) -g %csati *** hostok listázása $laz(%csati) %csati csatin...
  .who %csati
}
/servers {
  if (!$1) && ($active !ischan) { echo $color(info2) -atng *** /servers hiba: a parancsot csati ablakban használd, vagy add meg melyik csatira vonatkozzon! | halt }
  var %csati
  if (!$1) { %csati = $active }
  else { %csati = $1- }
  .disable #simawho | .enable #serverscan
  /echo $color(background) -g %csati - | /echo $color(whois) -g %csati *** irc szerverek listázása $laz(%csati) %csati csatin...
  .who %csati
}
/idents {
  if (!$1) && ($active !ischan) { echo $color(info2) -atng *** /idents hiba: a parancsot csati ablakban használd, vagy add meg melyik csatira vonatkozzon! | halt }
  var %csati
  if (!$1) { %csati = $active }
  else { %csati = $1- }
  .disable #simawho | .enable #identscan
  /echo $color(background) -g %csati - | /echo $color(whois) -g %csati *** identek listázása $laz(%csati) %csati csatin...
  .who %csati
}
/realnames {
  if (!$1) && ($active !ischan) { echo $color(info2) -atng *** /realnames hiba: a parancsot csati ablakban használd, vagy add meg melyik csatira vonatkozzon! | halt }
  var %csati
  if (!$1) { %csati = $active }
  else { %csati = $1- }
  .disable #simawho | .enable #realscan
  /echo $color(background) -g %csati - | /echo $color(whois) -g %csati *** real namek listázása $laz(%csati) %csati csatin...
  .who %csati
}
;END

;PSYBNC
/psybnc {
  if ( $1 = erase ) { .quote eraseprivatelog | /echo $color(info) -atng *** psyBNC log törölve. | /halt }
  if ( $1 = -youhave ) { if (!$?!="Üzeneted van a psyBNC-ben! Elolvasod?") { /halt } }
  .raw playprivatelog
}
;END

;NEVNAP
/nevnap {
  if ($1) && (!$2) && ($1 != -s) { /echo $color(info2) -atng *** /nevnap hiba: túl kevés paraméter! használat: /nevnap (hónap) (nap) | halt }
  if ($2) {
    %nevnap = $readini system\nevnapok.ini $1 $2
    var %honap $1
    var %nap $2
    tokenize 32 %nevnap
    unset %nevnap
    if ($0 > 1) { /echo $color(info) -atng *** Névnapok ( $+ %honap %nap $+ ): $1- }
    else { /echo $color(info) -atng *** Névnap ( $+ %honap %nap $+ ): $1- }
  }
  else {
    %nevnap = $readini system\nevnapok.ini $asctime(m) $asctime(d) 
    var %param $1
    tokenize 32 %nevnap
    unset %nevnap
    if (%param == -s) {
      if ($0 > 1) { /echo $color(info) -sn Mai névnap(ok): $1- }
      else { /echo $color(info) -sn Mai névnap: $1- }
    }
    else {
      if ($0 > 1) { /echo $color(info) -atng *** A mai névnap(ok): $1- }
      else { /echo $color(info) -atng *** A mai névnap: $1- }
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
  if ($1 == $null ) { /echo $color(info2) -atng *** /netzbeep hiba: túl kevés paraméter! használat: /netzbeep (pager/query/mail/highlight) vagy [freki] [hossz] [hányszor] [szünet] | halt }
  if ($1 == pager) { .timer 1 0 /dll system\netz.dll beep 1000 100 5 50 | return }
  if ($1 == query) { .timer 1 0 /dll system\netz.dll beep 3000 10 2 80 | return }
  if ($1 == highlight) { .timer 1 0 /dll system\netz.dll beep 3000 10 2 80 | return }
  if ($1 == mail) { .timer 1 0 /dll system\netz.dll beep 1000 10 1 10 | return }
  if ($4 == $null ) { /echo $color(info2) -atng *** /netzbeep hiba: túl kevés paraméter! használat: /netzbeep (pager/query/mail/highlight) vagy [freki] [hossz] [hányszor] [szünet] | halt }
  .timer 1 0 /dll system\netz.dll beep $1 $2 $3 $4
}
;END

;GETEXTENSION
/getextension {
  if ( $1 == $null ) { /echo $color(info2) -atng *** /getextension hiba: túl kevés paraméter! használat: /getextension [fájlnév] | halt }
  var %i = $calc( $len( $1 ) - 1 )
  while ( ( $mid( $1, %i, 1 ) != . ) && ( %i > 0 ) ) {
    dec %i
  }
  if ( %i == 0 ) {
    return $null
    } else {
    return $mid( $1, %i, $len( $1 ) - %i )
  }
}
;END

;ÉKEZETLESZED
/ekezetleszed {
  return $replace($1-,í,i,Í,I,ö,o,Ö,O,ü,u,Ü,U,ó,o,Ó,O,õ,o,Õ,O,ú,u,Ú,U,á,a,Á,A,û,u,Û,U,é,e,É,E)
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

;JOBOK
/job {
  if ($2 == $null) { /echo $color(info2) -atng *** /job hiba: túl kevés paraméter! használat: /job (dátum (pl. 2007/11/06)) [idõ (pl. 0:25)] [parancs] | halt }

  if ($2 == off) || ($2 == stop) {
    if ($hget(jobs,$1) != $null) {
      hdel jobs $1
      hsave jobs system\jobs.dat
      echo $color(info) -atng *** Job $+ $1 törölve.
      return
    }
    else {
      echo $color(info2) -atng *** Job $+ $1 nem létezik.
      return
    }
  }

  var %datum
  var %ido
  var %parancs
  if ( / isin $1 ) {
    %datum = $1
    if (: !isin $2) { /echo $color(info2) -atng *** /job hiba: túl kevés paraméter! használat: /job (dátum (pl. 2007/11/06)) [idõ (pl. 0:25)] [parancs] | halt }
    %ido = $2
    if ($3 == $null) { /echo $color(info2) -atng *** /job hiba: túl kevés paraméter! használat: /job (dátum (pl. 2007/11/06)) [idõ (pl. 0:25)] [parancs] | halt }
    %parancs = $3-
  }
  else {
    if (: !isin $1) { /echo $color(info2) -atng *** /job hiba: túl kevés paraméter! használat: /job (dátum (pl. 2007/11/06)) [idõ (pl. 0:25)] [parancs] | halt }
    %datum = $asctime(yyyy/mm/dd)
    %ido = $1
    %parancs = $2-
  }

  ; szabad job num kereses
  var %tnum 1
  while ($hget(jobs,%tnum) != $null) {
    inc %tnum 1
  }
  hadd jobs %tnum $ctime($gettok(%datum,3,47) $+ / $+ $gettok(%datum,2,47) $+ / $+ $gettok(%datum,1,47) %ido) %parancs
  hsave jobs system\jobs.dat

  if ($gettok(%parancs,1,32) == /onalarm) {
    echo $color(info) -atngq *** Alarm $+ %tnum bekapcsolva ( $+ %datum %ido $+ ): %parancs
  }
  else {
    echo $color(info) -atngq *** Job $+ %tnum bekapcsolva ( $+ %datum %ido $+ ): %parancs
  }
}

/jobs {
  if ($hget(jobs,0).item == 0) {
    echo $color(info) -atng *** Nincs aktív job.
    return
  }

  if ($1 == off) || ($1 == stop) {
    hdel -w jobs *
    hsave jobs system\jobs.dat
    echo $color(info) -atng *** Jobok törölve.
    return
  }

  var %i $hget(jobs,0).item
  echo $color(info) -atng *** Aktív jobok:
  while (%i > 0) {
    tokenize 32 $hget(jobs,%i).data
    echo $color(info) -atng * $hget(jobs,%i).item $+ . $asctime($1,yyyy/mm/dd HH:nn) - $2-
    dec %i 1
  }
}

/onalarm {
  echo $color(highlight) -atng *** ALARM: $1-
  var %a $tip(alarm, Alarm, $1-, 60, system\img\warning.ico )
  /beep 5 100
  /netzbeep pager
}

/initjobs {
  if ($hget(jobs) != $null) {
    hfree jobs
  }
  hmake jobs 1
  ; betoltjuk fajlbol az jobokat (ha letezik)
  if ($exists(system\jobs.dat)) {
    hload jobs system\jobs.dat
  }
  if (!$timer(jobs)) {
    .timerjobs -i 0 60 /jobcheck
  }
}

/jobcheck {
  var %i $hget(jobs,0).item
  while (%i > 0) {
    tokenize 32 $hget(jobs,%i).data
    if ($ctime >= $1) {
      if ($2 != /onalarm) {
        echo $color(info) -atng *** Job $+ $hget(jobs,%i).item indítása: $2-
      }
      $2-
      hdel jobs $hget(jobs,%i).item
      %i = $hget(jobs,0).item
      continue
    }
    dec %i 1
  }
  hsave jobs system\jobs.dat
}

/alarm {
  if ($2 == $null) { /echo $color(info2) -atng *** /alarm hiba: túl kevés paraméter! használat: /alarm (dátum (pl. 2007/11/06)) [idõ (pl. 0:25)] [üzenet] | halt }

  if ($2 == off) || ($2 == stop) {
    if (/onalarm isin $hget(jobs,$1)) {
      hdel jobs $1
      hsave jobs system\jobs.dat
      echo $color(info) -atng *** Alarm $+ $1 törölve.
      return
    }
    else {
      echo $color(info2) -atng *** Alarm $+ $1 nem létezik.
      return
    }
  }

  var %datum
  var %ido
  var %uzenet
  if ( / isin $1 ) {
    %datum = $1
    if (: !isin $2) { /echo $color(info2) -atng *** /alarm hiba: túl kevés paraméter! használat: /alarm (dátum (pl. 2007/11/06)) [idõ (pl. 0:25)] [üzenet] | halt }
    %ido = $2
    if ($3 == $null) { /echo $color(info2) -atng *** /alarm hiba: túl kevés paraméter! használat: /alarm (dátum (pl. 2007/11/06)) [idõ (pl. 0:25)] [üzenet] | halt }
    %uzenet = $3-
  }
  else {
    if (: !isin $1) { /echo $color(info2) -atng *** /alarm hiba: túl kevés paraméter! használat: /alarm (dátum (pl. 2007/11/06)) [idõ (pl. 0:25)] [üzenet] | halt }
    %datum = $asctime(yyyy/mm/dd)
    %ido = $1
    %uzenet = $2-
  }

  job %datum %ido /onalarm %uzenet
}

/alarms {
  var %off 0
  if ($1 == off) || ($1 == stop) {
    %off = 1
  }

  ; alarmok megszamolasa
  var %i $hget(jobs,0).item
  var %ac 0
  while (%i > 0) {
    tokenize 32 $hget(jobs,%i).data
    if ($2 == /onalarm) {
      inc %ac 1
    }
    dec %i 1
  }
  if (%ac == 0) {
    echo $color(info) -atng *** Nincs aktív alarm.
    return
  }

  if (%off) {
    var %i $hget(jobs,0).item
    while (%i > 0) {
      tokenize 32 $hget(jobs,%i).data
      if ($2 == /onalarm) {
        hdel jobs $hget(jobs,%i).item
      }
      dec %i 1
    }
    hsave jobs system\jobs.dat
    echo $color(info) -atng *** Alarmok törölve.
    return
  }

  var %i $hget(jobs,0).item
  echo $color(info) -atng *** Aktív alarmok:
  while (%i > 0) {
    tokenize 32 $hget(jobs,%i).data
    if ($2 == /onalarm) {
      echo $color(info) -atng * $hget(jobs,%i).item $+ . $asctime($1,yyyy/mm/dd HH:nn) - $remove($2-,/onalarm)
    }
    dec %i 1
  }
}
;END
