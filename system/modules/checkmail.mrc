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
  if ($1 == off) { .timercheckmail_auto off | echo $color(info) -atngq *** Automata email ellen�rz�s kikapcsolva. | return }
  if (!%checkmail_interval) || (!%checkmail_szerver) || (!%checkmail_port) || (!%checkmail_username) || (!%checkmail_pass) { /mailsetup | halt }
  if ($1 == on) { %checkmail_lastnum = 0 | .timercheckmail_auto -i 0 $calc(%checkmail_interval * 60) /checkmail -quiet | echo $color(info) -atngq *** Automata email ellen�rz�s bekapcsolva. | return }
  echo $color(info) -atng *** /autocheckmail - Automata email ellen�rz�s. haszn�lat: /autocheckemail [on|off]
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
  if ($sockerr > 0) { if (!%checkmail_quiet) { /echo $color(info2) -atng *** checkmail: hiba a kapcsol�d�s sor�n! ellen�rizd az email szerver be�ll�t�saidat! } | halt }
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
        /echo $color(info2) -atng *** checkmail: hib�s felhaszn�l�n�v vagy jelsz�! ( $+ $gettok(%datain,2-,32) $+ )
      }
      else {
        /echo $color(info2) -atng *** checkmail: szerver hiba! ellen�rizd az email be�ll�t�saidat! %datain
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
  if (!%checkmail_quiet) { /echo $color(info2) -atng *** checkmail: szerver hiba, ismeretlen v�lasz: %datain }
  goto ujraolvas
}

on 1:sockclose:checkmail: { unset %poptimes | unset %checkmail_quiet }

alias checkmail_check {
  if ($1 == %checkmail_lastnum) && (%checkmail_quiet) {
    sockclose checkmail
    return
  }
  %checkmail_lastnum = $1
  if ($1 == 0) { if (!%checkmail_quiet) { /echo $color(info) -atng *** checkmail: nincs �j emailed. } | unset %poptimes | unset %checkmail_quiet | sockclose checkmail }
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
      if (%checkmail_tooltip) {
        var %tip $tip(email, Email, $1 �j emailed �rkezett!, $null, system\img\email.ico, $null, emailer )
      }
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

    /echo $color(info) -atng *** checkmail: $+ $color(nick) $1 �j emailed �rkezett! %eprogtxt
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
  %gmail_location = https://mail.google.com/mail/?ui=mobile
  gmail_locationconv

  %gmail_emailnum = -1
  %gmail_inboxreceived = 0
  ;%gmail_debug = 1

  if (%gmail_debug) {
    %gmail_login = 1
    .clear @gmail_debug
    /window -e @gmail_debug Fixedsys
    .remove c:\gmaildbg_1.txt | .remove c:\gmaildbg_2.txt | .remove c:\gmaildbg_3.txt
    .remove c:\gmaildbg_4.txt | .remove c:\gmaildbg_5.txt | .remove c:\gmaildbg_6.txt
    .remove c:\gmaildbg_7.txt | .remove c:\gmaildbg_8.txt | .remove c:\gmaildbg_9.txt
    .remove c:\gmaildbg_10.txt | .remove c:\gmaildbg_11.txt | .remove c:\gmaildbg_12.txt
  }

  gmail_sockclose
}

