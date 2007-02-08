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

;EGYÉB PARANCSOK
/flashbang { /say 0,8FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG FLASHBANG }
/slap /me slaps $$1 around a bit with a large trout
/on /orignick
/ig /ignore $$1-
/unig /ignore -r $$1-
/unignore /ignore -r $$1-
/kb /kickban $$1-
/motd { if (!%motd_kiiras) { %motd_kiir = 1 } | .raw motd }
/lusers { if (!%lusers_kiiras) { %lusers_kiir = 1 } | .raw lusers }
/whois { if (!$1) { /echo $color(info2) -atng *** /whois hiba: túl kevés paraméter! használat: /whois [nick] | halt } | %whois_ablak = $active | /whois $1 $1 }
/w /whois $$1
/whowas { if (!$1) { /echo $color(info2) -atng *** /whowas hiba: túl kevés paraméter! használat: /whowas [nick] | halt } | %whois_ablak = $active | .raw whowas $1 $1 }
/ww /whowas $$1
/me {
  if ($1 == $null) {
    .raw PRIVMSG $active : $+ $chr(1) $+ ACTION  $+ $chr(1)
    echo $color(action) -tnm $active * $me | .hadd lastmsg $cid $+ $me $ctime | /idlecheck
  }
  else { .describe $active $1- }
}
/describe { echo $color(action) -tnm $1 * $me $2- | .describe $1- | .hadd lastmsg $cid $+ $me $ctime | /idlecheck }
/whoami /echo $color(info) -atng *** A nicked: $me
/ip /echo $color(info) -atng *** Az IP címed: $ip | /clipboard $ip
/host /echo $color(info) -atng *** A hostod: $host | /clipboard $host
/version /ctcp $$1 version
/sa /server atw.irc.hu
/sh /server hub.irc.hu
/ss /server sote.irc.hu
/sx /server extra.irc.hu
/se /server elte.irc.hu
/si /server irc.hu
/sl /server localhost
/s /server $$1-
/sm {
  if (!$1) { echo $color(info2) -atng *** /sm hiba: kevés paraméter! használat: /sm [szerver] | halt }
  /server -m $$1-
}
/sn /server -n
/op /mode # +ooo $$1 $2 $3
/dop /mode # -ooo $$1 $2 $3
/deop /mode # -ooo $$1 $2 $3
/voice /mode # +vvv $$1 $2 $3
/devoice /mode # -vvv $$1 $2 $3
/network /echo $color(info) -atng *** Aktív irc hálózat: $network
/cid /echo $color(info) -atng *** Connection ID: $cid
/j /join $$1-
/p /part # $1-
/n /nick $$1
/m /mode $$1-
/k /kick # $$1 $2-
/q /query $$1
/send /dcc send $$1 $$2-
/chat /dcc chat $$1
/ping /ctcp $$1 ping
/paint /run mspaint
/emailer {
  if (!%emailezo_prog) { /mailsetup }
  else { /run %emailezo_prog }
}
/page /ctcp $$1 page
/awaysetup { /setup | /did -f setupdialog 2 }
/uptime {
  if (%uptime_meres) { /tuptime }
  echo $color(info) -atng * online time: $hossz($uptime(server,3))
  echo $color(info) -atng * system uptime: $hossz($uptime(system,3))

  if (%uptime_record_date != $null) {
    var %urecd
    %urecd = ( $+ $asctime(%uptime_record_date) $+ )
  }

  if (%uptime_record != $null) { echo $color(info) -atng * system uptime rekord: $hossz(%uptime_record) %urecd }
}
;END

