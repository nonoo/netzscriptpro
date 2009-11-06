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

;HASZNÁLAT
/jobhasznalat {
  /echo $color(info2) -atng *** /job hiba: túl kevés paraméter! használat: /job (dátum (pl. 2007/11/06, 11/06)) vagy holnap vagy (nap(ok) neve(i), retrig, vesszõvel elválasztva)) [idõ (pl. 0:25)] [parancs]
}

/alarmhasznalat {
  /echo $color(info2) -atng *** /alarm hiba: túl kevés paraméter! használat: /alarm (dátum (pl. 2007/11/06, 11/06)) vagy holnap vagy (nap(ok) neve(i), retrig, vesszõvel elválasztva)) [idõ (pl. 0:25)] [üzenet]
}

/ebresztohasznalat {
  /echo $color(info2) -atng *** /ebreszto hiba: túl kevés paraméter! használat: /ebreszto (-NUM(,DELAY) NUM=hányszor aktiválódjon az ébresztõ,DELAY=hány perc legyen a késleltetés) (dátum (pl. 2007/11/06, 11/06)) vagy holnap vagy (nap(ok) neve(i), retrig, vesszõvel elválasztva)) [idõ (pl. 0:25)] [üzenet]
}
;END

;SEGÉDFÜGGVÉNYEK
/daynamehun2eng {
  if ( $1 == hétfõ || $1 == hetfo ) { return mon }
  if ( $1 == kedd ) { return tue }
  if ( $1 == szerda ) { return wed }
  if ( $1 == csütörtök || $1 == csutortok ) { return thu }
  if ( $1 == péntek || $1 == pentek ) { return fri }
  if ( $1 == szombat ) { return sat }
  if ( $1 == vasárnap || $1 == vasarnap ) { return sun }
  return $null
}

/daynameeng2hun {
  if ( $1 == mon || $1 == monday ) { return hétfõ }
  if ( $1 == tue || $1 == tuesday ) { return kedd }
  if ( $1 == wed || $1 == wednesday ) { return szerda }
  if ( $1 == thu || $1 == thursday ) { return csütörtök }
  if ( $1 == fri || $1 == friday ) { return péntek }
  if ( $1 == sat || $1 == saturday ) { return szombat }
  if ( $1 == sun || $1 == sunday ) { return vasárnap }
  return $null
}

; 1 byteal ter vissza, aminek az elso bitje 1, ha retriggerelni kell az esemenyt, tobbi bit pedig a napot mutatja
/getprop {
  var %prop 0
  if (hetfo isin $1 || hétfõ isin $1) { %prop = $biton(%prop,2) }
  if (kedd isin $1) { %prop = $biton(%prop,3) }
  if (szerda isin $1) { %prop = $biton(%prop,4) }
  if (csutortok isin $1 || csütörtök isin $1) { %prop = $biton(%prop,5) }
  if (pentek isin $1 || péntek isin $1) { %prop = $biton(%prop,6) }
  if (szombat isin $1) { %prop = $biton(%prop,7) }
  if (vasarnap isin $1 || vasárnap isin $1) { %prop = $biton(%prop,8) }
  ; ha több nap van megadva, akkor egyertelmu a retrig, azert nezzuk a vesszore is
  if (retrig isin $1) || (, isin $1) { %prop = $biton(%prop,1) }
  return %prop
}

; prop-ot olvashatova alakitja
/getdaynamesfromprop {
  var %res
  if ($isbit($1,1)) { %res = %res $+ , retrig }
  if ($isbit($1,2)) { %res = %res $+ , hétfõ }
  if ($isbit($1,3)) { %res = %res $+ , kedd }
  if ($isbit($1,4)) { %res = %res $+ , szerda }
  if ($isbit($1,5)) { %res = %res $+ , csütörtök }
  if ($isbit($1,6)) { %res = %res $+ , péntek }
  if ($isbit($1,7)) { %res = %res $+ , szombat }
  if ($isbit($1,8)) { %res = %res $+ , vasárnap }
  if ($left(%res,1) == ,) { %res = $right(%res,$calc($len(%res)-1)) }
  return %res
}

