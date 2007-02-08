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

;SZINTEMAK
/origtema {
  %en_bal = 6(
  %en_jobb = 6)
  %mas_bal = 6(
  %mas_jobb = 6)
  %idleszin_60perce = 5
  %idleszin_40perce = 6
  %idleszin_20perce = 14
  %idleszin_10perce = 15
  %idleszin_0perce = 0
  %nick_highlight_szin = 9
  /idlecheck
  /color action 7
  /color ctcp 11
  /color highlight 9
  /color info 6
  /color info2 4
  /color invite 8
  /color join 3
  /color kick 15
  /color mode 14
  /color nick 13
  /color normal 14
  /color notice 6
  /color notify 7
  /color other 0
  /color own 15
  /color part 14
  /color quit 14
  /color topic 3
  /color wallops 9
  /color whois 6
  /color editbox 1
  /color editbox text 0
  /color background 1
  /color listbox 1
  /color listbox text 14
  /color gray text 15
  %timestamp_format = 14(HH:nn:ss14)
  .timestamp -f %timestamp_format
  %szintema = eredeti
  echo $color(info) -atng *** Eredeti színtéma betöltve.
}
/classictema {
  /color action 7
  /color ctcp 4
  /color highlight 9
  /color info 3
  /color info2 4
  /color invite 8
  /color join 3
  /color kick 4
  /color mode 14
  /color nick 9
  /color normal 14
  /color notice 7
  /color notify 7
  /color other 0
  /color own 15
  /color part 3
  /color quit 3
  /color topic 3
  /color wallops 13
  /color whois 10
  /color editbox 1
  /color editbox text 15
  /color background 1
  /color listbox 1
  /color listbox text 14
  /color gray text 15
  %en_bal = 3=<9
  %en_jobb = 3>=
  %mas_bal = 3-<9
  %mas_jobb = 3>-
  %idleszin_60perce = 5
  %idleszin_40perce = 3
  %idleszin_20perce = 14
  %idleszin_10perce = 15
  %idleszin_0perce = 0
  %nick_highlight_szin = 8
  /idlecheck
  %szintema = klasszikus
  %timestamp_format = 14[HH:nn:ss14]
  .timestamp -f %timestamp_format
  echo $color(info) -atng *** Klasszikus színtéma betöltve.
}
;END

;WNDBACK
/wndback {
  var %ablak
  if (!$1-) { %ablak = $active }
  else { %ablak = $1 }
  ; statusz ablakban, &serversben nem szarakodunk
  if (%ablak = Status Window) || (%ablak = &servers) { return }
  if (%wndback) && ($window(%ablak)) {
    var %origablaknev = %ablak
    ; custom ablak nevek eltavolitasa
    if ($2) { %ablak = $2- }
    else { %ablak = $remove(%ablak,@,_telnetssl,_telnet) }
    ; hogy kiferjen a csati ablakba
    var %origfontsize = %wndback_font_size
    while ($width(%ablak,%wndback_font,%wndback_font_size,1) > $calc($window(-2).w - 230)) { dec %wndback_font_size 1 }
    window -pnh @wndback 0 0 $calc($width(%ablak,%wndback_font,%wndback_font_size,1) + 10) $calc($height(%ablak,%wndback_font,%wndback_font_size) + 30)
    drawtext -or @wndback $rgb( [ %wndback_font_color ] ) " $+ %wndback_font $+ " %wndback_font_size 0 0 %ablak
    %wndback_font_size = %origfontsize

    ; |,/,\ jeleket kicsereljuk
    if ($chr(124) isin %ablak) || (\ isin %ablak) || (/ isin %ablak) {
      var %ablak2 = $replace(%origablaknev,$chr(124),$chr(0),\,$chr(0),/,$chr(0))
      .drawsave @wndback system\temp\ $+ %ablak2 $+ .bmp
      .window -c @wndback
      .background -c %origablaknev system\temp\ $+ %ablak2 $+ .bmp
      .remove system\temp\ $+ %ablak2 $+ .bmp
    }
    else {
      .drawsave @wndback system\temp\ $+ %origablaknev $+ .bmp
      .window -c @wndback
      .background -c %origablaknev system\temp\ $+ %origablaknev $+ .bmp
      .remove system\temp\ $+ %origablaknev $+ .bmp
    }
  }
  else { if ($window(%ablak)) { background -x %ablak } }
}
/wndbackall {
  ; osszes ablak hatterenek frissitese
  if ($chan(0)) {
    var %i $chan(0)
    while (%i > 0) {
      wndback $chan(%i)
      dec %i 1
    }
  }
  if ($query(0)) {
    var %i $query(0)
    while (%i > 0) {
      wndback $query(%i)
      dec %i 1
    }
  }
  if ($chat(0)) {
    var %i $chat(0)
    while (%i > 0) {
      wndback $chat(%i)
      dec %i 1
    }
  }
}
;END