;ALAP PARANCSOK
/join {
  if (!$1) { /echo $color(info2) -atng *** /join hiba: túl kevés paraméter! használat: /join (paraméterek) [csati] (pass) | halt }
  if (!$server) { /echo $color(info2) -atng *** /join hiba: nem kapcsolódtál egy szerverhez sem! | halt }
  var %param
  var %cs $1
  var %pass $2-
  if ($1 == -n) { %param = -n | %cs = $2 | %pass = $3- }
  ; ha hianyzik a # vagy a ! vagy a & a csati elejerol akkor odateszunk egy #-t
  if ($left(%cs,1) != $chr(35)) && ($left(%cs,1) != $chr(33)) && ($left(%cs,1) != $chr(38)) { %cs = $chr(35) $+ %cs }
  /join %param %cs %pass
}
/topic {
  if (!$1) {
    if ($active = Status Window) { /echo $color(info2) -atng *** /topic hiba: a státusz ablakban nincs topic! | halt }
    if ($active !ischan) { halt }
    /topic $active
  }
  if ($1 ischan) { /topic $1- }
  else {
    if ($active = Status Window) { /echo $color(info2) -atng *** /topic hiba: a státusz ablakban nem tudsz topicot váltani! | halt }
    if ($active !ischan) { halt }
    /topic $active $1-
  }
}
/ctcp {
  if (!$2) { /echo $color(info2) -atng *** /ctcp hiba: túl kevés paraméter! használat: /ctcp [nick|csati] [msg] | halt }
  if ($1 ischan) { /echo $color(ctcp) -tgq $1 *** Ctcp $laz($1) $1 $+ $toldalek($1,-ra,-re) $+ : $2- }
  else { /echo $color(ctcp) -atngq *** CTCP $1 $+ $toldalek($1,-nak,-nek) $+ : $2- }
  ; ping eseten nem a szokasos $ctimeot kuldjuk, hanem a $tickset, hogy pontosabb legyen a meres
  if ($2 == ping) { .raw PRIVMSG $1 : $+ $chr(1) $+ PING $ticks $+ $chr(1) }
  else { .ctcp $1 $2- }
}
/query {
  if (!$1) { /echo $color(info2) -atng *** /query hiba: túl kevés paraméter! használat: /query [nick] (msg) | halt }

  ; ha meg nincs megnyitva az ablak
  if ($window($1) == $null) {
    /query $1

    if (%getlog) { /getlog $1 }
    /echo $color(background) -ng $1 -
    var %greet $read(system\greetings.txt)
    .hadd data $cid $+ koszones $+ $1 %greet
    /echo $color(info) -tng $1 *** Köszönés: F7 - %greet

    ; hatterbe kiirjuk query nevet
    if (%wndback) { wndback $nick }
  }
  else {
    /query $1
  }
}
/autoaway {
  if (%autoaway_hasznalat) && (!$away) {
    %autoaway = 1
    ; ha kell, minden kapcsolaton kapcsoljuk az awayt
    if (%aaway_f10) { /aaway }
    else { /away }
  }
}
/away {
  if (!$away) && (!$1) { /away gone }
  else { /away $1- }
}
/aaway {
  if ($away) { /scon -at1 /away }
  else {
    if (!$1) { /scon -at1 /away gone }
    else { var %tmp = $1- | /scon -at1 /away %tmp }
  }

}
/who {
  if (!$1) { /echo $color(info2) -atng *** /who hiba: túl kevés paraméter! használat: /who [nick|csati] | halt }
  /echo $color(background) -qag - | /echo $color(other) -qag *** who $1- ***
  /who $1-
}
/anick {
  if ($1 == $null) { /echo $color(info2) -atng *** /nick hiba: túl kevés paraméter! használat: /nick [új nick] | halt }
  if ($1 === $anick) { /echo $color(info2) -atngq *** /anick hiba: az alternatív nicked jelenleg is $anick $+ ! | halt }
  /echo $color(info) -atngq *** Alternatív nicked: $+ $color(nick) $1
  .anick $1
}
/nick {
  if ($1 == $null) { /echo $color(info2) -atng *** /nick hiba: túl kevés paraméter! használat: /nick [új nick] | halt }
  if ($$1 === $me) { /echo $color(info2) -atngq *** /nick hiba: a nicked jelenleg is $me $+ ! | halt }
  if ($timer(OrigNick $+ $cid).type) {
    /echo $color(info2) -atngq *** Figyelem: az OrigNick aktív $laz(%orig_nick) %orig_nick nickre! (F8 - kikapcsolás)
    .hdel data $cid $+ doit $+ $replace($active,Status Window,status)
    .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /orignick off
  }
  /nick $$1
}
/kickban {
  if (!$1) { /echo $color(info2) -atng *** /kickban hiba: túl kevés paraméter! használat: /kickban (csati) [nick|host] (indok) | halt }
  if ($1 ischan) {
    var %comment $3-
    if (!%comment) { %comment = kickban! netZ $+ %ver }
    /ban -k $1 $2 2 %comment
  }
  else {
    var %comment $2-
    if (!%comment) { %comment = kickban! netZ $+ %ver }
    /ban -k $1 2 %comment
  }
}
/kick {
  if (!$1) {
    echo $color(info2) -atng *** /kick hiba: kevés paraméter! használat: /kick (csati) [nick] (indok)
    return
  }
  if ($1 ischan) {
    var %comment $3-
    if (!%comment) { %comment = kicked! netZ $+ %ver }
    /kick $1 $2 %comment
  }
  else {
    if ($active !ischan) { echo $color(info2) -atng *** /kick hiba: a parancsot csati ablakban használd, vagy add meg melyik csatira vonatkozzon! | halt }
    var %comment $2-
    if (!%comment) { %comment = kicked! netZ $+ %ver }
    /kick $active $1 %comment
  }
}
/notice {
  if ($2 == $null) {
    echo $color(info2) -atng *** /notice hiba: kevés paraméter! használat: /notice [nick] [msg]
    return
  }
  var %i 1
  :loop
  ; ha van megfelelo ablak akkor abba irjuk a noticet
  if ( $chat(%i) == $remove($1,=) ) || ( $query(%i) == $1 ) { /echo $color(notice) -tm $1 -n-o-t-i-c-e-> $2- | .notice $1- | return }
  if (%i >= $query(0)) && (%i >= $chat(0)) {
    ; egyebkent meg az aktiv ablakba irjuk
    /echo $color(notice) -atngm -n-o-t-i-c-e-> - $+ $1 $+ - $2-
    .notice $1-
    return
  }
  inc %i
  goto loop
  :exit
}
/ame {
  var %i 0
  while (%i < $chan(0)) { inc %i 1 | .describe $chan(%i) $1- }
}
/amsg {
  var %i 0
  while (%i < $chan(0)) { inc %i 1 | /msg $chan(%i) $1- }
}
/msg {
  if ($2 == $null) {
    echo $color(info2) -atng *** /msg hiba: kevés paraméter! használat: /msg [nick|csati] [msg]
    return
  }
  if ($1 == Status) && ($2 == Window) {
    echo $color(info2) -atng *** /msg hiba: a status windowba nem tudsz üzenni!
    return
  }
  var %i 1
  :loop
  ; ha van megfelelo ablak akkor abba irjuk az msgt
  if ( $chan(%i) == $1 ) || ( $chat(%i) == $remove($1,=) ) || ( $query(%i) == $1 ) { /echo $color(own) -tm $1 %en_bal $+  $+ $color(nick) $+ $me $+ %en_jobb $+  $+ $color(own) $2- | .msg $1- | return }
  if (%i >= $chan(0)) && (%i >= $query(0)) && (%i >= $chat(0)) {
    ; egyebkent meg az aktiv ablakba irjuk
    /echo $color(notice) -atngm -m-s-g-> - $+ $1 $+ - $2-
    .msg $1 $2-
    return
  }
  inc %i
  goto loop
}
/say {
  if ($1 == $null) {
    echo $color(info2) -atng *** /say hiba: kevés paraméter! használat: /say [msg]
    return
  }
  if ($active == Status Window) {
    echo $color(info2) -atng *** /say hiba: a status windowba nem tudsz üzenni!
    return
  }
  .msg $active $1-
}
;END

