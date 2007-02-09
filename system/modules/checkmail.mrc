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

;CHECKMAIL
alias /autocheckmail {
  if ($1 == off) { .timercheckmail_auto off | echo $color(info) -atngq *** Automata email ellenõrzés kikapcsolva. | return }
  if (!%checkmail_interval) || (!%checkmail_szerver) || (!%checkmail_port) || (!%checkmail_username) || (!%checkmail_pass) { /mailsetup | halt }
  if ($1 == on) { %checkmail_lastnum = 0 | .timercheckmail_auto -i 0 $calc(%checkmail_interval * 60) /checkmail -quiet | echo $color(info) -atngq *** Automata email ellenõrzés bekapcsolva. | return }
  echo $color(info) -atng *** /autocheckmail - Automata email ellenõrzés. használat: /autocheckemail [on|off]
}
alias /mailsetup { /setup | /did -f setupdialog 194 }
alias /checkmail {
  if ($1 = -quiet) { %checkmail_quiet = 1 }
  else { unset %checkmail_quiet }
  if (!%checkmail_username) || (!%checkmail_pass) {
    if (!%checkmail_gmailmode) {
      if (!%checkmail_szerver) || (!%checkmail_port) {
        /mailsetup | halt
      }
    }
  }
  if (!%checkmail_quiet) { echo $color(info) -atng *** checkmail... }
  if (%checkmail_gmailmode) { /checkmail_gmail | return }

  if ($sock(checkmail).status == active) { sockclose checkmail }
  if (%checkmail_ssl) { sockopen -e checkmail %checkmail_szerver %checkmail_port }
  else { sockopen checkmail %checkmail_szerver %checkmail_port }
}

on 1:sockopen:checkmail: {
  if ($sockerr > 0) { if (!%checkmail_quiet) { /echo $color(info2) -atng *** checkmail: hiba a kapcsolódás során! ellenõrizd az email szerver beállításaidat! } | halt }
  %poptimes = 0
}

on 1:sockread:checkmail: {
  var %data
  var %data2
  var %datain
  :ujraolvas
  sockread %datain
  if (!$sockbr) { return }
  %data2 = $gettok(%datain,2,32)
  %data = $gettok(%datain,1,32)
  if (%data == -ERR) || (%data = +ERR) {
    if (!%checkmail_quiet) {
      if (%poptimes == 2) || (%poptimes == 3) {
        /echo $color(info2) -atng *** checkmail: hibás felhasználónév vagy jelszó! ( $+ $gettok(%datain,2-,32) $+ )
      }
      else {
        /echo $color(info2) -atng *** checkmail: szerver hiba! ellenõrizd az email beállításaidat! %datain
      }
    }
    if ($sock(checkmail).status == active) { sockclose checkmail }
    unset %poptimes | unset %checkmail_quiet
    halt
  }
  if (%data == +OK) {
    inc %poptimes 1
    if (%poptimes == 1) { sockwrite -n checkmail USER %checkmail_username }
    if (%poptimes == 2) { sockwrite -n checkmail PASS $dekod(%checkmail_pass) }
    if (%poptimes == 3) { sockwrite -n checkmail STAT }
    if (%poptimes == 4) {
      checkmail_check %data2
      sockclose checkmail
      unset %poptimes | unset %checkmail_quiet
    }
    halt
  }
  if (!%checkmail_quiet) { /echo $color(info2) -atng *** checkmail: szerver hiba, ismeretlen válasz: %datain }
  goto ujraolvas
}

on 1:sockclose:checkmail: { unset %poptimes | unset %checkmail_quiet }

alias checkmail_check {
  if ($1 == %checkmail_lastnum) && (%checkmail_quiet) {
    sockclose checkmail
    halt
  }
  %checkmail_lastnum = $1
  if ($1 == 0) { if (!%checkmail_quiet) { /echo $color(info) -atng *** checkmail: nincs új emailed. } | unset %poptimes | unset %checkmail_quiet | sockclose checkmail }
  else {
    if (%checkmail_pager) && (%checkmail_quiet) && (!$appactive) {
      if (%checkmail_beep) {
        if (!%checkmail_beep_winamp) || ($dll(system/netz.dll, winamp, GetCurrentWinampSong) == 0)  { /beep 2 100 }
        else {
          if ($dll(system\netz.dll, winamp, isplaying)) { /beep 2 100 }
        }
      }
      if (%checkmail_speaker) { .timer 1 0 /netzbeep mail }
      if (%checkmail_flash) { .timer 1 0 /flash %checkmail_flash_szoveg }
    }

    var %eprogtxt

    if (%checkmail_emailer) { .timer 1 0 /emailer }
    else {
      if (%emailezo_prog) {
        %eprogtxt = (F8 - emailer)
        .hdel data $cid $+ doit $+ $replace($active,Status Window,status)
        .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /emailer
      }
    }

    /echo $color(info) -atng *** checkmail: $+ $color(nick) $1 új emailed érkezett! %eprogtxt
  }
}
;END

