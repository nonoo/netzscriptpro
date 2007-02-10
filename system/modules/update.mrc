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

;UPDATE
alias /update {
  if ($1 == -quiet) { %dl_quiet = 1 }
  else {
    if (!$dialog(dl)) { /dialog -mr dl dl | dialog -t dl netZ Update }
    /dialog -v dl
  }
  /dl_import %update_url $+ %update_php
}
; az egyes update fileokat tomoriti ki, dolgozza fel
alias /updateapply {
  if (!$1) { echo $color(info2) -atng *** /updateapply hiba: túl kevés paraméter! használat: /updateapply [update file] | halt }
  ; update info
  if ($nopath($1) == %update_php) { %dl_noclose = 1 | /updateinfo %dl_downloaddir $+ %dl_filename | return }

  if (!%dl_quiet) { did -a dl 5 Feldolgozás: $1 $+ ... }
  .hdel -w patchfiles *
  ; ha ki kell tomoriteni
  if ($right($1,4) == .zip) {
    if (!%dl_quiet) { did -ra dl 2 Kicsomagolás: | did -ra dl 3 $1 }
    /dll system\unzip.dll Unzip -doQ2 " $+ $1 $+ " " $+ $mircdir $+ "
    /dll system\unzip.dll Unzip -v $1 .
    .remove $1
  }
  else { .hadd patchfiles 1 $1 }

  ; vegigmegyunk a (kicsomagolt) fileokon
  if (!%dl_quiet) { did -ra dl 2 Update: }
  var %i 0
  var %ffile
  while (%i <= $hget(patchfiles,0).item) {
    inc %i 1
    %ffile = $hget(patchfiles,%i)
    if (!%dl_quiet) { did -ra dl 3 %ffile | var %pos = $round($calc(($hget(patchfiles,0).item / %i)*100),0) | did -ra dl 4 %pos $+ % | /did -a dl 9 %pos 0 100 | did -r dl 18 }
    ; exec.mrc-t vegrehajtjuk
    if ($nopath(%ffile) == exec.mrc) {
      .play -c -s " $+ %ffile $+ " 1
      .remove %ffile
    }
  }
  if (!%dl_quiet) { did -r dl 4 | did -r dl 9 | did -ra dl 2 Kész. | did -a dl 5 kész. $+ $crlf }
  .hdel -w patchfiles *
}
; unzip kezeles
on *:SIGNAL:mUnzip: {
  if ($1 == list) {
    var %ujfajl = $left($2-,$calc($pos($2-,|)-1))
    if ($isfile(%ujfajl)) { .hadd patchfiles $calc($hget(patchfiles,0).item + 1) %ujfajl }
  }
}

alias /updateinfo {
  if (!$1) { echo $color(info2) -atng *** /updateinfo hiba: túl kevés paraméter! használat: /updateinfo [update info file] | halt }
  if ($file($1).size == 0) { return }
  if (!$readini($1,latestversion,ver)) { echo $color(info2) -atng *** /updateinfo hiba: nem update filet adtál meg paraméternek! | halt }
  if (!%dl_quiet) { did -ra dl 2 Update info | did -r dl 3 | did -r dl 4 | did -r dl 9 | did -r dl 18 }
  var %currentversion $remove($gettok(%ver,1,32),.)
  var %latestversion $remove($readini($1,latestversion,ver),.)
  var %currentversion_full $gettok(%ver,1,32)
  var %latestversion_full $readini($1,latestversion,ver)
  if (%latestversion > %currentversion) {
    if (!%dl_quiet) { 
      %patchneeded = $readini($1,yourversion,%currentversion_full)
      var %date = $readini($1,%latestversion_full,date)
      if (%date) { %date = ( $+ %date $+ ) }
      did -a dl 5 --------------------------------------------- $+ $crlf $+ Legújabb verzió: %latestversion_full %date $+ $crlf $+ Megjegyzések a verzióhoz: $+ $crlf $+ $crlf
      var %comment1 = $readini($1,%latestversion_full,comment1)
      var %comment2 = $readini($1,%latestversion_full,comment2)
      var %comment3 = $readini($1,%latestversion_full,comment3)
      var %comment4 = $readini($1,%latestversion_full,comment4)
      var %comment5 = $readini($1,%latestversion_full,comment5)
      if (%comment1) { did -a dl 5 %comment1 $+ $crlf }
      if (%comment2) { did -a dl 5 %comment2 $+ $crlf }
      if (%comment3) { did -a dl 5 %comment3 $+ $crlf }
      if (%comment4) { did -a dl 5 %comment4 $+ $crlf }
      if (%comment5) { did -a dl 5 %comment5 $+ $crlf }
      did -ra dl 6 Update
      %dl_noclose = 1
    }
    else {
      /echo $color(highlight) -atng *** Új netZ Script Pro frissítést találtam! (F8 - frissítések megtekintése)
      .hdel data $cid $+ doit $+ $replace($active,Status Window,status)
      .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /update
    }
  }
  else {
    if (!%dl_quiet) { did -a dl 5 --------------------------------------------- $+ $crlf $+ A legújabb verziójú netZ Script Prot használod. $+ $crlf }
  }
  ; mass message
  var %massmsg1 = $readini($1,%currentversion_full,massmsg)
  if (%massmsg1) { echo $color(highlight) -antg *** Üzenet a készítõtõl: %massmsg1 }
  .remove $1
}
;END