; kiszamolja hogy a megadott napnal a jelenlegi datumhoz meg hany masodpercet kell hozzaadni hogy megkapjuk az adott napot
/getdayshift {
  if ($1 == holnap) {
    return 86400
  }
  var %napshift 86400
  while ($asctime($calc($ctime + %napshift),ddd) != $daynamehun2eng($1)) {
    inc %napshift 86400
  }
  return %napshift
}

/initjobs {
  if ($hget(jobs) != $null) {
    hfree jobs
  }
  hmake jobs 1
  ; betoltjuk fajlbol az jobokat (ha letezik)
  if ($exists(system\jobs.dat)) {
    hload jobs system\jobs.dat
  }
  if (!$timer(jobs)) {
    .timerjobs -i 0 60 /jobcheck
  }
}
;END

;JOBCHECK
/jobcheck {
  var %i $hget(jobs,0).item
  while (%i > 0) {
    tokenize 32 $hget(jobs,%i).data
    var %datum $1
    var %ido $2
    var %prop $3
    var %parancs $4-
    var %trig 0
    if (!%prop && $ctime($gettok(%datum,3,47) $+ / $+ $gettok(%datum,2,47) $+ / $+ $gettok(%datum,1,47) %ido) <= $ctime) { %trig = 1 }
    if (%prop > 1 && $daynameeng2hun($asctime(ddd)) isin $getdaynamesfromprop(%prop) && $asctime(HH) == $gettok(%ido,1,58) && $asctime(nn) == $gettok(%ido,2,58)) { %trig = 1 }
    if (%prop == 1 && $asctime(HH) == $gettok(%ido,1,58) && $asctime(nn) == $gettok(%ido,2,58)) { %trig = 1 }

    if (%trig) {
      if ($gettok(%parancs,1,32) != /onalarm) && ($gettok(%parancs,1,32) != /onebreszto) {
        echo $color(info) -atng *** Job $+ $hget(jobs,%i).item indítása: %parancs
      }
      %parancs
      ; retrigger eseten nem toroljuk
      if (!$isbit(%prop,1)) {
        var %jobnum $hget(jobs,%i).item
        hdel jobs %jobnum
        %i = $hget(jobs,0).item
        continue
      }
    }
    dec %i 1
  }
  hsave jobs system\jobs.dat
}
;END

