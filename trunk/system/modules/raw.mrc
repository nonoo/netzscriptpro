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

;ONAWAY
raw 305:*: {
  aecho $color(info) -tng *** Away kikapcsolva.
  unset %autoaway
  if (%awaynick_hasznalat) { .nick %away_eredeti_nick }
  if (%awayback_hasznalat) {
    if (%awaymessage_mindencsatira) { /ame %awayback_message }
    else {
      ; awaymessage a megadott csatikra
      if (%awaymessage_csatik) {
        var %i $numtok(%awaymessage_csatik,32)
        while (%i > 0) {
          ; multi szerver tamogatas miatt (csak azokba az ablakokba nyomjuk amejek a jelenlegi kapcsolatnal aktivak)
          if ($1 ison $gettok(%awaymessage_csatik,%i,32)) {
            /describe $gettok(%awaymessage_csatik,%i,32) %awayback_message
          }
          dec %i 1
        }
      }
    }
  }
  halt
}
raw 306:*: {
  aecho $color(info) -tng *** Away bekapcsolva.
  if (%awaynick_hasznalat) {
    %away_eredeti_nick = $me
    if (%awaynick_kisbetusre) {
      .nick $lower(%away_eredeti_nick)
    }
    else {
      .nick %awaynick
    }
  }
  var %awaypagermsg
  if (%away_pager) { %awaypagermsg = (pager: on) }
  if (%autoaway) {
    unset %autoaway
    if (%autoaway_message_hasznalat) {
      if (%awaymessage_mindencsatira) { /ame %autoaway_message %awaypagermsg }
      else {
        if (%awaymessage_csatik) {
          var %i $numtok(%awaymessage_csatik,32)
          while (%i > 0) {
            ; multi szerver tamogatas miatt (csak azokba az ablakokba nyomjuk amejek a jelenlegi kapcsolatnal aktivak)
            if ($1 ison $gettok(%awaymessage_csatik,%i,32)) {
              /describe $gettok(%awaymessage_csatik,%i,32) %autoaway_message %awaypagermsg
            }
            dec %i 1
          }
        }
      }
    }
  }
  else {
    var %awaymsg
    if ($awaymsg != gone) { %awaymsg = ( $+ $awaymsg $+ ) }
    if (%awaymessage_hasznalat) {
      if (%awaymessage_mindencsatira) { /ame %awaymessage %awaymsg %awaypagermsg }
      else {
        if (%awaymessage_csatik) {
          var %i $numtok(%awaymessage_csatik,32)
          while (%i > 0) {
            ; multi szerver tamogatas miatt (csak azokba az ablakokba nyomjuk amejek a jelenlegi kapcsolatnal aktivak)
            if ($1 ison $gettok(%awaymessage_csatik,%i,32)) {
              /describe $gettok(%awaymessage_csatik,%i,32) %awaymessage %awaymsg %awaypagermsg
            }
            dec %i 1
          }
        }
      }
    }
  }
  halt
}
;END

