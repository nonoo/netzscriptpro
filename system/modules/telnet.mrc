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

;TELNETSERVER
alias /ts /telnetserver $$1-
alias /telnetserver {
  if (!$1) { echo $color(info2) -atng *** /telnetserver hiba: túl kevés paraméter! használat: /telnetserver [port] (bind ip) | halt }
  var %telnetablak @tserv: $+ $1
  var %socknev tserv_ $+ $1

  ; ha mar van nyitva ijen telnetserver ablak, eloterbe hozzuk
  if ($window(%telnetablak)) {
    /window -a %telnetablak
    ; ha aktiv a socket, csak siman eloterbe hozzuk az ablakot
    if ($sock(%socknev)) { halt }
  }
  else {
    ; ha nincs meg nyitott ablak
    sockclose %socknev
    /window -ek0 %telnetablak Fixedsys
    /wndback %telnetablak
    var %bindip $2
    if ($2) { %bindip = bind ip: $2 }
    echo $color(info) -tng %telnetablak *** netZ telnetserver: $+ $color(nick) port $1 %bindip
    echo $color(background) -ng %telnetablak -
    echo $color(info) -tng %telnetablak *** CRLF a sorok végére: %telnetcrlf (/crlf [1/0/status])
    echo $color(info) -tng %telnetablak *** Helyi visszhang: %telnetlecho (/lecho [1/0])
  }
  echo $color(background) -ng %telnetablak -
  echo $color(nick) -nt %telnetablak *** Figyelés megkezdése: port $1
  [ % $+ [ telnetcrlf $+ [ %socknev ] ] ] = %telnetcrlf
  [ % $+ [ telnetlecho $+ [ %socknev ] ] ] = %telnetlecho
  if ($2) { /socklisten -d $2 %socknev $1 }
  else { /socklisten %socknev $1 }
}

on *:socklisten:tserv_*: {
  var %telnetablak @ $+ $replace($sockname,_,:)
  ; keresunk egy szabad socket szamot (nevet)
  var %i 0
  while ($sock($sockname $+ _ $+ %i)) { inc %i 1 }

  /sockaccept $sockname $+ _ $+ %i
  echo $color(info) -t %telnetablak *** $sock($sockname $+ _ $+ %i).ip kapcsolódott!
}

alias /closetelnetserverwindow {
  var %socknev $remove($replace($1,:,_),@)
  sockclose %socknev $+ *
  unset % $+ [ telnetcrlf $+ [ %socknev ] ]
  unset % $+ [ telnetlecho $+ [ %socknev ] ]
}

on *:close:@tserv*: { /closetelnetserverwindow $target }

on *:sockclose:tserv_*: {
  var %telnetablak @tserv: $+ $gettok($replace($sockname,_,:),2,58)
  echo $color(info) -t %telnetablak *** $sock($sockname).ip megszakította a kapcsolatot.
}

on *:sockwrite:tserv_*: {
  var %telnetablak @tserv: $+ $gettok($replace($sockname,_,:),2,58)
  if ($sockerr) { echo $color(info2) -t %telnetablak *** Socket hiba! }
  halt
}

on *:sockread:tserv_*: {
  var %telnetablak @tserv: $+ $gettok($replace($sockname,_,:),2,58)
  var %tmp
  :ujraolvas
  /sockread -f %tmp
  if (!$sockbr) { return }
  /echo $color(normal) -tm %telnetablak %mas_bal $+  $+ $color(nick) $+ $sock($sockname).ip $+ %mas_jobb $+  $+ $color(normal) %tmp
  goto ujraolvas
}

alias active_telnetserver_window_sockstatus {
  return $sock($remove($replace($active,:,_),@) $+ _*).status
}

alias listclients {
  if (tserv: !isin $active) { echo $color(info2) -atng *** A /listclients parancsot telnetserver ablakban használd! | halt }
  if (!$sock(tserv $+ _ $+ $gettok($active,2,58) $+ _*)) { echo $color(info2) -atng *** Nincsenek aktív kliensek ezen a kapcsolaton! | halt }
  var %i 0
  ; egyszerre maximum 255 kapcsolatot tudunk listazni
  while (%i < 255) {
    if ($sock(tserv $+ _ $+ $gettok($active,2,58) $+ _ $+ %i)) {
      echo $color(info) -atng *** $calc(%i + 1) $+ . $+ $color(nick) $sock(tserv $+ _ $+ $gettok($active,2,58) $+ _ $+ %i).ip
    }
    inc %i 1
  }
}