on 1:sockopen:gmail: {
  if ($sockerr > 0) { if (!%checkmail_quiet) { /echo $color(info2) -atng *** checkmail: hiba a kapcsol�d�s sor�n! ellen�rizd az email szerver be�ll�t�saidat! } | halt }

  if (ServiceLoginAuth isin %gmail_location) {
    if (%gmail_debug) { echo -tng @gmail_debug %gmail_login - starting authentication, location: %gmail_location }

    var %gmail_galx $gmail_getcookiedata(GALX)
    if ($len(%gmail_galx)) {
      %gmail_galx = GALX= $+ %gmail_galx $+ &
    }

    var %logintmp %gmail_galx $+ rmShown=1&Email= $+ $urlencode(%checkmail_username) $+ &Passwd= $+ $urlencode($dekod(%checkmail_pass)) $+ &PersistentCookie=yes&service=mail&continue= $+ $urlencode(http://mail.google.com/?rm=false&passive=true&&btmpl=mobile&ui=html)

    if ( !$gmail_getcookiedata(GMAIL_LOGIN) ) {
      hadd gmailcookies GMAIL_LOGIN $+ ; $+ / $+ ; $+ .google.com T $+ $calc($ctime * 1000) $+ / $+ $calc($ctime * 1000) $+ / $+ $calc($ctime * 1000 + 1000);
    }

    sockwrite -n gmail POST %gmail_location HTTP/1.1
    sockwrite -n gmail Accept: */*
    sockwrite -n gmail Accept-Language: en-us
    sockwrite -n gmail Content-Type: application/x-www-form-urlencoded
    sockwrite -n gmail Content-Length: $len(%logintmp)
    sockwrite -n gmail User-Agent: netZ Script Pro v $+ %ver
    sockwrite -n gmail Connection: close
    sockwrite -n gmail Host: %gmail_host $+ : $+ %gmail_port
    gmail_sendcookies
    sockwrite -n gmail
    sockwrite -n gmail %logintmp
    sockwrite -n gmail
    return
  }

  ; egyebkent meg a redirecteket kovetjuk
  if (%gmail_debug) { echo -tng @gmail_debug %gmail_login - opening %gmail_location }
  sockwrite -n gmail GET %gmail_location HTTP/1.1
  sockwrite -n gmail Accept: */*
  sockwrite -n gmail Accept-Language: en-us
  sockwrite -n gmail User-Agent: netZ Script Pro v $+ %ver
  sockwrite -n gmail Host: %gmail_host $+ : $+ %gmail_port
  sockwrite -n gmail Connection: close
  gmail_sendcookies
  sockwrite -n gmail $crlf
}

alias gmail_getcookiedata {
  var %gmail_cookiecount = $hget(gmailcookies,0).item
  while (%gmail_cookiecount > 0) {
    var %cookie $hget(gmailcookies,%gmail_cookiecount).item
    var %cookiename $left(%cookie,$calc($pos(%cookie,$chr(59),1) - 1))
    if (%cookiename == $1 ) {
      return $hget(gmailcookies,%gmail_cookiecount).data
    }
    dec %gmail_cookiecount 1
  }
}

alias gmail_cookiedel {
  if ($hget(gmailcookies) != $null) {
    hdel -w gmailcookies *
  }
  .remove system\gmailcookies.dat
}

; http://www.nonoo.hu/lofasz/valami -> www.nonoo.hu
alias gmail_getdomain {
  var %domain = $remove($1-,http://,https://)
  var %cp $pos(%domain,/,1)
  if (%cp != $null) {
    %domain = $left(%domain,$calc(%cp - 1))
  }
  if ( : isin %domain ) {
    %gmail_port = $gettok(%domain,2,58)
    %domain = $gettok(%domain,1,58)
  }
  return %domain
}

alias gmail_locationconv {
  %gmail_port = $null
  %gmail_host = $gmail_getdomain(%gmail_location)

  if ($left(%gmail_location,8) == https://) {
    %gmail_proto = https
  }
  else {
    %gmail_proto = http
  }

  if ( !%gmail_port ) {
    if (https:// isin %gmail_location) {
      %gmail_port = 443
    }
    else {
      %gmail_port = 80
    }
  }

  ; http://www.nonoo.hu/lofasz/valami -> /lofasz/valami
  var %cp = $pos(%gmail_location,/,3)
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
    var %cookie $hget(gmailcookies,%gmail_cookiecount).item
    var %cookiename $left(%cookie,$calc($pos(%cookie,$chr(59),1) - 1))
    var %cookiepath $mid(%cookie,$calc($len(%cookiename) + 2),$calc($pos(%cookie,$chr(59),2) - $len(%cookiename) - 2))
    var %cookiedomain $mid(%cookie,$calc($pos(%cookie,$chr(59),2) + 1),$calc($len(%cookie) - $pos(%cookie,$chr(59),2) + 2))
    var %cookiedata $hget(gmailcookies,%gmail_cookiecount).data
    if (($len(%gmail_location) && %cookiepath !isin %gmail_location ) || %cookiedomain !isin %gmail_host) {
      if (%gmail_debug) {
        echo -tng @gmail_debug %gmail_login - cookie ' $+ %cookiename $+ ' is not in location ( $+ %cookiepath - %gmail_location $+ , %cookiedomain - %gmail_host $+ ), not sending
      }
      dec %gmail_cookiecount 1
      continue
    }
    sockwrite -n gmail Cookie: %cookiename $+ = $+ %cookiedata
    if (%gmail_debug) { echo -tng @gmail_debug %gmail_login - sent cookie: %cookiename $+ = $+ %cookiedata }
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

  %cs = $calc($pos($1-,;Path=,1) + 6)
  if (%cs == 6) {
    ; nincs path
    %cookiepath = /
  }
  else {
    var %pathstr = $mid($1-,%cs,$calc($len($1-) - %cs))
    %ce = $calc($pos(%pathstr,$chr(59),1) - 1)
    var %cookiepath = $mid(%pathstr,0,%ce)
  }

  var %cookiedomain
  %cs = $calc($pos($1-,;Domain=,1) + 8)
  if (%cs == 8) {
    ; nincs domain
    %cookiedomain = %gmail_host
  }
  else {
    var %domainstr = $mid($1-,%cs,$calc($len($1-) - %cs))
    %ce = $calc($pos(%domainstr,$chr(59),1) - 1)
    %cookiedomain = $mid(%domainstr,0,%ce)
  }

  if (%gmail_debug) { echo -tng @gmail_debug %gmail_login - got cookie: %cookiename $+ = $+ %cookiedata path: %cookiepath domain: %cookiedomain }
  if (%cookiedata == EXPIRED) {
    hdel gmailcookies %cookiename $+ ; $+ %cookiepath $+ ; $+ %cookiedomain
  }
  else {
    hadd gmailcookies %cookiename $+ ; $+ %cookiepath $+ ; $+ %cookiedomain %cookiedata
  }

  if (ServiceLoginAuth !isin %gmail_location) {
    unset %gmail_location
  }
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

  if ($left(%temp,10) == Set-Cookie) {
    gmail_setcookie %temp
  }

  if ($left(%temp,8) == Location) {
    gmail_location %temp
    if (%gmail_debug) {
      echo -tng @gmail_debug %gmail_login - got location (header): %gmail_location
      write c:\gmaildbg_ $+ %gmail_login $+ .txt %temp
    }
    gmail_sockclose
    return
  }

  ; ha nem http headerben jon a location, a html head-bol ollozzuk ki
  if ( content= $+ $chr(34) $+ 0; $+ $chr(32) $+ url= isin %temp ) {
    var %cs $calc($pos(%temp,$chr(34) $+ 0; $+ $chr(32) $+ url=,1)+8)
    var %ce $calc($pos(%temp,$chr(34)) - %cs)
    %gmail_location = $remove($mid(%temp,%cs,%ce),&#39;)
    gmail_locationconv
    if (%gmail_debug) {
      echo -tng @gmail_debug %gmail_login - got location (meta): %gmail_location
      write c:\gmaildbg_ $+ %gmail_login $+ .txt %temp
    }
    gmail_sockclose
    halt
  }

  if ( (%gmail_inboxreceived) || ($chr(32) $+ levelek isin %temp) ) {
    if ( ($chr(40) !isin %temp && $chr(41) !isin %temp) || ($chr(32) $+ levelek isin %temp && $chr(32) $+ levelek $+ $chr(32) $+ &nbsp; $+ $chr(40) !isin %temp) ) {
      %gmail_emailnum = 0
    }
    else {
      if ($chr(32) $+ levelek $+ $chr(32) $+ &nbsp; $+ $chr(40) !isin %temp) {
        var %cs = $calc($pos(%temp,$chr(40)) + 1)
        %gmail_emailnum = $mid(%temp, %cs, $calc($pos(%temp,$chr(41)) - %cs) )
      }
      else {
        var %cs = $calc($pos(%temp,levelek $+ $chr(32) $+ &nbsp; $+ $chr(40)) + 15)
        %gmail_emailnum = $mid(%temp, %cs, $calc($pos(%temp,$chr(41) $+ $chr(32) $+ </a>) - %cs) )
      }
    }
    if (%gmail_debug) {
      echo -tng @gmail_debug %gmail_login - got emailnum: %gmail_emailnum
      write c:\gmaildbg_ $+ %gmail_login $+ .txt %temp
    }
    gmail_sockclose
    halt
  }

  if ( (>Inbox isin %temp && Inbox< !isin %temp) ) {
    %gmail_inboxreceived = 1
  }

  if (you $+ $chr(32) $+ entered $+ $chr(32) $+ is $+ $chr(32) $+ incorrect isin %temp) {
    if (!%checkmail_quiet) { /echo $color(info2) -atng *** checkmail: hib�s felhaszn�l�n�v vagy jelsz�! }
    gmail_cookiedel
    unset %gmail_*
    unset %checkmail_quiet
    sockclose gmail
    halt
  }

  if (%gmail_debug) { write c:\gmaildbg_ $+ %gmail_login $+ .txt %temp }
  goto ujraolvas
}

on 1:sockclose:gmail: { gmail_sockclose }

alias gmail_sockclose {
  sockclose gmail

  var %gmail_cookiecount = $hget(gmailcookies,0).item
  if (%gmail_cookiecount == 0) {
    %gmail_location = https://www.google.com/accounts/ServiceLoginAuth?service=mail
    gmail_locationconv
  }

  if (/mail/? isin %gmail_location) {
    ; logged in
    %gmail_location = https://mail.google.com/mail/?ui=mobile
    gmail_locationconv
  }

  if ($len(%gmail_location) > 0) {
    if (%gmail_debug) {
      inc %gmail_login 1
      echo -tng @gmail_debug %gmail_login - connecting to: %gmail_host $+ : $+ %gmail_port (proto %gmail_proto $+ )
    }
    if (%gmail_proto == https) {
      sockopen -e gmail %gmail_host %gmail_port
    }
    else {
      sockopen gmail %gmail_host %gmail_port
    }
    return
  }

  if (%gmail_emailnum == -1) {
    if (!%checkmail_quiet) { /echo $color(info2) -atng *** checkmail: hiba t�rt�nt a lek�rdez�s sor�n - val�sz�n�leg v�ltozott a google protokoll. }
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