;WHOIS/WHOWAS
raw 301:*: {
  var %reason $hget(data,$cid $+ awayreason $+ $2)
  if ($3- != Gone, for more info use WHOIS $2 $2) { %reason = $3- | .hadd data $cid $+ awayreason $+ $2 $3- }
  if (%whois_ablak) {
    if (%reason) {
      /echo %whois_ablak  $+ $color(gray) $+ away: $+ $color(highlight) %reason | /halt
    }
    else {
      /echo %whois_ablak  $+ $color(gray) $+ away: $+ $color(highlight) on
      /halt
    }
  }
  else {
    if ($2 != $me) {
      ; csak 5 percenkent toljuk be a nincs a szamitogepenel szoveget
      if (!$hget(data,$cid $+ $nick $+ awaymsgtimeout)) {
        .hadd -u $+ 300 data $cid $+ $nick $+ awaymsgtimeout 1
        ; ha van eltarolt awayreasonunk, kiirjuk
        if (%reason) {
          /echo $color(whois) -tg $2 *** $2 most nincs a számítógépénél! ( $+ %reason $+ )
        }
        else { /echo $color(whois) -tg $2 *** $2 most nincs a számítógépénél! }
      }
    }
    /halt
  }
}
raw 311:* {
  %whois_ablak = -g $active
  if ( $active = Status Window ) { %whois_ablak = -sg }
  var %orszag $read -s $+ $right($4,2) system\domains.txt
  if (%orszag != $null) { %orszag = ( $+ %orszag $+ ) }
  echo $color(background) %whois_ablak -
  echo $color(other) %whois_ablak  $+ whois $2
  echo %whois_ablak  $+ $color(gray) $+ host: $3 $+ @ $+ $4 %orszag
  echo %whois_ablak  $+ $color(gray) $+ realname: $6-
  halt
}
raw 312:* {
  echo %whois_ablak  $+ $color(gray) $+ irc szerver: $3 ( $+ $4- $+ )
  halt
}
raw 313:* {
  echo $color(info2) %whois_ablak  $+ $5- $+ !
  halt
}
raw 314:* {
  echo $color(background) %whois_ablak -
  echo $color(other) %whois_ablak  $+ whowas $2
  echo %whois_ablak  $+ $color(gray) $+ host: $2 $+ ! $+ $3 $+ @ $+ $4
  echo %whois_ablak  $+ $color(gray) $+ realname: $6-
  halt
}
raw 317:* {
  echo %whois_ablak  $+ $color(gray) $+ idle: $hossz($3) óta.
  ; eltaroljuk az idlet
  .hadd lastmsg $cid $+ $2 $calc($ctime - $3)
  /idlecheck

  if ( $4 != $null ) && ( secon !isin $4 ) {
    /echo %whois_ablak  $+ $color(gray) $+ connected: $asctime($4)
    if ($calc($ctime - $4) > 0) { /echo %whois_ablak  $+ $color(gray) $+ uptime: $hossz($calc($ctime - $4)) }
  }
  /halt
}
raw 318:* {
  echo $color(background) %whois_ablak -
  unset %whois_ablak
  halt
}
raw 319:* {
  var %csatik $remove($3-,&servers)
  if (%csatik) { echo %whois_ablak  $+ $color(gray) $+ csatik: %csatik }
  halt
}
raw 401:*: { echo $color(info2) -atng *** $2 jelenleg nincs az ircen! | halt }
raw 369:*: {
  if (%whois_ablak) {
    echo $color(background) %whois_ablak -
    unset %whois_ablak
  }
  halt
}
raw 406:* { echo $color(info2) -atng *** Nem találtam $2 nevû usert! | unset %whois_ablak | halt }
;END

;BANLIST
raw 367:* {
  if (!%voltban) { /echo $color(background) -g $2 - | /echo $color(whois) -g $2  $+ $color(nick) $+ banlist on $2 | %voltban = 1 }
  /echo $color(whois) -g $2 $3
  /halt
}
raw 368:* {
  if (%voltban) { /echo $color(background) -ng $2 - }
  else { /echo $color(info) -tg $2 *** Nincsenek banok $laz($2) $2 csatin. }
  /unset %voltban
  /halt
}
;END

;REOP LIST
raw 344:* {
  if (!%voltreop) { /echo $color(background) -g $2 - | /echo $color(whois) -g $2  $+ $color(nick) $+ reop list on $2 | %voltreop = 1 }
  /echo $color(whois) -g $2 $3-
  /halt
}
raw 345:* {
  if (%voltreop) { /echo $color(background) -g $2 - }
  else { /echo $color(info) -tg $2 *** Nincs reop lista $laz($2) $2 csatin. }
  /unset %voltreop
  /halt
}
;END

;NICK
raw 432:* { echo $color(info2) -atng *** Hibás nick: $2 | halt }
raw 433:* {
  ; ha epp megy az orignick
  if ($timer(OrigNick $+ $cid).type) && ($2 == %orig_nick) { /halt }

  /echo $color(info2) -atng *** $az($2) $2 nick foglalt. (F8 - $2 megszerzése OrigNick használatával)
  .hdel data $cid $+ doit $+ $replace($active,Status Window,status)
  .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /orignick $2
  /halt
}
raw 436:* { echo $color(info2) -stg *** A szerver kirúgott nick ütközés miatt! | echo $color(info2) -atng *** A szerver kirúgott nick ütközés miatt! | halt }
raw 437:* {
  ; ha epp megy az orignick
  if ($timer(OrigNick $+ $cid).type) && ($2 == %orig_nick) { /halt }

  if ( $chr(33) !isin $2 ) && ( $chr(35) !isin $2 ) {
    echo $color(info2) -atng *** $az($2) $2 nick jelenleg nem elérhetõ netsplit miatt! (F8 - $2 megszerzése OrigNick használatával) 
    .hdel data $cid $+ doit $+ $replace($active,Status Window,status)
    .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /orignick $2
  }
  else {
    echo $color(info2) -atng *** $az($2) $2 csati jelenleg nem elérhetõ netsplit miatt!
  }
  halt
}
;END