alias dropclient {
  if (tserv: !isin $active) { echo $color(info2) -atng *** A /dropclient parancsot telnetserver ablakban használd! | halt }
  if ($1 == $null) { echo $color(info2) -atng *** /dropclient hiba: túl kevés paraméter! Használat: /dropclient [kliens sorszáma] | halt }
  if (!$sock(tserv $+ _ $+ $gettok($active,2,58) $+ _*)) { echo $color(info2) -atng *** Nincsenek aktív kliensek ezen a kapcsolaton! | halt }
  if (!$sock(tserv $+ _ $+ $gettok($active,2,58) $+ _ $+ $calc($1 - 1))) { echo $color(info2) -atng *** Nincs $1 $+ . sorszámú aktív kliens ezen a kapcsolaton! | halt }
  echo $color(info) -at *** $sock(tserv $+ _ $+ $gettok($active,2,58) $+ _ $+ $calc($1 - 1)).ip lekapcsolva.
  sockclose tserv $+ _ $+ $gettok($active,2,58) $+ _ $+ $calc($1 - 1)
}

menu @tserv* {
  $iif($active_telnetserver_window_sockstatus,Minden kliens lekapcsolása) {
    var %socknev $remove($replace($active,:,_),@)
    sockclose %socknev $+ _*
    echo $color(info) -at *** Minden kliens lekapcsolva. 
  }
  $iif($active_telnetserver_window_sockstatus,Adott kliens lekapcsolása) { /dropclient $$?="Sorszám?" }
  -
  $iif($active_telnetserver_window_sockstatus,Kliensek listázása) { /listclients }
  -
  Ablak bezárása: { /closetelnetserverwindow $active | /window -c $active }
}

on 1:INPUT:@tserv*: {
  var %socknev $remove($replace($active,:,_),@)
  if ($left($1,1) = /) && (!$ctrlenter) {
    if ($1 = /lecho) {
      if ($2 = 1) {
        [ % $+ [ telnetlecho $+ [ %socknev ] ] ] = 1
        echo $color(info) -tng $target *** Helyi visszhang bekapcsolva.
        /halt
      }
      if ($2 = 0) {
        [ % $+ [ telnetlecho $+ [ %socknev ] ] ] = 0
        echo $color(info) -tng $target *** Helyi visszhang kikapcsolva.
        /halt
      }
      echo $color(info) -tng $target *** Helyi visszhang: [ % $+ [ telnetlecho $+ [ %socknev ] ] ]
      /halt
    }
    if ($1 = /crlf) {
      if ($2 = 1) {
        [ % $+ [ telnetcrlf $+ [ %socknev ] ] ] = 1
        echo $color(info) -tng $target *** CRLF a sorok végére bekapcsolva.
        /halt
      }
      if ($2 = 0) {
        [ % $+ [ telnetcrlf $+ [ %socknev ] ] ] = 0
        echo $color(info) -tng $target *** CRLF a sorok végére kikapcsolva.
        /halt
      }
      if ($2 == status) {
        echo $color(info) -tng $target *** CRLF a sorok végén: [ % $+ [ telnetcrlf $+ [ %socknev ] ] ] 
        /halt
      }
      sockwrite -n %socknev
      /halt
    }
  }
  else {
    if (!$sock(%socknev $+ _*).status) { echo $color(info2) -tng $target *** Nincs aktív kapcsolat! | /halt }
    if ($1- == $null) { halt }
    if ([ % $+ [ telnetlecho $+ [ %socknev ] ] ]) { echo $color(own) -tm $target %en_bal $+  $+ $color(nick) $+ $me $+ %en_jobb $+  $+ $color(own) $1- }
    if ([ % $+ [ telnetcrlf $+ [ %socknev ] ] ] == 0) { sockwrite %socknev $+ _* $1- }
    else { sockwrite -n %socknev $+ _* $1- }
  }
}
;END

