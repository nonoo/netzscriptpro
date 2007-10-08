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

;ONHOTLINK
on ^1:HOTLINK:*http*:*: {
  if (!%dl_hotlink) { halt }
}
on ^1:HOTLINK:*ftp*:*: {
  if (!%dl_hotlink) { halt }
}
on 1:HOTLINK:*http*:*:{
  /onhotlink $1
}
on 1:HOTLINK:*ftp*:*:{
  /onhotlink $1
}
alias /onhotlink {
  ; elejerol levagjuk a felesleges karaktereket
  var %mit $1
  if ($pos(%mit,http://) > 1) { %mit = $right(%mit,$calc(1+$len(%mit)-$pos(%mit,http://))) }
  if ($pos(%mit,https://) > 1) { %mit = $right(%mit,$calc(1+$len(%mit)-$pos(%mit,https://))) }
  if ($pos(%mit,ftp://) > 1) { %mit = $right(%mit,$calc(1+$len(%mit)-$pos(%mit,ftp://))) }
  ; vegerol leszedjuk a ' jelet (topicnal lehet ijen)
  if ($right(%mit,1) == ') { %mit = $left(%mit,$calc($len(%mit)-1))) }

  var %i $numtok(%dl_hotlink_kiterjesztesek,32)
  var %volthotlink
  while (%i > 0) {
    ; ha illeszkedik a letoltendo kiterjesztesekre, letoltjuk a filet
    if ($gettok(%dl_hotlink_kiterjesztesek,%i,32) iswm %mit) { /dl %mit | %volthotlink = 1 }
    dec %i 1
  }
  ; ha nem volt match
  if (!%volthotlink) { /dll system/netz.dll sysopen %mit }
}
;END

;ONDNS
on *:DNS: {
  /haltdef
  var %i $dns(0)
  if (!%i) { /echo $color(info) -atng *** $dns(0).ip - nem lehet visszafejteni! | halt }
  /clipboard $dns(%i).ip
  while (%i > 0) {
    if ($dns(%i).nick) { /echo $color(info) -atng *** $+ $color(nick) $dns(%i).nick  $+ $color(info) $+ - ip: $dns(%i).ip host: $dns(%i).addr }
    else { echo $color(info) -atng *** ip: $dns(%i).ip host: $dns(%i).addr }
    dec %i
  }
}
;END

;ONDCCINPUT
on 1:INPUT:=: {
  /haltdef
  var %tempszoveg $1-
  if (!%tempszoveg) { /halt }
  ; away kikapcs szoveg beirasara
  if ($away) && (%auto_awayoff) && ($left($1,1) != /) { /away }
  ; parancsok vegrehajtasa
  if ($left($1,1) = /) && (!$ctrlenter) {
    .timer 1 0 %tempszoveg
    /halt
  }
  ; textformatter
  %tempszoveg = $textformat(%tempszoveg)
  ; uzenet elkuldese
  /msg $active %tempszoveg
  /halt
}
;END

;ONINPUT
on 1:INPUT:#: {
  /haltdef
  var %tempszoveg $1-
  ; nem lehetett beirni azt hogy "", ez a fix ra
  if ($1- == $chr(34) $+ $chr(34)) { %tempszoveg = "" }
  if (%tempszoveg == $null) { /halt }
  ; away kikapcs szoveg beirasara
  if ($away) && (%auto_awayoff) && ($left($1,1) != /) && ($server) { /away }
  ; parancsok vegrehajtasa
  if ($left($1,1) = /) && (!$ctrlenter) {
    .timer 1 0 %tempszoveg
    /halt
  }
  if (!$server) {
    /echo $color(info2) -atng *** Nem vagy szerverhez kapcsolÛdva!
    halt
  }
  ; textformatter
  %tempszoveg = $textformat(%tempszoveg)
  ; nick kiegeszites
  if (*: iswm $1) && ($1 != :) {
    var %a = $remove($1,:)
    var %b = 0
    while (%b < $nick($chan,0)) {
      inc %b
      if (%a $+ * iswm $nick($chan,%b) ) { %a = $nick($chan,%b) | /msg $chan %nickcomp_bal $+ %a $+ %nickcomp_jobb $2- | halt }
    }
  }
  ; lastmsg (idle detekt)
  .hadd lastmsg $cid $+ $me $ctime
  /idlecheck
  ; uzenet elkuldese
  /msg $chan %tempszoveg
  /halt
}

on 1:INPUT:Status window: {
  if ($1- == $null) { /halt }
  ; away kikapcs szoveg beirasara
  if ($away) && (%auto_awayoff) && ($left($1,1) != /) && ($server) { /away }
  ; parancsok vegrehajtasa
  if ($left($1,1) = /) && (!$ctrlenter) { .timer 1 0 $1- | halt }
  if (!$server) {
    /echo $color(info2) -atng *** Nem vagy szerverhez kapcsolÛdva!
    halt
  }
  .raw -q $1-
  halt
}

on 1:INPUT:?: {
  /haltdef
  var %tempszoveg $1-
  ; nem lehetett beirni azt hogy "", ez a fix ra
  if ($1- == $chr(34) $+ $chr(34)) { %tempszoveg = "" }
  if (%tempszoveg == $null) { /halt }
  ; away kikapcs szoveg beirasara
  if ($away) && (%auto_awayoff) && ($left($1,1) != /) && ($server) { /away }
  ; parancsok vegrehajtasa
  if ($left($1,1) = /) && (!$ctrlenter) {
    .timer 1 0 %tempszoveg
    /halt
  }
  if (!$server) {
    /echo $color(info2) -atng *** Nem vagy szerverhez kapcsolÛdva!
    halt
  }
  ; textformatter
  %tempszoveg = $textformat(%tempszoveg)
  ; lastmsg (idle detekt)
  .hadd lastmsg $cid $+ $me $ctime
  /idlecheck
  ; uzenet elkuldese
  /msg $active %tempszoveg
  /halt
}
;END

;ONNOTICE/ONLAG
on ^*:notice:*:#: {
  if ($chan == &servers) {
    var %tempinf = $1-
    if (%netsplit_detect_onlyhu) {
      if ( $right($5,3) != .hu ) && ($right($3,3) != .hu) { /halt }
    }
    if (Received SQUIT isin %tempinf) { %tempinf = $remove(%tempinf,Received SQUIT) | %tempinf =  $+ $color(nick) $+ $5  $+ $color(whois) $+ elszakadt $laz($3) $+  $+ $color(nick) $3  $+ $color(whois) $+ szervertıl. $6- }
    if (Received SERVER isin %tempinf) { %tempinf = $remove(%tempinf,Received SERVER) | %tempinf =  $+ $color(nick) $+ $5  $+ $color(whois) $+ kapcsolÛdott $laz($3) $+  $+ $color(nick) $3  $+ $color(whois) $+ szerverhez. $6- }
    if (Sending SERVER isin %tempinf) { %tempinf = $remove(%tempinf,Sending SERVER) | %tempinf =  $+ $color(whois) $+ KapcsolÛd·s $laz($3) $+  $+ $color(nick) $3  $+ $color(whois) $+ szerverhez. ( $+ $5- }
    if (Sending SQUIT isin %tempinf) { %tempinf = $remove(%tempinf,Sending SQUIT) | %tempinf =  $+ $color(nick) $+ $3  $+ $color(whois) $+ lekapcsol·sa $4- }
    /echo $color(info) -stg *** NetSplit Info: %tempinf
    /halt
  }
  /echo $color(notice) -t $chan Channel notice $+ $color(nick) $nick $+  $+ $color(notice) $+ $toldalek($nick,-tÛl,-tıl) $+ : $+ $color(nick) $1-
  halt
}
on ^*:notice:*:*: {
  ; lag detektor
  if ($nick = $me) && ($left($1,5) == $chr(254) $+ lag-) {
    var %lag = $calc(($ticks - $remove($1,$chr(254) $+ lag-)) / 1000)
    .hadd data $cid $+ lag %lag
    ; ha van %lagwindow, azaz ha nem csak a titlebarba akarjuk kiiratni
    if ($window(%lagwindow)) {
      ; lag msbe atvaltasa
      var %lagmsec
      if (%lag < 1) { %lagmsec = ( $+ $calc(%lag * 1000) msec) }
      ; lag kiirasa
      if (%lagwindow == Status Window) { /echo $color(info) -stg *** Lag: %lag sec. %lagmsec }
      else { /echo $color(info) -tg %lagwindow *** Lag: %lag sec. %lagmsec }
      unset %lagwindow
    }
  }
  else {
    ; sima notice
    ;
    ; ha kell pager
    if (%highlight_pager) {
      var %lastmsg = $hget(lastmsg,$cid $+ $nick $+ highlight)
      if ($calc($ctime - %lastmsg) > %flash_priviknel_timeout) || (!%lastmsg) {
        if (!$appactive) {
          if (%flash_priviknel) { /flash %flash_priviknel_szoveg }
          if (%beep_priviknel) {
            ; regi vindoz alatt beepelunk
            if ($os == 95) || ($os == 98) || ($os == me) { /beep 2 100 }
            else {
              if (!%beep_priviknel_winamp) || ($dll(system/netz.dll, winamp, GetCurrentWinampSong) == 0) { /beep 2 100 }
              else {
                if ($dll(system\netz.dll, winamp, isplaying)) { /beep 2 100 }
              }
            }
          }
          if (%pcspeaker_priviknel) { /netzbeep highlight }
        }
      }
    }
    ; lastmsg (idle detekt)
    .hadd lastmsg $cid $+ $nick $ctime
    /idlecheck

    /aecho $color(notice) -tng Notice $+ $color(nick) $nick $+  $+ $color(notice) $+ $toldalek($nick,-tÛl,-tıl) $+ : $+ $color(nick) $1-
  }
  halt
}
on ^*:snotice:*: {
  if (currently in split isin $1-) { /echo $color(info2) -atng *** A szerver jelenleg split mÛdban van. ElkÈpzelhetı hogy nÈh·ny csatira nem fogsz tudni belÈpni. }
  else { /aecho $color(notice) -tng Notice $laz($nick) $+  $+ $color(nick) $nick $+  $+ $color(notice) szervertıl $+ : $+ $color(nick) $1- }
  ; ha ircproxyt hasznalunk, nem hajtodik vegre az onconnect
  if (Attached on connection isin $1-) {
    /onconnect
    ; az osszes eddig megnyitott csati ablakba lekerjuk a topicot
    var %i $chan(0)
    while (%i > 0) {
      if ($chan(%i) != &servers) { topic $chan(%i) }
      dec %i 1
    }
  }
  halt
}
;END

;PSYBNC KEZEL…S
menu @psyBNC {
  Log tˆrlÈse: .quote eraseprivatelog
  -
  Bez·r·s: /window -c @psyBNC
}
on ^*:notice:*:?: {
  if ($nick == -psyBNC) {
    if (PLAYPRIVATELOG isin $1-) { .timer 1 1 /psybnc -youhave | halt }
    if (/DCCGET isin $1-) {
      if ( $?!="Fogadod a f·jlt amit $1 k¸ld neked? ( $+ $left($10,$calc($len($1-)-1)) $+ )" = $true ) { .timer 1 0 .quote dccget $1 $14 }
      halt
    }
    if (file isin $1-) && (from isin $1-) && (received isin $1-) {
      if ( $?!="Letˆltˆd a f·jlt a psyBNC-rıl? ( $+ $left($6,$calc($len($1-)-1)) $+ )" = $true ) { .timer 1 0 .quote dccsendme $6 }
      halt
    }
  }
}
;END

;DCC FLOOD DETEKT
ctcp ^1:DCC:*: {
  if (%flooddetekt) {
    if ($2 = CHAT) {
      var %kutya = $hget(flood,$cid $+ $nick $+ chats)
      if (!%kutya) { %kutya = 1 }
      else { inc %kutya 1 }
      if (%kutya >= %max_chat) {
        echo $color(other) -atng *** $nick dcc chat floodolt! 5 percre dcc ignoreolom.
        .ignore -du300 $nick
        :nem
        .hdel flood $cid $+ $nick $+ chats
        halt
      }
      .hadd -u $+ %time_chat flood $cid $+ $nick $+ chats %kutya
    }
    if ($2 = SEND) {
      var %kutya = $hget(flood,$cid $+ $nick $+ sends)
      if (!%kutya) { %kutya = 1 }
      else { inc %kutya 1 }
      if (%kutya >= %max_send) {
        echo $color(other) -atng *** $nick dcc send floodolt! 5 percre dcc ignoreolom.
        .ignore -du300 $nick
        :nem
        .hdel flood $cid $+ $nick $+ sends
        halt
      }
      .hadd -u $+ %time_send flood $cid $+ $nick $+ sends %kutya
    }
  }
}

;J¡T…KOK
ctcp ^1:5inrow: {
  echo $color(highlight) -atng *** $+ $color(nick) $nick  $+ $color(highlight) $+ amıb·zni akar veled! Ha szeretnÈl j·tszani, nyomj F8-at!
  .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /run system\5inrow.exe $2
  halt
}
ctcp ^1:chess: {
  echo $color(highlight) -atng *** $+ $color(nick) $nick  $+ $color(highlight) $+ sakkozni akar veled! Ha szeretnÈl j·tszani, nyomj F8-at!
  .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /run system\chess.exe $2
  halt
}
;END

;ONPAGE
ctcp ^1:PAGE: {
  haltdef
  /echo $color(highlight) -atng *** $nick paget k¸ldˆtt!
  .ignore -tu $+ %pager_timeout $nick
  if (%pager) || ( (%away_pager) && ($away) ) {
    if (%pager_beep) {
      if (!%pager_beep_winamp) || ($dll(system/netz.dll, winamp, GetCurrentWinampSong) == 0)  { /beep 5 100 }
      else {
        if ($dll(system\netz.dll, winamp, isplaying)) { /beep 5 100 }
      }
    }
    if (%pager_speaker) { /netzbeep pager }
    if (%pager_flash) { /flash %pager_flash_szoveg }
  }
  halt
}
;END

;ONCTCP
on ^1:CTCP:*: { haltdef | halt }
ctcp ^1:CLIENTINFO: {
  haltdef
  echo $color(highlight) -atng *** $nick lekÈrdezte a clientinfÛt!
  .ctcpreply $nick CLIENTINFO netZ Script Pro %ver - http://netz.nonoo.hu/

  ; flood vedelem
  if (%flooddetekt) && (%flooddetekt_ctcp) {
    var %kutya = $hget(flood,$cid $+ ctcp)
    if (!%kutya) { %kutya = 1 }
    else { inc %kutya 1 }
    if (%kutya >= %max_ctcp) {
      echo $color(other) -tga *** ctcp flood vÈdelem: ctcp ignore bekapcsolva 5 percre
      .ignore -tu300 *!*@*
      .hdel flood $cid $+ ctcp
      halt
    }
    .hadd -u $+ %time_ctcp flood $cid $+ ctcp %kutya
  }
  halt
}
ctcp ^1:TIME: {
  haltdef
  echo $color(highlight) -atng *** $nick lekÈrdezte az idıd! (ctcp time)
  .ctcpreply $nick TIME $asctime

  ; flood vedelem
  if (%flooddetekt) && (%flooddetekt_ctcp) {
    var %kutya = $hget(flood,$cid $+ ctcp)
    if (!%kutya) { %kutya = 1 }
    else { inc %kutya 1 }
    if (%kutya >= %max_ctcp) {
      echo $color(other) -tga *** ctcp flood vÈdelem: ctcp ignore bekapcsolva 5 percre
      .ignore -tu300 *!*@*
      .hdel flood $cid $+ ctcp
      halt
    }
    .hadd -u $+ %time_ctcp flood $cid $+ ctcp %kutya
  }
  halt
}
ctcp ^1:PING: {
  haltdef
  .timer 1 0 .ctcpreply $nick PING $1
  echo $color(highlight) -atng *** $nick megpingelt!

  ; flood vedelem
  if (%flooddetekt) && (%flooddetekt_ctcp) {
    var %kutya = $hget(flood,$cid $+ ctcp)
    if (!%kutya) { %kutya = 1 }
    else { inc %kutya 1 }
    if (%kutya >= %max_ctcp) {
      echo $color(other) -tga *** ctcp flood vÈdelem: ctcp ignore bekapcsolva 5 percre
      .ignore -tu300 *!*@*
      .hdel flood $cid $+ ctcp
      halt
    }
    .hadd -u $+ %time_ctcp flood $cid $+ ctcp %kutya
  }
  halt
}
ctcp ^1:VERSION: {
  haltdef
  echo $color(highlight) -atng *** $nick lekÈrdezte a verziÛt!
  .ctcpreply $nick VERSION netZ Script Pro %ver - http://netz.nonoo.hu/

  ; flood vedelem
  if (%flooddetekt) && (%flooddetekt_ctcp) {
    var %kutya = $hget(flood,$cid $+ ctcp)
    if (!%kutya) { %kutya = 1 }
    else { inc %kutya 1 }
    if (%kutya >= %max_ctcp) {
      echo $color(other) -tga *** ctcp flood vÈdelem: ctcp ignore bekapcsolva 5 percre
      .ignore -tu300 *!*@*
      .hdel flood $cid $+ ctcp
      halt
    }
    .hadd -u $+ %time_ctcp flood $cid $+ ctcp %kutya
  }
  halt
}
on 1:CTCPREPLY:*: {
  haltdef
  if ($1 = PING) { var %rttr = $calc(($ticks - $2) / 1000) | /echo $color(info) -atng *** $nick v·laszolt a pingre: %rttr sec. | halt }
  echo $color(ctcp) -atng *** $nick CTCP v·lasza: $1-
  halt
}
;END

;ONOPEN (K÷SZ÷N…S)
on 1:OPEN:?: {
  if ($nick = -psyBNC) { /halt }

  if (%getlog) { /getlog $nick }
  var %greet = $read(system\greetings.txt)
  .hdel data $cid $+ koszones $+ $nick
  .hadd data $cid $+ koszones $+ $nick %greet
  echo $color(background) -ng $nick -
  /echo $color(info) -tng $nick *** KˆszˆnÈs: F7 - %greet
  ; hatterbe kiirjuk query nevet
  if (%wndback) { wndback $nick }
}
on 1:OPEN:=: {
  if (%getlog) { /getlog $nick }
  var %greet = $read(system\greetings.txt)
  .hdel data $cid $+ koszones $+ $nick
  .hadd data $cid $+ koszones $+ $nick %greet
  echo $color(background) -ng $nick -
  /echo $color(info) -tng $nick *** KˆszˆnÈs: F7 - %greet
  ; hatterbe kiirjuk query nevet
  if (%wndback) { wndback $nick }
}
;END

;ONDCCCLOSE
on 1:CLOSE:!: { /window -c =$nick | /echo $color(info) -st *** $nick befejezte a DCC Chatet. | /window -g0 "status window" | /halt }
on 1:CLOSE:=: { /window -c =$nick | /echo $color(info) -st *** $nick befejezte a DCC Chatet | /window -g0 "status window" | /halt }
;END

;ONEXIT
on 1:EXIT: {
  ; ¸rÌtj¸k a temp kˆnyvt·rat
  var %a $findfile(system\temp,*.*,0,.remove $1-)
  ; hash tablakat toroljuk
  .hfree dl_urllist
  .hfree flood
  .hfree data
  .hfree lastmsg
  .hfree patchfiles
  .hfree uzenet
}
;END

;ONCONNECT
alias /onconnect {
  if (%quitmessage_random) { %quitmessage = 15,14[netZ] $+ $chr(32) $+ $read system\quit.txt }

  %away_eredeti_nick = $me

  %legutobbiszerver5 = %legutobbiszerver4
  %legutobbiszerver4 = %legutobbiszerver3
  %legutobbiszerver3 = %legutobbiszerver2
  %legutobbiszerver2 = %legutobbiszerver1
  %legutobbiszerver1 = $server

  /echo $color(highlight) -sng *** F2 - /join %kedvenc_csatik
  /echo $color(background) -sng -
  if (%winamp_automata_kijelzes) { .wpauto on }
  if (%lagdetect_titlebarban) { .lagauto on }
  if (%autojoin) {
    var %i 1
    var %cs $gettok(%autojoin_csatik,1,32)
    while (%cs) {
      .timer 1 0 /join %cs
      inc %i 1
      %cs = $gettok(%autojoin_csatik,%i,32)
    }
  }
  if (%idleszin_hasznalat) { .timeridlecheck $+ $cid 0 60 /idlecheck }
  ; hash tablakat uritjuk
  .hdel -w data $cid $+ *
  if (%flooddetekt) { .hdel -w flood $cid $+ * }
  .hdel -w lastmsg $cid $+ *

  othercheck
}
on *:connect: { /onconnect }
;END

;ONNICK
on ^1:nick: {
  ; idlecheckben atirjuk az adatait
  if ($hget(lastmsg,$cid $+ $nick)) { .hadd lastmsg $cid $+ $newnick $hget(lastmsg,$cid $+ $nick) }
  /wndback $newnick
  if ( $nick = $me ) {
    ;/aecho $color(join) -tn --nostatus *** Az ˙j nicked: $+ $color(highlight) $newnick
    ;if ($active !ischan) { echo $color(join) -atn *** Az ˙j nicked: $+ $color(highlight) $newnick }
    /aecho $color(join) -tn *** Az ˙j nicked: $+ $color(highlight) $newnick
    if ($newnick == %orig_nick) && ($timer(OrigNick $+ $cid).type) { /echo $color(info) -atng *** OrigNick: $newnick visszaszerezve. | .timerOrigNick $+ $cid off | halt }
    halt
  }

  ; minden csatiablakba kiirjuk a nickvaltast amelyikben az illeto bennvan
  var %i $chan(0)
  while (%i > 0) {
    if ($newnick ison $chan(%i)) { /echo $color(join) -tn $chan(%i) *** $+ $color(highlight) $nick ˙j nickje: $+ $color(highlight) $newnick }
    dec %i 1
  }
  ; ha epp arrol a nickrol valtott at amire vagyunk
  if ($nick == %orig_nick) && ($timer(OrigNick $+ $cid).type) { .timer 1 0 .nick %orig_nick }

  ; ha van nyitott query vele
  if ($query($newnick) != $null) {
    var %greet $read(system\greetings.txt)
    .hdel data $cid $+ koszones $+ $newnick
    .hadd data $cid $+ koszones $+ $newnick %greet
    ; ha az utolsÛ sor az hogy a user kilÈpett, akkor szÛlunk, hogy visszajˆtt
    if (*** $newnick kilÈpett az ircrıl. isin $strip($line($newnick,$line($newnick,0)))) {
      echo $color(join) -t $newnick *** $+ $color(highlight) $nick ˙j nickje: $+ $color(highlight) $newnick (F7 - %greet $+ )
      } else {
      echo $color(join) -t $newnick *** $+ $color(highlight) $nick ˙j nickje: $+ $color(highlight) $newnick (F7 - %greet $+ )
    }
  }

  ; flooddetekt
  if (%flooddetekt) {
    ; atirjuk a regi nick floodmerojet az uj nickre
    if ($hget(flood, $cid $+ $nick $+ nicks)) { .hadd -u $+ %time_nick flood $cid $+ $newnick $+ nicks $hget(flood,$cid $+ $nick $+ nicks) }

    var %kutya = $hget(flood,$cid $+ $newnick $+ nicks)
    if (!%kutya) { %kutya = 1 }
    else { inc %kutya 1 }
    if (%kutya >= %max_nick) {

      ; minden csatin vegigmegyunk ahol a user benntvan
      var %i $chan(0)
      while (%i > 0) {
        if ($newnick !ison $chan(%i)) { dec %i 1 | continue }

        if (%flooddetekt_csatikra) && ($chan(%i) isin %flooddetekt_csatik) {
          /echo $color(other) -tg $chan(%i) *** $newnick nickfloodolt!
        }
        if (!%flooddetekt_csatikra) {
          /echo $color(other) -tg $chan(%i) *** $newnick nickfloodolt!
        }

        if (%flooddetekt_csatikra) && ($chan(%i) !isin %flooddetekt_csatik) {
          goto nem
        }
        if ($me isop $chan(%i)) {
          if ($nick isop $chan(%i)) && (!%kick_oposokat) { goto nem }
          if ($nick isvoice $chan(%i)) && (!%kick_voiceosokat) { goto nem }

          if (%ban_nick) { .timer 1 0 /kickban $chan(%i) $newnick nickflood }
          elseif (%kick_nick) {
            .timer 1 0 /kick $chan(%i) $newnick nickflood
          }
        }
        :nem
        dec %i 1
      }
      .hdel flood $cid $+ $newnick $+ nicks
      halt
    }
    .hadd -u $+ %time_nick flood $cid $+ $newnick $+ nicks %kutya
  }
  halt
}
;END

;ONPART
on ^1:PART:*: {
  /haltdef
  if ($nick = $me) { /echo $color(part) -t $chan *** KilÈptÈl a csatirÛl. | /halt }
  if (($nick($chan,0) = 2) && ($me !isop $chan)) { /echo $color(info) -st *** OpHopot hajtottam vÈgre a $chan csatin! | .timer 1 0 /hop $chan 1 | /halt }
  if ($1) {
    /echo $color(part) -tn $chan *** $+ $color(gray) $nick ( $+ $address $+ ) kilÈpett a csatirÛl. ( $+ $color(other) $+ $1- $+ )
  }
  else {
    /echo $color(part) -tn $chan *** $+ $color(gray) $nick ( $+ $address $+ ) kilÈpett a csatirÛl.
  }
  /halt
}
;END

;ONQUIT
on ^1:QUIT: {
  if ($nick != $me) {
    ; toroljuk az illeto lastmsgjet
    .hdel lastmsg $cid $+ $nick

    var %rizon
    if ($1-) && ($1- != "") { %rizon = ( $+ $1- $+ ) }
    ; minden csatira kiirjuk ahol az illeto bennt volt
    var %i $chan(0)
    while (%i > 0) {
      if ($nick ison $chan(%i)) {
        /echo $color(quit) -tn $chan(%i) *** $+ $color(gray) $nick ( $+ $address $+ ) kilÈpett az ircrıl. %rizon
        ; ophop
        if ($chan(%i) != &servers) && ($nick($chan(%i),0) = 2) && ($me !isop $chan(%i)) { /echo $color(info) -st *** OpHopot hajtottam vÈgre a $chan(%i) csatin! | /hop $chan(%i) 1 }
      }
      dec %i 1
    }
    ; query ablakaba is beleirjuk hogy kilepett
    if ($query($nick)) {
      /echo $color(quit) -t $nick *** $+ $color(gray) $nick kilÈpett az ircrıl. %rizon
    }
    if ($nick = %orig_nick) && ($timer(OrigNick $+ $cid).type) { .timer 1 0 .nick %orig_nick }
  }
  /halt
}
;END

;ONJOIN
on ^1:JOIN:*: {
  haltdef
  if ($nick = $me) {
    if ($chan = &servers) { window -h &servers | halt }
    var %greet $read(system\greetings.txt)
    .hdel data $cid $+ koszones $+ $chan
    .hadd data $cid $+ koszones $+ $chan %greet
    /echo $color(join) -tn $chan *** BelÈptÈl a $+ $color(highlight) $chan csatira. (F7 - %greet $+ )
    /idlecheck
    ; hatterbe kiirjuk csati nevet
    if (%wndback) { wndback $chan }
    if ($chan == &bitlbee) {
      %bitlbee_oldmoodtext = $null
    }
  }
  else {
    var %greet $read(system\greetings.txt)
    .hdel data $cid $+ koszones $+ $chan
    .hadd data $cid $+ koszones $+ $chan %greet
    ; webchat ip visszafejtes
    var %tmpwebchat
    if (webchat.xs4all.nl isin $address) {
      %tmpwebchat = (Webchat ip: $hextoipc($remove($address,@webchat.xs4all.nl)) F8 - host lekÈrÈse)
      .hdel data $cid $+ doit $+ $replace($chan,Status Window,status)
      .hadd data $cid $+ doit $+ $replace($chan,Status Window,status) /dns $hextoipc($remove($address,@webchat.xs4all.nl))
    }
    echo $color(join) -t $chan *** $+ $color(highlight) $nick ( $+ $address $+ ) belÈpett a csatira! (F7 - %greet $+ ) %tmpwebchat
    ; ha van nyitott query Ès az utolsÛ sor az hogy a user kilÈpett, akkor szÛlunk, hogy visszajˆtt
    if (*** $nick kilÈpett az ircrıl. isin $strip($line($nick,$line($nick,0)))) {
      var %greet $read(system\greetings.txt)
      .hdel data $cid $+ koszones $+ $nick
      .hadd data $cid $+ koszones $+ $nick %greet
      echo $color(join) -t $nick *** $+ $color(highlight) $nick ( $+ $address $+ ) belÈpett az ircre! (F7 - %greet $+ )
    }

    if (%flooddetekt) {
      var %kutya = $hget(flood,$cid $+ $nick $+ joins)
      if (!%kutya) { %kutya = 1 }
      else { inc %kutya 1 }
      if (%kutya >= %max_join) {
        if (%flooddetekt_csatikra) && ($chan isin %flooddetekt_csatik) {
          echo $color(other) -tg $chan *** $nick cyclefloodolt!
        }
        if (!%flooddetekt_csatikra) {
          echo $color(other) -tg $chan *** $nick cyclefloodolt!
        }

        if (%flooddetekt_csatikra) && ($chan !isin %flooddetekt_csatik) {
          goto nem
        }

        if ($me isop $chan) {
          if ($nick isop $chan) && (!%kick_oposokat) { goto nem }
          if ($nick isvoice $chan) && (!%kick_voiceosokat) { goto nem }

          if (%ban_csati) { .timer 1 0 /kickban $chan $nick cycle }
          elseif (%kick_join) {
            .timer 1 0 /kick $chan $nick cycle
          }
        }
        :nem
        .hdel flood $cid $+ $nick $+ joins
        halt
      }
      .hadd -u $+ %time_join flood $cid $+ $nick $+ joins %kutya
    }
  }
}
;END

;ONDISCONNECT
on *:DISCONNECT: {
  /haltdef
  .timeridlecheck $+ $cid off
  .lagauto off
  .wpauto off
  ; hash tablakat uritjuk
  .hdel -w data $cid $+ *
  if (%flooddetekt) { .hdel -w flood $cid $+ * }
  .hdel -w lastmsg $cid $+ *

  /aecho $color(info2) -tng *** Megszakadt a kapcsolat. (F2 - ˙jrakapcsolÛd·s)
  if ($away) {
    .timer 1 0 .nick %away_eredeti_nick
  }
  /halt
}
;END

;ONNOTIFY
on ^*:NOTIFY: {
  /echo $color(info) -tmgs *** $+ $color(nick) $nick belÈpett az ircre!
  /echo $color(info) -tmga *** $+ $color(nick) $nick belÈpett az ircre!
  ; ha kell pager
  if (%highlight_pager) {
    if (!$appactive) {
      if (%flash_priviknel) { /flash NOTIFY }
      if (%beep_priviknel) {
        ; regi vindoz alatt beepelunk
        if ($os == 95) || ($os == 98) || ($os == me) { /beep 2 100 }
        else {
          if (!%beep_priviknel_winamp) || ($dll(system/netz.dll, winamp, GetCurrentWinampSong) == 0) { /beep 2 100 }
          else {
            if ($dll(system\netz.dll, winamp, isplaying)) { /beep 2 100 }
          }
        }
      }
      if (%pcspeaker_priviknel) { /netzbeep query }
    }
  }
  /halt
}
on ^*:UNOTIFY: {
  /echo $color(info) -tgs *** $+ $color(nick) $nick kilÈpett az ircrıl.
  /echo $color(info) -tga *** $+ $color(nick) $nick kilÈpett az ircrıl.
  /halt
}
;END

;ONINVITE
on ^1:INVITE:*: {
  /echo $color(invite) -atng *** $nick meghÌvott $laz($chan) $chan csatira! (F8 - belÈpÈs)
  .hdel data $cid $+ doit $+ $replace($active,Status Window,status)
  .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /join $chan
  ; flooddetekt
  if (%flooddetekt) {
    var %kutya = $hget(flood,$cid $+ $nick $+ invites)
    if (!%kutya) { %kutya = 1 }
    else { inc %kutya 1 }
    if (%kutya >= %max_invite) {
      echo $color(other) -atng *** $nick invitefloodolt! 5 percig ignoreolom az invitejait.
      .ignore -iu300 $nick
      .hdel flood $cid $+ $nick $+ invites
      halt
    }
    .hadd -u $+ %time_invite flood $cid $+ $nick $+ invites %kutya
  }
  /halt
}
;END

;ONTOPIC
on ^1:TOPIC:*: {
  /haltdef
  ; topic torles
  if ( $1- = $null ) { 
    if ($nick != $me) { /echo -tn $chan *** $+ $color(gray) $nick ( $+ $address $+ ) tˆrˆlte a topicot. }
    else { /echo -tn $chan *** Tˆrˆlted a topicot. }
    /halt
  }
  ; topic valtas
  if ( $nick != $me ) { /echo -tn $chan *** $+ $color(gray) $nick ( $+ $address $+ ) megv·ltoztatta a topicot: ' $+ $color(gray) $+ $1- $+ ' }
  else { /echo -tn $chan *** Megv·ltoztattad a topicot: ' $+ $color(gray) $+ $1- $+ ' }
  /halt
}
;END

;ONACTION
on ^1:ACTION:*:#:{
  var %tempszoveg = $1-
  ; webchat unicode karakterek
  %tempszoveg = $replace($1-,√ú,‹,√ü,¸,√≥,Û,≈,ı,√∫,˙,√ä,È,√•,·,≈π,˚,√≠,Ì,√°,·,√ñ,÷,√ì,”,√â,…,√Å,¡,ı∞,€,√ç,Õ,√©,È,ı±,˚,√º,¸,√∂,ˆ,√ö,⁄,ıë,ı,ıê,’,√É¬º,˚)
  ; highlight
  if ($highlight_ok(%tempszoveg)) {
    echo $color(action) -tm $chan  $+ %nick_highlight_szin $+ * $nick %tempszoveg
  }
  else { echo $color(action) -tm $chan * $nick %tempszoveg }
  ; awayreason eltarolasa
  if (away isin $1-) || (tavozik isin $1-) || (t·vozik isin $1-) || (gone isin $1-) { .hadd data $cid $+ awayreason $+ $nick $1- }
  ; villogtatjuk a csati ablakot ha a nevunk benne van az uzenetben
  if ($highlight_ok(%tempszoveg)) {
    /window -g2 $chan
    ; ha kell pager
    if (%highlight_pager) {
      var %lastmsg = $hget(lastmsg,$cid $+ $nick $+ highlight)
      if ($calc($ctime - %lastmsg) > %flash_priviknel_timeout) || (!%lastmsg) {
        if (!$appactive) {
          if (%flash_priviknel) { /flash %flash_priviknel_szoveg }
          if (%beep_priviknel) {
            if (!%beep_priviknel_winamp) || ($dll(system/netz.dll, winamp, GetCurrentWinampSong) == 0) { /beep 2 100 }
            else {
              if ($dll(system\netz.dll, winamp, isplaying)) { /beep 2 100 }
            }
          }
          if (%pcspeaker_priviknel) { /netzbeep highlight }
        }
      }
    }
  }
  ; lastmsg (idle detekt)
  .hadd lastmsg $cid $+ $nick $ctime
  /idlecheck
  ; flooddetekt (csati uzenetnek vesszuk)
  if (%flooddetekt) {
    var %kutya = $hget(flood,$cid $+ $nick $+ $chan)
    if (!%kutya) { %kutya = 1 }
    else { inc %kutya 1 }
    if (%kutya >= %max_csati) {
      if (%flooddetekt_csatikra) && ($chan isin %flooddetekt_csatik) {
        echo $color(other) -tg $chan *** $nick floodolt!
      }
      if (!%flooddetekt_csatikra) {
        echo $color(other) -tg $chan *** $nick floodolt!
      }

      if (%flooddetekt_csatikra) && ($chan !isin %flooddetekt_csatik) {
        goto nem
      }

      if ($me isop $chan) {
        if ($nick isop $chan) && (!%kick_oposokat) { goto nem }
        if ($nick isvoice $chan) && (!%kick_voiceosokat) { goto nem }

        if (%ban_csati) { .timer 1 0 /kickban $chan $nick flood }
        elseif (%kick_csati) {
          .timer 1 0 /kick $chan $nick flood
        }
      }
      :nem
      .hdel flood $cid $+ $nick $+ $chan
      halt
    }
    .hadd -u $+ %time_csati flood $cid $+ $nick $+ $chan %kutya
  }
  /halt
}
on ^1:ACTION:*:?:{
  /echo $color(action) -tm $nick * $nick $1-
  ; flash, csak akkor ha az illeto mar %flash_priviknel_timeout perce nem irt privat uzenetet
  var %lastmsg = $hget(lastmsg,$cid $+ $nick $+ privi)
  if ($calc($ctime - %lastmsg) > %flash_priviknel_timeout) || (!%lastmsg) {
    if (%flash_priviknel) { /flash %flash_priviknel_szoveg }
    if (%beep_priviknel) {
      if (!%beep_priviknel_winamp) || ($dll(system/netz.dll, winamp, GetCurrentWinampSong) == 0) { /beep 2 100 }
      else {
        if ($dll(system\netz.dll, winamp, isplaying)) { /beep 2 100 }
      }
    }
    if (%pcspeaker_priviknel) { /netzbeep query }
  }
  ; lastmsg (idle detekt)
  .hadd lastmsg $cid $+ $nick $ctime
  .hadd lastmsg $cid $+ $nick $+ privi $ctime
  /idlecheck
  /halt
}
;END

;ONTEXT
on ^1:TEXT:*:#:{
  /haltdef
  var %tempszoveg = $1-
  ; webchat unicode karakterek
  %tempszoveg = $replace($1-,√ú,‹,√ü,¸,√≥,Û,≈,ı,√∫,˙,√ä,È,√•,·,≈π,˚,√≠,Ì,√°,·,√ñ,÷,√ì,”,√â,…,√Å,¡,ı∞,€,√ç,Õ,√©,È,ı±,˚,√º,¸,√∂,ˆ,√ö,⁄,ıë,ı,ıê,’)
  ; plusz jelek
  var %plusz
  if ($nick isvo $chan) { %plusz = + }
  if ($nick ishop $chan) { %plusz = % }
  if ($nick isop $chan) { %plusz = @ }
  ; urlek kiemelese
  if (%url_kiemeles) {
    var %i = $len(%tempszoveg)
    while (%i > 0) {
      if ((http:// isin $gettok(%tempszoveg,%i,32)) || (ftp:// isin $gettok(%tempszoveg,%i,32)) || (https:// isin $gettok(%tempszoveg,%i,32)))  {
        ; ha van alahuzas, reverz, bold a kiemeles styleban, akkor azokat a kiemeles vegen ki kell kapcsolnunk
        var %url_kiemeles_unset
        if ( isin %url_kiemeles_style) { %url_kiemeles_unset = %url_kiemeles_unset $+  }
        if ( isin %url_kiemeles_style) { %url_kiemeles_unset = %url_kiemeles_unset $+  }
        if ( isin %url_kiemeles_style) { %url_kiemeles_unset = %url_kiemeles_unset $+  }
        if ( isin %url_kiemeles_style) { %url_kiemeles_unset = %url_kiemeles_unset $+  }
        %tempszoveg = $replace(%tempszoveg,$gettok(%tempszoveg,%i,32),%url_kiemeles_style $+ $gettok(%tempszoveg,%i,32) $+ %url_kiemeles_unset)
      }
      dec %i 1
    }
  }
  ; kiemelÈs+kiÌr·s
  if ($highlight_ok(%tempszoveg)) {
    /echo $color(normal) -tm $chan %mas_bal $+  $+ %nick_highlight_szin $+ %plusz $+ $nick $+ %mas_jobb $+  $+ $color(normal) %tempszoveg
    ; villogtatjuk a csati ablakot ha a nevunk benne van az uzenetben
    /window -g2 $chan
    ; ha kell pager
    if (%highlight_pager) {
      var %lastmsg = $hget(lastmsg,$cid $+ $nick $+ highlight)
      if ($calc($ctime - %lastmsg) > %flash_priviknel_timeout) || (!%lastmsg) {
        if (!$appactive) {
          if (%flash_priviknel) { /flash %flash_priviknel_szoveg }
          if (%beep_priviknel) {
            ; regi vindoz alatt beepelunk
            if ($os == 95) || ($os == 98) || ($os == me) { /beep 2 100 }
            else {
              if (!%beep_priviknel_winamp) || ($dll(system/netz.dll, winamp, GetCurrentWinampSong) == 0) { /beep 2 100 }
              else {
                if ($dll(system\netz.dll, winamp, isplaying)) { /beep 2 100 }
              }
            }
          }
          if (%pcspeaker_priviknel) { /netzbeep highlight }
        }
      }
    }
  }
  else { /echo $color(normal) -tm $chan %mas_bal $+  $+ $color(nick) $+ %plusz $+ $nick $+ %mas_jobb $+  $+ $color(normal) %tempszoveg }
  ; lastmsg (idle detekt)
  .hadd lastmsg $cid $+ $nick $ctime
  /idlecheck
  ; flooddetekt
  if (%flooddetekt) {
    var %kutya = $hget(flood,$cid $+ $nick $+ $chan)
    if (!%kutya) { %kutya = 1 }
    else { inc %kutya 1 }
    if (%kutya >= %max_csati) {
      if (%flooddetekt_csatikra) && ($chan isin %flooddetekt_csatik) {
        echo $color(other) -tg $chan *** $nick floodolt!
      }
      if (!%flooddetekt_csatikra) {
        echo $color(other) -tg $chan *** $nick floodolt!
      }

      if (%flooddetekt_csatikra) && ($chan !isin %flooddetekt_csatik) {
        goto nem
      }
      if ($me isop $chan) {
        if ($nick isop $chan) && (!%kick_oposokat) { goto nem }
        if ($nick isvoice $chan) && (!%kick_voiceosokat) { goto nem }

        if (%ban_csati) { .timer 1 0 /kickban $chan $nick flood }
        elseif (%kick_csati) {
          .timer 1 0 /kick $chan $nick flood
        }
      }
      :nem
      .hdel flood $cid $+ $nick $+ $chan
      halt
    }
    .hadd -u $+ %time_csati flood $cid $+ $nick $+ $chan %kutya
  }
  /halt
}

on ^1:TEXT:*:?:{
  /haltdef
  var %tempszoveg $1-
  ; webchat unicode karakterek
  %tempszoveg = $replace($1-,√ú,‹,√ü,¸,√≥,Û,≈,ı,√∫,˙,√ä,È,√•,·,≈π,˚,√≠,Ì,√°,·,√ñ,÷,√ì,”,√â,…,√Å,¡,ı∞,€,√ç,Õ,√©,È,ı±,˚,√º,¸,√∂,ˆ,√ö,⁄,ıë,ı,ıê,’)
  ; bitlbee
  if (%tempszoveg == <<bitlbee>> $+ $chr(32) $+ *** $+ $chr(32) $+ This $+ $chr(32) $+ conversation $+ $chr(32) $+ has $+ $chr(32) $+ timed $+ $chr(32) $+ out. $+ $chr(32) $+ ***) {
    halt
  }
  ; psybnc check
  if ($nick = -psyBNC) {
    /window @psyBNC Fixedsys
    if ( PLAYPRIVATELOG isin $1- ) { .timer 1 0 /psybnc -youhave | halt }
    if ( /DCCGET isin $1- ) {
      if ( $?!="Fogadod a f·jlt amit $1 k¸ld neked? ( $+ $left($10,$calc($len($1-)-1)) $+ )" = $true ) { .timer 1 0 .quote dccget $1 $14 }
      halt
    }
    if ( file isin $1- ) && ( from isin $1- ) && ( received isin $1- ) {
      if ( $?!="Letˆltˆd a f·jlt a psyBNC-rıl? ( $+ $left($6,$calc($len($1-)-1)) $+ )" = $true ) { .timer 1 0 .quote dccsendme $6 }
      halt
    }
    /echo $color(normal) @psyBNC %tempszoveg 
    /window -c -psyBNC 
    /halt
  }
  ; urlek kiemelese
  if (%url_kiemeles) {
    var %i = $len(%tempszoveg)
    while (%i > 0) {
      if ((http:// isin $gettok(%tempszoveg,%i,32)) || (ftp:// isin $gettok(%tempszoveg,%i,32)) || (https:// isin $gettok(%tempszoveg,%i,32))) {
        ; ha van alahuzas, reverz, bold a kiemeles styleban, akkor azokat a kiemeles vegen ki kell kapcsolnunk
        var %url_kiemeles_unset
        if ( isin %url_kiemeles_style) { %url_kiemeles_unset = %url_kiemeles_unset $+  }
        if ( isin %url_kiemeles_style) { %url_kiemeles_unset = %url_kiemeles_unset $+  }
        if ( isin %url_kiemeles_style) { %url_kiemeles_unset = %url_kiemeles_unset $+  }
        if ( isin %url_kiemeles_style) { %url_kiemeles_unset = %url_kiemeles_unset $+  }
        %tempszoveg = $replace(%tempszoveg,$gettok(%tempszoveg,%i,32),%url_kiemeles_style $+ $gettok(%tempszoveg,%i,32) $+ %url_kiemeles_unset)
      }
      dec %i 1
    }
  }
  ; ¸zenet kiÌr·sa
  /echo $color(normal) -tm $nick %mas_bal $+  $+ $color(nick) $+ $nick $+ %mas_jobb $+  $+ $color(normal) %tempszoveg
  ; flash, csak akkor ha az illeto mar %flash_priviknel_timeout perce nem irt privat uzenetet
  var %lastmsg = $hget(lastmsg,$cid $+ $nick $+ privi)
  if ($calc($ctime - %lastmsg) > %flash_priviknel_timeout) || (!%lastmsg) {
    if (!$appactive) {
      if (%flash_priviknel) { /flash %flash_priviknel_szoveg }
      if (%beep_priviknel) {
        if ($os == 95) || ($os == 98) || ($os == me) { /beep 2 100 }
        else {
          if (!%beep_priviknel_winamp) || ($dll(system/netz.dll, winamp, GetCurrentWinampSong) == 0) { /beep 2 100 }
          else {
            if ($dll(system\netz.dll, winamp, isplaying)) { /beep 2 100 }
          }
        }
      }
      if (%pcspeaker_priviknel) { /netzbeep query }
    }
  }
  ; lastmsg (idle detekt)
  .hadd lastmsg $cid $+ $nick $ctime
  .hadd lastmsg $cid $+ $nick $+ privi $ctime
  /idlecheck
  /halt
}
;END

;ONDCC
on 1:FILERCVD:*.*: {
  /echo $color(info) -atg *** Megjˆtt $laz($nopath($filename)) $nopath($filename) $+  $+ $color(nick) $nick $+  $+ $color(info) $+ $toldalek($nick,-tÛl,-tıl) $+ !
  ; ha kepet, filmet, zenet toltottunk le, nezoke elinditasat felkinaljuk
  if (.jpg isin $nopath($filename)) || (.jpeg isin $nopath($filename)) || (.gif isin $nopath($filename)) || (.png isin $nopath($filename)) || (.bmp isin $nopath($filename)) || (.mpg isin $nopath($filename)) || (.mpeg isin $nopath($filename)) || (.avi isin $nopath($filename)) || (.wmv isin $nopath($filename)) || (.mov isin $nopath($filename)) || (.mp3 isin $nopath($filename)) || (.wav isin $nopath($filename)) || (.ogg isin $nopath($filename)) || (.txt isin $nopath($filename)) || (.pdf isin $nopath($filename)) || (.exe isin $nopath($filename)) || (.mpe isin $nopath($filename)) {
    echo $color(info) -atng *** F8 - $nopath($filename) megnyit·sa
    .hdel data $cid $+ doit $+ $replace($active,Status Window,status)
    .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /run $filename
  }
  halt
}
on 1:FILESENT:*: { /echo $color(info) -atg *** ¡tment $laz($nopath($filename)) $nopath($filename) $+  $+ $color(nick) $nick $+  $+ $color(info) $+ $toldalek($nick,-nak,-nek) $+ ! | halt }
on 1:SENDFAIL:*: { echo $color(info2) -atg *** Nem siker¸lt elk¸ldeni $+  $+ $color(nick) $nick $+  $+ $color(info2) $+ $toldalek($nick,-nak,-nek) $laz($nopath($filename)) $nopath($filename) f·jlt! | /halt }
on 1:GETFAIL:*: { echo $color(info2) -atg *** Nem siker¸lt fogadni $laz($nopath($filename)) $nopath($filename) f·jlt $+  $+ $color(nick) $nick $+  $+ $color(info2) $+ $toldalek($nick,-tÛl,tıl) $+ ! | /halt }
;END