;INZULTÁLÁS
/insult {
  if (!$1) { echo $color(info2) -atng *** /insult hiba: kevés paraméter! használat: /insult [nick] | halt }
  var %szoveg = $read(system\insult.txt)
  %szoveg = $lower($left(%szoveg,1)) $+ $right(%szoveg,$calc($len(%szoveg) - 1))
  /msg $active $1 $+ : %szoveg
}
/insultquery {
  if (!$1) { echo $color(info2) -atng *** /insult hiba: kevés paraméter! használat: /insult [nick] | halt }
  var %szoveg = $read(system\insult.txt)
  %szoveg = $lower($left(%szoveg,1)) $+ $right(%szoveg,$calc($len(%szoveg) - 1))
  /msg $active %szoveg
}
;END

;HOP
/cycle { /hop 1 }
/hop {
  if (!$1) || (($2) && ($1 !ischan)) || (($1 ischan) && (!$2)) { /echo $color(info2) -atng *** /hop hiba: túl kevés paraméter! használat: /hopchan (csati) [cyclek száma] | return }
  var %cyclec = 0
  var %csati
  var %cyclenum
  if ($1 ischan) { %csati = $1 | %cyclenum = $2 }
  else {
    if ($active !ischan) { /echo $color(info2) -atng *** /hop hiba: a parancsot csati ablakban használd! | return }
    %csati = $active | %cyclenum = $1
  }
  while (%cyclec < %cyclenum) {
    .raw -q part %csati
    .raw -q join %csati
    inc %cyclec 1
  }
}
;END

