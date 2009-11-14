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

alias /setup {
  .reload -rs system\modules\setupdialog.mrc
  /dialog -mr setupdialog setupdialog
}

;INIT
on *:DIALOG:setupdialog:init:*: {
  /dialog -t setupdialog netZ Script Pro %ver Setup
  ;WINAMP
  did -a $dname 7 %winamp_kiiras_szoveg
  did -a $dname 20 %winamp_csik_hossza
  did -a $dname 21 %winamp_csik_balkeret
  did -a $dname 22 %winamp_csik_jobbkeret
  did -a $dname 23 %winamp_csik_karakter
  did -a $dname 24 %winamp_csik_karakter_holvan

  if (%winamp_csik_kijelzes) {
    did -c $dname 8
    did -e $dname 14
    did -e $dname 15
    did -e $dname 16
    did -e $dname 17
    did -e $dname 18
    did -e $dname 19
    did -e $dname 20
    did -e $dname 21
    did -e $dname 22
    did -e $dname 23
    did -e $dname 24
  }
  if (%winamp_eltelt_ido_kijelzes) { did -c $dname 9 }
  if (%winamp_osszes_ido_kijelzes) { did -c $dname 10 }
  if (%winamp_fajlmeret_kijelzes) { did -c $dname 11 }
  if (%winamp_fajltipus_kijelzes) { did -c $dname 12 }

  if (%winamp_automata_kijelzes) {
    did -c $dname 26
    did -e $dname 27
    did -e $dname 28
    did -e $dname 29
  }
  if (%winamp_automata_osszes_csatira) { did -c $dname 27 }
  if (%winamp_automata_aktiv_csatira) { did -c $dname 28 }
  if (%winamp_automata_kivalasztott_csatira) {
    did -c $dname 29
    if (%winamp_automata_kijelzes) { did -e $dname 30 }
  }
  did -a $dname 30 %winamp_automata_csatik
  if (%winamp_kijelzes_titlebarban) { did -c $dname 31 }

  ; regi vindoz alatt nem megy a winamp auto kijelzes
  if ($os == 95) || ($os == 98) || ($os == me) { did -b $dname 26 | did -b $dname 31 }
  ;END

  ;AWAY
  if (%awaymessage_hasznalat) { did -c $dname 34 | did -e $dname 35 }
  did -a $dname 35 %awaymessage
  if (%awaynick_hasznalat) { did -c $dname 36 | did -e $dname 37 | did -e $dname 273 }
  did -a $dname 37 %awaynick
  if (%awaynick_kisbetusre) { did -c $dname 273 | did -b $dname 37 }
  if (%autoaway_hasznalat) { did -c $dname 38 | did -e $dname 39 | did -e $dname 41 }
  did -a $dname 39 %autoaway_ido
  did -a $dname 42 %autoaway_message
  if (%awayback_hasznalat) { did -c $dname 43 | did -e $dname 44 }
  if (%autoaway_message_hasznalat) { did -c $dname 41 | if (%autoaway_hasznalat) { did -e $dname 42 } }
  did -a $dname 44 %awayback_message
  if (%auto_awayoff) { did -c $dname 45 }
  if (%away_pager) { did -c $dname 46 | did -e $dname 48 | did -e $dname 49 }
  if (!%awaymessage_mindencsatira) { did -e $dname 55 | did -c $dname 54 }
  else { did -c $dname 53 }
  did -a $dname 55 %awaymessage_csatik
  if (%aaway_f10) { did -c $dname 257 }
  if (%away_memoria) { did -c $dname 318 }

  ; regi vindoz alatt nem megy az auto away
  if ($os == 95) || ($os == 98) || ($os == me) { did -b $dname 38 }
  ;END

  ;FLOOD
  if (%flooddetekt) { did -c $dname 57 }
  if (%flooddetekt_ctcp) { did -c $dname 247 }
  if (%kick_csati) { did -c $dname 70 }
  if (%ban_csati) { did -c $dname 104 }
  if (%kick_join) { did -c $dname 105 }
  if (%ban_join) { did -c $dname 106 }
  if (%kick_kick) { did -c $dname 107 }
  if (%ban_kick) { did -c $dname 108 }
  if (%kick_ban) { did -c $dname 109 }
  if (%ban_ban) { did -c $dname 110 }
  if (%kick_deop) { did -c $dname 111 }
  if (%ban_deop) { did -c $dname 112 }
  if (%kick_nick) { did -c $dname 113 }
  if (%ban_nick) { did -c $dname 114 }
  if (!%kick_oposokat) { did -c $dname 74 }
  if (!%kick_voiceosokat) { did -c $dname 116 }
  did -a $dname 73 %max_csati
  did -a $dname 78 %max_invite
  did -a $dname 80 %max_chat
  did -a $dname 82 %max_send
  did -a $dname 84 %max_join
  did -a $dname 86 %max_kick
  did -a $dname 88 %max_ban
  did -a $dname 90 %max_deop
  did -a $dname 92 %max_nick
  did -a $dname 248 %max_ctcp
  did -a $dname 75 %time_csati
  did -a $dname 79 %time_invite
  did -a $dname 81 %time_chat
  did -a $dname 83 %time_send
  did -a $dname 85 %time_join
  did -a $dname 87 %time_kick
  did -a $dname 89 %time_ban
  did -a $dname 91 %time_deop
  did -a $dname 93 %time_nick
  did -a $dname 250 %time_ctcp
  did -a $dname 115 %flooddetekt_csatik
  if (%flooddetekt_csatikra) { did -c $dname 274 }
  if ($did(57).state) {
    if (!%ban_csati) { did -e $dname 70 }
    did -e $dname 104
    if (!%ban_join) { did -e $dname 105 }
    did -e $dname 106
    if (!%ban_kick) { did -e $dname 107 }
    did -e $dname 108
    if (!%ban_ban) { did -e $dname 109 }
    did -e $dname 110
    if (!%ban_deop) { did -e $dname 111 }
    did -e $dname 112
    if (!%ban_nick) { did -e $dname 113 }
    did -e $dname 114
    did -e $dname 74
    did -e $dname 116
    did -e $dname 73
    did -e $dname 78
    did -e $dname 80
    did -e $dname 82
    did -e $dname 84
    did -e $dname 86
    did -e $dname 88
    did -e $dname 90
    did -e $dname 92
    did -e $dname 75
    did -e $dname 79
    did -e $dname 81
    did -e $dname 83
    did -e $dname 85
    did -e $dname 87
    did -e $dname 89
    did -e $dname 91
    did -e $dname 93
    did -e $dname 247
    if ($did(247).state) { did -e $dname 248 | did -e $dname 250 }
    did -e $dname 274
    if ($did(274).state) { did -e $dname 115 }
  }
  ;END

  ;DESIGN
  did -a $dname 95 %nickcomp_bal
  did -a $dname 118 %nickcomp_jobb
  did -a $dname 121 %en_bal
  did -a $dname 123 %en_jobb
  did -a $dname 130 %mas_bal
  did -a $dname 128 %mas_jobb
  did -a $dname 135 %titlebar_bal
  did -a $dname 133 %titlebar_jobb
  did -a $dname 140 %menu_bal
  did -a $dname 138 %menu_jobb
  if (%quitmessage_random) { did -c $dname 142 | did -b $dname 143 }
  did -a $dname 143 %quitmessage
  did -a $dname 229 %szintema
  if (%idleszin_hasznalat) { did -c $dname 232 | did -e $dname 238 | did -e $dname 239 | did -e $dname 240 | did -e $dname 237 }
  did -a $dname 233 %idleszin_0perce
  did -a $dname 238 %idleszin_10perce
  did -a $dname 239 %idleszin_20perce
  did -a $dname 240 %idleszin_40perce
  did -a $dname 241 %idleszin_60perce
  if (%idleszin_60perce_hasznalat) { did -c $dname 237 | did -e $dname 241 }
  ;END

  ;EGYÉB
  if (%autojoin) { did -c $dname 148 | did -e $dname 149 }
  did -a $dname 149 %autojoin_csatik
  did -a $dname 151 %kedvenc_csatik
  if (%motd_kiiras) { did -c $dname 153 }
  if (%lusers_kiiras) { did -c $dname 154 }
  if (%autoupdate) { did -c $dname 163 }
  did -a $dname 168 %timestamp_format
  if (%dl_hotlink) { did -c $dname 179 | did -e $dname 187 }
  did -a $dname 187 %dl_hotlink_kiterjesztesek
  did -a $dname 188 %dl_downloaddir
  if (%wndback) { did -c $dname 221 | did -e $dname 223 | did -e $dname 225 | did -e $dname 227 | did -e $dname 308 }
  did -a $dname 223 %wndback_font
  did -a $dname 225 %wndback_font_size
  did -a $dname 227 %wndback_font_color
  did -a $dname 308 %wndback_nodisp
  if (%autoconnect) { did -c $dname 243 | did -e $dname 244 }
  did -a $dname 244 %autoconnect_servers
  if (%getlog) { did -c $dname 254 | did -e $dname 256 }
  did -a $dname 256 %getlog_numlines
  if (%url_kiemeles) { did -c $dname 259 | did -e $dname 261 }
  did -a $dname 261 %url_kiemeles_style
  did -a $dname 265 %highlight_szavak2
  did -a $dname 280 %highlight_ignore_szavak2
  if (%uptime_meres) { did -c $dname 267 | did -e $dname 268 | did -e $dname 269 }
  if (%uptime_notice) { did -c $dname 268 }
  if (%uptime_notice_newrecord) { did -c $dname 269 }
  if (%netsplit_detect) { did -c $dname 271 | did -e $dname 272 }
  if (%netsplit_detect_onlyhu) { did -c $dname 272 }
  if (%auto_orignick) { did -c $dname 315 }
  if (%ophop) { did -c $dname 320 }
  ;END

  ;DESIGN3
  if (%winamp_kijelzes_titlebarban) { did -c $dname 156 }
  if (%itime_kijelzes_titlebarban) { did -c $dname 157 }
  if (%lagdetect_titlebarban) { did -c $dname 158 | did -e $dname 160 | did -e $dname 245 }
  if (%lagdetect_titlebarban_csik) { did -c $dname 245 }
  did -a $dname 160 %lagdetect_auto_interval
  if (%tooltip_priviknel) { did -c $dname 311 }
  if (%highlight_tooltip) { did -c $dname 310 }
  if (%checkmail_tooltip) { did -c $dname 312 }
  if (%tooltip_dccnel) { did -c $dname 313 }
  if (%tooltip_pagenel) { did -c $dname 316 }
  if (%tooltip_noticenal) { did -c $dname 317 }
  if (%tooltip_multiline) { did -c $dname 321 }
  ;END

  ;BEEP
  if (%flash_priviknel) { did -c $dname 193 | did -e $dname 197 | did -e $dname 201 }
  did -a $dname 197 %flash_priviknel_szoveg
  if (%beep_priviknel) { did -c $dname 198 | did -e $dname 201 | did -e $dname 203 }
  if (%beep_priviknel_winamp) { did -c $dname 203 }
  if (%pcspeaker_priviknel) { did -c $dname 199 | did -e $dname 201 }
  did -a $dname 201 $calc(%flash_priviknel_timeout / 60)
  if (%pager) { did -c $dname 51 | did -e $dname 48 | did -e $dname 49 | did -b $dname 46 | did -e $dname 205 | did -e $dname 208 }
  if (%pager_speaker) { did -c $dname 48 }
  if (%pager_beep) { did -c $dname 49 | did -e $dname 204 }
  if (%pager_beep_winamp) { did -c $dname 204 }
  if (%pager_flash) { did -c $dname 205 | did -e $dname 206 }
  did -a $dname 206 %pager_flash_szoveg
  did -a $dname 208 $calc(%pager_timeout / 60)
  if (%checkmail_flash) { did -c $dname 211 }
  did -a $dname 212 %checkmail_flash_szoveg
  if (%checkmail_beep) { did -c $dname 213 | did -e $dname 214 }
  if (%checkmail_beep_winamp) { did -c $dname 214 }
  if (%checkmail_speaker) { did -c $dname 215 }
  if (%highlight_pager) { did -c $dname 216 }

  ; regi vindoz alatt nem megy a winampos beep
  if ($os == 95) || ($os == 98) || ($os == me) { did -b $dname 203 | did -b $dname 204 }
  ;END

  ;EMAIL
  if (%checkmail) { did -c $dname 170 | did -e $dname 180 | did -e $dname 182 | did -e $dname 183 }
  did -a $dname 172 %checkmail_szerver
  did -a $dname 178 %checkmail_port
  did -a $dname 173 %checkmail_username
  did -a $dname 176 $dekod(%checkmail_pass)
  did -a $dname 180 %checkmail_interval
  if (%checkmail_pager) {
    if (%checkmail_beep) { did -e $dname 214 }
    if (%checkmail_flash) { did -e $dname 212 }
    did -c $dname 182 | did -e $dname 211 | did -e $dname 213 | did -e $dname 215
  }
  if (%checkmail_emailer) { did -c $dname 183 }
  did -a $dname 185 %emailezo_prog
  ; regi vindoz alatt nem megy a winampos beep
  if ($os == 95) || ($os == 98) || ($os == me) { did -b $dname 214 }
  if (%checkmail_ssl) { did -c $dname 275 }
  if (%checkmail_gmailmode) {
    did -c $dname 276
    did -b $dname 172 | did -b $dname 178 | did -b $dname 275
    did -v $dname 278
  }
  if (%checkmail_deletecounter) { did -c $dname 279 }
  ;END

  ;SKYPE
  if (%skype_hasznalat) { did -c $dname 284 }
  else {
    did -b $dname 286 | did -b $dname 288 | did -b $dname 289 | did -b $dname 290 | did -b $dname 292 | did -b $dname 294
    did -b $dname 295 | did -b $dname 298
  }
  did -a $dname 298 %skype_separator
  did -a $dname 295 %skype_winamp_szoveg
  if (%skype_winamp_kijelzes) { did -c $dname 294 }
  else { did -b $dname 295 | did -b $dname 301 | did -b $dname 302 }
  if (%skype_winamp_hossz_kijelzes) { did -c $dname 301 }
  if (%skype_winamp_bitrata_kijelzes) { did -c $dname 302 }
  if (%skype_away_kijelzes) { did -c $dname 286 }
  else { did -b $dname 288 | did -b $dname 289 }
  did -a $dname 288 %skype_away_szoveg
  if (%skype_awaymsg_kiiras) { did -c $dname 289 }
  if (%skype_away_follow) { did -c $dname 290 }
  else { did -b $dname 292 }
  did -a $dname 292 Away
  did -a $dname 292 Not Available
  did -a $dname 292 Do Not Disturb
  did -a $dname 292 Invisible
  if (%skype_away_mod == away) { did -c $dname 292 1 }
  if (%skype_away_mod == na) { did -c $dname 292 2 }
  if (%skype_away_mod == dnd) { did -c $dname 292 3 }
  if (%skype_away_mod == invisible) { did -c $dname 292 4 }
  did -a $dname 303 %skype_msg1
  did -a $dname 304 %skype_msg2
  ;END

  ;TWITTER/RSS
  did -a $dname 325 %twitter_acc
  did -a $dname 326 $dekod(%twitter_pass)
  if (%rss_auto_check) { did -c $dname 330 }
  ;END
}
;END