;TELNET
alias /telnet {
  var %telnetssl = 0
  var %host $1
  var %port $2

  if ($1 == -ssl) {
    %telnetssl = 1
    %host = $2
    %port = $3
  }

  if (: isin %host) { %port = $gettok(%host,2,58) | %host = $gettok(%host,1,58) }
  if (!%host) || (!%port) { echo $color(info2) -atng *** /telnet hiba: túl kevés paraméter! használat: /telnet (-ssl) [host] [port] | halt }

  var %telnetablak
  var %socknev
  if ($1 == -ssl) {
    %telnetablak = @ $+ %host $+ : $+ %port $+ _telnetssl
    %socknev = %host $+ _ $+ %port $+ _ $+ telnetssl
  }
  else {
    %telnetablak = @ $+ %host $+ : $+ %port $+ _telnet
    %socknev = %host $+ _ $+ %port $+ _ $+ telnet
  }

  ; ha mar van nyitva ijen telnet kapcsolat ablak, eloterbe hozzuk
  if ($window(%telnetablak)) {
    /window -a %telnetablak
    ; ha aktiv a kapcsolat, csak siman eloterbe hozzuk az ablakot
    if ($sock(%socknev).status) { halt }
  }
  else {
    ; ha nincs meg nyitott ablak
    sockclose %socknev
    /window -ek0 %telnetablak Fixedsys
    /wndback %telnetablak
    echo $color(info) -tng %telnetablak *** netZ telnet: $+ $color(nick) %host $+ : $+ %port
    echo $color(background) -ng %telnetablak -
    echo $color(info) -tng %telnetablak *** CRLF a sorok végére: %telnetcrlf (/crlf [1/0/status])
    echo $color(info) -tng %telnetablak *** Helyi visszhang: %telnetlecho (/lecho [1/0])
    echo $color(info) -tng %telnetablak *** SSL: %telnetssl
  }
  echo $color(background) -ng %telnetablak -
  echo $color(nick) -nt %telnetablak *** Kapcsolódás...
  [ % $+ [ telnetcrlf $+ [ %socknev ] ] ] = %telnetcrlf
  [ % $+ [ telnetlecho $+ [ %socknev ] ] ] = %telnetlecho
  if (%telnetssl) {
    /sockopen -e %socknev %host %port
  }
  else {
    /sockopen %socknev %host %port
  }
}

on *:sockopen:*_telnet: {
  var %telnetablak @ $+ $remove($replace($sockname,_,:),:telnet) $+ _telnet
  if (!$sockerr) { /echo $color(nick) -t %telnetablak *** Kapcsolódva! }
  else { /echo $color(info2) -t %telnetablak *** Nem lehet kapcsolódni! }
}
on *:sockopen:*_telnetssl: {
  var %telnetablak @ $+ $remove($replace($sockname,_,:),:telnetssl) $+ _telnetssl
  if (!$sockerr) { /echo $color(nick) -t %telnetablak *** Kapcsolódva! }
  else { /echo $color(info2) -t %telnetablak *** Nem lehet kapcsolódni! }
}

alias active_telnet_window_sockstatus {
  return $sock($remove($replace($active,:,_),@)).status
}

menu *_telnet* {
  $iif($active_telnet_window_sockstatus,Disconnect) {
    var %socknev $remove($replace($active,:,_),@)
    if ($sock(%socknev).status) {
      if ($sock(%socknev).status) { echo $color(info2) -t %telnetablak *** Megszakadt a kapcsolat. }
      sockclose %socknev
    }
    else {
      if (telnetssl isin $active) {
        /telnet -ssl $gettok(%socknev,1,95) $gettok(%socknev,2,95)
      }
      else {
        /telnet $gettok(%socknev,1,95) $gettok(%socknev,2,95)
      }
    }
  }
  Reconnect {
    var %socknev $remove($replace($active,:,_),@)
    if ($sock(%socknev).status) { echo $color(info2) -t %telnetablak *** Megszakadt a kapcsolat. }
    sockclose %socknev
    if (telnetssl isin $active) {
      /telnet -ssl $gettok(%socknev,1,95) $gettok(%socknev,2,95)
    }
    else {
      /telnet $gettok(%socknev,1,95) $gettok(%socknev,2,95)
    }
  }
  -
  Ablak bezárása: { /closetelnetwindow $active | /window -c $active }
}

alias /closetelnetwindow {
  var %socknev $remove($replace($1,:,_),@)
  sockclose %socknev
  unset % $+ [ telnetcrlf $+ [ %socknev ] ]
  unset % $+ [ telnetlecho $+ [ %socknev ] ]
}

on *:close:*_telnet*: { /closetelnetwindow $target }