;JOB
/job {
  if ($2 == $null) { /jobhasznalat | halt }

  ; job torles
  if ($2 == off) || ($2 == stop) {
    if ($hget(jobs,$1) != $null) {
      hdel jobs $1
      hsave jobs system\jobs.dat
      echo $color(info) -atng *** Job $+ $1 törölve.
      return
    }
    else {
      echo $color(info2) -atng *** Job $+ $1 nem létezik.
      return
    }
  }

  ; job parancs atiras
  if ($hget(jobs,$1) != $null) {
    var %datum $gettok($hget(jobs,$1),1,32)
    var %ido $gettok($hget(jobs,$1),2,32)
    var %prop $gettok($hget(jobs,$1),3,32)
    hdel jobs $1
    hadd jobs $1 %datum %ido %prop $2-
    hsave jobs system\jobs.dat

    /echo $color(info) -atng *** Job $+ $1 parancs átírva: $2-
    return
  }

  var %datum
  var %ido
  var %prop $getprop($1)
  var %parancs
  if ( / isin $1 ) { ; datum is meg lett adva
    if ($count($1,/) == 2) {
      ; normal datum lett megadva
      %datum = $1
    }
    if ($count($1,/) == 1) {
      ; evszam nelkuli datum lett megadva
      %datum = $asctime(yyyy) $+ / $+ $1
    }
    if ($count($1,/) > 2) { /jobhasznalat | halt }
    if (: !isin $2) { /jobhasznalat | halt }
    %ido = $2
    if ($3 == $null) { /jobhasznalat | halt }
    %parancs = $3-
  }
  else {
    if (%prop) || ($1 == holnap) { ; retrig van, vagy napnev
      if (: !isin $2) { /jobhasznalat | halt }
      %datum = $asctime(yyyy/mm/dd)
      %ido = $2
      ; ha holnap a parameter, vagy az idopont a multban van, holnapi datumot veszunk
      if ( $1 == holnap ) {
        %datum = $asctime($calc($ctime + 86400),yyyy/mm/dd)
      }
      %parancs = $3-
    }
    else { ; egyaltalan nincs megadva datum
      if (: !isin $1) { /jobhasznalat | halt }
      %datum = $asctime(yyyy/mm/dd)
      %ido = $1
      %parancs = $2-
    }
  }

  ; ha az idopont a multban van, holnapi napra tesszuk a datumot
  if (!%prop && $ctime($gettok(%datum,3,47) $+ / $+ $gettok(%datum,2,47) $+ / $+ $gettok(%datum,1,47) %ido) < $ctime) {
    %datum = $asctime($calc($ctime + 86400),yyyy/mm/dd)
  }

  ; ido check
  if ($gettok(%ido,1,58) > 23) || ($gettok(%ido,1,58) < 0) {
    ; datum holnapra
    %datum = $asctime($calc($ctime + 86400),yyyy/mm/dd)
    %ido = 00: $+ $gettok(%ido,2,58)
  }
  if ($gettok(%ido,2,58) > 59) { %ido = $gettok(%ido,1,58) $+ :59 }
  if ($gettok(%ido,2,58) < 0) { %ido = $gettok(%ido,1,58) $+ :00 }

  ; szabad job num kereses
  var %tnum 1
  while ($hget(jobs,%tnum) != $null) {
    inc %tnum 1
  }

  hadd jobs %tnum %datum %ido %prop %parancs
  hsave jobs system\jobs.dat

  if ($gettok(%parancs,1,32) == /onalarm) {
    if (%prop) { echo $color(info) -atngq *** Alarm $+ %tnum bekapcsolva ( $+ $getdaynamesfromprop($gettok($hget(jobs,%tnum),3,32)) $gettok($hget(jobs,%tnum),2,32) $+ ): $remove(%parancs,/onalarm) }
    else { echo $color(info) -atngq *** Alarm $+ %tnum bekapcsolva ( $+ $gettok($hget(jobs,%tnum),1,32) $gettok($hget(jobs,%tnum),2,32) $+ ): $remove(%parancs,/onalarm) }
  }
  else {
    if ($gettok(%parancs,1,32) == /onebreszto) {
      if (%prop) { echo $color(info) -atngq *** Ébresztõ $+ %tnum bekapcsolva ( $+ $getdaynamesfromprop($gettok($hget(jobs,%tnum),3,32)) $gettok($hget(jobs,%tnum),2,32) $+ ): $gettok(%parancs,3-,32) }
      else { echo $color(info) -atngq *** Ébresztõ $+ %tnum bekapcsolva ( $+ $gettok($hget(jobs,%tnum),1,32) $gettok($hget(jobs,%tnum),2,32) $+ ): $gettok(%parancs,3-,32) }
    }
    else {
      if (%prop) { echo $color(info) -atngq *** Job $+ %tnum bekapcsolva ( $+ $getdaynamesfromprop($gettok($hget(jobs,%tnum),3,32)) $gettok($hget(jobs,%tnum),2,32) $+ ): %parancs }
      else { echo $color(info) -atngq *** Job $+ %tnum bekapcsolva ( $+ $gettok($hget(jobs,%tnum),1,32) $gettok($hget(jobs,%tnum),2,32) $+ ): %parancs }
    }
  }
}

/jobs {
  if ($hget(jobs,0).item == 0) {
    echo $color(info) -atng *** Nincs aktív job.
    return
  }

  if ($1 == off) || ($1 == stop) {
    hdel -w jobs *
    hsave jobs system\jobs.dat
    echo $color(info) -atng *** Jobok törölve.
    return
  }

  var %i $hget(jobs,0).item
  echo $color(info) -atng *** Aktív jobok:
  while (%i > 0) {
    tokenize 32 $hget(jobs,%i).data
    var %datum $1
    var %ido $2
    var %prop $3
    var %parancs $4-
    if (%prop) {
      echo $color(info) -atng * $hget(jobs,%i).item $+ . $getdaynamesfromprop(%prop) %ido - %parancs
    }
    else {
      echo $color(info) -atng * $hget(jobs,%i).item $+ . %datum %ido - %parancs
    }
    dec %i 1
  }
}
;END