;RANDOMNICK
/rnick {
  var %rtz
  if (!$1) { %rtz = 1 }
  else { %rtz = $1 }
  var %i 0
  while (%i < %rtz) {
    /nick $rand(A,Z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z) $+ $rand(a,z)
    inc %i 1
  }
}
;END

;CLICKZ
/statusclick { ; kattintas a status windowban
  if (!$server) { /server %legutobbiszerver1 | /halt }
  /lusers
}
;END

;CONVERT
/convert {
  if (!$1) { echo $color(info2) -atng *** /convert hiba: túl kevés paraméter! használat: /convert [ip|longip] | halt }
  /echo $color(info) -atng *** $1 --> $longip($1)
  /clipboard $longip($1)
}
;END

;SHOWQ
/showq {
  /echo $color(info) -atng *** A quit messaged: %quitmessage
}
;END

;DOMAIN
/domain {
  if (!$1) { /echo $color(info2) -atng *** /domain hiba: túl kevés paraméter. használat: /domain [domain(pl. hu)] | halt }
  var %orszag = $read -s $+ $right($1,2) system\domains.txt
  if ( %orszag = $null ) { %orszag = N/A }
  /echo $color(info) -atng *** Domain keresés: $right($1,2) $+ : %orszag
}
;END

;I-TIME
/itime {
  var %ora = $asctime(HH)
  var %perc = $asctime(nn)
  var %mp = $asctime(ss)
  var %ora2 = $calc( %ora * 60  * 60 * 1000 )
  var %perc2 = $calc( %perc *60 * 1000 )
  var %mp2 = $calc( %mp * 1000 )
  var %ossz = $calc( %ora2 + %perc2 + %mp2 )
  var %oszt = $calc( 400 + 26000 + 60000 )
  var %szam0 = %ossz / %oszt
  if (!$1) { /echo $color(info) -atngq *** Internet idõ: @ $+ $int(%szam0) }
  return $int(%szam0)
}
;END

;MERET
/meret {
  if (!$1) { var %mi 0 byte }
  else { var %mi $1 byte }
  if ($1 >= 1024) { %mi = $round($calc($1 / 1024),2) $+ kb }
  if ($1 >= 1048576) { %mi = $round($calc($1 / 1024 / 1024),2) $+ mb }
  if ($1 >= 1073741824) { %mi = $round($calc($1 / 1024 / 1024 /1024),2) $+ gb }
  return %mi
}
;END

;HOSSZ
/hossz {
  var %uptc $duration($1)
  var %helyperc $chr(32) $+ perc
  %uptc = $replace(%uptc,mins,%helyperc)
  %uptc = $replace(%uptc,min,%helyperc)
  %uptc = $replace(%uptc,percs,%helyperc)
  %helyperc = $chr(32) $+ másodperc
  %uptc = $replace(%uptc,secs,%helyperc)
  %uptc = $replace(%uptc,sec,%helyperc)
  %uptc = $replace(%uptc,másodpercs,%helyperc)
  %helyperc = $chr(32) $+ óra
  %uptc = $replace(%uptc,hr,%helyperc)
  %uptc = $replace(%uptc,hrs,%helyperc)
  %uptc = $replace(%uptc,óras,%helyperc)
  %helyperc = $chr(32) $+ nap
  %uptc = $replace(%uptc,day,%helyperc)
  %uptc = $replace(%uptc,days,%helyperc)
  %uptc = $replace(%uptc,naps,%helyperc)
  %helyperc = $chr(32) $+ hét
  %uptc = $replace(%uptc,wks,%helyperc)
  %uptc = $replace(%uptc,wk,%helyperc)
  %uptc = $replace(%uptc,héts,%helyperc)
  return %uptc
}
;END

