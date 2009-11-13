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


;RIZSA
alias rizsa { dialog -m rizsa rizsa }
dialog rizsa {
  title "-= RiZSa-WiNDoW 3.1 =-"
  size -1 -1 500 197
  option pixels notheme
  edit "", 1, 1 20 498 155, autovs multi return vsbar
  edit "", 2, 0 1 260 20
  button "Beny�g", 100, 260 1 80 20, ok
  button "Bez�r�s", 101, 340 1 80 20, cancel
  button "T�rl�s", 102, 420 1 80 20
  button "Bet�lt�s", 103, 1 176 80 20
  button "Ment�s", 104, 83 176 80 20
}
on 1:dialog:rizsa:init:*:{
  /did -a $dname 2 $active
}
on 1:dialog:rizsa:sclick:102:{ 
  did -r $dname 1
}
on 1:dialog:rizsa:sclick:103:{
  var %filename = $hfile="File" [ c:\*.* ]
  var %ciklusv = 0
  var %max = $lines(%filename)
  :idevissza
  inc %ciklusv 1
  if (%ciklusv <= %max) { did -i $dname 1 %ciklusv $read(%filename,n,%ciklusv) }
  else { goto end }
  goto idevissza
  :end
}
on 1:dialog:rizsa:sclick:104:{
  var %filename = $hfile="File" [ c:\*.* ]
  var %i 0
  write -c %filename
  while (%i < $did(1).lines) {
    inc %i 1
    write %filename $did(1,%i)
  }
}
on 1:dialog:rizsa:sclick:100:{
  if ( $did(1).seltext = $null ) { echo $color(info2) -atng *** Nem v�lasztott�l ki sz�veget a RizsaWindowban! | /halt }
  /msg $did(2) $remove($did(1).seltext,$crlf)
  halt
}
;END

;ASCIICODES
alias /asciicodes /dialog -m DLGascii DLGascii
dialog DLGascii {
  title "ASCII k�d konvert�l�"
  size -1 -1 152 80
  option dbu
  button "K�sz", 3, 105 67 45 12, ok
  box "Konvert�l�", 5, 2 3 149 60
  edit "97", 6, 24 16 20 10, autohs center
  button "Convert!", 10, 6 29 37 12
  radio "Karakter -> ASCII k�d", 11, 61 16 70 10
  radio "ASCII k�d -> karakter", 12, 61 27 70 10
  text "Mit:", 13, 7 17 14 8
  text "Eredm�ny:", 14, 60 45 30 8
  edit "a", 15, 90 44 28 10, read autohs center
}
on *:DIALOG:DLGascii:init:*: did -c $dname 12
on *:DIALOG:DLGascii:sclick:10: if (!$did($dname,11).state) did -ra $dname 15 $chr($did($dname,6)) | else did -ra $dname 15 $asc($did($dname,6)) 
;END

;TEXTFORMATSETUP
alias /textformatter { /dialog -mr tfsetup tfsetup }
dialog tfsetup {
  title "Text Formatter"
  size -1 -1 155 215
  box "",1,4 2 147 210
  check "Al�h�zott",2,10 12 100 20
  check "F�lk�v�r",3,10 32 100 20
  check "Inverz",4,10 52 100 20
  check "Visszafele",5,10 72 100 20
  check "V�letlen nagybet�k",6,10 92 110 20
  check "V�letlen sz�nek",7,10 112 100 20
  check "�L�T�",8,10 132 100 20
  check "Topten Hacker",9,10 152 100 20
  button "Okay", 100, 10 180 65 25, OK default
  button "M�gsem", 101, 80 180 65 25, cancel
}
on *:DIALOG:tfsetup:sclick:100: {
  if $did(2).state = 1 { %onunderline = 1 }
  else { %onunderline = 0 }
  if $did(3).state = 1 { %onbold = 1 }
  else { %onbold = 0 }
  if $did(4).state = 1 { %oninverse = 1 }
  else { %oninverse = 0 }
  if $did(5).state = 1 { %onreverse = 1 }
  else { %onreverse = 0 }
  if $did(6).state = 1 { %onrandomcase = 1 }
  else { %onrandomcase = 0 }
  if $did(7).state = 1 { %onrcolor = 1 }
  else { %onrcolor = 0 }
  if $did(8).state = 1 { %onelite = 1 }
  else { %onelite = 0 }
  if $did(9).state = 1 { %ontopten = 1 }
  else { %ontopten = 0 }
}
on *:DIALOG:tfsetup:init:*: {
  if (%onunderline) { /did -c $dname 2 }
  if (%onbold) { /did -c $dname 3 }
  if (%oninverse) { /did -c $dname 4 }
  if (%onreverse) { /did -c $dname 5 }
  if (%onrandomcase) { /did -c $dname 6 }
  if (%onrcolor) { /did -c $dname 7 }
  if (%onelite) { /did -c $dname 8 }
  if (%ontopten) { /did -c $dname 9 }
}
;END

;TEXTFORMAT
alias /textformat {
  /set -n %tempszoveg $1-
  if (%onrandomcase) { /set -n %tempszoveg $randomcase(%tempszoveg) }
  if (%ontopten) { /set -n %tempszoveg $topten(%tempszoveg) }
  if (%onelite) { /set -n %tempszoveg $elite(%tempszoveg) }
  if (%onreverse) { /set -n %tempszoveg $reverse(%tempszoveg) }
  if (%onrcolor) { /set -n %tempszoveg $randomcolor(%tempszoveg) }
  if (%onbold) { /set -n %tempszoveg  $+ %tempszoveg }
  if (%oninverse) { /set -n %tempszoveg  $+ %tempszoveg }
  if (%onunderline) { /set -n %tempszoveg  $+ %tempszoveg }
  return %tempszoveg
}
;END

;RANDOMCASE
alias /randomcase {
  var %tempsz = $1-
  %tempsz = $lower(%tempsz)
  %tempsz = $strip(%tempsz)
  %tempsz = $replace(%tempsz,a,A)
  %tempsz = $replace(%tempsz,e,E)
  %tempsz = $replace(%tempsz,i,I)
  %tempsz = $replace(%tempsz,o,O)
  %tempsz = $replace(%tempsz,u,U)
  %tempsz = $replace(%tempsz,y,Y)
  %tempsz = $replace(%tempsz,�,�)
  %tempsz = $replace(%tempsz,g,G)
  %tempsz = $replace(%tempsz,x,X)
  %tempsz = $replace(%tempsz,z,Z)
  return %tempsz
}
;END

;TOPTEN
alias /topten {
  var %s
  var %i = $len($1-)
  var %j = 1
  while (%j <= %i) { %s = %s $+ $chr(32) $+ $mid($1-,%j,1) | inc %j }
  /unset %i | /unset %j | return %s
}
;END