;WHO
#simawho on
raw 352:*: {
  if ($chr(42) isin $7) || (a isin $7) { /echo -ag  $+ $color(other) $+ Who $6 $+ : Csati: $2 - Ident: $3 - Host: $4 $5 - RName: $9- - $+ $color(highlight) ircop! }
  else { /echo -ag  $+ $color(other) $+ Who $6 $+ : Csati: $2 - Ident: $3 - Host: $4 $5 - RName: $9- }
  /halt
}

raw 315:*: {
  /echo $color(background) -ag -
  /halt
}
#simawho end
;END

;LISTÁZÁSOK
#hostscan off
raw 352:* {
  /echo $color(whois) -g $2 ××× $+ $color(highlight) $6  $+ $color(whois) $+ hostja: $+ $color(wallops) $4
  /halt
}
raw 315:* {
  /echo $color(background) -g $2 -
  .disable #hostscan | .enable #simawho | /halt
}
#hostscan end

#serverscan off
raw 352:* {
  /echo $color(whois) -g $2 ××× $+ $color(highlight) $6  $+ $color(whois) $+ irc szervere: $+ $color(wallops) $5
  /halt
}
raw 315:* {
  /echo $color(background) -g $2 -
  .disable #serverscan | .enable #simawho | /halt
}
#serverscan end

#identscan off
raw 352:* {
  /echo $color(whois) -g $2 ××× $+ $color(highlight) $6  $+ $color(whois) $+ identje: $+ $color(wallops) $3
  /halt
}
raw 315:* {
  /echo $color(background) -g $2 -
  .disable #identscan | .enable #simawho | /halt
}
#identscan end

#realscan off
raw 352:* {
  /echo $color(whois) -g $2 ××× $+ $color(highlight) $6  $+ $color(whois) $+ real name: $+ $color(wallops) $9-
  /halt
}
raw 315:* {
  /echo $color(background) -g $2 -
  .disable #realscan | .enable #simawho | /halt
}
#realscan end
;END

