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

;ONMODE
alias modekiir {
  var %i = 0
  var %c
  ; hanyadik modenal jarunk a pluszminusz jelet nemszamitva
  var %modec 2
  var %param
  ; ez jelzi hogy modeot adunk hozza vagy veszunk el
  var %plusz 1
  ; vegigmegyunk minden egyes karakteren
  while (%i < $len($1)) {
    inc %i 1
    %c = $right($left($1,%i),1)
    if (%c == +) { %plusz = 1 | continue }
    if (%c == -) { %plusz = 0 | continue }
    %param = [ $ $+ [ %modec ] ]
    if (%plusz) {
      if (%c = h ) {
        if (%nick = $me) && (%param = $me) { /echo $color(mode) -tn %chan *** Half Opot adt�l magadnak. ( $+ $color(gray) $+ +h %param $+ ) | inc %modec 1 | continue }
        if (%nick = $me) { /echo $color(mode) -tn %chan *** Half Opot adt�l $+ $color(gray) %param $+  $+ $color(mode) $+ $toldalek(%param,-nak,-nek) $+ . ( $+ $color(gray) $+ +h %param $+ ) }
        if (%param = $me) { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) Half Opot adott neked! ( $+ $color(gray) $+ +h %param $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) Half Opot adott $+ $color(gray) %param  $+ $color(mode) $+ $toldalek(%param,-nak,-nek). ( $+ $color(gray) $+ +h %param $+ ) }
        inc %modec 1
        continue
      }
      if (%c = l ) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** User limitet �ll�tott�l be a csatinak! ( $+ $color(gray) $+ +l %chan %param $+ ) }
        else {  /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) user limitet �ll�tott be a csatinak. ( $+ $color(gray) $+ +l %chan %param $+ ) }
        inc %modec 1
        continue
      }
      if (%c = o) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** Opot adt�l  $+ $color(gray) $+ %param $+  $+ $color(mode) $+ $toldalek(%param,-nak,-nek) $+ . ( $+ $color(gray) $+ +o %param $+ ) | inc %modec 1 | continue }
        if (%param = $me) { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) opot adott neked! ( $+ $color(gray) $+ +o $me $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) opot adott $+ $color(gray) %param $+  $+ $color(mode) $+ $toldalek(%param,-nak,-nek) $+ . ( $+ $color(gray) $+ +o %param $+ ) }
        inc %modec 1
        continue
      }
      if (%c = a) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** Channel Ownert adt�l $+ $color(gray) %param $+  $+ $color(mode) $+ $toldalek(%param,-nak,-nek) $+ . ( $+ $color(gray) $+ +a %param $+ ) }
        if (%param = $me ) { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) Channel Ownert adott neked! ( $+ $color(gray) $+ +a %param $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) Channel Ownert adott $+ $color(gray) %param  $+ $color(mode) $+ $toldalek(%param,-nak,-nek) $+ . ( $+ $color(gray) $+ +a %param $+ ) }
        inc %modec 1
        continue
      }
      if (%c = k) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** Jelszavat �ll�tott�l be a csatinak! ( $+ $color(gray) $+ +k %param $+ ) }
        else {  /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) jelszavat �ll�tott be a csatinak. ( $+ $color(gray) $+ +k %param $+ ) }
        continue
        inc %modec 1
      }
      if (%c = i) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** Be�ll�tottad a csatinak az invite only flaget! ( $+ $color(gray) $+ +i %chan $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) be�ll�totta az invite only flaget a csatinak. ( $+ $color(gray) $+ +i %chan $+ ) }
        continue
      }
      if (%c = m) {
        if (%nick = $me ) { /echo $color(mode) -tn %chan *** A csati moder�lt lett! ( $+ $color(gray) $+ +m %chan $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) moder�ltra �ll�totta a csatit! ( $+ $color(gray) $+ +m %chan $+ ) }
        continue
      }
      if (%c = n ) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** A csatira ezent�l nem lehet k�ls� �zenetet k�ldeni! ( $+ $color(gray) $+ +n %chan $+ ) }
        else { /echo $color(mode) -tn %chan *** A csatira ezent�l nem lehet k�ls� �zenetet k�ldeni! ( $+ $color(gray) $+ +n %chan by $+ $color(gray) %nick $+ ) }
        continue
      }
      if (%c = t ) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** A csatin ezent�l csak az opok tudj�k a topicot megv�ltoztatni! (+t %chan $+ ) }
        else { /echo $color(mode) -tn %chan *** A csatin ezent�l csak az opok tudj�k a topicot megv�ltoztatni! ( $+ $color(gray) $+ +t %chan by $+ $color(gray) %nick $+ ) }
        continue
      }
      if (%c = s) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** A csati ezent�l titkos! ( $+ $color(gray) $+ +s %chan $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) titkoss� tette a csatit. ( $+ $color(gray) $+ +s %chan $+ ) }
        continue
      }
      if (%c = p) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** A csati priv�t lett! ( $+ $color(gray) $+ +p %chan $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) priv�tt� tette a csatit. ( $+ $color(gray) $+ +p %chan $+ ) }
        continue
      }
      if (%c = v) {
        if (%param = $me) && (%nick = $me) { /echo $color(mode) -tn %chan *** Voiceot adt�l magadnak! | inc %modec 1 | continue }
        if (%param = $me) { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ voiceot adott neked! }
        elseif (%nick = $me) { /echo $color(mode) -tn %chan *** Voiceot adt�l $+ $color(gray) %param $+  $+ $color(mode) $+ $toldalek(%param,-nak,-nek) $+ . }
        elseif (%param = %nick) { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ voiceot adott mag�nak. ( $+ $color(gray) $+ +v %nick $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ voiceot adott $+ $color(gray) %param $+  $+ $color(mode) $+ $toldalek(%param,-nak,-nek). ( $+ $color(gray) $+ +v %param $+ ) }
        inc %modec 1
        continue
      }
      if (%c = b) { inc %modec 1 | continue }
      if (%c === R) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** Reop hostot �ll�tott�l be a csatinak! ( $+ $color(gray) $+ +R %param $+ ) }
        else {  /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) �j reop hostot �ll�tott be a csatinak. ( $+ $color(gray) $+ +R %param $+ ) }
        continue
        inc %modec 1
      }

      ; ha nem egyezett egyik parameterre sem
      if (%nick = $me) { /echo $color(mode) -tn %chan *** Mode: + $+ %c %chan }
      else { /echo $color(mode) -tn %chan *** Mode: + $+ %c %chan by $+ $color(gray) %nick }

    }
    else {

      if (%c = l ) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** Leszedted a user limitet a csatir�l! ( $+ $color(gray) $+ -l %chan $+ ) }
        else {  /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) leszedte a user limitet a csatir�l. ( $+ $color(gray) $+ -l %chan $+ ) }
        continue
      }
      if (%c = a) {
        if (%nick = $me) && (%param = $me) { /echo $color(mode) -tn %chan *** Elvetted a Channel Ownert magadt�l. ( $+ $color(gray) $+ -a %param $+ ) | inc %modec 1 | continue }
        if (%nick = $me) { /echo $color(mode) -tn %chan *** Elvetted a Channel Ownert $+ $color(gray) %param $+  $+ $color(mode) $+ $toldalek(%param,-t�l,-t�l) $+ . ( $+ $color(gray) $+ -a %param $+ ) }
        if (%param = $me) { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) elvette a Channel Ownert t�led! ( $+ $color(gray) $+ -a %param $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) elvette a Channel Ownert $+ $color(gray) %param  $+ $color(mode) $+ $toldalek(%param,-t�l,-t�l) $+ . ( $+ $color(gray) $+ -a %param $+ ) }
        inc %modec 1
        continue
      }
      if (%c = h) {
        if (%nick = $me) && (%param = $me) { /echo $color(mode) -tn %chan *** Elvetted a Half Opot magadt�l. ( $+ $color(gray) $+ -a %param $+ ) | inc %modec 1 | continue }
        if (%nick = $me) { /echo $color(mode) -tn %chan *** Elvetted a Half Opot $+ $color(gray) %param $+  $+ $color(mode) $+ $toldalek(%param,-t�l,-t�l) $+ . ( $+ $color(gray) $+ -a %param $+ ) }
        if (%param = $me) { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) elvette a Half Opot t�led! ( $+ $color(gray) $+ -a %param $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) elvette a Half Opot $+ $color(gray) %param  $+ $color(mode) $+ $toldalek(%param,-t�l,-t�l) $+ . ( $+ $color(gray) $+ -a %param $+ ) }
        inc %modec 1
        continue
      }
      if (%c = k) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** Leszedted a jelsz�t a csatir�l! ( $+ $color(gray) $+ -k %param $+ ) }
        else {  /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) leszedte a jelsz�t a csatir�l. ( $+ $color(gray) $+ -k %param $+ ) }
        inc %modec 1
        continue
      }
      if (%c = i) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** Leszedted az invite only flaget a csatir�l! ( $+ $color(gray) $+ -i %chan $+ ) }
        else {  /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) leszedte az invite only flaget a csatir�l. ( $+ $color(gray) $+ -i %chan $+ ) }
        continue
      }
      if (%c = m) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** A csati ezent�l nem moder�lt! ( $+ $color(gray) $+ -m %chan $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) leszedte a moder�lts�got a csatir�l. ( $+ $color(gray) $+ -m %chan $+ ) }
        continue
      }
      if (%c = n) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** A csatira ezent�l lehet k�ls� �zenetet k�ldeni! ( $+ $color(gray) $+ -n %chan $+ ) }
        else {  /echo $color(mode) -tn %chan *** A csatira ezent�l lehet k�ls� �zenetet k�ldeni! ( $+ $color(gray) $+ -n %chan by %nick $+ ) }
        continue
      }
      if (%c = t) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** A csatin ezent�l b�rki megv�ltoztathatja a topicot! ( $+ $color(gray) $+ -t %chan $+ ) }
        else {  /echo $color(mode) -tn %chan *** A csatin ezent�l b�rki megv�ltoztathatja a topicot! ( $+ $color(gray) $+ -t %chan by %nick $+ ) }
        continue
      }
      if (%c = s) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** A csati ezent�l nem titkos! ( $+ $color(gray) $+ -s %chan $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) leszedte a csatir�l a secret flaget. ( $+ $color(gray) $+ -s %chan $+ ) }
        continue
      }
      if (%c = p) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** A csati ezent�l nem priv�t! ( $+ $color(gray) $+ -p %chan $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) leszedte a private flaget a csatir�l. ( $+ $color(gray) $+ -p %chan $+ ) }
        continue
      }
      if (%c = v) {
        if (%param = $me ) && (%nick = $me) { /echo $color(mode) -tn %chan *** Elvetted magadt�l a voiceodat! | inc %modec 1 | continue }
        if (%param = $me ) { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ elvette a voiceodat! }
        elseif (%nick = $me) { /echo $color(mode) -tn %chan *** Elvetted $+ $color(gray) %param  $+ $color(mode) $+ voice�t. }
        elseif (%param = %nick) { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ elvette a voiceot mag�t�l. ( $+ $color(gray) $+ -v %nick $+ ) }
        else { /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ elvette $+ $color(gray) %param  $+ $color(mode) $+ voice�t. ( $+ $color(gray) $+ -v %param $+ ) }
        inc %modec 1
        continue
      }
      if (%c = o) { inc %modec 1 | continue }
      if (%c = b) { inc %modec 1 | continue }
      if (%c === R) {
        if (%nick = $me) { /echo $color(mode) -tn %chan *** Leszedted $laz(%param) %param reop hostot a csatir�l! ( $+ $color(gray) $+ -R %param $+ ) }
        else {  /echo $color(mode) -tn %chan *** $+ $color(gray) %nick  $+ $color(mode) $+ ( $+ %address $+ ) leszedte $laz(%param) $+  $+ $color(gray) %param reop hostot a csatir�l. ( $+ $color(gray) $+ -R %param $+ ) }
        inc %modec 1
        continue
      }

      ; ha nem egyezett egyik parameterre sem
      if (%nick = $me) { /echo $color(mode) -tn %chan *** Mode: - $+ %c %chan }
      else { /echo $color(mode) -tn %chan *** Mode: - $+ %c %chan by  $+ $color(gray) $+ %nick }
    }
  }
  unset %nick %chan %address
}
on ^1:RAWMODE:*: {
  %nick = $nick | %chan = $chan | %address = $address
  /modekiir $1-
  halt
}
;END

