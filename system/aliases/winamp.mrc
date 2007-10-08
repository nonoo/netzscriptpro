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

;WINAMP KIJELZÉS
/wptitle {
  ; winampban jatszott track nevevel ter vissza

  var %winamp.title $dll(system/netz.dll, winamp, GetCurrentWinampSong)
  if (%winamp.title == 0) {
    /echo $color(info2) -atng *** Nem találtam aktív mp3 lejátszót.
    halt
  }
  return %winamp.title
}

/wpmsg { 
  ; winamp kijelzes szovegevel ter vissza

  var %winamp.title $wptitle

  ; csak akkor irjuk ki a zarojelek kozotti dolgokat ha kell, egyebkent nem irunk zarojelet se
  if (!%winamp_csik_kijelzes) && (!%winamp_eltelt_ido_kijelzes) && (!%winamp_osszes_ido_kijelzes) && (!%winamp_fajltipus_kijelzes) && (!%winamp_fajlmeret_kijelzes) {
    return %winamp.title
  }

  var %winamp.kbps @ $+ $dll(system/netz.dll, winamp, GetCurrentWinampSongKbps) $+ kbps
  var %winamp.khz $dll(system/netz.dll, winamp, GetCurrentWinampSongKHz)
  var %winamp.totaltime $dll(system/netz.dll, winamp, GetCurrentWinampSongTotalTime)
  var %winamp.elapsedtime $dll(system/netz.dll, winamp, GetCurrentWinampSongElapsedTime)
  var %winamp.channels $dll(system/netz.dll, winamp, GetCurrentWinampSongChannels)
  var %winamp.filename $dll(system/netz.dll, winamp, GetCurrentWinampSongFileName)

  var %winamp.filesize $null

  if (%winamp.totaltime <= 0) && (!$file(%winamp.filename).size) {
    var %winamp.stream 1
    var %winamp.fileformat $chr(32) $+ stream $+ %winamp.kbps
  }

  ; fajlnev, fajlformatum
  if (%winamp.filename != $null) && (!%winamp.stream) {
    var %winamp.filesize $file(%winamp.filename).size
    %winamp.filesize = $round($calc(%winamp.filesize / 1024 / 1024),2)
    if (%winamp_fajltipus_kijelzes) {
      ; fileformat elotti helykihagyas, ha kell
      var %winamp.fileformat $lower($gettok(%winamp.filename,-1, 46)) $+ %winamp.kbps
      if (%winamp_csik_kijelzes) || (%winamp_eltelt_ido_kijelzes) || (%winamp_osszes_ido_kijelzes) {
        %winamp.fileformat = $chr(32) $+ %winamp.fileformat
      }
    }
  }

  ; osszes ido kijelzese
  if (!%winamp.stream) && (%winamp_osszes_ido_kijelzes) {
    var %winamp.t_mins 0

    var %winamp.t_secs %winamp.totaltime

    :totalloop
    if (%winamp.t_secs < 60) {
      goto endtotalloop
    }
    inc %winamp.t_mins
    dec %winamp.t_secs 60
    goto totalloop
    :endtotalloop

    if (%winamp.t_secs < 10) {
      var %winamp.filler2 0
    }
    var %winamp.total %winamp.t_mins $+ : $+ %winamp.filler2 $+ %winamp.t_secs
    ;ha kell, rakunk ele spacet
    if (%winamp_csik_kijelzes) && (!%winamp_eltelt_ido_kijelzes) {
      %winamp.total = $chr(32) $+ %winamp.total
    }
  }

  ; eltelt ido kijelzese
  if (%winamp_eltelt_ido_kijelzes) {
    var %winamp.e_mins 0
    var %winamp.e_secs %winamp.elapsedtime
    :elapsedloop
    if (%winamp.e_secs < 60) {
      goto endelapsedloop
    }
    inc %winamp.e_mins
    dec %winamp.e_secs 60
    goto elapsedloop
    :endelapsedloop

    if (%winamp.e_secs < 10) {
      var %winamp.filler 0
    }
    var %winamp.elapsed %winamp.e_mins $+ : $+ %winamp.filler $+ %winamp.e_secs
    ; ha van osszes ido kijelzes, rakunk perjelet
    if (%winamp_osszes_ido_kijelzes) && (!%winamp.stream) { %winamp.elapsed = %winamp.elapsed $+ / }
    ;ha kell, rakunk ele spacet
    if (%winamp_csik_kijelzes) && (!%winamp.stream) {
      %winamp.elapsed = $chr(32) $+ %winamp.elapsed
    }
  }

  ; fajlmeret kiiras
  if (%winamp.filesize) {
    if (%winamp_fajlmeret_kijelzes) {
      ;ha kell, rakunk ele spacet
      if (%winamp_csik_kijelzes) || (%winamp_eltelt_ido_kijelzes) || (%winamp_osszes_ido_kijelzes) || (%winamp_fajltipus_kijelzes) {
        %winamp.filesize = $chr(32) $+ %winamp.filesize $+ mb
      }
      else {
        %winamp.filesize = %winamp.filesize $+ mb
      }
    }
    else {
      %winamp.filesize = $null
    }
  }

  ; ha van csik kijelzes
  if (!%winamp.stream) && (%winamp_csik_kijelzes) {
    var %winamp.holtart $round($calc((%winamp.elapsedtime / %winamp.totaltime)*%winamp_csik_hossza),0)
    if (%winamp.holtart == %winamp_csik_hossza) { %winamp.holtart = %winamp_csik_hossza - 1 }
    var %winamp.i 0
    var %winamp.csik %winamp_csik_balkeret
    ; megcsinaljuk a csikot
    while (%winamp.i < %winamp_csik_hossza) {
      if (%winamp.i == %winamp.holtart) { %winamp.csik = %winamp.csik $+ %winamp_csik_karakter_holvan }
      else { %winamp.csik = %winamp.csik $+ %winamp_csik_karakter }
      %winamp.i = %winamp.i + 1
    }
    %winamp.csik = %winamp.csik $+ %winamp_csik_jobbkeret
  }

  ; audio cd lejatszasanal
  if ($file(%winamp.filename).size < 100) || (%winamp.filesize < 100) || (!$file(%winamp.filename).size) { %winamp.filesize = $null }

  %winamp.title = %winamp.title ( $+ %winamp.csik $+ %winamp.elapsed $+ %winamp.total $+ %winamp.fileformat $+ %winamp.filesize $+ )
  return %winamp.title
}

