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
  if ($right($1,4) == .zip) || ($right($1,3) == .gz) {
    if (!%dl_quiet) { did -ra dl 2 Kicsomagolás: | did -ra dl 3 $1 }
    /dll system\unzip.dll Unzip -doQ2 " $+ $1 $+ " " $+ $mircdir $+ "
    /dll system\unzip.dll Unzip -v $1 .
    .remove $1
  }
  else { .hadd patchfiles 1 $1 }

  ; vegigmegyunk a (kicsomagolt) fileokon, ha .patch kiterjesztesuek, vegrehajtjuk oket
  if (!%dl_quiet) { did -ra dl 2 Update: }
  var %i 0
  var %ffile
  while (%i <= $hget(patchfiles,0).item) {
    inc %i 1
    %ffile = $hget(patchfiles,%i)
    if (!%dl_quiet) { did -ra dl 3 %ffile | var %pos = $round($calc(($hget(patchfiles,0).item / %i)*100),0) | did -ra dl 4 %pos $+ % | /did -a dl 9 %pos 0 100 | did -r dl 18 }
    ; patch filera elinditjuk a patchet
    if ($right(%ffile,6) == .patch) {
      /echo $color(info) -atng *** /update: Ha megjelenik egy parancssor ablak a patch.exe-vel és kérdést tesz fel, vagy valamit kiír, akkor a patchet nem sikerült lefuttatni. Ebben az esetben töltsd le a honlapról a legújabb kiadást, majd azt patcheld! (ha van hozzá frissítés)
      ; binaris peccs
      if ($right(%ffile,10) == .bin.patch) {
        /write -c %dl_downloaddir $+ netztemp.bat system\patch.exe --binary -p0 -ENsd " $+ $left($mircdir,$calc($len($mircdir)-1)) $+ " -r nul -i " $+ %ffile $+ " & del %ffile & del %dl_downloaddir $+ netztemp.bat
      }
      else {
        /write -c %dl_downloaddir $+ netztemp.bat system\patch.exe -p0 -ENsd " $+ $left($mircdir,$calc($len($mircdir)-1)) $+ " -r nul -i " $+ %ffile $+ " & del %ffile & del %dl_downloaddir $+ netztemp.bat
      }
      /run %dl_downloaddir $+ netztemp.bat
    }
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
    if ($isfile($mircdir $+ %ujfajl)) { .hadd patchfiles $calc($hget(patchfiles,0).item + 1) %ujfajl }
  }
}

alias /updateinfo {
  if (!$1) { echo $color(info2) -atng *** /updateinfo hiba: túl kevés paraméter! használat: /updateinfo [update info file] | halt }
  if (!$readini($1,latestversion,ver)) { echo $color(info2) -atng *** /updateinfo hiba: nem update filet adtál meg paraméternek! | halt }
  if (!%dl_quiet) { did -ra dl 2 Update info | did -r dl 3 | did -r dl 4 | did -r dl 9 | did -r dl 18 }
  var %currentversion $remove($gettok(%ver,1,32),2.)
  var %latestversion $remove($readini($1,latestversion,ver),2.)
  var %rcversion $remove($readini($1,rcversion,ver),2.)
  if (%rcversion > %latestversion) && (%latestversion > %currentversion) {
    if (!%dl_quiet) { 
      %patchneeded = $readini($1,yourversion,%currentversion)
      var %date = $readini($1,2. $+ %rcversion,date)
      did -a dl 5 --------------------------------------------- $+ $crlf $+ Legújabb verzió: 2. $+ %rcversion ( $+ %date $+ ) $+ $crlf $+ A legújabb verzióra frissítéshez elõbb le kell töltened a legutóbbi kiadást ( $+ %latestversion $+ )! $+ $crlf $+ A letöltést az update gombra kattintással indíthatod el, a telepítõt $laz(%dl_downloaddir) %dl_downloaddir könyvtárban fogod megtalálni. $+ $crlf
      did -ra dl 6 Update
      %dl_noclose = 1
    }
    else {
      /echo $color(highlight) -atng *** Új netZ Script Pro kiadást+frissítést találtam! (F8 - frissítések megtekintése)
      .hdel data $cid $+ doit $+ $replace($active,Status Window,status)
      .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /update
    }
  }
  elseif (%latestversion > %currentversion) {
    if (!%dl_quiet) { 
      %patchneeded = $readini($1,yourversion,%currentversion)
      var %date = $readini($1,2. $+ %rcversion,date)
      if (%date) { %date = ( $+ %date $+ ) }
      did -a dl 5 --------------------------------------------- $+ $crlf $+ Legújabb kiadás: 2. $+ %latestversion %date $+ $crlf $+ Töltsd le az új kiadást az update gombra kattintással! $+ $crlf $+ A telepítõt $laz(%dl_downloaddir) %dl_downloaddir könyvtárban fogod megtalálni. $+ $crlf
      did -ra dl 6 Update
      %dl_noclose = 1
    }
    else {
      /echo $color(highlight) -atng *** Új netZ Script Pro kiadást találtam! (F8 - frissítések megtekintése)
      .hdel data $cid $+ doit $+ $replace($active,Status Window,status)
      .hadd data $cid $+ doit $+ $replace($active,Status Window,status) /update
    }
  }
  elseif (%rcversion > %currentversion) {
    if (!%dl_quiet) { 
      %patchneeded = $readini($1,yourversion,%currentversion)
      var %date = $readini($1,2. $+ %rcversion,date)
      if (%date) { %date = ( $+ %date $+ ) }
      did -a dl 5 --------------------------------------------- $+ $crlf $+ Legújabb verzió: 2. $+ %rcversion %date $+ $crlf $+ Megjegyzések a verzióhoz: $+ $crlf $+ $crlf
      var %comment1 = $readini($1,2. $+ %rcversion,comment1)
      var %comment2 = $readini($1,2. $+ %rcversion,comment2)
      var %comment3 = $readini($1,2. $+ %rcversion,comment3)
      var %comment4 = $readini($1,2. $+ %rcversion,comment4)
      var %comment5 = $readini($1,2. $+ %rcversion,comment5)
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
  elseif (%rcversion == %currentversion) || (%rcversion < %currentversion) {
    if (!%dl_quiet) { did -a dl 5 --------------------------------------------- $+ $crlf $+ A legújabb verziójú netZ Script Prot használod. $+ $crlf }
  }
  ; mass message
  var %massmsg1 = $readini($1,%currentversion,massmsg)
  if (%massmsg1) { echo $color(highlight) -antg *** Üzenet a készítõtõl: %massmsg1 }
  .remove $1
}
;END
