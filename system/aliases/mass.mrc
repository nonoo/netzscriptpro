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

;MASSOP
/massop {
  var %csati
  if ($1) { %csati = $1 }
  else { %csati = $active }
  if (%csati !ischan) { /echo $color(info2) -atng *** /massop hiba: a parancsot csati ablakban használd! | return }
  if ($me !isop %csati) {
    /echo $color(info2) -atng *** /massop hiba: nem vagy op $laz(%csati) %csati csatin!
    return
  }
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /massop hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  echo $color(info) -tg %csati *** Massop...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me !isop %csati) {
      /echo $color(info2) -atng *** /massop hiba: nem vagy op $laz(%csati) %csati csatin!
      return
    }
    if ($me != $nick(%csati,%i)) && ($nick(%csati,%i) !isop %csati) { /mode %csati +o $nick(%csati,%i) }
    inc %i 1
  }
}
/massdeop {
  var %csati
  if ($1) { %csati = $1 }
  else { %csati = $active }
  if (%csati !ischan) { /echo $color(info2) -atng *** /massdeop hiba: a parancsot csati ablakban használd! | return }
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /massdeop hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  if ($me !isop %csati) {
    /echo $color(info2) -atng *** /massdeop hiba: nem vagy op $laz(%csati) %csati csatin!
    return
  }
  echo $color(info) -tg %csati *** Massdeop...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me !isop %csati) {
      /echo $color(info2) -atng *** /massdeop hiba: nem vagy op $laz(%csati) %csati csatin!
      return
    }
    if ($me != $nick(%csati,%i)) && ($nick(%csati,%i) isop %csati) { /mode %csati -o $nick(%csati,%i) }
    inc %i 1
  }
}
;END

;MASSMSG
/massmsg {
  if (!$2) { /echo $color(info2) -atng *** /massmsg hiba: túl kevés paraméter! használat: /massmsg [csati] [msg] | return }
  var %csati $1
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /massmsg hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  echo $color(info) -tg %csati *** Massmsg...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me != $nick(%csati,%i)) { /msg $nick(%csati,%i) $2- }
    inc %i 1
  }
}
/massmsgops {
  if (!$2) { /echo $color(info2) -atng *** /massmsgops hiba: túl kevés paraméter! használat: /massmsgops [csati] [msg] | return }
  var %csati $1
  echo $color(info) -tg %csati *** Massmsg opoknak...
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /massmsgops hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me != $nick(%csati,%i)) && ($nick(%csati,%i) isop %csati) { /msg $nick(%csati,%i) $2- }
    inc %i 1
  }
}
/massmsgnonops {
  if (!$2) { /echo $color(info2) -atng *** /massmsgnonops hiba: túl kevés paraméter! használat: /massmsgnonops [csati] [msg] | return }
  var %csati $1
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /massmsgnonops hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  echo $color(info) -tg %csati *** Massmsg nem opoknak...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me != $nick(%csati,%i)) && ($nick(%csati,%i) !isop %csati) { /msg $nick(%csati,%i) $2- }
    inc %i 1
  }
}
;END

;MASSKICK
/masskick {
  var %csati
  if ($1) { %csati = $1 }
  else { %csati = $active }
  if (%csati !ischan) { /echo $color(info2) -atng *** /masskick hiba: a parancsot csati ablakban használd! | return }
  if ($me !isop %csati) {
    /echo $color(info2) -atng *** /masskick hiba: nem vagy op $laz(%csati) %csati csatin!
    return
  }
  echo $color(info) -tg %csati *** Masskick...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me !isop %csati) {
      /echo $color(info2) -atng *** /masskick hiba: nem vagy op $laz(%csati) %csati csatin!
      return
    }
    if ($me != $nick(%csati,%i)) && ($nick(%csati,%i) !isop %csati) { /kick %csati $nick(%csati,%i) $2- }
    inc %i 1
  }
}
;END

;MASSNOTICE
/massnotice {
  if (!$2) { /echo $color(info2) -atng *** /massnotice hiba: túl kevés paraméter! használat: /massnotice [csati] [msg] | return }
  var %csati $1
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /massnotice hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  echo $color(info) -tg %csati *** Massnotice...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me != $nick(%csati,%i)) { /notice $nick(%csati,%i) $2- }
    inc %i 1
  }
}
/massnoticeops {
  if (!$2) { /echo $color(info2) -atng *** /massnoticeops hiba: túl kevés paraméter! használat: /massnoticeops [csati] [msg] | return }
  var %csati $1
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /massnoticeops hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  echo $color(info) -tg %csati *** Massnotice opoknak...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me != $nick(%csati,%i)) && ($nick(%csati,%i) isop %csati) { /notice $nick(%csati,%i) $2- }
    inc %i 1
  }
}
/massnoticenonops {
  if (!$2) { /echo $color(info2) -atng *** /massnoticenonops hiba: túl kevés paraméter! használat: /massnoticenonops [csati] [msg] | return }
  var %csati $1
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /massnoticenonops hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  echo $color(info) -tg %csati *** Massnotice nem opoknak...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me != $nick(%csati,%i)) && ($nick(%csati,%i) !isop %csati) { /notice $nick(%csati,%i) $2- }
    inc %i 1
  }
}
;END