;RAW
raw 001:*: { halt }
raw 002:*: { halt }
raw 003:*: { halt }
raw 004:*: { halt }
raw 005:*: { halt }
raw 006:*: { halt }
raw 007:*: { halt }
#simastatslinkinfo on
raw 211:*: {
  echo $color(info) -sg *** $2 - elküldött üzenetek: $4 ( $+ $meret($5) $+ )
  echo $color(info) -sg *** $2 - fogadott üzenetek: $6 ( $+ $meret($7) $+ )
  echo $color(info) -sg *** kapcsolat megnyitva: $asctime($calc($ctime - $8))
  echo $color(background) -sg -
  halt
}
raw 219:*: { echo $color(info) -sg *** lista vége | halt }
#simastatslinkinfo end
#forgalomstatslinkinfo off
raw 211:*: {
  if ($me isin $2) {
    echo $color(info) -atng *** fogadott üzenetek: $4 ( $+ $meret($5) $+ )
    echo $color(info) -atng *** elküldött üzenetek: $6 ( $+ $meret($7) $+ )
    echo $color(info) -atng *** kapcsolat megnyitva: $asctime($calc($ctime - $8))
  }
  halt
}
raw 219:*: { .enable #simastatslinkinfo | .disable #forgalomstatslinkinfo | halt }
#forgalomstatslinkinfo end

;LUSERS
raw 251:*: {
  if (!%lusers_kiiras) && (!%lusers_kiir) { halt }
  /echo $color(background) -sn - | echo $color(other) -sn *** Stats of $server at $time $date
  echo $color(highlight) -sn *** A hálózatban lévõ felhasználók száma: $4
  %fickokszama = $4
  %szerverszam = $10
  var %macko
  if ( $10 < %fickokszama ) {
    %macko = $round($calc(%fickokszama / $10),0)
  }
  else { %macko = $round($calc($10 / %fickokszama),0) }
  if ( %macko = $null ) { %macko = 0 }
  echo $color(highlight) -sn *** A hálózatban lévõ szerverek száma: $10 - Átlagosan %macko ember van 1 szerveren.
  halt
}
raw 252:*: { if (!%lusers_kiiras) && (!%lusers_kiir) { halt } | echo $color(highlight) -sn *** ircopok száma a hálózaton: $2 | halt }
raw 253:*: { if (!%lusers_kiiras) && (!%lusers_kiir) { halt } | echo $color(highlight) -sn *** Ismeretlen kapcsolatok száma: $2 | halt }
raw 254:*: {
  if (!%lusers_kiiras) && (!%lusers_kiir) { halt }
  var %macko
  if ($2 < %fickokszama) {
    %macko = $round($calc(%fickokszama / $2),0)
  }
  else { %macko = $round($calc($2 / %fickokszama),0) }
  if (!%macko) { %macko = 0 }
  echo $color(highlight) -sn *** A hálózaton lévõ csatik száma: $2 - Átlagosan %macko ember van 1 csatin.
  if (%szerverszam < $2) {
    %macko = $round($calc($2 / %szerverszam),0)
  }
  else { %macko = $round($calc(%szerverszam / $2),0) }
  if (!%macko) { %macko = 0 }
  echo $color(highlight) -sn *** Csati/szerver arány: Átlagosan %macko csati van 1 szerveren.
  /unset %fickokszama | /unset %szerverszam | halt
}
raw *:*current local*users*: { if (!%lusers_kiiras) && (!%lusers_kiir) { halt } | echo $color(highlight) -sn *** Helyi felhasználók száma: $remove($7,$chr(44)) - Max: $9 ( $+ $round($calc(($remove($7,$chr(44)) / $9) * 100),0) $+ % $+ ) | halt } }
raw *:*current global users*: { if (!%lusers_kiiras) && (!%lusers_kiir) { halt } | echo $color(highlight) -sn *** Felhasználók száma: $remove($7,$chr(44)) - Max: $9 ( $+ $round($calc(($remove($7,$chr(44)) / $9) * 100),0) $+ % $+ ) | echo $color(background) -s - | unset %lusers_kiir | halt } }
;END