;WINAMP EVENTS
; csik beallitasaira katt
on *:DIALOG:setupdialog:sclick:8: {
  if ($did(8).state) {
    did -e $dname 14
    did -e $dname 15
    did -e $dname 16
    did -e $dname 17
    did -e $dname 18
    did -e $dname 19
    did -e $dname 20
    did -e $dname 21
    did -e $dname 22
    did -e $dname 23
    did -e $dname 24
  }
  else {
    did -b $dname 14
    did -b $dname 15
    did -b $dname 16
    did -b $dname 17
    did -b $dname 18
    did -b $dname 19
    did -b $dname 20
    did -b $dname 21
    did -b $dname 22
    did -b $dname 23
    did -b $dname 24
  }
}

; automata kijelzesre katt
on *:DIALOG:setupdialog:sclick:26: {
  if ($did(26).state) {
    did -e $dname 27
    did -e $dname 28
    did -e $dname 29
  }
  else {
    did -b $dname 27
    did -b $dname 28
    did -b $dname 29
  }
}
; automata kijelzes allitasanal
on *:DIALOG:setupdialog:sclick:27: {
  did -b $dname 30
}
on *:DIALOG:setupdialog:sclick:28: {
  did -b $dname 30
}
on *:DIALOG:setupdialog:sclick:29: {
  did -e $dname 30
}
;END