;MASSDCCSEND
/massdccsend {
  if (!$2) { /echo $color(info2) -atng *** /massdccsend hiba: túl kevés paraméter! használat: /massdccsend [csati] [fájl] | return }
  var %csati $1
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /massdccsend hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  echo $color(info) -tg %csati *** Mass DCC Send...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me != $nick(%csati,%i)) { /dcc send $nick(%csati,%i) $2- }
    inc %i 1
  }
}
;END

;MASSINVITE
/massinvite {
  if (!$2) { /echo $color(info2) -atng *** /massinvite hiba: túl kevés paraméter! használat: /massinvite [csati] [hova] | return }
  var %csati $1
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /massinvite hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  echo $color(info) -tg %csati *** Mass invite a $2 csatira...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me != $nick(%csati,%i)) { /invite $nick(%csati,%i) $2 }
    inc %i 1
  }
}
/massinvitenonops {
  if (!$2) { /echo $color(info2) -atng *** /massinvitenonops hiba: túl kevés paraméter! használat: /massinvitenonops [csati] [hova] | return }
  var %csati $1
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /massinvitenonops hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  echo $color(info) -tg %csati *** Mass invite (nem oposokat) a $2 csatira...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me != $nick(%csati,%i)) && ($nick(%csati,%i) !isop %csati) { /invite $nick(%csati,%i) $2 }
    inc %i 1
  }
}
;END

;MASSVOICE (nem oposokra)
/massvoice {
  var %csati
  if ($1) { %csati = $1 }
  else { %csati = $active }
  if (%csati !ischan) { /echo $color(info2) -atng *** /massvoice hiba: a parancsot csati ablakban használd! | return }
  if ($me !isop %csati) {
    /echo $color(info2) -atng *** /massvoice hiba: nem vagy op $laz(%csati) %csati csatin!
    return
  }
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /massvoice hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  echo $color(info) -tg %csati *** Massvoice...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me !isop %csati) {
      /echo $color(info2) -atng *** /massvoice hiba: nem vagy op $laz(%csati) %csati csatin!
      return
    }
    if ($me != $nick(%csati,%i)) && ($nick(%csati,%i) !isop %csati) { /mode %csati +v $nick(%csati,%i) }
    inc %i 1
  }
}
;END

;MASSDEVOICE (nem oposokra)
/massdevoice {
  var %csati
  if ($1) { %csati = $1 }
  else { %csati = $active }
  if (%csati !ischan) { /echo $color(info2) -atng *** /massdevoice hiba: a parancsot csati ablakban használd! | return }
  if ($me !isop %csati) {
    /echo $color(info2) -atng *** /massdevoice hiba: nem vagy op $laz(%csati) %csati csatin!
    return
  }
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /massdevoice hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  echo $color(info) -tg %csati *** Massdevoice...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me !isop %csati) {
      /echo $color(info2) -atng *** /massdevoice hiba: nem vagy op $laz(%csati) %csati csatin!
      return
    }
    if ($me != $nick(%csati,%i)) && ($nick(%csati,%i) !isop %csati) { /mode %csati -v $nick(%csati,%i) }
    inc %i 1
  }
}
;END

;MASSKICKBAN (nem oposokra)
/masskickban {
  var %csati
  if ($1) { %csati = $1 }
  else { %csati = $active }
  if (%csati !ischan) { /echo $color(info2) -atng *** /masskickban hiba: a parancsot csati ablakban használd! | return }
  if ($me !isop %csati) {
    /echo $color(info2) -atng *** /masskickban hiba: nem vagy op $laz(%csati) %csati csatin!
    return
  }
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /masskickban hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  echo $color(info) -tg %csati *** Masskickban...
  var %i 1
  while (%i <= $nick(%csati,0)) {
    if ($me !isop %csati) {
      /echo $color(info2) -atng *** /masskickban hiba: nem vagy op $laz(%csati) %csati csatin!
      return
    }
    if ($me != $nick(%csati,%i)) && ($nick(%csati,%i) !isop %csati) { /kickban %csati $nick(%csati,%i) }
    inc %i 1
  }
}
;END

;MASSHIGHLIGHT
/masshighlight {
  var %csati
  if ($1) { %csati = $1 }
  else { %csati = $active }
  if (%csati !ischan) { /echo $color(info2) -atng *** /masshighlight hiba: a parancsot csati ablakban használd! | return }
  if (!$nick(%csati,0)) { /echo $color(info2) -atng *** /masshighlight hiba: nem vagy bennt $laz(%csati) %csati csatin! | return }
  var %i 1
  var %nicklist
  while (%i <= $nick(%csati,0)) {
    if ($me != $nick(%csati,%i)) { %nicklist = %nicklist $+ $chr(32) $+ $nick(%csati,%i) }
    if ($len(%nicklist) > 200) { /msg %csati %nicklist | %nicklist = $null }
    inc %i 1
  }
  /msg %csati %nicklist
}
;END