;GMAIL
alias checkmail_gmail {
  ; ha nincs gmailcookies hash tabla, betoltjuk fajlbol (ha letezik)
  if ($hget(gmailcookies) == $null) {
    hmake gmailcookies 1
    if ($exists(system\gmailcookies.dat)) {
      hload gmailcookies system\gmailcookies.dat
    }
  }

  ; elsore megprobaljuk lekerni az emailek szamat
  %gmail_location = /mail/?ik=&search=inbox&view=tl&start=0&init=1&zx=
  %gmail_host = mail.google.com
  %gmail_port = 80

  %gmail_emailnum = -1
  ;%gmail_debug = 1

  if (%gmail_debug) {
    %gmail_login = 1
    .window -c @gmail_debug
    /window -e @gmail_debug Fixedsys
    .remove c:\1.txt
    .remove c:\2.txt
    .remove c:\3.txt
    .remove c:\4.txt
    .remove c:\5.txt
    .remove c:\6.txt
    .remove c:\7.txt
  }

  sockclose gmail
  sockopen gmail %gmail_host %gmail_port
}

on 1:sockopen:gmail: {
  if ($sockerr > 0) { if (!%checkmail_quiet) { /echo $color(info2) -atng *** checkmail: hiba a kapcsolódás során! ellenõrizd az email szerver beállításaidat! } | halt }

  if (ServiceLogin isin %gmail_location) {
    ; ez akkor van ha nem jo a/nem volt bekuldott cookie, ujra kell loginelni
    gmail_cookiedel
    ; siman bekuldjuk POST-tal a felhasznalonevet, jelszot
    var %logintmp Email= $+ $urlencode(%checkmail_username) $+ &Passwd= $+ $urlencode($dekod(%checkmail_pass)) $+ &PersistentCookie=yes&service=mail&continue= $+ $urlencode(http://mail.google.com/mail/?) $+ &rm=false&passive=true&nui=5&btmpl=mobile&ui=html
    sockwrite -n gmail POST /accounts/ServiceLoginAuth HTTP/1.0
    sockwrite -n gmail Accept: */*
    sockwrite -n gmail Accept-Language: en-us
    sockwrite -n gmail Content-Type: application/x-www-form-urlencoded
    sockwrite -n gmail Content-Length: $len(%logintmp)
    sockwrite -n gmail User-Agent: netZ Script Pro v $+ %ver
    sockwrite -n gmail Host: www.google.com
    sockwrite -n gmail Connection: close
    sockwrite -n gmail
    sockwrite -n gmail %logintmp
    sockwrite -n gmail
    return
  }

  ; egyebkent meg a redirecteket kovetjuk
  if (%gmail_debug) { echo -tng @gmail_debug %gmail_login - opening %gmail_location }
  sockwrite -n gmail GET %gmail_location HTTP/1.0
  sockwrite -n gmail Accept: */*
  sockwrite -n gmail Accept-Language: en-us
  sockwrite -n gmail User-Agent: netZ Script Pro v $+ %ver
  sockwrite -n gmail Host: %gmail_host
  sockwrite -n gmail Connection: close
  gmail_sendcookies
  sockwrite -n gmail $crlf

  unset %gmail_location
}

alias gmail_cookiedel {
  if ($hget(gmailcookies) != $null) {
    hdel -w gmailcookies *
  }
  .remove system\gmailcookies.dat
}

alias gmail_locationconv {
  ; http://www.nonoo.hu/lofasz/valami -> www.nonoo.hu
  %gmail_host = $remove(%gmail_location,http://,https://)
  var %cp $pos(%gmail_host,/,1)
  if (%cp != $null) {
    %gmail_host = $left(%gmail_host,$calc(%cp - 1))
  }

  if (https:// isin %gmail_location) {
    %gmail_port = 443
  }
  else {
    %gmail_port = 80
  }

  ; http://www.nonoo.hu/lofasz/valami -> /lofasz/valami
  %cp = $pos(%gmail_location,/,3)
  if (%cp != $null) {
    %gmail_location = $remove(%gmail_location,$left(%gmail_location,$calc(%cp - 1)))
  }
  else {
    %gmail_location = /
  }

  %gmail_location = $replace(%gmail_location,&amp;,&)
}

; elkuldi az eltarolt cookiekat a szervernek
alias gmail_sendcookies {
  var %gmail_cookiecount = $hget(gmailcookies,0).item
  while (%gmail_cookiecount > 0) {
    sockwrite -n gmail Cookie: $hget(gmailcookies,%gmail_cookiecount).item $+ = $+ $hget(gmailcookies,%gmail_cookiecount).data
    if (%gmail_debug) { echo -tng @gmail_debug %gmail_login - sent cookie: $hget(gmailcookies,%gmail_cookiecount).item $+ = $+ $hget(gmailcookies,%gmail_cookiecount).data }
    dec %gmail_cookiecount 1
  }
}

; Set-Cookie kezdetu sornal hivjuk meg, eltarolja a cookiet hash tablaba
alias gmail_setcookie {
  ; elso space pos
  var %cs $calc($pos($1-,$chr(32),1)+1)
  ; egyenlosegjel pos
  var %ce $pos($1-,$chr(61),1)
  var %cookiename = $mid($1-,%cs,$calc(%ce - %cs))
  ; pontosvesszo pos
  var %cc $pos($1-,$chr(59),1)
  if (%cc == $null) { %cc = $calc($len($1-) + 1) }
  var %cookiedata = $mid($1-,$calc(%ce + 1),$calc( %cc - %ce - 1 ) )
  if (%gmail_debug) { echo -tng @gmail_debug %gmail_login - got cookie: %cookiename $+ = $+ %cookiedata }
  if (%cookiedata == EXPIRED) { hdel gmailcookies %cookiename }
  else { hadd gmailcookies %cookiename %cookiedata }
}

; kivagja a parameterkent megadott sorbol a location-t
alias gmail_location {
  var %cs $calc($pos($1-,$chr(32),1)+1)
  %gmail_location = $mid($1-,%cs,$calc($len($1-)-%cs+1))
  gmail_locationconv
}

on 1:sockread:gmail: {
  var %temp
  :ujraolvas
  sockread %temp
  if (!$sockbr) { return }

  if (<title>Welcome $+ $chr(32) $+ to $+ $chr(32) $+ Gmail</title> isin %temp) {
    if (!%checkmail_quiet) { /echo $color(info2) -atng *** checkmail: hibás felhasználónév vagy jelszó! }
    unset %gmail_*
    unset %checkmail_quiet
    sockclose gmail
    halt
  }

  if ($left(%temp,10) == Set-Cookie) {
    if (GV=EXPIRED; isin %temp) {
      %gmail_location = https://www.google.com/accounts/ServiceLoginAuth
      gmail_locationconv
      if (%gmail_debug) { echo -tng @gmail_debug %gmail_login - cookie expired, relogging }
      else {
        gmail_sockclose
        halt
      }
    }
    gmail_setcookie %temp
    if (!%gmail_debug) { goto ujraolvas }
  }

  if ($left(%temp,8) == Location) {
    gmail_location %temp
    if (%gmail_debug) { echo -tng @gmail_debug %gmail_login - got location: %gmail_location }
    else {
      gmail_sockclose
      halt
    }
  }

  ; ha nem http headerben jon a location, a html head-bol ollozzuk ki
  if (%gmail_location == $null) && (meta $+ $chr(32) $+ content= $+ $chr(34) $+ 0; $+ $chr(32) $+ url=' isin %temp) {
    var %cs $calc($pos(%temp,$chr(34) $+ 0; $+ $chr(32) $+ url=',1)+9)
    var %ce $calc($pos(%temp,' $+ $chr(34)) - %cs)
    %gmail_location = $mid(%temp,%cs,%ce)
    gmail_locationconv
    if (%gmail_debug) { echo -tng @gmail_debug %gmail_login - got location: %gmail_location }
    else {
      gmail_sockclose
      halt
    }
  }

  ; ez a szoveg a rendes gmail oldalon van, ha ez jon,
  ; lekerjuk a javascript oldalt amiben benne lesz az olvasatlan levelek szama
  if (indexOf $+ $chr(40) $+ 'nocheckbrowser' $+ $chr(41) isin %temp) {
    %gmail_location = http://mail.google.com/mail/?ik=&search=inbox&view=tl&start=0&init=1&zx=
    gmail_locationconv
    if (%gmail_debug) { echo -tng @gmail_debug %gmail_login - getting number of unread mails }
    else {
      gmail_sockclose
      halt
    }
  }

  ; megkeressuk a sort amiben az inboxban levo emailek szama van
  ; D(["ds",[["inbox",1]
  if (%gmail_location == $null) && (D $+ $chr(40) $+ $chr(91) $+ $chr(34) $+ ds $+ $chr(34) $+ $chr(44) $+ $chr(91) $+ $chr(91) $+ $chr(34) $+ inbox $+ $chr(34) isin %temp) {
    var %cs = $calc($pos(%temp,$chr(34) $+ inbox $+ $chr(34)) + 8)
    %gmail_emailnum = $mid(%temp,%cs, $calc($pos(%temp,$chr(93)) - %cs) )
    if (%gmail_debug) { echo -tng @gmail_debug %gmail_login - got emailnum: %gmail_emailnum }
    else {
      gmail_sockclose
      halt
    }
  }

  if (%gmail_debug) { write c:\ $+ %gmail_login $+ .txt %temp }
  goto ujraolvas
}

on 1:sockclose:gmail: { gmail_sockclose }

alias gmail_sockclose {
  sockclose gmail
  if ($len(%gmail_location) > 0) {
    if (%gmail_debug) { inc %gmail_login 1 }
    if (%gmail_port == 443) {
      sockopen -e gmail %gmail_host %gmail_port
    }
    else {
      sockopen gmail %gmail_host %gmail_port
    }
    return
  }

  if (%gmail_emailnum == -1) {
    if (!%checkmail_quiet) { /echo $color(info2) -atng *** checkmail: hiba történt a lekérdezés során - valószínûleg változott a google protokoll. }
    gmail_cookiedel
  }
  else {
    checkmail_check %gmail_emailnum
  }

  hsave gmailcookies system\gmailcookies.dat
  unset %gmail_*
  unset %checkmail_quiet
}
;END