raw 255:*: { if (!%lusers_kiiras) && (!%lusers_kiir) { halt } | echo $color(highlight) -sn *** A szerveren lévõ felhasználók száma: $4 | halt }
raw 303:*: { if (!$2-) { /echo $color(info2) -atng *** Nincs ircen a megadott nickek közül senki sem! | /halt } | echo $color(whois) -atng *** Ircen van: $2- |  /halt }
raw 441:* { echo $color(info2) -atng *** $2 nincs bennt $laz($3) $3 csatin! | halt }
raw 442:* { echo $color(info2) -atng *** Nem vagy bennt $laz($2) $2 csatin! | halt }
raw 443:* { echo $color(info2) -atng *** $2 már bennt van $laz($3) $3 csatin! | halt }
raw 421:* { echo $color(info2) -atng *** Ismeretlen parancs: / $+ $lower($2) | halt }
raw 461:* { echo $color(info2) -atng *** Hiányzó paraméter! (/ $+ $lower($2) $+ ) | halt }
raw 412:*: { echo $color(info2) -atng *** Nincs mit elküldeni! (nem adtál meg szöveget!) | halt }
raw 501:*: { echo $color(info2) -atng *** Ismeretlen mode flag! | halt }
raw 331:*: { echo $color(whois) -tng $2 *** $az($2) $2 csatinak nincsen beállítva topic. | /halt }
raw 332:*: {
  ; &serversel nem szarakodunk
  if ($2 == &servers) { halt }
  .hadd data $cid $+ channeltopic $+ $2 $3-
  .timertopic $+ $2 $+ $cid 1 5 /echo $color(highlight) -tn $2  $+ $color(topic) $+ *** A csati topicja: ' $+ $color(highlight) $+ $3- $+ '
  halt
}
raw 333:*: { .timertopic $+ $2 $+ $cid off | /echo $color(highlight) -tn $2  $+ $color(topic) $+ *** A csati topicja: ' $+ $color(highlight) $+ $hget(data,$cid $+ channeltopic $+ $2) $+  $+ $color(topic) $+ ' * beállítója: $3 @ $asctime($calc($4-)) | halt }
raw 341:*: { echo $color(info) -atng *** Meghívás elküldve $+ $color(nick) $2 $+  $+ $color(info) $+ $toldalek($nick,-nak,-nek) a $3 csatira! | halt }
raw 353:*: { halt }
raw 366:*: { halt }
raw 375:*:{
  /echo $color(background) -s -
  /echo $color(other) -s *** MOTD of $3
  /echo $color(background) -s -
  /halt
}
raw 372:*:{
  if ($3-) { echo $color(highlight) -s $3- }
  else { echo $color(background) -s - }
  halt
}
raw 376:*:{ /echo $color(background) -s - | /halt }
raw 381:* { echo $color(info2) -atng *** Mostantól $6- vagy! | halt }
raw 391:*:{ echo $color(info) -atng *** Servertime: $3- | /halt }
raw 402:*: { echo $color(info2) -atng *** $2 nincs az ircen! | unset %whois_ablak | halt }
raw 403:* { if ($2 != &servers) { echo $color(info2) -atng *** Nincs $2 nevû csati az ircen! } | halt }
raw 404:* {
  if ($2 != &servers) {
    if (m isin $gettok($chan(#qka).mode,1,32)) {
      echo $color(info2) -atng *** $az($2) $2 csati moderált, nem tudsz üzenni rá!
    }
    else {
      echo $color(info2) -atng *** Nem tudsz üzenni $laz($2) $2 csatira! Valószínûleg moderált (és nincsen voiceod), nem vagy bennt a csatin vagy bannolva vagy.
    }
  }
  halt
}
raw 405: * { echo $color(info) -atng *** Már elérted a maximálisan megengededett csati számot a szerveren! | /halt }
raw 409:*: { echo $color(info2) -atng *** Nincs megadva a kiindulási pont! | /halt }
raw 411:*: { echo $color(info2) -atng *** Nincs megadva cél! ( $+ $5 $+ ) | /halt }
raw 422:* { echo $color(info2) -stng *** Nincs MOTD. | halt }
raw 482:* {
  if ($me isop $2) { echo $color(info2) -tg $2 *** $3- }
  else { echo $color(info2) -tg $2 *** Nincsen opod a csatin! }
  halt
}
raw 483:* { echo $color(info2) -atng *** Nem tudod a szervert killelni! | /halt }
raw 463:* { echo $color(info2) -atng *** A hostod Klineon van ezen a szerveren. Próbálozz másikkal... | /halt }
raw 464:* { echo $color(info2) -atng *** Hibás jelszó! | /halt }
raw 465:* { echo $color(info2) -atng *** Klineod van ezen a szerveren. Próbálozz másikkal... | /halt }
raw 471:* { echo $color(info2) -atng *** $az($2) $2 csatornára nem férsz be a limit miatt! (+l - limit) | halt }
raw 472:* { echo $color(info2) -atng *** Hibás mode parancs! | halt }
raw 473:* { echo $color(info2) -atng *** $az($2) $2 csatira csak meghívóval lehet belépni. (+i - invite only) | /halt }
raw 474:* { echo $color(info2) -atng *** Nem tudsz belépni $laz($2) $2 csatira mert bannolva vagy! | /halt }
raw 475:* { echo $color(info2) -atng *** $az($2) $2 csatira csak jelszóval léphetsz be! Ha tudod a jelszót írd be: /join $2 [jelszó] | halt }
raw 481:*:{ echo $color(info2) -atng *** Nem vagy ircop módban! | /halt }
raw 502:*:{ echo $color(info2) -atng *** Nem tudod más felhasználók modeját állítani! | /halt }
raw 913:*:{ echo $color(info2) -atng *** Nincs hozzá jogod! | /halt }
raw 927:* { echo $color(info2) -atng *** Már benntvagy a $2 csatin! | halt }
raw *:*motd file is m*: { halt }
raw *:*change too fast*: { halt }
raw *:*no message delivered*: { halt }
raw *:*is connecting from*: { echo %whois_ablak  $+ $color(gray) $+ valós host: $6- | halt }
on ^1:ERROR:*server full*: /echo $color(info2) -sn *** A szerver teljesen megtelt felhasználókkal! Próbálj másikat!
raw 302:*: halt
raw 020:*: { echo $color(info) -stng *** Kérlek várj amíg a szerver feldolgozza a kapcsolódási kérelmed... | halt }
raw 042:*: { echo $color(info) -stng *** A szerver által adott egyedi azonosítód: $2 | halt }
;END