;ONKICK
on ^1:KICK:*: {
  /haltdef
  var %kreason = $1-
  if (%kreason) { %kreason = ( $+ $color(other) $+ %kreason $+ ) }
  if ($nick = $me) && ( $knick = $me ) { /echo $color(kick) -tn $chan *** Kir�gtad magad a csatir�l! %kreason | goto dudva }
  if ($nick = $me) { /echo $color(kick) -tn $chan *** Kir�gtad $+ $color(other) $knick $+ -t a csatir�l! %kreason | goto dudva }
  if ($nick = $knick) { /echo $color(kick) -tn $chan ***  $+ $color(other) $nick ( $+ $address $+ ) kir�gta mag�t a csatir�l! %kreason | goto dudva }
  if ($knick = $me) { /echo $color(kick) -tn $chan *** $+ $color(other) $nick ( $+ $address $+ ) kir�gott a csatir�l! %kreason }
  else { /echo $color(kick) -tn $chan *** $+ $color(other) $nick ( $+ $address $+ ) kir�gta $+ $color(other) $knick $+ -t! %kreason }
  :dudva
  if ($nick != $me) && (%flooddetekt) {
    var %kutya = $hget(flood,$cid $+ $nick $+ kicks $+ $chan)
    if (!%kutya) { %kutya = 1 }
    else { inc %kutya 1 }
    if (%kutya >= %max_kick) {
      if (%flooddetekt_csatikra) && ($chan isin %flooddetekt_csatik) {
        echo $color(other) -tg $chan *** $nick masskickelt!
      }
      if (!%flooddetekt_csatikra) {
        echo $color(other) -tg $chan *** $nick masskickelt!
      }

      if (%flooddetekt_csatikra) && ($chan !isin %flooddetekt_csatik) {
        goto nem
      }
      if ($me isop $chan) {
        if (%ban_kick) { .timer 1 0 /kickban $chan $nick masskick }
        elseif (%kick_kick) {
          .timer 1 0 /kick $chan $nick masskick
        }
      }
      :nem
      .hdel flood $cid $+ $nick $+ kicks $+ $chan
      halt
    }
    .hadd -u $+ %time_kick flood $cid $+ $nick $+ kicks $+ $chan %kutya
  }
  /halt
}
;END