;AWAY EVENTS
on *:DIALOG:setupdialog:sclick:34: {
  if ($did(34).state) { did -e $dname 35 }
  else { did -b $dname 35 }
}
on *:DIALOG:setupdialog:sclick:36: {
  if ($did(36).state) { if (!$did(273).state) { did -e $dname 37 } | did -e $dname 273 }
  else { did -b $dname 37 | did -b $dname 273 }
}
on *:DIALOG:setupdialog:sclick:273: {
  if ($did(273).state) { did -b $dname 37 }
  else { did -e $dname 37 }
}
on *:DIALOG:setupdialog:sclick:38: {
  if ($did(38).state) { did -e $dname 39 | did -e $dname 41 | did -e $dname 42 }
  else { did -b $dname 39 | did -b $dname 41 | did -b $dname 42 }
}
on *:DIALOG:setupdialog:sclick:41: {
  if ($did(41).state) { did -e $dname 42 }
  else { did -b $dname 42 }
}
on *:DIALOG:setupdialog:sclick:43: {
  if ($did(43).state) { did -e $dname 44 }
  else { did -b $dname 44 }
}
on *:DIALOG:setupdialog:sclick:46: {
  if ($did(46).state) || ($did(51).state) {
    did -e $dname 48 | did -e $dname 49 | did -e $dname 205 | did -e $dname 208
    if ($did(49).state) { did -e $dname 204 }
    if ($did(205).state) { did -e $dname 206 }
  }
  else { did -b $dname 48 | did -b $dname 49 | did -b $dname 204 | did -b $dname 205 | did -b $dname 206 | did -b $dname 208 }
  if ($did(51).state) { did -b $dname 46 }
  else { did -e $dname 46 }
}
on *:DIALOG:setupdialog:sclick:52: {
  /dialog -k $dname
  .timer 1 0 /aaway
}
on *:DIALOG:setupdialog:sclick:53: {
  did -b $dname 55
}
on *:DIALOG:setupdialog:sclick:54: {
  did -e $dname 55
}
;END