;ELITE
alias /elite {
  var %tempsz
  %tempsz = $1-
  %tempsz = $replace(%tempsz,(c),�)
  %tempsz = $replace(%tempsz,(tm),�)
  %tempsz = $replace(%tempsz,(r),�)
  %tempsz = $replacecs(%tempsz,a,�)
  %tempsz = $replacecs(%tempsz,A,�)
  %tempsz = $replacecs(%tempsz,�,�)
  %tempsz = $replacecs(%tempsz,�,�)
  %tempsz = $replacecs(%tempsz,e,�)
  %tempsz = $replacecs(%tempsz,�,�)
  %tempsz = $replacecs(%tempsz,E,�)
  %tempsz = $replacecs(%tempsz,�,�)
  %tempsz = $replacecs(%tempsz,i,�)
  %tempsz = $replacecs(%tempsz,I,�)
  %tempsz = $replacecs(%tempsz,u,�)
  %tempsz = $replacecs(%tempsz,U,�)
  %tempsz = $replacecs(%tempsz,y,�)
  %tempsz = $replacecs(%tempsz,Y,�)
  %tempsz = $replacecs(%tempsz,z,�)
  %tempsz = $replacecs(%tempsz,Z,�)
  %tempsz = $replacecs(%tempsz,r,�)
  %tempsz = $replacecs(%tempsz,R,�)
  %tempsz = $replacecs(%tempsz,x,�)
  %tempsz = $replacecs(%tempsz,t,�)
  %tempsz = $replacecs(%tempsz,T,�)
  %tempsz = $replacecs(%tempsz,n,�)
  %tempsz = $replacecs(%tempsz,N,�)
  %tempsz = $replacecs(%tempsz,d,�)
  %tempsz = $replacecs(%tempsz,D,�)
  %tempsz = $replacecs(%tempsz,c,�)
  %tempsz = $replacecs(%tempsz,C,�)
  %tempsz = $replacecs(%tempsz,l,�)
  %tempsz = $replacecs(%tempsz,l,�)
  %tempsz = $replacecs(%tempsz,s,$)
  %tempsz = $replacecs(%tempsz,S,�)
  %tempsz = $replacecs(%tempsz,o,�)
  %tempsz = $replacecs(%tempsz,O,�)
  return %tempsz
}
;END

;REVERSE
alias /reverse {
  var %hossz = $len($1-) | var %mond | var %i = 0
  :ismet
  var %mond = %mond $+ $mid($1-,%hossz,1)
  if ($mid($1-,%hossz,1) = $chr(32)) { %mond = %mond $chr(32) }
  dec %hossz
  if %hossz = 0 { return %mond }
  goto ismet
}
;END

;RANDOMCOLOR
alias /randomcolor {
  var %mond
  var %hossz = $len($1-)
  var %i = 0
  :ismet1
  inc %i
  var %punci = $rand(0,15)
  if ( %punci = 1 ) { %punci = 10 }
  if ( $mid($1-,%i,1) = $chr(32) ) { %mond = %mond $chr(32) }
  else { %mond = %mond $+  $+ %punci $+ $mid($1-,%i,1) }
  if (%i = %hossz) {
    return %mond
  }
  goto ismet1
}
;END

;CALC
alias /calc {
  if (!$1) { /window -ek0 @Calc Fixedsys | /echo $color(other) @Calc *** netZCalc | /echo $color(background) @Calc - | background -t @Calc system\img\back.jpg | /halt }
  /echo $color(info) -atng *** netzcalc: $1 = $calc($1)
}
on *:INPUT:@Calc:{
  echo $color(gray) @Calc $1- = $calc($1-)
}
;END