;ONUNBAN
on ^1:UNBAN:*: {
  /haltdef
  if ( $nick != $me ) { /echo $color(kick) -tn $chan *** $+ $color(other) $nick ( $+ $address $+ ) levette a $+ $color(other) $banmask hostot a banlist�r�l! ( $+ $color(other) $+ -b $banmask $+ ) }
  else { /echo $color(kick) -tn $chan *** Levetted a $+ $color(other) $banmask hostot a banlist�r�l! ( $+ $color(other) $+ -b $banmask $+ ) }
  /halt
}
;END

;ONBAN
on ^1:BAN:*: {
  /haltdef
  if ($nick = $me) { /echo $color(kick) -tn $chan *** Bannoltad $laz($banmask) $+  $+ $color(other) $banmask hostot! }
  else { 
    /echo $color(kick) -tn $chan *** $+ $color(other) $nick ( $+ $address $+ ) bannolta $laz($banmask) $+  $+ $color(other) $banmask hostot!
    ; ha minket bannoltak
    if ($me isop $chan) {
      if ($banmask iswm $address($me,5)) {
        .timer 1 0 /mode $chan -bo $banmask $nick
        /echo $color(other) -tg $chan *** $nick bannolt t�ged! (F8 - KickBan $nick $+ )
        .hdel data $cid $+ doit $+ $replace($active,Status Window,status)
        .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /kickban $chan $nick
      }
      elseif ($bnick = $me) {
        .timer 1 0 /mode $chan -bo $banmask $nick
        /echo $color(other) -tg $chan *** $nick bannolt t�ged! (F8 - KickBan $nick $+ )
        .hdel data $cid $+ doit $+ $replace($active,Status Window,status)
        .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /kickban $chan $nick
      }
    }
    else {
      if ($banmask iswm $address($me,5)) || ($bnick = $me) {
        /echo $color(other) -tg $chan *** $nick bannolt t�ged!
      }
    }
  }
  if (%flooddetekt) {
    var %kutya = $hget(flood,$cid $+ $nick $+ bans $+ $chan)
    if (!%kutya) { %kutya = 1 }
    else { inc %kutya 1 }
    if (%kutya >= %max_ban) {
      if (%flooddetekt_csatikra) && ($chan isin %flooddetekt_csatik) {
        echo $color(other) -tg $chan *** $nick massbannolt!
      }
      if (!%flooddetekt_csatikra) {
        echo $color(other) -tg $chan *** $nick massbannolt!
      }

      if (%flooddetekt_csatikra) && ($chan !isin %flooddetekt_csatik) {
        goto nem
      }
      if ($me isop $chan) {
        if (%ban_ban) { .timer 1 0 /kickban $chan $nick massban }
        elseif (%kick_ban) {
          .timer 1 0 /kick $chan $nick massban
        }
      }
      .hdel flood $cid $+ $nick $+ bans $+ $chan
      halt
    }
    .hadd -u $+ %time_ban flood $cid $+ $nick $+ bans $+ $chan %kutya
  }
  /halt
}
;END