;FLOOD EVENTS
on *:DIALOG:setupdialog:sclick:104: {
  if ($did(104).state) { did -b $dname 70 }
  else { did -e $dname 70 }
}
on *:DIALOG:setupdialog:sclick:106: {
  if ($did(106).state) { did -b $dname 105 }
  else { did -e $dname 105 }
}
on *:DIALOG:setupdialog:sclick:108: {
  if ($did(108).state) { did -b $dname 107 }
  else { did -e $dname 107 }
}
on *:DIALOG:setupdialog:sclick:110: {
  if ($did(110).state) { did -b $dname 109 }
  else { did -e $dname 109 }
}
on *:DIALOG:setupdialog:sclick:112: {
  if ($did(112).state) { did -b $dname 111 }
  else { did -e $dname 111 }
}
on *:DIALOG:setupdialog:sclick:114: {
  if ($did(114).state) { did -b $dname 113 }
  else { did -e $dname 113 }
}
on *:DIALOG:setupdialog:sclick:247: {
  if ($did(247).state) { did -e $dname 248 | did -e $dname 250 }
  else { did -b $dname 248 | did -b $dname 250 }
}
on *:DIALOG:setupdialog:sclick:57: {
  if ($did(57).state) {
    did -e $dname 70
    did -e $dname 104
    did -e $dname 105
    did -e $dname 106
    did -e $dname 107
    did -e $dname 108
    did -e $dname 109
    did -e $dname 110
    did -e $dname 111
    did -e $dname 112
    did -e $dname 113
    did -e $dname 114
    did -e $dname 74
    did -e $dname 116
    did -e $dname 73
    did -e $dname 78
    did -e $dname 80
    did -e $dname 82
    did -e $dname 84
    did -e $dname 86
    did -e $dname 88
    did -e $dname 90
    did -e $dname 92
    did -e $dname 75
    did -e $dname 79
    did -e $dname 81
    did -e $dname 83
    did -e $dname 85
    did -e $dname 87
    did -e $dname 89
    did -e $dname 91
    did -e $dname 93
    did -e $dname 247
    if ($did(247).state) { did -e $dname 248 | did -e $dname 250 }
    did -e $dname 274
    if ($did(274).state) { did -e $dname 115 }
  }
  else {
    did -b $dname 70
    did -b $dname 104
    did -b $dname 105
    did -b $dname 106
    did -b $dname 107
    did -b $dname 108
    did -b $dname 109
    did -b $dname 110
    did -b $dname 111
    did -b $dname 112
    did -b $dname 113
    did -b $dname 114
    did -b $dname 74
    did -b $dname 116
    did -b $dname 73
    did -b $dname 78
    did -b $dname 80
    did -b $dname 82
    did -b $dname 84
    did -b $dname 86
    did -b $dname 88
    did -b $dname 90
    did -b $dname 92
    did -b $dname 75
    did -b $dname 79
    did -b $dname 81
    did -b $dname 83
    did -b $dname 85
    did -b $dname 87
    did -b $dname 89
    did -b $dname 91
    did -b $dname 93
    did -b $dname 247
    did -b $dname 248
    did -b $dname 250
    did -b $dname 274
    did -b $dname 115
  }
}
on *:DIALOG:setupdialog:sclick:274: {
  if ($did(274).state) { did -e $dname 115 }
  else { did -b $dname 115 }
}
;END

;DESIGN EVENTS
on *:DIALOG:setupdialog:sclick:142: {
  if ($did(142).state) { did -b $dname 143 }
  else { did -e $dname 143 }
}
on *:DIALOG:setupdialog:sclick:125: {
  did -r $dname 95
  did -ra $dname 118 :
}
on *:DIALOG:setupdialog:sclick:124: {
  did -ra $dname 121 6(
  did -ra $dname 123 6)
}
on *:DIALOG:setupdialog:sclick:126: {
  did -ra $dname 130 6(
  did -ra $dname 128 6)
}
on *:DIALOG:setupdialog:sclick:132: {
  did -ra $dname 135 :[
  did -ra $dname 133 ]:
}
on *:DIALOG:setupdialog:sclick:137: {
  did -ra $dname 140 :[
  did -ra $dname 138 ]:
}
on *:DIALOG:setupdialog:sclick:144: {
  did -ra $dname 143 6,13 13,6  netZ v $+ %ver - http://netz.nonoo.hu/ 6,13 
}
on *:DIALOG:setupdialog:sclick:229: {
  dialog -x $dname
  if (%szintema == eredeti) { /classictema }
  else { /origtema }
}
on *:DIALOG:setupdialog:sclick:232: {
  if ($did(232).state) {
    did -e $dname 238 | did -e $dname 239 | did -e $dname 240 | did -e $dname 237 | if ($did(237).state) { did -e $dname 241 }
  }
  else {
    did -b $dname 238 | did -b $dname 239 | did -b $dname 240 | did -b $dname 241 | did -b $dname 237
  }
}
on *:DIALOG:setupdialog:sclick:237: {
  if ($did(237).state) { did -e $dname 241 }
  else { did -b $dname 241 }
}
;END