;AMÕBA/SAKK
/amoba {
  if (!$1) { echo $color(info2) -atng *** /amoba hiba: túl kevés paraméter! használat: /amoba [nick] | halt }
  /run system\5inrow.exe | .ctcp $1 5inrow $ip
  echo $color(info) -atng *** Amõba kérés elküldve $1 $+ $toldalek($1,-nak,-nek) $+ .
}
/sakk {
  if (!$1) { echo $color(info2) -atng *** /sakk hiba: túl kevés paraméter! használat: /sakk [nick] | halt }
  /run system\chess.exe | .ctcp $1 chess $ip
  echo $color(info) -atng *** Sakk kérés elküldve $1 $+ $toldalek($1,-nak,-nek) $+ .
}
;END

;HEXTOIP
/hextoipc {
  if (!$1) { echo $color(info2) -atng *** /hextoipc hiba: túl kevés paraméter! használat: /hextoipc [hexadecimálisan kódolt ip] | halt }
  var %i 2
  var %hexszam
  var %ip
  while (%i <= 8) {
    %hexszam = $right($left($1,%i),2)
    %ip = %ip $+ $base(%hexszam,16,10) $+ .
    inc %i 2
  }
  ; vegerol a pontot levagjuk
  return $left(%ip,$calc($len(%ip)-1))
}
/hextoip {
  if (!$1) { echo $color(info2) -atng *** /hextoip hiba: túl kevés paraméter! használat: /hextoip [hexadecimálisan kódolt ip] | halt }
  /echo $color(info) -atngq *** $1 $+ : $hextoipc($1)
}
;END

;IDLECHECK (nick szinezes idletol fuggoen)
/idlecheck {
  var %csatinum $chan(0)
  while (%csatinum > 0) {
    var %nicknum $line($chan(%csatinum),0,1)
    while (%nicknum > 0) {
      var %lastmsg = $hget(lastmsg,$cid $+ $line($chan(%csatinum),%nicknum,1))
      ; nincs idle alapu szinezes
      if (!%idleszin_hasznalat) { cline %idleszin_0perce $chan(%csatinum) %nicknum }
      else {
        ; ismeretlen idle
        if (!%lastmsg) || ($calc($ctime - %lastmsg) < 0) { cline %idleszin_20perce $chan(%csatinum) %nicknum | .hadd lastmsg $cid $+ $line($chan(%csatinum),%nicknum,1) $calc($ctime - 1800) }
        ; 60 perce idlek
        elseif ($calc($ctime - %lastmsg) > 2400) {
          if (%idleszin_60perce_hasznalat) { cline %idleszin_60perce $chan(%csatinum) %nicknum }
          else { cline %idleszin_40perce $chan(%csatinum) %nicknum }
        }
        ; 40 perce idlek
        elseif ($calc($ctime - %lastmsg) > 1800) { cline %idleszin_40perce $chan(%csatinum) %nicknum }
        ; 20 perce idlek
        elseif ($calc($ctime - %lastmsg) > 1200) { cline %idleszin_20perce $chan(%csatinum) %nicknum }
        ; 10 perce idlek
        elseif ($calc($ctime - %lastmsg) > 600) { cline %idleszin_10perce $chan(%csatinum) %nicknum }
        ; kevesebb mint 10 perce idlek (itt vannak)
        else { cline %idleszin_0perce $chan(%csatinum) %nicknum }
      }
      dec %nicknum 1
    }
    dec %csatinum 1
  }
}
;END