on *:sockclose:*_telnet: {
  var %telnetablak @ $+ $remove($replace($sockname,_,:),:telnet) $+ _telnet
  echo $color(info2) -t %telnetablak *** Megszakadt a kapcsolat.
}
on *:sockclose:*_telnetssl: {
  var %telnetablak @ $+ $remove($replace($sockname,_,:),:telnetssl) $+ _telnetssl
  echo $color(info2) -t %telnetablak *** Megszakadt a kapcsolat.
}

on *:sockwrite:*_telnet: {
  var %telnetablak @ $+ $remove($replace($sockname,_,:),:telnet) $+ _telnet
  if ($sockerr) { echo $color(info2) -t %telnetablak *** Socket hiba! }
  halt
}
on *:sockwrite:*_telnetssl: {
  var %telnetablak @ $+ $remove($replace($sockname,_,:),:telnetssl) $+ _telnetssl
  if ($sockerr) { echo $color(info2) -t %telnetablak *** Socket hiba! }
  halt
}

on *:sockread:*_telnet: {
  var %telnetablak @ $+ $remove($replace($sockname,_,:),:telnet) $+ _telnet
  var %tmp
  :ujraolvas
  /sockread -f %tmp
  if (!$sockbr) { return }
  %tmp = $replace(%tmp,$chr(32),$space,[1m,,[0m,)
  /echo $color(normal) -tm %telnetablak %mas_bal $+  $+ $color(nick) $+ $left($sockname,$calc($pos($sockname,_,1)-1)) $+ %mas_jobb $+  $+ $color(normal) %tmp
  goto ujraolvas
}
on *:sockread:*_telnetssl: {
  var %telnetablak @ $+ $remove($replace($sockname,_,:),:telnetssl) $+ _telnetssl
  var %tmp
  :ujraolvas
  /sockread -f %tmp
  if (!$sockbr) { return }
  %tmp = $replace(%tmp,$chr(32),$space,[1m,,[0m,)
  /echo $color(normal) -tm %telnetablak %mas_bal $+  $+ $color(nick) $+ $left($sockname,$calc($pos($sockname,_,1)-1)) $+ %mas_jobb $+  $+ $color(normal) %tmp
  goto ujraolvas
}

on 1:INPUT:*_telnet*: {
  var %socknev $remove($replace($target,:,_),@)
  if ($left($1,1) = /) && (!$ctrlenter) {
    if ($1 = /lecho) {
      if ($2 = 1) {
        [ % $+ [ telnetlecho $+ [ %socknev ] ] ] = 1
        echo $color(info) -tng $target *** Helyi visszhang bekapcsolva.
        /halt
      }
      if ($2 = 0) {
        [ % $+ [ telnetlecho $+ [ %socknev ] ] ] = 0
        echo $color(info) -tng $target *** Helyi visszhang kikapcsolva.
        /halt
      }
      echo $color(info) -tng $target *** Helyi visszhang: [ % $+ [ telnetlecho $+ [ %socknev ] ] ]
      /halt
    }
    if ($1 = /crlf) {
      if ($2 = 1) {
        [ % $+ [ telnetcrlf $+ [ %socknev ] ] ] = 1
        echo $color(info) -tng $target *** CRLF a sorok végére bekapcsolva.
        /halt
      }
      if ($2 = 0) {
        [ % $+ [ telnetcrlf $+ [ %socknev ] ] ] = 0
        echo $color(info) -tng $target *** CRLF a sorok végére kikapcsolva.
        /halt
      }
      if ($2 == status) {
        echo $color(info) -tng $target *** CRLF a sorok végén: [ % $+ [ telnetcrlf $+ [ %socknev ] ] ]
        /halt
      }
      sockwrite -n %socknev
      /halt
    }
  }
  else {
    if (!$sock(%socknev).status) { echo $color(info2) -tng $target *** Nincs kapcsolat! | /halt }
    if ($1- == $null) { halt }
    if ([ % $+ [ telnetlecho $+ [ %socknev ] ] ]) { echo $color(own) -tm $target %en_bal $+  $+ $color(nick) $+ $me $+ %en_jobb $+  $+ $color(own) $1- }
    if ([ % $+ [ telnetcrlf $+ [ %socknev ] ] ] == 0) { sockwrite %socknev $1- }
    else { sockwrite -n %socknev $1- }
  }
}
;END