;ONDEOP
on ^1:deop:*: {
  /haltdef
  if ($nick = $me) {
    if ($opnick = $me) { /echo $color(kick) -tn $chan *** Elvetted az opot magadt�l. ( $+ $color(other) $+ -o $opnick $+ ) }
    else { /echo $color(kick) -tn $chan *** Elvetted az opot $+ $color(highlight) $opnick $+  $+ $toldalek($opnick,-t�l,-t�l) $+ . ( $+ $color(other) $+ -o $opnick $+ ) }
    halt
  }
  if ($opnick = $nick) { /echo $color(mode) -tn $chan *** $+ $color(other) $nick ( $+ $address $+ ) elvette az opot mag�t�l. ( $+ $color(highlight) $+ -o $opnick $+ ) }
  elseif ($opnick = $me) { /echo $color(kick) -t $chan *** $+ $color(other) $nick ( $+ $address $+ ) elvette az opot t�led! ( $+ $color(highlight) $+ -o $opnick $+  $+ $color(other) $+ ) }
  else { /echo $color(kick) -t $chan *** $+ $color(other) $nick ( $+ $address $+ ) elvette az opot $+ $color(other) $opnick $+  $+ $toldalek($opnick,-t�l,-t�l) $+ ! ( $+ $color(other) $+ -o $opnick $+ ) }
  :hah
  if ($nick != $me) {
    if (%flooddetekt) {
      var %kutya = $hget(flood,$cid $+ $nick $+ deops $+ $chan)
      if (!%kutya) { %kutya = 1 }
      else { inc %kutya 1 }
      if (%kutya >= %max_deop) {
        if (%flooddetekt_csatikra) && ($chan isin %flooddetekt_csatik) {
          echo $color(other) -tg $chan *** $nick massdeopolt!
        }
        if (!%flooddetekt_csatikra) {
          echo $color(other) -tg $chan *** $nick massdeopolt!
        }

        if (%flooddetekt_csatikra) && ($chan !isin %flooddetekt_csatik) {
          goto nem
        }
        if ($me isop $chan) {
          if (%ban_deop) { .timer 1 0 /kickban $chan $nick massdeop }
          elseif (%kick_deop) {
            .timer 1 0 /kick $chan $nick massdeop
          }
        }
        .hdel flood $cid $+ $nick $+ deops $+ $chan
        halt
      }
      .hadd -u $+ %time_deop flood $cid $+ $nick $+ deops $+ $chan %kutya
    }
  }
  /halt
}
;END