;FANCY STUFF
/fancy.autumn {  /say 8,0æ0,8æ7,8æ8,7æ1,7æ7,1æ0 $$?="Üzenet?" 7æ1,7æ8,7æ7,8æ0,8æ8,0æ10 }
/fancy.sunset  { /say 8,16 `%16,8%,4,8`%8,4%,5,4`%4,5%,17,5`%5,17%,8,17 $$?="Üzenet?" 5,17`%17,5%,4,5`%5,4%,8,4`%4,8%,16,8`%8,16%,  }
/fancy.ocean  { /say 11,16 `%16,11%,12,11`%11,12%,2,12`%12,2%,17,2`%2,17%,0,17 $$?="Üzenet?"  2,17`%17,2%,12,2`%2,12%,11,12`%12,11%,16,11`%11,16%,  }
/fancy.bluefade { /say 12¸,%0,12%'´ 2,12¸,%12,2%'´ 1,2¸,%2,1%'´ 12,1 $$?="Üzenet?" 1,1 2,1`'%1,2%,¸ 12,2`'%2,12%,¸ 0,12`'%12,0%,¸ }
/fancy.redfade { /say 4¸,%0,4%'´ 5,4¸,%4,5%'´ 1,5¸,%5,1%'´ 4,1 $$?="Üzenet?" 1,1 5,1`'%1,5%,¸ 4,5`'%5,4%,¸ 0,4`'%4,0%,¸ }
/fancy.purplefade { /say 13¸,%0,13%'´ 6,13¸,%13,6%'´ 1,6¸,%6,1%'´ 6,1 $$?="Üzenet?" 1,1 6,1`'%1,6%,¸ 13,6`'%6,13%,¸ 0,13`'%13,0%,¸ }
/fancy.greenfade { /say 9¸,%0,9%'´ 3,9¸,%9,3%'´ 1,3¸,%3,1%'´ 3,1 $$?="Üzenet?" 1,1 3,1`'%1,3%,¸ 9,3`'%3,9%,¸ 0,9`'%9,0%,¸ }
/fancy.yellowfade { /say 8¸,%0,8%'´ 7,8¸,%8,7%'´ 1,7¸,%7,1%'´ 7,1 $$?="Üzenet?" 1,1 7,1`'%1,7%,¸ 8,7`'%7,8%,¸ 0,8`'%8,0%,¸ }
/fancy.greyfade { /say 15¸,%0,15%'´ 14,15¸,%15,14%'´ 1,14¸,%14,1%'´ 14,1 $$?="Üzenet?" 1,1 14,1`'%1,14%,¸ 15,14`'%14,15%,¸ 0,15`'%15,0%,¸ }
/fancy.lila { /say 0,13«6»13,6«1»6,1«15 $$?="Üzenet?" 6,1»1,6«13»6,13«0» }
/fancy.rainbow { /say 1,1 1,2 1,3 1,4 1,5 1,6 1,7 1,8 1,9 1,10 1,11 1,12 1,13 1,14 1,15 1,18 8,1 $$?="Üzenet?" 8,1 1,18 1,15 1,14 1,13 1,12 1,11 1,10 1,9 1,8 1,7 1,6 1,5 1,4 1,3 1,2 1,1 }
/fancy.dobozos {
  var %uzenet $1-
  if (%uzenet == $null) { %msg = $$?="Üzenet?" }
  var %w $rand(0,15) | var %ww  $+ %w $+ , $+ %w | var %q  $+ $rand(0,15) $+ , $+ %w | /say %ww  %uzenet $+ ! | /say %q %uzenet  1,1!  | /say %ww %uzenet  1,1! | /say 0,0 1,1 %uzenet $+ !
}
/fancy.caution { /say 1,8!8,1C1,8a8,1U1,8t8,1I1,8o8,1N1,8!8 $$?="Üzenet?" 1,8!8,1C1,8a8,1U1,8t8,1I1,8o8,1N1,8! }
/fancy.hiya {
  var %msg $1-
  if (%msg == $null) { %msg = $$?="Üzenet?" }
  say 4,1/8/9/3/12/6/13/4/8/9/3/12/6/13/4/8/9/1,1 %msg 12\6\13\4\8\9\3\12\6\13\4\8\9\3\12\6\13\ 
  say 1,1.6,15H1,1.9,14I1,1.8,13Y1,1.0,12A8,1*6,11H1,1.9,10I1,1.8,13Y1,1-6,15A8,1| %msg |6,15H1,1-9,13I1,1.8,10Y1,1.6,11A8,1*0,12H1,1.9,13I1,1.8,14Y1,1.6,15A1,1.
  say 12,1\6\13\4\8\9\3\12\6\13\4\8\9\3\12\6\13\1,1 %msg 4,1/8/9/3/12/6/13/4/8/9/3/12/6/13/4/8/9/8
}
/fancy.tesco {
  say 2,0  2,2 2,0 2,2 2,0 2,2 2,0 2,2 2,0 2,2 2,0 2,2 2,0 0,0.
  say 2,0|0,0....4,0TESCO0,0....2,0|
  say 2,0|0,0..0,4GAZDASÁGOS0,0 2,0|
  say 2,0|___2,0CSATORNA__2,0|
  say 0,0..0,2 2,0 0,2 2,0 0,2 2,0 0,2 2,0 0,2 2,0 0,2 0,0..
  say 0,0..0,2 2,0 0,2 2,0 0,2 2,0 0,2 2,0 0,2 2,0 0,2 0,0..
}
/fancy.szines {
  var %msg $1-
  if (%msg == $null) { %msg = $$?="Üzenet?" }
  /say 3 $+ %msg 4,6 $+ %msg 0,4 $+ %msg 4,2 $+ %msg 11,13 $+ %msg 2,3 $+ %msg 8,9 $+ %msg 3,11 $+ %msg 0,7 $+ %msg 2,0 $+ %msg 4,11 $+ %msg 3,4 $+ %msg 4,6 $+ %msg 0,4 $+ %msg 4,2 $+ %msg 11,13 $+ %msg 2,3 $+ %msg 8,9 $+ %msg 3,11 $+ %msg 0,7 $+ %msg 2,0 $+ %msg 4,11 $+ %msg 3,4 $+ %msg 4,6 $+ %msg 0,4 $+ %msg 4,2 $+ %msg 11,13 $+ %msg
}
/anyad /say 3kurva anyad 4,6kurva anyad 0,4kurva anyad 4,2kurva anyad 11,13kurva anyad 2,3kurva anyad 8,9kurva anyad 3,11kurva anyad 0,7kurva anyad 2,0kurva anyad 4,11kurva anyad 3,4kurva anyad 4,6kurva anyad 0,4kurva anyad 4,2kurva anyad 11,13kurva anyad 2,3kurva anyad 8,9kurva anyad 3,11kurva anyad 0,7kurva anyad 2,0kurva anyad 4,11kurva anyad 3,4kurva anyad 4,6kurva anyad 0,4kurva anyad 4,2kurva anyad 11,13kurva anyad
;END