;HOTKEYS
/f1 {
  /window -ak0 @hotkeys Fixedsys
  /echo $color(background) @hotkeys -
  /echo @hotkeys *** netZ Script Pro %ver HotKeys
  /echo $color(background) @hotkeys -
  /echo @hotkeys *** F2 - Connect to %legutobbiszerver1
  /echo @hotkeys *** F4 - Winamp kijelzés (/wp)
  /echo @hotkeys *** F5 - Email check (/checkmail)
  /echo @hotkeys *** F6 - Email setup (/mailsetup)
  /echo @hotkeys *** F7 - Köszönés
  /echo @hotkeys *** F8 - "Action Button"
  /echo @hotkeys *** F9 - Awaysetup (/awaysetup)
  /echo @hotkeys *** F10 - Away ON/OFF
  /echo @hotkeys *** F11 - FTP szerver indítása
  /echo @hotkeys *** F12 - netZ Script Pro Setup
  /echo @hotkeys *** CTRL+F3 - Új netZ Script Pro indítása
  /echo $color(background) @hotkeys -
}
/f2 {
  if (!$server) { /server %legutobbiszerver1 }
  else {
    var %i 1
    var %cs $gettok(%kedvenc_csatik,1,32)
    while (%cs) {
      /join %cs
      inc %i 1
      %cs = $gettok(%kedvenc_csatik,%i,32)
    }
  }
}
/f4 { /wp }
/f6 { /mailsetup }
/f5 { /checkmail }
/f7 {
  if ($active == Status Window) { halt }
  var %greet = $hget(data,$cid $+ koszones $+ $active)
  if (%greet) {
    /say %greet
    .hdel data $cid $+ koszones $+ $active
  }
}
/f8 {
  var %ablak $active
  if ($active == Status Window) { %ablak = status }
  var %mit = $hget(data,$cid $+ doit $+ %ablak)
  if (%mit) { .timer 1 0 %mit }
  ;.hdel data $cid $+ doit $+ %ablak
}
/f9 { /awaysetup }
/f10 {
  if (%aaway_f10) { /aaway }
  else { /away }
}
/f11 { /run system\guildftpd\guildftpd.exe }
/f12 { /setup }
/cf3 {
  .run mirc.exe
  /echo $color(info) -atng *** Új netZ Script Pro betöltve.
}  
;END

