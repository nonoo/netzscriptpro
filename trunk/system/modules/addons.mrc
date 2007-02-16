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
  var %tempszoveg $1
  if (%onrandomcase) { %tempszoveg = $randomcase(%tempszoveg) }
  if (%ontopten) { %tempszoveg = $topten(%tempszoveg) }
  if (%onelite) { %tempszoveg = $elite(%tempszoveg) }
  if (%onreverse) { %tempszoveg = $reverse(%tempszoveg) }
  if (%onrcolor) { %tempszoveg = $randomcolor(%tempszoveg)    }
  if (%onbold) { %tempszoveg =  $+ %tempszoveg }
  if (%oninverse) { %tempszoveg =  $+ %tempszoveg }
  if (%onunderline) { %tempszoveg =  $+ %tempszoveg }
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
  sockwrite -n szotar GET http://szotar.sztaki.hu/dict_search.php?L= $+ %nyelvfrom $+ : $+ %nyelvto $+ : $+ %szotar $+ &S=W&M=3&MR=30&O=HUN&wap_exp=1&C=1&W= $+ $replace(%szo,$chr(32),+)
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