;ALARM
/alarm {
  if ($2 == $null) { /alarmhasznalat | halt }

  ; alarm leallitasa
  if ($2 == off) || ($2 == stop) {
    if (/onalarm isin $hget(jobs,$1)) {
      hdel jobs $1
      hsave jobs system\jobs.dat
      echo $color(info) -atng *** Alarm $+ $1 törölve.
      return
    }
    else {
      echo $color(info2) -atng *** Alarm $+ $1 nem létezik.
      return
    }
  }

  ; alarm uzenet atirasa
  if (/onalarm isin $hget(jobs,$1)) {
    var %datum $gettok($hget(jobs,$1),1,32)
    var %ido $gettok($hget(jobs,$1),2,32)
    var %prop $gettok($hget(jobs,$1),3,32)
    hdel jobs $1
    hadd jobs $1 %datum %ido %prop /onalarm $2-
    hsave jobs system\jobs.dat

    /echo $color(info) -atng *** Alarm $+ $1 üzenet átírva: $2-
    return
  }

  var %datum
  var %ido
  var %uzenet
  if ( / isin $1 ) || ( $getprop($1) ) || ( $1 == holnap ) {
    %datum = $1
    if (: !isin $2) { /alarmhasznalat | halt }
    %ido = $2
    if ($3 == $null) { /alarmhasznalat | halt }
    %uzenet = $3-
  }
  else {
    if (: !isin $1) { /alarmhasznalat | halt }
    %datum = $asctime(yyyy/mm/dd)
    %ido = $1
    %uzenet = $2-
  }

  job %datum %ido /onalarm %uzenet
}

/alarms {
  var %off 0
  if ($1 == off) || ($1 == stop) {
    %off = 1
  }

  ; alarmok megszamolasa
  var %i $hget(jobs,0).item
  var %ac 0
  while (%i > 0) {
    if ($gettok($hget(jobs,%i).data,4,32) == /onalarm) {
      inc %ac 1
    }
    dec %i 1
  }
  if (%ac == 0) {
    echo $color(info) -atng *** Nincs aktív alarm.
    return
  }

  if (%off) {
    var %i $hget(jobs,0).item
    while (%i > 0) {
      if ($gettok($hget(jobs,%i).data,4,32) == /onalarm) {
        hdel jobs $hget(jobs,%i).item
      }
      dec %i 1
    }
    hsave jobs system\jobs.dat
    echo $color(info) -atng *** Alarmok törölve.
    return
  }

  var %i $hget(jobs,0).item
  echo $color(info) -atng *** Aktív alarmok:
  while (%i > 0) {
    tokenize 32 $hget(jobs,%i).data
    var %datum $1
    var %ido $2
    var %prop $3
    var %parancs $4-
    if ($gettok(%parancs,1,32) == /onalarm) {
      if (%prop) {
        echo $color(info) -atng * $hget(jobs,%i).item $+ . $getdaynamesfromprop(%prop) %ido - $gettok(%parancs,2-,32)
      }
      else {
        echo $color(info) -atng * $hget(jobs,%i).item $+ . %datum %ido - $gettok(%parancs,2-,32)
      }
    }
    dec %i 1
  }
}

/onalarm {
  echo $color(highlight) -atng *** ALARM: $1-
  var %a $tip(alarm, Alarm, $1-, 60, system\img\warning.ico )
  /beep 5 100
  /netzbeep pager
}
;END

;ÉBRESZTÕ
/onebreszto {
  if ($1 == -off) {
    .timerEbreszto off
    var %ebresztotimes $calc( $gettok($2,1,44) - 1 )
    var %ebresztodelay $gettok($2,2,44)
    if (%ebresztodelay !isnum) { %ebresztodelay = 2 }
    if (%ebresztotimes > 0) {
      /echo $color(info) -atng *** Ébresztõ leállítva, még %ebresztotimes alkalommal lesz aktív.
      .timerEbreszto 1 $calc(%ebresztodelay * 60) /onebreszto %ebresztotimes $+ $chr(44) $+ %ebresztodelay $3-
      return
    }
    /echo $color(info) -atng *** Ébresztõ leállítva.
    return
  }
  echo $color(highlight) -atng *** ÉBRESZTÕ: $2- (F8 - leállítás)
  .hdel data $cid $+ doit $+ $replace($active,Status Window,status)
  .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /onebreszto -off $1-
  if (!$tip(ebreszto)) {
    var %a $tip(ebreszto, Ébresztõ, $2-, 60, system\img\warning.ico )
  }
  /beep 5 100
  /netzbeep ebreszto
  .timerEbreszto 1 5 /onebreszto $1-
}