; winamp kijelzes a megadott csatira, ha nincs megadva akkor az aktualis ablakba
/wp {
  ; regi vindoz alatt nem megy
  if ($os == 95) || ($os == 98) || ($os == me) { echo $color(info2) -atng *** Ez az opció Windows $+ $os alatt nem mûködik! | return }
  ; statusz ablakba maskepp irjuk ki
  if ($active == Status Window) {
    /echo $color(info) -atng Winamp: $wpmsg
  }
  else {
    if ($1) && ($1 ischan) {
      if ($2) {
        /describe $1 $2- $wpmsg
      }
      else {
        /describe $1 %winamp_kiiras_szoveg $wpmsg
      }
    }
    else {
      if ($1) {
        /describe $active $1- $wpmsg
      }
      else {
        /describe $active %winamp_kiiras_szoveg $wpmsg
      }
    }
  }
}
; minden csatira elkuldi a winamp kijelzest
/awp {
  ; regi vindoz alatt nem megy
  if ($os == 95) || ($os == 98) || ($os == me) { echo $color(info2) -atng *** Ez az opció Windows $+ $os alatt nem mûködik! | return }
  /ame %winamp_kiiras_szoveg $wpmsg
}

; winamp automata kijelzes
/wpautochk {
  ; ha nem fut a winamp
  if (!$dll(system/netz.dll, winamp, GetCurrentWinampSong)) { halt }

  var %wptitle $wptitle
  if (%winamp_automata_lasttr != %wptitle) {
    %winamp_automata_lasttr = %wptitle
    if (%winamp_automata_aktiv_csatira) { /wp }
    if (%winamp_automata_osszes_csatira) {
      ; minden szerver kapcsolatra vegigmegyunk
    /scon -at1 /ame %winamp_kiiras_szoveg $!wpmsg }
  }
  if (%winamp_automata_kivalasztott_csatira) && (%winamp_automata_csatik) {
    ; minden szerver kapcsolatra vegigmegyunk
    var %j $scon(0)
    while (%j > 0) {
      var %i 1
      var %cs $gettok(%winamp_automata_csatik,1,32)
      while (%cs) {
        ; osszes kapcsolatra kinyomjuk
        scon %j
        if ($scon(%j).$me ison %cs) && ($scon(%j).$server) { /describe %cs %winamp_kiiras_szoveg $wpmsg }
        scon -r

        inc %i 1
        %cs = $gettok(%winamp_automata_csatik,%i,32)
      }
      dec %j 1
    }
  }
}
/wpauto {
  ; regi vindoz alatt nem megy
  if ($os == 95) || ($os == 98) || ($os == me) { return }

  if ($1 == off) { .timerwinamp_auto off | echo $color(info) -atngq *** Automata Winamp kijelzés kikapcsolva. | return }
  if ($1 == on) { .timerwinamp_auto 0 1 wpautochk | echo $color(info) -atngq *** Automata Winamp kijelzés bekapcsolva. | return }
  if ($timer(winamp_auto).type) { echo $color(info) -atng *** Automata Winamp kijelzés: aktív }
  else { echo $color(info) -atng *** Automata Winamp kijelzés: inaktív }
}
;END