;EGYÉB EVENTS
on *:DIALOG:setupdialog:sclick:148: {
  if ($did(148).state) { did -e $dname 149 }
  else { did -b $dname 149 }
}
on *:DIALOG:setupdialog:sclick:158: {
  if ($did(158).state) { did -e $dname 160 | did -e $dname 245 }
  else { did -b $dname 160 | did -b $dname 245 }
}
on *:DIALOG:setupdialog:sclick:179: {
  if ($did(179).state) { did -e $dname 187 }
  else { did -b $dname 187 }
}
on *:DIALOG:setupdialog:sclick:190: {
  if ($did(188)) {
    var %prog $sdir="Alap netZ Downloader letöltési könyvtár:" $did(188)
  }
  else {
    var %prog $sdir="Alap netZ Downloader letöltési könyvtár:" c:\
  }
  if (%prog) { did -ra $dname 188 %prog }
}
on *:DIALOG:setupdialog:sclick:192: { .timer 1 0 /run notepad.exe system\greetings.txt }
on *:DIALOG:setupdialog:sclick:221: {
  if ($did(221).state) { did -e $dname 223 | did -e $dname 225 | did -e $dname 227 | did -e $dname 308 }
  else { did -b $dname 223 | did -b $dname 225 | did -b $dname 227 | did -b $dname 308 }
}
on *:DIALOG:setupdialog:sclick:243: {
  if ($did(243).state) { did -e $dname 244 }
  else { did -b $dname 244 }
}
on *:DIALOG:setupdialog:sclick:254: {
  if ($did(254).state) { did -e $dname 256 }
  else { did -b $dname 256 }
}
on *:DIALOG:setupdialog:sclick:259: {
  if ($did(259).state) { did -e $dname 261 }
  else { did -b $dname 261 }
}
on *:DIALOG:setupdialog:sclick:267: {
  if ($did(267).state) { did -e $dname 268 | did -e $dname 269 }
  else { did -b $dname 268 | did -b $dname 269 }
}
on *:DIALOG:setupdialog:sclick:271: {
  if ($did(271).state) { did -e $dname 272 }
  else { did -b $dname 272 }
}
;END

;BEEP EVENTS
on *:DIALOG:setupdialog:sclick:193: {
  if ($did(193).state) { did -e $dname 197 }
  else { did -b $dname 197 }
  if ($did(199).state) || ($did(198).state) || ($did(193).state) { did -e $dname 201 }
  else { did -b $dname 201 }
}
on *:DIALOG:setupdialog:sclick:198: {
  if ($did(199).state) { did -e $dname 203 }
  else { did -b $dname 203 }
  if ($did(199).state) || ($did(198).state) || ($did(193).state) { did -e $dname 201 }
  else { did -b $dname 201 }
}
on *:DIALOG:setupdialog:sclick:199: {
  if ($did(199).state) || ($did(198).state) || ($did(193).state) { did -e $dname 201 }
  else { did -b $dname 201 }
}
on *:DIALOG:setupdialog:sclick:48: {
  if (!$did(205).state) && (!$did(49).state) && (!$did(48).state) {
    if ($did(51).state) { did -u $dname 51 }
    if ($did(46).state) { did -u $dname 46 }
    did -b $dname 48 | did -b $dname 49 | did -b $dname 204 | did -b $dname 205 | did -b $dname 206 | did -b $dname 208
  }
}
on *:DIALOG:setupdialog:sclick:49: {
  if ($did(49).state) { did -e $dname 204 }
  else { did -b $dname 204 }
  if (!$did(205).state) && (!$did(49).state) && (!$did(48).state) {
    if ($did(51).state) { did -u $dname 51 }
    if ($did(46).state) { did -u $dname 46 }
    did -b $dname 48 | did -b $dname 49 | did -b $dname 204 | did -b $dname 205 | did -b $dname 206 | did -b $dname 208
  }
}
on *:DIALOG:setupdialog:sclick:51: {
  if ($did(46).state) || ($did(51).state) {
    did -e $dname 48 | did -e $dname 49 | did -e $dname 205 | did -e $dname 208
    if ($did(49).state) { did -e $dname 204 }
    if ($did(205).state) { did -e $dname 206 }
  }
  else { did -b $dname 48 | did -b $dname 49 | did -b $dname 204 | did -b $dname 205 | did -b $dname 206 | did -b $dname 208 }
  if ($did(51).state) { did -b $dname 46 }
  else { did -e $dname 46 }
}
on *:DIALOG:setupdialog:sclick:205: {
  if ($did(205).state) { did -e $dname 206 }
  else { did -b $dname 206 }
  if (!$did(205).state) && (!$did(49).state) && (!$did(48).state) {
    if ($did(51).state) { did -u $dname 51 }
    if ($did(46).state) { did -u $dname 46 }
    did -b $dname 48 | did -b $dname 49 | did -b $dname 204 | did -b $dname 205 | did -b $dname 206 | did -b $dname 208
  }
}
on *:DIALOG:setupdialog:sclick:211: {
  if ($did(211).state) { did -e $dname 212 }
  else { did -b $dname 212 }
}
on *:DIALOG:setupdialog:sclick:213: {
  if ($did(213).state) { did -e $dname 214 }
  else { did -b $dname 214 }
}
;END

;EMAIL EVENTS
on *:DIALOG:setupdialog:sclick:170: {
  if ($did(170).state) { did -e $dname 180 | did -e $dname 182 | did -e $dname 183 }
  else { did -b $dname 180 | did -b $dname 182 | did -b $dname 183 }
}
on *:DIALOG:setupdialog:sclick:182: {
  if ($did(182).state) {
    if ($did(213).state) { did -e $dname 214 }
    if ($did(211).state) { did -e $dname 212 }
    did -e $dname 211 | did -e $dname 213 | did -e $dname 215
  }
  else { did -b $dname 211 | did -b $dname 212 | did -b $dname 213 | did -b $dname 214 | did -b $dname 215 }
}
on *:DIALOG:setupdialog:sclick:186: {
  var %prog $dir="Emailezõ program" c:\
  if (%prog) { did -ra $dname 185 %prog }
}
on *:DIALOG:setupdialog:sclick:275: {
  if ($did(275).state) { did -ra $dname 178 995 }
  else { did -ra $dname 178 110 }
}
on *:DIALOG:setupdialog:sclick:276: {
  if ($did(276).state) { did -b $dname 172 | did -b $dname 178 | did -b $dname 275 | did -v $dname 278 }
  else { did -e $dname 172 | did -e $dname 178 | did -e $dname 275 | did -h $dname 278 }
}
on *:DIALOG:setupdialog:sclick:277: {
  /emailsettingssave
  /checkmail
}
on *:DIALOG:setupdialog:sclick:278: {
  /gmail_cookiedel
  /echo $color(info) -atng *** GMail cookie törölve.
}
alias /emailsettingssave {
  if ($did(170).state) { %checkmail = 1 }
  else { %checkmail = 0 }
  %checkmail_szerver = $did(172)
  %checkmail_port = $did(178)
  %checkmail_username = $did(173)
  %checkmail_pass = $enkod($did(176))
  %checkmail_interval = $did(180)
  if ($did(182).state) { %checkmail_pager = 1 }
  else { %checkmail_pager = 0 }
  if ($did(183).state) { %checkmail_emailer = 1 }
  else { %checkmail_emailer = 0 }
  %emailezo_prog = $did(185)
  if ($did(275).state) { %checkmail_ssl = 1 }
  else { %checkmail_ssl = 0 }
  if ($did(276).state) { %checkmail_gmailmode = 1 }
  else { %checkmail_gmailmode = 0 }
  if ($did(279).state) { %checkmail_deletecounter = 1 }
  else { %checkmail_deletecounter = 0 }
}
;END