/ebreszto {
  ; aktiv ebreszto leallitasa
  if ($1 == off) {
    if (!$timer(ebreszto)) {
      echo $color(info2) -atng *** Jelenleg nincs ébresztés folyamatban.
      return
    }
    .timerEbreszto off
    echo $color(info) -atng *** Ébresztés leállítva.
    return
  }

  if ($2 == $null) { /ebresztohasznalat | halt }

  ; ebreszto leallitasa
  if ($2 == off) || ($2 == stop) {
    if (/onebreszto isin $hget(jobs,$1)) {
      hdel jobs $1
      hsave jobs system\jobs.dat
      echo $color(info) -atng *** Ébresztõ $+ $1 törölve.
      return
    }
    else {
      echo $color(info2) -atng *** Ébresztõ $+ $1 nem létezik.
      return
    }
  }

  ; ebreszto uzenet atirasa
  if (/onebreszto isin $hget(jobs,$1)) {
    var %datum $gettok($hget(jobs,$1),1,32)
    var %ido $gettok($hget(jobs,$1),2,32)
    var %prop $gettok($hget(jobs,$1),3,32)
    hdel jobs $1
    hadd jobs $1 %datum %ido %prop /onebreszto $2-
    hsave jobs system\jobs.dat

    /echo $color(info) -atng *** Ébresztõ $+ $1 üzenet átírva: $2-
    return
  }

  var %datum
  var %ido
  var %uzenet
  var %times 1,2
  if ( - isin $1 ) {
    if ($3 == $null) { /ebresztohasznalat | halt }

    %times = $remove($1,-)

    if ( / isin $2 ) || ( $getprop($2) ) || ( $2 == holnap ) {
      %datum = $2
      if (: !isin $3) { /ebresztohasznalat | halt }
      %ido = $3
      if ($4 == $null) { /ebresztohasznalat | halt }
      %uzenet = $4-
    }
    else {
      if (: !isin $2) { /ebresztohasznalat | halt }
      %datum = $asctime(yyyy/mm/dd)
      %ido = $2
      %uzenet = $3-
    }
  }
  else {
    if ( / isin $1 ) || ( $getprop($1) ) || ( $1 == holnap ) {
      %datum = $1
      if (: !isin $2) { /ebresztohasznalat | halt }
      %ido = $2
      if ($3 == $null) { /ebresztohasznalat | halt }
      %uzenet = $3-
    }
    else {
      if (: !isin $1) { /ebresztohasznalat | halt }
      %datum = $asctime(yyyy/mm/dd)
      %ido = $1
      %uzenet = $2-
    }
  }

  job %datum %ido /onebreszto %times %uzenet
}

/ebresztok {
  var %off 0
  if ($1 == off) || ($1 == stop) {
    %off = 1
  }

  ; ebresztok megszamolasa
  var %i $hget(jobs,0).item
  var %ac 0
  while (%i > 0) {
    if ($gettok($hget(jobs,%i).data,4,32) == /onebreszto) {
      inc %ac 1
    }
    dec %i 1
  }
  if (%ac == 0) {
    echo $color(info) -atng *** Nincs aktív ébresztõ.
    return
  }

  if (%off) {
    var %i $hget(jobs,0).item
    while (%i > 0) {
      if ($gettok($hget(jobs,%i).data,4,32) == /onebreszto) {
        hdel jobs $hget(jobs,%i).item
      }
      dec %i 1
    }
    hsave jobs system\jobs.dat
    echo $color(info) -atng *** Ébresztõk törölve.
    return
  }

  var %i $hget(jobs,0).item
  echo $color(info) -atng *** Aktív ébresztõk:
  while (%i > 0) {
    tokenize 32 $hget(jobs,%i).data
    var %datum $1
    var %ido $2
    var %prop $3
    var %parancs $4-
    if ($gettok(%parancs,1,32) == /onebreszto) {
      if (%prop) {
        echo $color(info) -atng * $hget(jobs,%i).item $+ . $getdaynamesfromprop(%prop) %ido - $gettok(%parancs,3-,32)
      }
      else {
        echo $color(info) -atng * $hget(jobs,%i).item $+ . %datum %ido - $gettok(%parancs,3-,32)
      }
    }
    dec %i 1
  }
}
;END