;HIGHLIGHT_OK
/highlight_ok {
  ; megnezi hogy a parameterkent megadott szovegben benne van-e legalabb 1, a %highlight_szavak
  ; valtozo altal tarolt szoreszlet
  var %i = $numtok(%highlight_szavak,32)
  while (%i > 0) {
    if ($gettok(%highlight_szavak,%i,32) isin $1-) { return 1 }
    dec %i 1
  }

  ; levagjuk a szamokat, specko karaktereket a nick vegerol, majd ellenorizzuk hogy bennt van-e
  ; ez a parameterkent megadott szovegben
  var %n = $remove($me,^,°,`,´,_,$chr(91),$chr(93),$chr(123),$chr(125),0,1,2,3,4,5,6,7,8,9)
  ; csak akkor vizsgalodunk, ha a maradek szoveg legalabb 3 karakteres (nem jo ha minden z
  ; beture highlightolunk pl.)
  if ($len(%n) >= 3) && (%n isin $1-) { return 1 }

  return 0
}

;UPTIME RECORD MÉRÕ
/tuptime {
  if (%uptime_record == $null) {
    %uptime_record = $uptime(system,3)
    %uptime_noticed = 1
    tuptimeinit
    return
  }

  if ($uptime(system,3) > %uptime_record) {
    %uptime_record = $uptime(system,3)
    %uptime_record_date = $ctime

    if (!%uptime_noticed) && (%uptime_notice_newrecord) {
      /echo $color(highlight) -atng *** Új uptime rekord: $hossz($uptime(system,3))
      %uptime_noticed = 1
    }
  }
  else {
    %uptime_noticed = 0
    tuptimeinit
  }

  if (!%uptime_notice) { return }

  if ($calc($uptime(system,3)/86400) > 30) {
    if (!%uptime_noticed_30) {
      /echo $color(highlight) -atng *** Uptime: a rendszer már 1 hónapja megy!
      %uptime_noticed_30 = 1
      return
    }
  }

  if ($calc($uptime(system,3)/86400) > 15) {
    if (!%uptime_noticed_15) {
      /echo $color(highlight) -atng *** Uptime: a rendszer már 15 napja megy!
      %uptime_noticed_15 = 1
      return
    }
  }

  if ($calc($uptime(system,3)/86400) > 7) {
    if (!%uptime_noticed_7) {
      /echo $color(highlight) -atng *** Uptime: a rendszer már 1 hete megy!
      %uptime_noticed_7 = 1
      return
    }
  }

  if ($calc($uptime(system,3)/86400) > 5) {
    if (!%uptime_noticed_5) {
      /echo $color(highlight) -atng *** Uptime: a rendszer már 5 napja megy!
      %uptime_noticed_5 = 1
      return
    }
  }

  if ($calc($uptime(system,3)/86400) > 2) {
    if (!%uptime_noticed_2) {
      /echo $color(highlight) -atng *** Uptime: a rendszer már 2 napja megy!
      %uptime_noticed_2 = 1
      return
    }
  }

  if ($calc($uptime(system,3)/86400) > 1) {
    if (!%uptime_noticed_1) {
      /echo $color(highlight) -atng *** Uptime: a rendszer már 1 napja megy!
      %uptime_noticed_1 = 1
      return
    }
  }
}

/tuptimeinit {
  if ($calc($uptime(system,3)/86400) > 30) {
    %uptime_noticed_1 = 1
    %uptime_noticed_2 = 1
    %uptime_noticed_5 = 1
    %uptime_noticed_7 = 1
    %uptime_noticed_15 = 1
    %uptime_noticed_30 = 1
    return
  }
  if ($calc($uptime(system,3)/86400) > 15) {
    %uptime_noticed_1 = 1
    %uptime_noticed_2 = 1
    %uptime_noticed_5 = 1
    %uptime_noticed_7 = 1
    %uptime_noticed_15 = 1
    %uptime_noticed_30 = 0
    return
  }
  if ($calc($uptime(system,3)/86400) > 7) {
    %uptime_noticed_1 = 1
    %uptime_noticed_2 = 1
    %uptime_noticed_5 = 1
    %uptime_noticed_7 = 1
    %uptime_noticed_15 = 0
    %uptime_noticed_30 = 0
    return
  }
  if ($calc($uptime(system,3)/86400) > 5) {
    %uptime_noticed_1 = 1
    %uptime_noticed_2 = 1
    %uptime_noticed_5 = 1
    %uptime_noticed_7 = 0
    %uptime_noticed_15 = 0
    %uptime_noticed_30 = 0
    return
  }
  if ($calc($uptime(system,3)/86400) > 2) {
    %uptime_noticed_1 = 1
    %uptime_noticed_2 = 1
    %uptime_noticed_5 = 0
    %uptime_noticed_7 = 0
    %uptime_noticed_15 = 0
    %uptime_noticed_30 = 0
    return
  }
  if ($calc($uptime(system,3)/86400) > 1) {
    %uptime_noticed_1 = 1
    %uptime_noticed_2 = 0
    %uptime_noticed_5 = 0
    %uptime_noticed_7 = 0
    %uptime_noticed_15 = 0
    %uptime_noticed_30 = 0
    return
  }
  %uptime_noticed_1 = 0
  %uptime_noticed_2 = 0
  %uptime_noticed_5 = 0
  %uptime_noticed_7 = 0
  %uptime_noticed_15 = 0
  %uptime_noticed_30 = 0
}
;END

;ENCODE/DECODE
/enkod {
  return $dll(system\netz.dll,enkod,$1-)
}

/dekod {
  return $dll(system\netz.dll,dekod,$1-)
}
;END

;VIEWLOG
/viewlog {
  ;megnezzuk hogy letezik-e a log
  if ($exists($logdir $+ # $+ .log)) { /run $logdir $+ # $+ .log | return }
  ;ha nem, megprobaljuk megnyitni ugy hogy a network is benne van a pathban
  if ($exists($logdir $+ $network $+ \ $+ # $+ .log)) { /run $logdir $+ $network $+ \ $+ # $+ .log | return }
  /echo $color(info2) -atng *** /viewlog hiba: az aktív ablakhoz nincs log fájl!
}
;END