;SKYPE EVENTS
on *:DIALOG:setupdialog:sclick:284: {
  if ($did(284).state) {
    did -e $dname 286 | did -e $dname 288 | did -e $dname 289 | did -e $dname 290 | did -e $dname 292 | did -e $dname 294
    did -e $dname 295 | did -e $dname 298 | did -e $dname 303 | did -e $dname 304
  }
  else {
    did -b $dname 286 | did -b $dname 288 | did -b $dname 289 | did -b $dname 290 | did -b $dname 292 | did -b $dname 294
    did -b $dname 295 | did -b $dname 298 | did -b $dname 303 | did -b $dname 304
  }
}
on *:DIALOG:setupdialog:sclick:286: {
  if ($did(286).state) { did -e $dname 288 | did -e $dname 289 }
  else { did -b $dname 288 | did -b $dname 289 }
}
on *:DIALOG:setupdialog:sclick:290: {
  if ($did(290).state) { did -e $dname 292 }
  else { did -b $dname 292 }
}
on *:DIALOG:setupdialog:sclick:294: {
  if ($did(294).state) { did -e $dname 295 | did -e $dname 301 | did -e $dname 302 }
  else { did -b $dname 295 | did -b $dname 301 | did -b $dname 302 }
}
;END

;TWITTER/RSS EVENTS
on *:DIALOG:setupdialog:sclick:331: { /rss edit }
;END