;SZ�T�RAK
on 1:sockclose:szotar: {
  if (%kifejezes) { echo $color(info) -atng *** $replace(%kifejezes,: $+  $+ $chr(44),:) }
  /echo $color(background) -ang -
  unset %nyelvfrom %nyelvto %szo %out %resfigy %kifejezes %kifejezes_listazas %szotar
}
on 1:sockread:szotar: {
  if ($sockerr > 0) { /echo $color(info2) -atng *** Sz�t�r: socket hiba. Pr�b�ld �jra! | halt }
  var %in
  :ujraolvas
  sockread %in
  if (!$sockbr) { return }
  ; hol tartunk a szovegben
  var %i 1
  ; mi a karakter amit epp vizsgalunk
  var %c
  ; kimenet
  var %outtext
  while (%i <= $len(%in)) {
    %c = $right($left(%in,%i),1)
    if (%c = <) { %out = 0 }
    if (%out) {
      if (%c == $chr(32)) { %outtext = %outtext $chr(32) }
      else { %outtext = %outtext $+ %c }
    }
    if (%c = >) { %out = 1 }
    inc %i
  }
  ; wap karakterkod processing by ViDe0 (Varga G�bor), 1999-2003. - video@primposta.com
  %outtext = $replace(%outtext,$chr(9),$null,&amp;,&,&nbsp;,$chr(32))
  %outtext = $replace(%outtext,é,�,� $+ $chr(173),�,á,�,û,�,ü,�,ö,�,ó,�,ú,�,õ,�,Ú,�, Ü,�, Û,�,ű,�,ő,�, Á,�)
  var %wap.csap
  var %wap.cs
  while ($pos(%outtext,&#,1)) {
    %wap.csap = $pos(%outtext,&#,1)
    %wap.csap = $calc(%wap.csap + 2 )
    if $mid(%outtext,$calc(%wap.csap + 3),1) = ; { %wap.cs = $mid(%outtext, %wap.csap , 3 ) }
    elseif $mid( %outtext, $calc( %wap.csap + 2) , 1 ) = ; { %wap.cs = $mid(%outtext, %wap.csap , 2 ) }
    elseif $mid( %outtext, $calc( %wap.csap + 4) , 1 ) = ; { %wap.cs = $mid(%outtext, %wap.csap , 4 ) }
    else { %wap.cs = $mid(%outtext, %wap.csap , 1 ) }
    %outtext = $replace(%outtext, &# $+ %wap.cs $+ ; , $chr( %wap.cs ) )
  }
  ; end

  ; nincs ilyen szo
  if (nem $+ $chr(32) $+ $chr(32) $+ tal�lhat� isin %outtext) { /echo $color(info2) -atng *** %nyelvfrom $+ 2 $+ %nyelvto $+ : $laz(%szo) %szo sz� nem tal�lhat� a sz�t�rban. | sockclose szotar | halt }
  ; csak hasonlo szavak vannak
  if (az $+ $chr(32) $+ $chr(32) $+ al�bbi $+ $chr(32) $+ $chr(32) $+ hasonl� $+ $chr(32) $+ $chr(32) $+ szavak isin %outtext) {
    /echo $color(info2) -atng *** %nyelvfrom $+ 2 $+ %nyelvto $+ : az al�bbi hasonl� szavakat tal�ltam:
    %hasonloszavak_listazas = 1
    halt
  }
  if (%hasonloszavak_listazas) && (&gt; isin %outtext) { unset %hasonloszavak_listazas | halt }
  if (%hasonloszavak_listazas) && (%outtext) { echo $color(info) -atng *** $replace(%outtext,.,. $+ $color(nick)) | halt }

  ; listazas
  if (%resfigy) && (&gt; isin %outtext) { %resfigy = 0 }
  if (%resfigy) {
    ; ha megvan a bejegyzes
    if (: isin %outtext) {
      if (%kifejezes_listazas) { echo $color(info) -atng *** $replace(%kifejezes,: $+  $+ $chr(44),:) }
      %kifejezes_listazas = 1
      %kifejezes =  $+ $color(nick) $+ %outtext $+ 
    }
    else {
      if (%kifejezes_listazas) && (%outtext) { %kifejezes = %kifejezes $+ , %outtext }
    }
  }
  if (tal�lat isin %outtext) { %resfigy = 1 }
  goto ujraolvas
}
on 1:sockopen:szotar: {
  if ($sockerr > 0) { /echo $color(info2) -atng *** Sz�t�r: Nem lehet kapcsol�dni a szotar.sztaki.hu-ra! | halt }
  ; ha feldolgozashoz tovabbvesszuk a szot
  %out = 1
  ; ha mehet a kimenetbe a soksok tal�lat
  %resfigy = 0
  /echo $color(background) -ang -
  /echo $color(info) -atng *** $+ $color(nick) %nyelvfrom $+ 2 $+ %nyelvto  $+ $color(info) $+ list�z�s $+ : $+ $color(nick) %szo
  sockwrite -n szotar GET http://szotar.sztaki.hu/dict_search.php?L= $+ %nyelvfrom $+ : $+ %nyelvto $+ : $+ %szotar $+ &S=W&M=3&wap_exp=1&W= $+ $replace(%szo,$chr(32),+) HTTP/1.1
  sockwrite -n szotar Host: szotar.sztaki.hu:80
  sockwrite -n szotar Accept: */*
  sockwrite -n szotar Accept-Language: en-us
  sockwrite -n szotar User-Agent: netZ Script Pro v $+ %ver
  sockwrite -n szotar Connection: close
  sockwrite -n szotar $crlf
}

alias /am {
  if (!$1) { echo $color(info2) -atng *** /am hiba: t�l kev�s param�ter! haszn�lat: /am [sz�] | halt }
  if ($sock(szotar).status == active) { sockclose szotar }
  %szo = $1-
  %nyelvfrom = ENG
  %nyelvto = HUN
  %szotar = EngHunDict
  sockclose szotar
  sockopen szotar szotar.sztaki.hu 80
}
alias /ma {
  if (!$1) { echo $color(info2) -atng *** /ma hiba: t�l kev�s param�ter! haszn�lat: /ma [sz�] | halt }
  if ($sock(szotar).status == active) { sockclose szotar }
  %szo = $1-
  %nyelvfrom = HUN
  %nyelvto = ENG
  %szotar = EngHunDict
  sockclose szotar
  sockopen szotar szotar.sztaki.hu 80
}
alias /nm {
  if (!$1) { echo $color(info2) -atng *** /nm hiba: t�l kev�s param�ter! haszn�lat: /nm [sz�] | halt }
  if ($sock(szotar).status == active) { sockclose szotar }
  %szo = $1-
  %nyelvfrom = GER
  %nyelvto = HUN
  %szotar = GerHunDict
  sockclose szotar
  sockopen szotar szotar.sztaki.hu 80
}
alias /mn {
  if (!$1) { echo $color(info2) -atng *** /mn hiba: t�l kev�s param�ter! haszn�lat: /mn [sz�] | halt }
  if ($sock(szotar).status == active) { sockclose szotar }
  %szo = $1-
  %nyelvfrom = HUN
  %nyelvto = GER
  %szotar = GerHunDict
  sockclose szotar
  sockopen szotar szotar.sztaki.hu 80
}
alias /fm {
  if (!$1) { echo $color(info2) -atng *** /fm hiba: t�l kev�s param�ter! haszn�lat: /fm [sz�] | halt }
  if ($sock(szotar).status == active) { sockclose szotar }
  %szo = $1-
  %nyelvfrom = FRA
  %nyelvto = HUN
  %szotar = FraHunDict
  sockclose szotar
  sockopen szotar szotar.sztaki.hu 80
}
alias /mf {
  if (!$1) { echo $color(info2) -atng *** /mf hiba: t�l kev�s param�ter! haszn�lat: /mf [sz�] | halt }
  if ($sock(szotar).status == active) { sockclose szotar }
  %szo = $1-
  %nyelvfrom = HUN
  %nyelvto = FRA
  %szotar = FraHunDict
  sockclose szotar
  sockopen szotar szotar.sztaki.hu 80
}
alias /om {
  if (!$1) { echo $color(info2) -atng *** /om hiba: t�l kev�s param�ter! haszn�lat: /om [sz�] | halt }
  if ($sock(szotar).status == active) { sockclose szotar }
  %szo = $1-
  %nyelvfrom = ITA
  %nyelvto = HUN
  %szotar = ItaHunDict
  sockclose szotar
  sockopen szotar szotar.sztaki.hu 80
}
alias /mo {
  if (!$1) { echo $color(info2) -atng *** /mo hiba: t�l kev�s param�ter! haszn�lat: /mo [sz�] | halt }
  if ($sock(szotar).status == active) { sockclose szotar }
  %szo = $1-
  %nyelvfrom = HUN
  %nyelvto = ITA
  %szotar = ItaHunDict
  sockclose szotar
  sockopen szotar szotar.sztaki.hu 80
}
alias /hm {
  if (!$1) { echo $color(info2) -atng *** /hm hiba: t�l kev�s param�ter! haszn�lat: /hm [sz�] | halt }
  if ($sock(szotar).status == active) { sockclose szotar }
  %szo = $1-
  %nyelvfrom = HOL
  %nyelvto = HUN
  %szotar = HolHunDict
  sockclose szotar
  sockopen szotar szotar.sztaki.hu 80
}
alias /mh {
  if (!$1) { echo $color(info2) -atng *** /mh hiba: t�l kev�s param�ter! haszn�lat: /mh [sz�] | halt }
  if ($sock(szotar).status == active) { sockclose szotar }
  %szo = $1-
  %nyelvfrom = HUN
  %nyelvto = HOL
  %szotar = HolHunDict
  sockclose szotar
  sockopen szotar szotar.sztaki.hu 80
}
alias /lm {
  if (!$1) { echo $color(info2) -atng *** /lm hiba: t�l kev�s param�ter! haszn�lat: /lm [sz�] | halt }
  if ($sock(szotar).status == active) { sockclose szotar }
  %szo = $1-
  %nyelvfrom = POL
  %nyelvto = HUN
  %szotar = PolHunDict
  sockclose szotar
  sockopen szotar szotar.sztaki.hu 80
}
alias /ml {
  if (!$1) { echo $color(info2) -atng *** /ml hiba: t�l kev�s param�ter! haszn�lat: /ml [sz�] | halt }
  if ($sock(szotar).status == active) { sockclose szotar }
  %szo = $1-
  %nyelvfrom = HUN
  %nyelvto = POL
  %szotar = PolHunDict
  sockclose szotar
  sockopen szotar szotar.sztaki.hu 80
}
;END

;TWITTER
alias /twit {
  if (!%twitter_acc || !%twitter_pass) {
    echo $color(info2) -atng *** /twit hiba: nincs be�ll�tva a twitter el�r�sed!
    /setup
    did -f setupdialog 322
    return
  }
  if ($len($1-) > 140 ) { echo $color(info2) -atng *** /twit hiba: az �zenet max. 140 karakter hossz� lehet! | return }
  twit_destroy
  if ($len($1) == 0) {
    %twittmp_showstatus = 1
  }
  else {
    %twittmp_showstatus = 0
  }
  %twittmp_msg = $1-
  echo $color(info) -atng *** twitter: kapcsol�d�s...
  sockopen twit twitter.com 80
}
alias /twit_destroy { unset %twittmp_* | sockclose twit | .remove system\temp\twit.xml }

on 1:sockopen:twit: {
  if ($sockerr > 0) { /echo $color(info2) -atng *** twitter hiba: nem lehet kapcsol�dni a twitter.com-ra! | halt }
  write -c system\temp\twit.xml

  var %authtmp $base64(%twitter_acc $+ : $+ $dekod(%twitter_pass)).enc
  if (!%twittmp_showstatus) {
    echo $color(info) -atng *** twitter: k�ld�s...
    sockwrite -n twit POST http://twitter.com/statuses/update.xml HTTP/1.1
    sockwrite -n twit Accept: */*
    sockwrite -n twit Accept-Language: en-us
    sockwrite -n twit Content-Type: application/x-www-form-urlencoded
    var %tmp status= $+ $urlencode($utf8(%twittmp_msg).enc)
    sockwrite -n twit Content-Length: $len(%tmp)
    sockwrite -n twit Authorization: Basic %authtmp
    sockwrite -n twit User-Agent: netZ Script Pro v $+ %ver
    sockwrite -n twit Connection: close
    sockwrite -n twit Host: twitter.com:80
    sockwrite -n twit
    sockwrite -n twit %tmp
    sockwrite -n twit
  }
  else {
    echo $color(info) -atng *** twitter: st�tusz lek�r�se...
    sockwrite -n twit GET http://twitter.com/users/show/ $+ %twitter_acc $+ .xml HTTP/1.1
    sockwrite -n twit Accept: */*
    sockwrite -n twit Accept-Language: en-us
    sockwrite -n twit Authorization: Basic %authtmp
    sockwrite -n twit User-Agent: netZ Script Pro v $+ %ver
    sockwrite -n twit Connection: close
    sockwrite -n twit Host: twitter.com:80
    sockwrite -n twit
  }
}
on 1:sockread:twit: {
  var %temp
  :ujraolvas
  sockread %temp
  if (!$sockbr) { return }
  if (%temp == HTTP/1.0 $+ $chr(32) $+ 401 $+ $chr(32) $+ Unauthorized) {
    /echo $color(info2) -atng *** twitter hiba: nem lehet autentik�lni, val�sz�n�leg hib�s a megadott felhaszn�l�n�v/jelsz�!
  }
  if ($left(%temp,12) == HTTP/1.0 $+ $chr(32) $+ 403) {
    /echo $color(info2) -atng *** twitter hiba: el�r�si hiba!
  }
  write system\temp\twit.xml $urldecode(%temp)
  goto ujraolvas
}
on 1:sockclose:twit: { twit_analyzeresponse | twit_destroy }

alias /twit_analyzeresponse {
  if ( !$isfile(system\temp\twit.xml) ) { /echo $color(info2) -atng *** twitter hiba: nem �rkezett v�lasz a szervert�l, pr�b�ld �jra! | return }

  var %result = $dll(system\xml.dll,create_parser,twit)
  if (%result != S_OK) { /echo $color(info2) -atng *** twitter hiba: nem lehet bet�lteni az XML �rtelmez�t (xml.dll)! | return }

  ;dll system\xml.dll set_handler_xmldecl twit twit_xml_hxmldecl
  dll system\xml.dll set_handler_startelement twit twit_xml_hstartelement
  dll system\xml.dll set_handler_endelement twit twit_xml_hendelement
  ;dll system\xml.dll set_handler_attribute twit twit_xml_hattribute
  dll system\xml.dll set_handler_chardata twit twit_xml_hchardata
  ;dll system\xml.dll set_handler_cdata twit twit_xml_hcdata
  dll system\xml.dll set_file twit system\temp\twit.xml

  %twittmp_position = $null
  %twittmp_gotstatus = 0
  %twittmp_changedtextnotice = FIGYELEM: a st�tuszod a k�vetkez� lett (lehet, hogy m�r �rtad kor�bban ezt a sz�veget):
  %result = $dll(system\xml.dll,parse_file,twit)
  if (%result != S_OK) { /echo $color(info2) -atng *** twitter hiba: nem lehet �rtelmezni a szerver v�lasz�t! }

  if (!%twittmp_gotstatus) { /echo $color(info2) -atng *** twitter hiba: nem volt bent a st�tusz a szerver v�lasz�ban (val�sz�n�leg priv�t vagy �s rossz jelsz�t adt�l meg)! }

  dll system\xml.dll free_parser twit
}

alias twit_xml_hxmldecl {}
alias twit_xml_hattribute {}
alias twit_xml_hcdata {}
alias twit_xml_hstartelement {
  if (%twittmp_position) { %twittmp_position = %twittmp_position $+ / }
  %twittmp_position = %twittmp_position $+ $2
}
alias twit_xml_hendelement {
  %twittmp_position = $left(%twittmp_position, $calc($len(%twittmp_position) - ($len($2) + 1)) )
}
alias twit_xml_hchardata {
  if (!%twittmp_position) { return } ; nem erdekelnek a http fejlecek

  if (!%twittmp_showstatus) { ; twit kuldes
    if ( %twittmp_position == status/truncated && $2 == true ) {
      /echo $color(nick) -atng *** twitter: FIGYELEM: t�l hossz� volt az �zeneted!
      %twittmp_changedtextnotice = a st�tuszod a k�vetkez� lett:
    }
    if ( %twittmp_position == status/text ) {
      %twittmp_gotstatus = 1
      if ( $2- != %twittmp_msg ) {
        /echo $color(nick) -atng *** twitter: %twittmp_changedtextnotice
        /echo $color(nick) -atng *** twitter: $2-
      }
      else { /echo $color(nick) -atng *** twitter: twit elk�ldve! }
    }
  }
  else { ; statusz lekeres
    if ( %twittmp_position == user/status/text ) {
      /echo $color(nick) -atng *** twitter: a jelenlegi st�tuszod: $2-
      %twittmp_gotstatus = 1
    }
  }

  if ( %twittmp_position == hash/error ) {
    /echo $color(info2) -atng *** twitter hiba�zenet: $2-
  }
}
;END

;RSS
alias /rss {
  if ($hget(rss) == $null) {
    hmake rss 100
    if ($exists(system\rss_data.dat)) {
      hload rss system\rss_data.dat
    }
  }

  if (!$hget(rss,0).item || $file(system\rss.ini).mtime != %rss_ini_mtime) { rss_rehash }

  if ($1 == --init) { .timerRSS 0 60 .rss }
  else {
    if ($timer(RSS)) { .timerRSS off | .timerRSS 0 60 .rss }
    rss_checkall
  }
}
alias /rss_rehash {
  if (!$exists(system\rss.ini)) { echo $color(info2) -atng *** RSS hiba: a system\rss.ini f�jl nem l�tezik! | halt }

  if ($hget(rss) != $null) {
    hdel -w rss *
  }
  else { hmake rss 100 }

  .remove system\rss_data.dat

  if ($fopen(rssconfig)) { .fclose rssconfig }

  var %rsstmp_default_engedelyezes = $readini(system\rss.init,np,default,engedelyezes)
  var %rsstmp_default_url = $readini(system\rss.init,np,default,url)
  var %rsstmp_default_felhasznalonev = $readini(system\rss.init,np,default,felhasznalonev)
  var %rsstmp_default_jelszo = $readini(system\rss.init,np,default,jelszo)
  var %rsstmp_default_frissitesi_ido = $readini(system\rss.init,np,default,frissitesi_ido)
  var %rsstmp_default_cim_kiirasa = $readini(system\rss.init,np,default,cim_kiirasa)
  var %rsstmp_default_ido_kiirasa_a_cimbe = $readini(system\rss.init,np,default,ido_kiirasa_a_cimbe)
  var %rsstmp_default_leiras_kiirasa = $readini(system\rss.init,np,default,leiras_kiirasa)
  var %rsstmp_default_link_kiirasa = $readini(system\rss.init,np,default,link_kiirasa)
  var %rsstmp_default_aktiv_ablakba = $readini(system\rss.init,np,default,aktiv_ablakba)
  var %rsstmp_default_egyeb_ablakokba = $readini(system\rss.init,np,default,egyeb_ablakokba)
  var %rsstmp_default_csatikra = $readini(system\rss.init,np,default,csatikra)

  ; eloszor egyenkent vegigmegyunk a szekciokon
  .fopen rssconfig system\rss.ini
  var %line
  var %section
  while (!$feof) {
    %line = $fread(rssconfig)
    if ($left(%line,1) == $chr(35)) { continue } ; # char
    if ($left(%line,1) == $chr(91)) { ; [ char
      %section = $remove(%line,$chr(91),$chr(93))
      if (%section == default) { continue }
      if ($chr(59) isin %section) {
        echo $color(info2) -atng *** RSS hiba: nem lehet ; karaktert haszn�lni a feed nev�ben, feed �tugorva ( $+ %section $+ )!
        continue
      }
      if ($chr(32) isin %section) {
        echo $color(info2) -atng *** RSS hiba: nem lehet helyk�z karaktert haszn�lni a feed nev�ben, feed �tugorva ( $+ %section $+ )!
        continue
      }

      ; beletesszuk a szekcio nevet a feedek listajaba pontosvesszovel elvalasztva
      if ($hget(rss,feeds)) { hadd rss feeds $hget(rss,feeds) $+ ; $+ %section }
      else { hadd rss feeds %section }

      var %rsstmp_engedelyezes = %rsstmp_default_engedelyezes
      var %rsstmp_url = %rsstmp_default_url
      var %rsstmp_felhasznalonev = %rsstmp_default_felhasznalonev
      var %rsstmp_jelszo = %rsstmp_default_jelszo
      var %rsstmp_frissitesi_ido = %rsstmp_default_frissitesi_ido
      var %rsstmp_cim_kiirasa = %rsstmp_default_cim_kiirasa
      var %rsstmp_ido_kiirasa_a_cimbe = %rsstmp_default_ido_kiirasa_a_cimbe
      var %rsstmp_leiras_kiirasa = %rsstmp_default_leiras_kiirasa
      var %rsstmp_link_kiirasa = %rsstmp_default_link_kiirasa
      var %rsstmp_aktiv_ablakba = %rsstmp_default_aktiv_ablakba
      var %rsstmp_egyeb_ablakokba = %rsstmp_default_egyeb_ablakokba
      var %rsstmp_csatikra = %rsstmp_default_csatikra

      while (!$feof) {
        var %fpos $fopen(rssconfig).pos
        %line = $fread(rssconfig)
        if ($left(%line,1) == $chr(35)) { continue } ; # char
        if ($left(%line,1) == $chr(91)) { ; szekcio vege
          .fseek rssconfig %fpos ; mivel mar beolvastuk az uj szekcio sorat, visszaugrunk 1 sort
          break
        }

        var %param = $gettok(%line,1,61)
        if (%param == engedelyezes) { %rsstmp_engedelyezes = $gettok(%line,2-,61) }
        if (%param == url) { %rsstmp_url = $gettok(%line,2-,61) }
        if (%param == felhasznalonev) { %rsstmp_felhasznalonev = $gettok(%line,2-,61) }
        if (%param == jelszo) { %rsstmp_jelszo = $gettok(%line,2-,61) }
        if (%param == frissitesi_ido) { %rsstmp_frissitesi_ido = $gettok(%line,2-,61) }
        if (%param == cim_kiirasa) { %rsstmp_cim_kiirasa = $gettok(%line,2-,61) }
        if (%param == ido_kiirasa_a_cimbe) { %rsstmp_ido_kiirasa_a_cimbe = $gettok(%line,2-,61) }
        if (%param == leiras_kiirasa) { %rsstmp_leiras_kiirasa = $gettok(%line,2-,61) }
        if (%param == link_kiirasa) { %rsstmp_link_kiirasa = $gettok(%line,2-,61) }
        if (%param == aktiv_ablakba) { %rsstmp_aktiv_ablakba = $gettok(%line,2-,61) }
        if (%param == egyeb_ablakokba) { %rsstmp_egyeb_ablakokba = $gettok(%line,2-,61) }
        if (%param == csatikra) { %rsstmp_csatikra = $gettok(%line,2-,61) }
      }

      hadd rss %section $+ _engedelyezes %rsstmp_engedelyezes
      hadd rss %section $+ _url %rsstmp_url
      hadd rss %section $+ _felhasznalonev %rsstmp_felhasznalonev
      hadd rss %section $+ _jelszo %rsstmp_jelszo
      hadd rss %section $+ _frissitesi_ido %rsstmp_frissitesi_ido
      hadd rss %section $+ _cim_kiirasa %rsstmp_cim_kiirasa
      hadd rss %section $+ _ido_kiirasa_a_cimbe %rsstmp_ido_kiirasa_a_cimbe
      hadd rss %section $+ _leiras_kiirasa %rsstmp_leiras_kiirasa
      hadd rss %section $+ _link_kiirasa %rsstmp_link_kiirasa
      hadd rss %section $+ _aktiv_ablakba %rsstmp_aktiv_ablakba
      hadd rss %section $+ _egyeb_ablakokba %rsstmp_egyeb_ablakokba
      hadd rss %section $+ _csatikra %rsstmp_csatikra

      if (%rsstmp_engedelyezes) { % [ $+ rss_tmp_ $+ [ %section ] $+ _rehashed ] = 1 }
    }
  }
  .fclose rssconfig
  %rss_ini_mtime = $file(system\rss.ini).mtime
  hsave rss system\rss_data.dat
  echo $color(info) -atngq *** RSS: rss.ini �jrat�ltve
}
alias /rss_checkall {
  if ($gettok($hget(rss,feeds),0,59) == 0) {
    echo $color(info2) -atngq *** RSS hiba: nincsenek be�ll�tva feedek!
    /setup
    did -f setupdialog 322
    return
  }
  echo $color(notice) -atngq *** RSS: feedek ellen�rz�se...

  ; vegigmegyunk a pontosvesszovel elvalasztott feedek listajan
  var %i 1
  var %feedname
  while (%i <= $gettok($hget(rss,feeds),0,59)) {
    %feedname = $gettok($hget(rss,feeds),%i,59))
    if ($show || !$hget(rss,%feedname $+ _lastcheck) || $calc($ctime - $hget(rss,%feedname $+ _lastcheck)) >= $calc($hget(rss,%feedname $+ _frissitesi_ido) * 60) || $1 = -f) {
      rss_check %feedname
    }
    inc %i 1
  }
}
alias /rss_echo {
  if (!$show) { return }

  var %i 1
  var %wndcount $gettok($hget(rss,$3 $+ _egyeb_ablakokba),0,32)
  var %wndname

  if ($hget(rss,$3 $+ _aktiv_ablakba)) { ; aktiv ablakba
    echo $1 $2 $+ a $4-
  }

  while (%i <= %wndcount) {
    %wndname = $gettok($hget(rss,$3 $+ _egyeb_ablakokba),%i,32)
    if ($len(%wndname)) {
      %wndname = @ $+ RSS: $+ %wndname
      if (!$window(%wndname)) { /window -ekmhw3 %wndname Fixedsys }
      echo $1 $2 %wndname $4-
      if (n !isin $2) { /window -g1 %wndname }
    }
    inc %i 1
  }
}
alias /rss_msgtochannels {
  if (!$show) { return }

  var %i 1
  var %chancount = $gettok($hget(rss,$1 $+ _csatikra),0,32)

  while (%i <= %chancount) {
    var %csati = $gettok($hget(rss,$1 $+ _csatikra),%i,32)
    ; osszes kapcsolatra
    var %j $scon(0)
    while (%j > 0) {
      scon %j
      if ($scon(%j).$server && $chan(%csati)) { msg %csati $2- }
      scon -r
      dec %j 1
    }
    inc %i 1
  }
}
alias /rss_check { ; params: feedname, jump
  if ($1 == $null) { return }
  if (!$hget(rss,$1 $+ _engedelyezes)) {
    ;echo $color(info) -tngq *** RSS ( $+ $1 $+ ): a feed nincs enged�lyezve, kihagy�s
    return
  }
  var %url = $hget(rss,$1 $+ _url)
  var %proto = http
  if (https:// isin %url) { %proto = https }

  var %domain = $gethostnamefromurl(%url)
  var %port = $getportfromurl(%url)
  rss_echo $color(notice) -tngq $1 *** RSS ( $+ $1 $+ ): kapcsol�d�s ( $+ %domain $+ : $+ %port $+ )...

  if (!$show) { % [ $+ rss_tmp_ $+ [ $1 ] $+ _quiet ] = 1 }
  else { % [ $+ rss_tmp_ $+ [ $1 ] $+ _quiet ] = 0 }

  hadd rss $1 $+ _lastcheck $ctime

  if ($2) { % [ $+ rss_tmp_ $+ [ $1 ] $+ _rehashed ] = 1 }

  if ($sock(rss_ $+ $1)) {
    % [ $+ rss_tmp_ $+ [ $1 ] $+ _noanalyze ] = 1
    sockclose rss_ $+ $1
  }
  if (%proto == https) { sockopen -e rss_ $+ $1 %domain %port }
  else { sockopen rss_ $+ $1 %domain %port }
}
on 1:sockopen:rss_*: {
  var %feedname = $remove($sockname,rss_)
  if ($sockerr > 0) { if (!% [ $+ rss_tmp_ $+ [ %feedname ] $+ _quiet ]) { /rss_echo $color(info2) -tg %feedname *** RSS hiba ( $+ %feedname $+ ): nem lehet kapcsol�dni a szerverre! } | return }
  if (!% [ $+ rss_tmp_ $+ [ %feedname ] $+ _quiet ]) { /rss_echo $color(notice) -tng %feedname *** RSS ( $+ %feedname $+ ): let�lt�s... }
  write -c system\temp\rss_ $+ %feedname $+ .xml

  var %authtmp
  if ($hget(rss,%feedname $+ _felhasznalonev) != $null) {
    %authtmp = $base64($hget(rss,%feedname $+ _felhasznalonev) $+ : $+ $hget(rss,%feedname $+ _jelszo)).enc
  }
  var %url = $hget(rss,%feedname $+ _url)
  sockwrite -n $sockname GET %url HTTP/1.1
  sockwrite -n $sockname Accept: */*
  if (%authtmp) { sockwrite -n $sockname Authorization: Basic %authtmp }
  sockwrite -n $sockname User-Agent: netZ Script Pro v $+ %ver
  sockwrite -n $sockname Connection: close
  sockwrite -n $sockname Host: $gethostnamefromurl(%url) $+ : $+ $getportfromurl(%url)
  sockwrite -n $sockname
}
on 1:sockread:rss_*: {
  var %feedname = $remove($sockname,rss_)
  var &temp
  :ujraolvas
  sockread &temp
  if (!$sockbr) { return }
  bwrite system\temp\rss_ $+ %feedname $+ .xml -1 &temp
  goto ujraolvas
}
on 1:sockclose:rss_*: {
  var %feedname = $remove($sockname,rss_)
  if (!% [ $+ rss_tmp_ $+ [ %feedname ] $+ _noanalyze ]) { rss_analyze %feedname }
}
alias /rss_analyze {
  if ( !$isfile(system\temp\rss_ $+ $1 $+ .xml) ) {
    if (!% [ $+ rss_tmp_ $+ [ $1 ] $+ _quiet ]) { /rss_echo $color(info2) -tg $1 *** RSS hiba ( $+ $1 $+ ): nem �rkezett v�lasz a szervert�l! }
    return
  }
  if (!$file(system\temp\rss_ $+ $1 $+ .xml).size) { return }

  var %result = $dll(system\xml.dll,create_parser,rss_ $+ $1)
  if (%result != S_OK) { if (!% [ $+ rss_tmp_ $+ [ $1 ] $+ _quiet ]) { /rss_echo $color(info2) -tg $1 *** RSS hiba ( $+ $1 $+ ): nem lehet bet�lteni az XML �rtelmez�t (xml.dll)! } | return }

  dll system\xml.dll set_handler_startelement rss_ $+ $1 rss_xml_hstartelement
  dll system\xml.dll set_handler_endelement rss_ $+ $1 rss_xml_hendelement
  dll system\xml.dll set_handler_chardata rss_ $+ $1 rss_xml_hchardata
  dll system\xml.dll set_handler_cdata rss_ $+ $1 rss_xml_hcdata
  dll system\xml.dll set_file rss_ $+ $1 system\temp\rss_ $+ $1 $+ .xml

  % [ $+ rss_tmp_ $+ [ $1 ] $+ _position ] = $null
  % [ $+ rss_tmp_ $+ [ $1 ] $+ _displayed ] = 0
  %result = $dll(system\xml.dll,parse_file,rss_ $+ $1)
  if (%result != S_OK) { if (!% [ $+ rss_tmp_ $+ [ $1 ] $+ _quiet ]) { /rss_echo $color(info2) -tg $1 *** RSS hiba ( $+ $1 $+ ): nem lehet �rtelmezni a szerver v�lasz�t! } }
  else {
    if (!% [ $+ rss_tmp_ $+ [ $1 ] $+ _displayed ] && !% [ $+ rss_tmp_ $+ [ $1 ] $+ _jump ]) {
      if (!% [ $+ rss_tmp_ $+ [ $1 ] $+ _quiet ]) { /rss_echo $color(notice) -tng $1 *** RSS ( $+ $1 $+ ): nincs �j bejegyz�s. }
    }
  }

  dll system\xml.dll free_parser rss_ $+ $1

  if (% [ $+ rss_tmp_ $+ [ $1 ] $+ _displayed ]) { hadd rss $1 $+ _lastupdate $gmt }

  hsave rss system\rss_data.dat
  .remove system\temp\rss_ $+ $1 $+ .xml
  unset % [ $+ rss_tmp_ $+ [ $1 ] $+ _* ]
}

alias rss_xml_hstartelement {
  var %feedname = $remove($1,rss_)
  if (% [ $+ rss_tmp_ $+ [ %feedname ] $+ _position ]) { % [ $+ rss_tmp_ $+ [ %feedname ] $+ _position ] = % [ $+ rss_tmp_ $+ [ %feedname ] $+ _position ] $+ / }
  % [ $+ rss_tmp_ $+ [ %feedname ] $+ _position ] = % [ $+ rss_tmp_ $+ [ %feedname ] $+ _position ] $+ $2

  if ($2 == item) {
    % [ $+ rss_tmp_ $+ [ %feedname ] $+ _title ] = $null
    % [ $+ rss_tmp_ $+ [ %feedname ] $+ _link ] = $null
    % [ $+ rss_tmp_ $+ [ %feedname ] $+ _description ] = $null
    % [ $+ rss_tmp_ $+ [ %feedname ] $+ _pubdate ] = $null
  }
}
alias rss_xml_hendelement {
  var %feedname = $remove($1,rss_)
  % [ $+ rss_tmp_ $+ [ %feedname ] $+ _position ] = $left(% [ $+ rss_tmp_ $+ [ %feedname ] $+ _position ], $calc($len(% [ $+ rss_tmp_ $+ [ %feedname ] $+ _position ]) - ($len($2) + 1)) )

  if ($2 == item) {
    var %pubdate = % [ $+ rss_tmp_ $+ [ %feedname ] $+ _pubdate ]
    if (%pubdate <= $gmt && ( !$hget(rss,%feedname $+ _lastupdate) || %pubdate > $hget(rss,%feedname $+ _lastupdate) ) ) {
      ; rehash utan csak 3 bejegyzest kuldunk ki
      if (% [ $+ rss_tmp_ $+ [ %feedname ] $+ _rehashed ] && % [ $+ rss_tmp_ $+ [ %feedname ] $+ _displayed ] >= 3) {
        dll system\xml.dll free_parser rss_ $+ %feedname
        return
      }

      if (% [ $+ rss_tmp_ $+ [ %feedname ] $+ _displayed ]) { rss_echo $color(background) -ng %feedname - }
      ; ha van alahuzas, reverz, bold a kiemeles styleban, akkor azokat a kiemeles vegen ki kell kapcsolnunk
      var %url_kiemeles_unset
      if ( isin %url_kiemeles_style) { %url_kiemeles_unset = %url_kiemeles_unset $+  }
      if ( isin %url_kiemeles_style) { %url_kiemeles_unset = %url_kiemeles_unset $+  }
      if ( isin %url_kiemeles_style) { %url_kiemeles_unset = %url_kiemeles_unset $+  }
      if ( isin %url_kiemeles_style) { %url_kiemeles_unset = %url_kiemeles_unset $+  }
      var %link = %url_kiemeles_style $+ % [ $+ rss_tmp_ $+ [ %feedname ] $+ _link ] $+ %url_kiemeles_unset

      var %displayed = 0
      var %titleanddescmatch = 0
      if ($len(% [ $+ rss_tmp_ $+ [ %feedname ] $+ _title ]) > 0 && % [ $+ rss_tmp_ $+ [ %feedname ] $+ _title ] == % [ $+ rss_tmp_ $+ [ %feedname ] $+ _description ]) { %titleanddescmatch = 1 }
      if ($hget(rss,%feedname $+ _cim_kiirasa) && $len(% [ $+ rss_tmp_ $+ [ %feedname ] $+ _title ]) > 0) {
        var %timestring = $null
        if ($hget(rss,%feedname $+ _ido_kiirasa_a_cimbe)) {
          %timestring = ( $+ $asctime( $calc(%pubdate + (-1 * $timezone)),yyyy. mm. dd. HH:nn:ss) $+ )
        }

        if (%titleanddescmatch) {
          rss_echo $color(notice) -tg %feedname *** RSS ( $+ $color(nick) $+  $+ %feedname $+ ): $+ $color(nick) % [ $+ rss_tmp_ $+ [ %feedname ] $+ _title ] %timestring
          rss_msgtochannels %feedname (netZ RSS) ( $+ %feedname $+ ): % [ $+ rss_tmp_ $+ [ %feedname ] $+ _title ] %timestring
          %displayed = 1
        }
        else {
          rss_echo $color(notice) -tg %feedname *** RSS ( $+ $color(nick) $+  $+ %feedname $+ ): $+ $color(nick) % [ $+ rss_tmp_ $+ [ %feedname ] $+ _title ]  $+ %timestring
          rss_msgtochannels %feedname (netZ RSS) ( $+ %feedname $+ ): % [ $+ rss_tmp_ $+ [ %feedname ] $+ _title ]  $+ %timestring
          %displayed = 1
        }
      }
      if ($hget(rss,%feedname $+ _leiras_kiirasa) && !%titleanddescmatch && $len(% [ $+ rss_tmp_ $+ [ %feedname ] $+ _description ]) > 0 && % [ $+ rss_tmp_ $+ [ %feedname ] $+ _description ] != Nincs $+ $chr(32) $+ le�r�s) {
        rss_echo $color(notice) -tg %feedname *** RSS ( $+ $color(nick) $+  $+ %feedname $+ ): $+ $color(nick) % [ $+ rss_tmp_ $+ [ %feedname ] $+ _description ]
        rss_msgtochannels %feedname (netZ RSS) ( $+ %feedname $+ ): % [ $+ rss_tmp_ $+ [ %feedname ] $+ _description ]
        %displayed = 1
      }
      if ($hget(rss,%feedname $+ _link_kiirasa) && $len(% [ $+ rss_tmp_ $+ [ %feedname ] $+ _link ]) > 0) {
        rss_echo $color(notice) -tg %feedname *** RSS ( $+ $color(nick) $+  $+ %feedname $+ ): %link
        rss_msgtochannels %feedname (netZ RSS) ( $+ %feedname $+ ): % [ $+ rss_tmp_ $+ [ %feedname ] $+ _link ]
        %displayed = 1
      }
      if (%displayed) { inc % [ $+ rss_tmp_ $+ [ %feedname ] $+ _displayed ] 1 }
    }
    else { dll system\xml.dll free_parser rss_ $+ %feedname }
  }
}
alias rss_xml_hcdata {
  var %feedname = $remove($1,rss_)
  var %tmppos = % [ $+ rss_tmp_ $+ [ %feedname ] $+ _position ]
  var %data = $utf8($urldecode($2-)).dec

  if (%tmppos == rss/channel/item/title) { % [ $+ rss_tmp_ $+ [ %feedname ] $+ _title ] = %data }
  if (%tmppos == rss/channel/item/link) { % [ $+ rss_tmp_ $+ [ %feedname ] $+ _link ] = %data }
  if (%tmppos == rss/channel/item/description) { % [ $+ rss_tmp_ $+ [ %feedname ] $+ _description ] = %data }
}
alias rss_xml_hchardata {
  var %feedname = $remove($1,rss_)
  var %tmppos = % [ $+ rss_tmp_ $+ [ %feedname ] $+ _position ]
  var %data = $2-

  if (!%tmppos) { ; http fejlecek
    if ($left(%data,14) == Last-Modified:) {
      var %lastmodtime = $httpdate($mid(%data,16,$calc($len(%data) - 15)))
      if (%lastmodtime && $hget(rss,%feedname $+ _lastupdate) && %lastmodtime <= $hget(rss,%feedname $+ _lastupdate)) {
        dll system\xml.dll free_parser rss_ $+ %feedname
        return
      }
    }
    if ($left(%data,9) == Location:) {
      var %newurl = $mid(%data,11,$calc($len(%data) - 10))
      var %oldurl = $hget(rss,%feedname $+ _url)
      if (http:// !isin %newurl && https:// !isin %newurl) {
        if ($left(%newurl,1) != /) { %newurl = / $+ %newurl }
        %newurl = http:// $+ $gethostnamefromurl(%oldurl) $+ : $+ $getportfromurl(%oldurl) $+ %newurl
      }
      hadd rss %feedname $+ _url %newurl
      if (!% [ $+ rss_tmp_ $+ [ %feedname ] $+ _quiet ]) { /rss_echo $color(info) -tng %feedname *** RSS ( $+ %feedname $+ ): �tir�ny�t�s k�vet�se: %newurl }
      % [ $+ rss_tmp_ $+ [ %feedname ] $+ _jump ] = 1
      if (!% [ $+ rss_tmp_ $+ [ %feedname ] $+ _quiet ]) { .timer 1 0 /rss_check %feedname 1 }
      else { .timer 1 0 .rss_check %feedname 1 }
      return
    }
    if (%data == HTTP/1.0 $+ $chr(32) $+ 401 $+ $chr(32) $+ Unauthorized) {
      if (!% [ $+ rss_tmp_ $+ [ %feedname ] $+ _quiet ]) { /rss_echo $color(info2) -tg %feedname *** RSS hiba ( $+ %feedname $+ ): nem lehet autentik�lni, val�sz�n�leg hib�s a megadott felhaszn�l�n�v/jelsz�! }
    }
    if ($left(%data,12) == HTTP/1.0 $+ $chr(32) $+ 403) {
      if (!% [ $+ rss_tmp_ $+ [ %feedname ] $+ _quiet ]) { /rss_echo $color(info2) -tg %feedname *** RSS hiba ( $+ %feedname $+ ): el�r�si hiba! }
    }
    return
  }

  if (%tmppos == rss/channel/item/pubDate) {
    % [ $+ rss_tmp_ $+ [ %feedname ] $+ _pubdate ] = $httpdate(%data)

    ; feltetelezzuk, hogy a legutolso bejegyzes van legelol a fajlban es utana jonnek a regebbiek
    ; igy csak addig kell parseolnunk a fajlt amig el nem erunk egy mar latott bejegyzesig
    if ($hget(rss,%feedname $+ _lastupdate) && % [ $+ rss_tmp_ $+ [ %feedname ] $+ _pubdate ] <= $hget(rss,%feedname $+ _lastupdate)) {
      dll system\xml.dll free_parser rss_ $+ %feedname
      return
    }
  }
  if (%tmppos == rss/channel/item/title && % [ $+ rss_tmp_ $+ [ %feedname ] $+ _title ] == $null) {
    % [ $+ rss_tmp_ $+ [ %feedname ] $+ _title ] = $utf8($urldecode($2-)).dec
  }
  if (%tmppos == rss/channel/item/link && % [ $+ rss_tmp_ $+ [ %feedname ] $+ _link ] == $null) {
    % [ $+ rss_tmp_ $+ [ %feedname ] $+ _link ] = $utf8($urldecode($2-)).dec
  }
  if (%tmppos == rss/channel/item/description && % [ $+ rss_tmp_ $+ [ %feedname ] $+ _description ] == $null) {
    % [ $+ rss_tmp_ $+ [ %feedname ] $+ _description ] = $utf8($urldecode($2-)).dec
  }
}
menu @RSS:* {
  Feedek friss�t�se	[/rss]: /rss
  -
  Feedek szerkeszt�se: /run notepad system\rss.ini
  -
  Ablak bez�r�sa: /window -c $active
}
;END