;OK GOMB
on *:DIALOG:setupdialog:sclick:3: {
  ;WINAMP
  %winamp_kiiras_szoveg = $did(7)
  if ($did(8).state) { %winamp_csik_kijelzes = 1 }
  else { %winamp_csik_kijelzes = 0 }
  if ($did(9).state) { %winamp_eltelt_ido_kijelzes = 1 }
  else { %winamp_eltelt_ido_kijelzes = 0 }
  if ($did(10).state) { %winamp_osszes_ido_kijelzes = 1 }
  else { %winamp_osszes_ido_kijelzes = 0 }
  if ($did(12).state) { %winamp_fajltipus_kijelzes = 1 }
  else { %winamp_fajltipus_kijelzes = 0 }
  if ($did(11).state) { %winamp_fajlmeret_kijelzes = 1 }
  else { %winamp_fajlmeret_kijelzes = 0 }
  %winamp_csik_hossza = $did(20)
  %winamp_csik_balkeret = $did(21)
  %winamp_csik_jobbkeret = $did(22)
  %winamp_csik_karakter = $did(23)
  %winamp_csik_karakter_holvan = $did(24)
  %winamp_automata_csatik = $did(30)
  if (!%winamp_csik_hossza) || (!%winamp_csik_balkeret) || (!%winamp_csik_jobbkeret) || (!%winamp_csik_karakter) || (!%winamp_csik_karakter_holvan) || (!%winamp_automata_csatik) { %winamp_csik_kijelzes = 0 }
  if ($did(27).state) { %winamp_automata_osszes_csatira = 1 }
  else { %winamp_automata_osszes_csatira = 0 }
  if ($did(28).state) { %winamp_automata_aktiv_csatira = 1 }
  else { %winamp_automata_aktiv_csatira = 0 }
  if ($did(29).state) { %winamp_automata_kivalasztott_csatira = 1 }
  else { %winamp_automata_kivalasztott_csatira = 0 }
  if ($did(26).state) { %winamp_automata_kijelzes = 1 | if ($server) { .timer 1 0 .wpauto on } }
  else { %winamp_automata_kijelzes = 0 | if ($server) { .timer 1 0 .wpauto off } }
  if ($did(31).state) { %winamp_kijelzes_titlebarban = 1 }
  else { %winamp_kijelzes_titlebarban = 0 }
  ;END

  ;AWAY
  if ($did(34).state) { %awaymessage_hasznalat = 1 }
  else { %awaymessage_hasznalat = 0 }
  %awaymessage = $did(35)
  if ($did(36).state) { %awaynick_hasznalat = 1 }
  else { %awaynick_hasznalat = 0 }
  %awaynick = $did(37)
  if ($did(273).state) { %awaynick_kisbetusre = 1 }
  else { %awaynick_kisbetusre = 0 }
  %autoaway_ido = $did(39)
  if ($did(38).state) { %autoaway_hasznalat = 1 }
  else { %autoaway_hasznalat = 0 }
  if ($did(41).state) { %autoaway_message_hasznalat = 1 }
  else { %autoaway_message_hasznalat = 0 }
  %autoaway_message = $did(42)
  if ($did(43).state) { %awayback_hasznalat = 1 }
  else { %awayback_hasznalat = 0 }
  %awayback_message = $did(44)
  if ($did(45).state) { %auto_awayoff = 1 }
  else { %auto_awayoff = 0 }
  if ($did(46).state) { %away_pager = 1 }
  else { %away_pager = 0 }
  if ($did(48).state) { %pager_speaker = 1 }
  else { %pager_speaker = 0 }
  if ($did(49).state) { %pager_beep = 1 }
  else { %pager_beep = 0 }
  if ($did(204).state) { %pager_beep_winamp = 1 }
  else { %pager_beep_winamp = 0 }
  if ($did(53).state) { %awaymessage_mindencsatira = 1 }
  else { %awaymessage_mindencsatira = 0 }
  %awaymessage_csatik = $did(55)
  if ($did(257).state) { %aaway_f10 = 1 }
  else { %aaway_f10 = 0 }
  if ($did(318).state) { %away_memoria = 1 }
  else { %away_memoria = 0 }
  ;END

  ;FLOOD
  if ($did(57).state) { %flooddetekt = 1 }
  else { %flooddetekt = 0 }
  if ($did(247).state) { %flooddetekt_ctcp = 1 }
  else { %flooddetekt_ctcp = 0 }
  if ($did(70).state) { %kick_csati = 1 }
  else { %kick_csati = 0 }
  if ($did(105).state) { %kick_join = 1 }
  else { %kick_join = 0 }
  if ($did(107).state) { %kick_kick = 1 }
  else { %kick_kick = 0 }
  if ($did(109).state) { %kick_ban = 1 }
  else { %kick_ban = 0 }
  if ($did(111).state) { %kick_deop = 1 }
  else { %kick_deop = 0 }
  if ($did(113).state) { %kick_nick = 1 }
  else { %kick_nick = 0 }
  if ($did(104).state) { %ban_csati = 1 }
  else { %ban_csati = 0 }
  if ($did(106).state) { %ban_join = 1 }
  else { %ban_join = 0 }
  if ($did(108).state) { %ban_kick = 1 }
  else { %ban_kick = 0 }
  if ($did(110).state) { %ban_ban = 1 }
  else { %ban_ban = 0 }
  if ($did(112).state) { %ban_deop = 1 }
  else { %ban_deop = 0 }
  if ($did(114).state) { %ban_nick = 1 }
  else { %ban_nick = 0 }
  if ($did(74).state) { %kick_oposokat = 0 }
  else { %kick_oposokat = 1 }
  if ($did(116).state) { %kick_voiceosokat = 0 }
  else { %kick_voiceosokat = 1 }
  %max_csati = $did(73)
  %max_invite = $did(78)
  %max_chat = $did(80)
  %max_send = $did(82)
  %max_join = $did(84)
  %max_kick = $did(86)
  %max_ban = $did(88)
  %max_deop = $did(90)
  %max_nick = $did(92)
  %max_ctcp = $did(248)
  %time_csati = $did(75)
  %time_invite = $did(79)
  %time_chat = $did(81)
  %time_send = $did(83)
  %time_join = $did(85)
  %time_kick = $did(87)
  %time_ban = $did(89)
  %time_deop = $did(91)
  %time_nick = $did(93)
  %time_ctcp = $did(250)
  if ($did(274).state) { %flooddetekt_csatikra = 1 }
  else { %flooddetekt_csatikra = 0 }
  %flooddetekt_csatik = $did(115)
  ;END

  ;DESIGN
  %nickcomp_bal = $did(95)
  %nickcomp_jobb = $did(118)
  %en_bal = $did(121)
  %en_jobb = $did(123)
  %mas_bal = $did(130)
  %mas_jobb = $did(128)
  %titlebar_bal = $did(135)
  %titlebar_jobb = $did(133)
  %menu_bal = $did(140)
  %menu_jobb = $did(138)
  %quitmessage = $did(143)
  if ($did(142).state) { %quitmessage_random = 1 }
  else { %quitmessage_random = 0 }
  if ($did(232).state) {
    %idleszin_hasznalat = 1
    ; osszes kapcsolatnal bekapcsoljuk
    var %j $scon(0)
    while (%j > 0) {
      ; osszes kapcsolatra kinyomjuk
      scon %j
      if ($scon(%j).$server) { .timeridlecheck $+ $cid 0 60 /idlecheck }
      scon -r

      dec %j 1
    }
  }
  else { %idleszin_hasznalat = 0 | .timeridlecheck* off }
  %idleszin_60perce = $did(241)
  %idleszin_40perce = $did(240)
  %idleszin_20perce = $did(239)
  %idleszin_10perce = $did(238)
  %idleszin_0perce = $did(233)
  if ($did(237).state) { %idleszin_60perce_hasznalat = 1 }
  else { %idleszin_60perce_hasznalat = 0 }
  idlecheck
  ;END

  ;EGYÉB
  if ($did(148).state) { %autojoin = 1 }
  else { %autojoin = 0 }
  %autojoin_csatik = $did(149)
  %kedvenc_csatik = $did(151)
  if ($did(153).state) { %motd_kiiras = 1 }
  else { %motd_kiiras = 0 }
  if ($did(154).state) { %lusers_kiiras = 1 }
  else { %lusers_kiiras = 0 }
  if ($did(163).state) { %autoupdate = 1 }
  else { %autoupdate = 0 }
  %timestamp_format = $did(168)
  if ($did(179).state) { %dl_hotlink = 1 }
  else { %dl_hotlink = 0 }
  %dl_hotlink_kiterjesztesek = $did(187)
  %dl_downloaddir = $did(188)
  if ($right(%dl_downloaddir,1) != \) { %dl_downloaddir = %dl_downloaddir $+ \ }
  if ($did(221).state) { %wndback = 1 }
  else { %wndback = 0 }
  %wndback_font = $did(223)
  %wndback_font_size = $did(225)
  %wndback_font_color = $did(227)
  %wndback_nodisp = $did(308)
  wndbackall
  if ($did(243).state) { %autoconnect = 1 }
  else { %autoconnect = 0 }
  %autoconnect_servers = $did(244)
  if ($did(254).state) { %getlog = 1 }
  else { %getlog = 0 }
  %getlog_numlines = $did(256)
  if ($did(259).state) { %url_kiemeles = 1 }
  else { %url_kiemeles = 0 }
  %url_kiemeles_style = $did(261)
  %highlight_szavak2 = $did(265)
  %highlight_ignore_szavak2 = $did(280)
  if ($did(267).state) { %uptime_meres = 1 }
  else { %uptime_meres = 0 }
  if ($did(268).state) { %uptime_notice = 1 }
  else { %uptime_notice = 0 }
  if ($did(269).state) { %uptime_notice_newrecord = 1 }
  else { %uptime_notice_newrecord = 0 }
  if ($did(271).state) { %netsplit_detect = 1 }
  else { %netsplit_detect = 0 }
  if ($did(272).state) { %netsplit_detect_onlyhu = 1 }
  else { %netsplit_detect_onlyhu = 0 }
  if ($did(315).state) { %auto_orignick = 1 }
  else { %auto_orignick = 0 }
  if ($did(320).state) { %ophop = 1 }
  else { %ophop = 0 }
  ;END

  ;DESIGN3
  if ($did(156).state) { %winamp_kijelzes_titlebarban = 1 }
  else { %winamp_kijelzes_titlebarban = 0 }
  if ($did(157).state) { %itime_kijelzes_titlebarban = 1 }
  else { %itime_kijelzes_titlebarban = 0 }
  %lagdetect_auto_interval = $did(160)
  if ($did(245).state) { %lagdetect_titlebarban_csik = 1 }
  else { %lagdetect_titlebarban_csik = 0 }
  if ($did(158).state) {
    %lagdetect_titlebarban = 1
    ; minden szerver kapcsolatra vegigmegyunk
    var %j $scon(0)
    while (%j > 0) {
      scon %j
      if ($scon(%j).$server) { .timer 1 0 .lagauto on }
      scon -r
      dec %j 1
    }
  }
  else {
    %lagdetect_titlebarban = 0
    ; minden szerver kapcsolatra vegigmegyunk
    var %j $scon(0)
    while (%j > 0) {
      scon %j
      if ($scon(%j).$server) { .timer 1 0 .lagauto off }
      scon -r
      dec %j 1
    }
  }
  if ($did(311).state) { %tooltip_priviknel = 1 }
  else { %tooltip_priviknel = 0 }
  if ($did(310).state) { %highlight_tooltip = 1 }
  else { %highlight_tooltip = 0 }
  if ($did(312).state) { %checkmail_tooltip = 1 }
  else { %checkmail_tooltip = 0 }
  if ($did(313).state) { %tooltip_dccnel = 1 }
  else { %tooltip_dccnel = 0 }
  if ($did(316).state) { %tooltip_pagenel = 1 }
  else { %tooltip_pagenel = 0 }
  if ($did(317).state) { %tooltip_noticenal = 1 }
  else { %tooltip_noticenal = 0 }
  if ($did(321).state) { %tooltip_multiline = 1 }
  else { %tooltip_multiline = 0 }
  ;END

  ;BEEP
  if ($did(193).state) { %flash_priviknel = 1 }
  else { %flash_priviknel = 0 }
  %flash_priviknel_szoveg = $did(197)
  if ($did(198).state) { %beep_priviknel = 1 }
  else { %beep_priviknel = 0 }
  if ($did(203).state) { %beep_priviknel_winamp = 1 }
  else { %beep_priviknel_winamp = 0 }
  if ($did(199).state) { %pcspeaker_priviknel = 1 }
  else { %pcspeaker_priviknel = 0 }
  %flash_priviknel_timeout = $calc($did(201) * 60)
  if ($did(51).state) { %pager = 1 }
  else { %pager = 0 }
  if ($did(204).state) { %pager_beep_winamp = 1 }
  else { %pager_beep_winamp = 0 }
  if ($did(205).state) { %pager_flash = 1 }
  else { %pager_flash = 0 }
  %pager_flash_szoveg = $did(206)
  %pager_timeout = $calc($did(208) * 60)
  if ($did(211).state) { %checkmail_flash = 1 }
  else { %checkmail_flash = 0 }
  %checkmail_flash_szoveg = $did(212)
  if ($did(213).state) { %checkmail_beep = 1 }
  else { %checkmail_beep = 0 }
  if ($did(214).state) { %checkmail_beep_winamp = 1 }
  else { %checkmail_beep_winamp = 0 }
  if ($did(215).state) { %checkmail_speaker = 1 }
  else { %checkmail_speaker = 0 }
  if ($did(216).state) { %highlight_pager = 1 }
  else { %highlight_pager = 0 }
  ;END

  ;SKYPE
  if ($did(284).state) { %skype_hasznalat = 1 }
  else {
    if (%skype_hasznalat) {
      /dll system/netz.dll skypesendmsg set profile rich_mood_text
    }
    %skype_hasznalat = 0
    /dll system/netz.dll skype disconnect
  }
  %skype_separator = $did(298)
  %skype_winamp_szoveg = $did(295)
  if ($did(294).state) { %skype_winamp_kijelzes = 1 }
  else { %skype_winamp_kijelzes = 0 }
  if ($did(301).state) { %skype_winamp_hossz_kijelzes = 1 }
  else { %skype_winamp_hossz_kijelzes = 0 }
  if ($did(302).state) { %skype_winamp_bitrata_kijelzes = 1 }
  else { %skype_winamp_bitrata_kijelzes = 0 }
  if ($did(286).state) { %skype_away_kijelzes = 1 }
  else { %skype_away_kijelzes = 0 }
  %skype_away_szoveg = $did(288)
  if ($did(289).state) { %skype_awaymsg_kiiras = 1 }
  else { %skype_awaymsg_kiiras = 0 }
  if ($did(290).state) { %skype_away_follow = 1 }
  else { %skype_away_follow = 0 }
  if ($did(292).sel == 1) { %skype_away_mod = away }
  if ($did(292).sel == 2) { %skype_away_mod = na }
  if ($did(292).sel == 3) { %skype_away_mod = dnd }
  if ($did(292).sel == 4) { %skype_away_mod = invisible }
  %skype_msg1 = $did(303)
  %skype_msg2 = $did(304)
  ;END

  ;TWITTER/RSS
  %twitter_acc = $did(325)
  %twitter_pass = $enkod($did(326))
  if ($did(330).state) { %rss_auto_check = 1 | .rss --init }
  else { %rss_auto_check = 0 | .timerRSS off }
  ;END

  emailsettingssave

  othercheck
}
;END
