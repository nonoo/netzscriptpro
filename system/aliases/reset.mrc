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

;RESET
/reset {
  if (!$?!="Tényleg resetelni akarod a scriptet? Ez minden beállításodat törölni fogja!") { /halt }
  /write -c system\urls.ini
  /write -c system\control.ini
  /write -c system\gmailcookies.dat
  /write -c system\jobs.dat
  /botop -c
  .firewall off
  %nemvoltinditva = 1
  %winamp_csik_kijelzes = 1
  %winamp_eltelt_ido_kijelzes = 1
  %winamp_osszes_ido_kijelzes = 1
  %winamp_fajlmeret_kijelzes = 1
  %winamp_fajltipus_kijelzes = 1
  %winamp_kiiras_szoveg = plays:
  %winamp_csik_hossza = 10
  %winamp_csik_karakter = -
  %winamp_csik_karakter_holvan = |
  %winamp_csik_balkeret = [
  %winamp_csik_jobbkeret = ]
  %winamp_automata_kijelzes = 0
  %winamp_automata_osszes_csatira = 0
  %winamp_automata_aktiv_csatira = 1
  %winamp_automata_kivalasztott_csatira = 0
  %winamp_automata_csatik = #csati1 #csati2 #csati3
  %winamp_automata_lasttr = blabla
  %winamp_kijelzes_titlebarban = 1
  %awaynick_hasznalat = 1
  %awaynick = netz
  %awaynick_kisbetusre = 1
  %away_eredeti_nick = netZ
  %awaymessage_hasznalat = 1
  %awaymessage_mindencsatira = 1
  %awaymessage_csatik = #csati1 #csati2 #csati3
  %awaymessage = is away
  %autoaway_hasznalat = 0
  %autoaway_ido = 20
  %autoaway_message_hasznalat = 0
  %autoaway_message = is away (auto-away)
  %auto_awayoff = 0
  %awayback_hasznalat = 1
  %awayback_message = is back
  %away_pager = 0
  %pager_speaker = 1
  %pager_beep = 1
  %pager = 1
  %onbold = 0
  %onreverse = 0
  %oninverse = 0
  %onunderline = 0
  %onrandomcase = 0
  %onrcolor = 0
  %onelite = 0
  %ontopten = 0
  %menu_bal = :[
  %menu_jobb = ]:
  %nickcomp_bal = $null
  %nickcomp_jobb = :
  %en_bal = 6(
  %en_jobb = 6)
  %mas_bal = 6(
  %mas_jobb = 6)
  %titlebar_bal = :[
  %titlebar_jobb = ]:
  %quitmessage_random = 1
  %quitmessage = $null
  %kedvenc_csatik = #qka
  %autojoin = 0
  %autojoin_csatik = #csati1 #csati2 #csati3
  %motd_kiiras = 1
  %lusers_kiiras = 0
  %lagdetect_titlebarban = 1
  %lagdetect_auto_interval = 15
  %itime_kijelzes_titlebarban = 0
  %flooddetekt = 0
  %kick_oposokat = 0
  %kick_voiceosokat = 0
  %max_csati = 5
  %max_kick = 3
  %max_ban = 3
  %max_deop = 3
  %max_join = 3
  %max_invite = 3
  %max_chat = 3
  %max_send = 3
  %max_nick = 3
  %time_csati = 3
  %time_kick = 5
  %time_ban = 5
  %time_deop = 5
  %time_join = 10
  %time_invite = 5
  %time_chat = 5
  %time_send = 5
  %time_nick = 5
  %ban_csati = 0
  %ban_kick = 1
  %ban_ban = 1
  %ban_deop = 1
  %ban_join = 1
  %ban_nick = 1
  %kick_csati = 0
  %kick_kick = 1
  %kick_ban = 1
  %kick_deop = 1
  %kick_join = 1
  %kick_nick = 1
  %autoupdate = 1
  %update_url = http://netz.nonoo.hu/update/
  %dl_hotlink = 1
  %dl_hotlink_kiterjesztesek = *.bz2 *.zip *.gz *.mp3 *.tar *.tar.bz2 *.wav *.nfo *.rar *.diz *.avi *.mpg *.mpeg *.wmv *.asf *.mov *.doc *.mid *.pdf *.ps *.ini *.exe *.ace *.mpe *.flac *.m4a
  %dl_downloaddir = C:\Downloads\
  %dl_letoltott_adatmennyiseg = 0
  %flash_priviknel = 1
  %flash_priviknel_szoveg = <ÜZENET>
  %flash_priviknel_timeout = 120
  %beep_priviknel = 1
  %pcspeaker_priviknel = 1
  %telnetcrlf = 1
  %telnetlecho = 1
  %emailezo_prog = $null
  %checkmail = 0
  %checkmail_szerver = freemail.hu
  %checkmail_port = 110
  %checkmail_username = $null
  %checkmail_pass = $null
  %checkmail_interval = 10
  %checkmail_pager = 1
  %checkmail_emailer = 0
  %checkmail_lastnum = 0
  %tmpSetting = -auto
  %update_php = update.ini
  %pager_beep_winamp = 0
  %beep_priviknel_winamp = 1
  %pager_flash = 1
  %pager_flash_szoveg = <PAGE>
  %pager_timeout = 180
  %checkmail_flash = 0
  %checkmail_flash_szoveg = <EMAIL>
  %checkmail_beep = 1
  %checkmail_beep_winamp = 1
  %checkmail_speaker = 1
  %highlight_pager = 1
  %wndback = 1
  %wndback_font = Arial Black
  %wndback_font_size = 100
  %wndback_font_color = 50,50,50
  ; 2.9
  %idleszin_60perce = 5
  %idleszin_40perce = 6
  %idleszin_20perce = 14
  %idleszin_10perce = 15
  %idleszin_0perce = 0
  if (%szintema == eredeti) {
    %nick_highlight_szin = 9
  }
  else {
    %nick_highlight_szin = 8
  }
  %szintema = eredeti
  ; 2.95
  %idleszin_hasznalat = 1
  %idleszin_60perce_hasznalat = 0
  %legutobbiszerver1 = irc.hu
  %legutobbiszerver2 = elte.irc.hu
  %legutobbiszerver3 = extra.irc.hu
  %legutobbiszerver4 = atw.irc.hu
  %legutobbiszerver5 = hub.irc.hu
  %autoconnect = 0
  %autoconnect_servers = extra.irc.hu atw.irc.hu
  ; 2.96
  %lagdetect_titlebarban_csik = 0
  %timestamp_format = 14(HH:nn:ss14)
  .timestamp -f %timestamp_format
  %time_ctcp = 10
  %max_ctcp = 3
  %flooddetekt_ctcp = 1
  ; 2.98
  %getlog = 1
  %getlog_numlines = 100
  ; 2.99
  %aaway_f10 = 1
  ; 2.100
  %url_kiemeles = 1
  %url_kiemeles_style = 0
  %highlight_szavak2 = $null
  ; 2.102
  %udpbeep = 0
  %uptime_meres = 1
  %uptime_notice = 0
  %uptime_notice_newrecord = 0
  %uptime_noticed = 1
  %uptime_record = $null
  %uptime_record_date = $null
  %netsplit_detect = 1
  %netsplit_detect_onlyhu = 1
  %flooddetekt_csatikra = 0
  %flooddetekt_csatik = #csati1 #csati2
  %checkmail_ssl = 0
  %checkmail_gmailmode = 0
  %checkmail_deletecounter = 1
  %highlight_ignore_szavak2 = top10(words)
  ; 2.103
  %skype_hasznalat = 0
  %skype_separator = $chr(124)
  %skype_winamp_szoveg = plays:
  %skype_winamp_kijelzes = 1
  %skype_winamp_hossz_kijelzes = 1
  %skype_winamp_bitrata_kijelzes = 1
  %skype_away_kijelzes = 1
  %skype_away_szoveg = away:
  %skype_awaymsg_kiiras = 1
  %skype_away_follow = 1
  %skype_away_mod = na
  %skype_delay = 5
  %skype_msg1 = $null
  %skype_msg2 = $null
  %skype_moodtext = $null
  %skype_oldmoodtext = $null
  %wndback_nodisp = $null
  ; 2.104
  %tooltip_priviknel = 1
  %highlight_tooltip = 1
  %checkmail_tooltip = 1
  %tooltip_dccnel = 1
  ; 2.105
  %auto_orignick = 1
  %away_memoria = 1
  %ophop = 1
  ; 2.106
  %tooltip_multiline = 1

  /echo $color(info) -atng *** Reset done.
}
;END

;VARCHECK
/varcheck {
  ; vegignezi a netz valtozoit es ha valamelyik hianyzik, default ertekre allitja
  %ver = 2.106
  %update_php = update.ini
  if (%nemvoltinditva == $null) { %nemvoltinditva = 0 }
  if (%url == $null) { %url = netz.nonoo.hu }
  if (%winamp_csik_kijelzes == $null) { %winamp_csik_kijelzes = 1 }
  if (%winamp_eltelt_ido_kijelzes == $null) { %winamp_eltelt_ido_kijelzes = 1 }
  if (%winamp_osszes_ido_kijelzes == $null) { %winamp_osszes_ido_kijelzes = 1 }
  if (%winamp_fajlmeret_kijelzes == $null) { %winamp_fajlmeret_kijelzes = 1 }
  if (%winamp_fajltipus_kijelzes == $null) { %winamp_fajltipus_kijelzes = 1 }
  if (%winamp_kiiras_szoveg == $null) { %winamp_kiiras_szoveg = plays: }
  if (%winamp_csik_hossza == $null) { %winamp_csik_hossza = 10 }
  if (%winamp_csik_karakter == $null) { %winamp_csik_karakter = - }
  if (%winamp_csik_karakter_holvan == $null) { %winamp_csik_karakter_holvan = | }
  if (%winamp_csik_balkeret == $null) { %winamp_csik_balkeret = [ }
  if (%winamp_csik_jobbkeret == $null) { %winamp_csik_jobbkeret = ] }
  if (%winamp_automata_kijelzes == $null) { %winamp_automata_kijelzes = 0 }
  if (%winamp_automata_osszes_csatira == $null) { %winamp_automata_osszes_csatira = 0 }
  if (%winamp_automata_aktiv_csatira == $null) { %winamp_automata_aktiv_csatira = 1 }
  if (%winamp_automata_kivalasztott_csatira == $null) { %winamp_automata_kivalasztott_csatira = 0 }
  if (%winamp_automata_csatik == $null) { %winamp_automata_csatik = #csati1 #csati2 #csati3 }
  if (%winamp_automata_lasttr == $null) { %winamp_automata_lasttr = blabla }
  if (%winamp_kijelzes_titlebarban == $null) { %winamp_kijelzes_titlebarban = 1 }
  if (%awaynick_hasznalat == $null) { %awaynick_hasznalat = 1 }
  if (%awaynick == $null) { %awaynick = netz }
  if (%awaynick_kisbetusre == $null) { %awaynick_kisbetusre = 1 }
  if (%away_eredeti_nick == $null) { %away_eredeti_nick = netZ }
  if (%awaymessage_hasznalat == $null) { %awaymessage_hasznalat = 1 }
  if (%awaymessage_mindencsatira == $null) { %awaymessage_mindencsatira = 1 }
  if (%awaymessage_csatik == $null) { %awaymessage_csatik = #csati1 #csati2 #csati3 }
  if (%awaymessage == $null) { %awaymessage = is away }
  if (%autoaway_hasznalat == $null) { %autoaway_hasznalat = 0 }
  if (%autoaway_ido == $null) { %autoaway_ido = 20 }
  if (%autoaway_message_hasznalat == $null) { %autoaway_message_hasznalat = 0 }
  if (%autoaway_message == $null) { %autoaway_message = is away (auto-away) }
  if (%auto_awayoff == $null) { %auto_awayoff = 0 }
  if (%awayback_hasznalat == $null) { %awayback_hasznalat = 1 }
  if (%awayback_message == $null) { %awayback_message = is back }
  if (%away_pager == $null) { %away_pager = 0 }
  if (%pager_speaker == $null) { %pager_speaker = 1 }
  if (%pager_beep == $null) { %pager_beep = 1 }
  if (%pager == $null) { %pager = 1 }
  if (%onbold == $null) { %onbold = 0 }
  if (%onreverse == $null) { %onreverse = 0 }
  if (%oninverse == $null) { %oninverse = 0 }
  if (%onunderline == $null) { %onunderline = 0 }
  if (%onrandomcase == $null) { %onrandomcase = 0 }
  if (%onrcolor == $null) { %onrcolor = 0 }
  if (%onelite == $null) { %onelite = 0 }
  if (%ontopten == $null) { %ontopten = 0 }
  if (%menu_bal == $null) { %menu_bal = :[ }
  if (%menu_jobb == $null) { %menu_jobb = ]: }
  if (%nickcomp_jobb == $null) { %nickcomp_jobb = : }
  if (%en_bal == $null) { %en_bal = 6( }
  if (%en_jobb == $null) { %en_jobb = 6) }
  if (%mas_bal == $null) { %mas_bal = 6( }
  if (%mas_jobb == $null) { %mas_jobb = 6) }
  if (%titlebar_bal == $null) { %titlebar_bal = :[ }
  if (%titlebar_jobb == $null) { %titlebar_jobb = ]: }
  if (%quitmessage_random == $null) { %quitmessage_random = 1 }
  if (%kedvenc_csatik == $null) { %kedvenc_csatik = #qka }
  if (%autojoin == $null) { %autojoin = 0 }
  if (%autojoin_csatik == $null) { %autojoin_csatik = #csati1 #csati2 #csati3 }
  if (%motd_kiiras == $null) { %motd_kiiras = 1 }
  if (%lusers_kiiras == $null) { %lusers_kiiras = 0 }
  if (%lagdetect_titlebarban == $null) { %lagdetect_titlebarban = 1 }
  if (%lagdetect_auto_interval == $null) { %lagdetect_auto_interval = 15 }
  if (%itime_kijelzes_titlebarban == $null) { %itime_kijelzes_titlebarban = 0 }
  if (%flooddetekt == $null) { %flooddetekt = 0 }
  if (%kick_oposokat == $null) { %kick_oposokat = 0 }
  if (%kick_voiceosokat == $null) { %kick_voiceosokat = 0 }
  if (%max_csati == $null) { %max_csati = 5 }
  if (%max_kick == $null) { %max_kick = 3 }
  if (%max_ban == $null) { %max_ban = 3 }
  if (%max_deop == $null) { %max_deop = 3 }
  if (%max_join == $null) { %max_join = 3 }
  if (%max_invite == $null) { %max_invite = 3 }
  if (%max_chat == $null) { %max_chat = 3 }
  if (%max_send == $null) { %max_send = 3 }
  if (%max_nick == $null) { %max_nick = 3 }
  if (%time_csati == $null) { %time_csati = 3 }
  if (%time_kick == $null) { %time_kick = 5 }
  if (%time_ban == $null) { %time_ban = 5 }
  if (%time_deop == $null) { %time_deop = 5 }
  if (%time_join == $null) { %time_join = 10 }
  if (%time_invite == $null) { %time_invite = 5 }
  if (%time_chat == $null) { %time_chat = 5 }
  if (%time_send == $null) { %time_send = 5 }
  if (%time_nick == $null) { %time_nick = 5 }
  if (%ban_csati == $null) { %ban_csati = 0 }
  if (%ban_kick == $null) { %ban_kick = 1 }
  if (%ban_ban == $null) { %ban_ban = 1 }
  if (%ban_deop == $null) { %ban_deop = 1 }
  if (%ban_join == $null) { %ban_join = 1 }
  if (%ban_nick == $null) { %ban_nick = 1 }
  if (%kick_csati == $null) { %kick_csati = 0 }
  if (%kick_kick == $null) { %kick_kick = 1 }
  if (%kick_ban == $null) { %kick_ban = 1 }
  if (%kick_deop == $null) { %kick_deop = 1 }
  if (%kick_join == $null) { %kick_join = 1 }
  if (%kick_nick == $null) { %kick_nick = 1 }
  if (%autoupdate == $null) { %autoupdate = 1 }
  if (%update_url == $null) { %update_url = http://netz.nonoo.hu/update/ }
  if (%dl_hotlink == $null) { %dl_hotlink = 1 }
  if (%dl_hotlink_kiterjesztesek == $null) { %dl_hotlink_kiterjesztesek = *.bz2 *.zip *.gz *.mp3 *.tar *.tar.bz2 *.wav *.nfo *.rar *.diz *.avi *.mpg *.mpeg *.wmv *.asf *.mov *.doc *.mid *.pdf *.ps *.ini *.exe *.ace *.mpe *.flac *.m4a }
  if (%dl_downloaddir == $null) { %dl_downloaddir = C:\Downloads\ }
  if (%dl_letoltott_adatmennyiseg == $null) { %dl_letoltott_adatmennyiseg = 0 }
  if (%flash_priviknel == $null) { %flash_priviknel = 1 }
  if (%flash_priviknel_szoveg == $null) { %flash_priviknel_szoveg = <ÜZENET> }
  if (%flash_priviknel_timeout == $null) { %flash_priviknel_timeout = 120 }
  if (%beep_priviknel == $null) { %beep_priviknel = 1 }
  if (%pcspeaker_priviknel == $null) { %pcspeaker_priviknel = 1 }
  if (%telnetcrlf == $null) { %telnetcrlf = 1 }
  if (%telnetlecho == $null) { %telnetlecho = 1 }
  if (%checkmail == $null) { %checkmail = 0 }
  if (%checkmail_szerver == $null) { %checkmail_szerver = freemail.hu }
  if (%checkmail_port == $null) { %checkmail_port = 110 }
  if (%checkmail_interval == $null) { %checkmail_interval = 10 }
  if (%checkmail_pager == $null) { %checkmail_pager = 1 }
  if (%checkmail_emailer == $null) { %checkmail_emailer = 0 }
  if (%checkmail_lastnum == $null) { %checkmail_lastnum = 0 }
  if (%tmpSetting == $null) { %tmpSetting = -auto }
  if (%pager_beep_winamp == $null) { %pager_beep_winamp = 0 }
  if (%beep_priviknel_winamp == $null) { %beep_priviknel_winamp = 1 }
  if (%pager_flash == $null) { %pager_flash = 1 }
  if (%pager_flash_szoveg == $null) { %pager_flash_szoveg = <PAGE> }
  if (%pager_timeout == $null) { %pager_timeout = 180 }
  if (%checkmail_flash == $null) { %checkmail_flash = 0 }
  if (%checkmail_flash_szoveg == $null) { %checkmail_flash_szoveg = <EMAIL> }
  if (%checkmail_beep == $null) { %checkmail_beep = 1 }
  if (%checkmail_beep_winamp == $null) { %checkmail_beep_winamp = 1 }
  if (%checkmail_speaker == $null) { %checkmail_speaker = 1 }
  if (%highlight_pager == $null) { %highlight_pager = 1 }
  if (%wndback == $null) { %wndback = 1 }
  if (%wndback_font == $null) { %wndback_font = Arial Black }
  if (%wndback_font_size == $null) { %wndback_font_size = 100 }
  if (%wndback_font_color == $null) { %wndback_font_color = 50,50,50 }
  ; 2.9
  if (%idleszin_60perce == $null) { %idleszin_60perce = 5 }
  if (%idleszin_40perce == $null) { %idleszin_40perce = 6 }
  if (%idleszin_20perce == $null) { %idleszin_20perce = 14 }
  if (%idleszin_10perce == $null) { %idleszin_10perce = 15 }
  if (%idleszin_0perce == $null) { %idleszin_0perce = 0 }
  if (%nick_highlight_szin == $null) { %nick_highlight_szin = 9 }
  if (%szintema == $null) { %szintema = eredeti }
  ; 2.95
  if (%idleszin_hasznalat == $null) { %idleszin_hasznalat = 1 }
  if (%idleszin_60perce_hasznalat == $null) { %idleszin_60perce_hasznalat = 0 }
  if (%legutobbiszerver1 == $null) { %legutobbiszerver1 = irc.hu }
  if (%legutobbiszerver2 == $null) { %legutobbiszerver2 = atw.irc.hu }
  if (%legutobbiszerver3 == $null) { %legutobbiszerver3 = extra.irc.hu }
  if (%legutobbiszerver4 == $null) { %legutobbiszerver4 = elte.irc.hu }
  if (%legutobbiszerver5 == $null) { %legutobbiszerver5 = hub.irc.hu }
  if (%autoconnect == $null) { %autoconnect = 0 }
  if (%autoconnect_servers == $null) { %autoconnect_servers = atw.irc.hu extra.irc.hu }
  ; 2.96
  if (%lagdetect_titlebarban_csik == $null) { %lagdetect_titlebarban_csik = 0 }
  if (%timestamp_format == $null) { %timestamp_format = 14(HH:nn:ss14) }
  .timestamp -f %timestamp_format
  if (%time_ctcp == $null) { %time_ctcp = 10 }
  if (%max_ctcp == $null) { %max_ctcp = 3 }
  if (%flooddetekt_ctcp == $null) { %flooddetekt_ctcp = 1 }
  ; 2.98
  if (%getlog == $null) { %getlog = 1 }
  if (%getlog_numlines == $null) { %getlog_numlines = 100 }
  ; 2.99
  if (%aaway_f10 == $null) { %aaway_f10 = 1 }
  ; 2.100
  if (%url_kiemeles == $null) { %url_kiemeles = 1 }
  if (%url_kiemeles_style == $null) { %url_kiemeles_style = 0 }
  ; 2.102
  if (%udpbeep == $null) { %udpbeep = 0 }
  if (%uptime_meres == $null) { %uptime_meres = 1 }
  if (%netsplit_detect == $null) { %netsplit_detect = 1 }
  if (%netsplit_detect_onlyhu == $null) { %netsplit_detect_onlyhu = 1 }
  if (%flooddetekt_csatikra == $null) { %flooddetekt_csatikra = 0 }
  if (%flooddetekt_csatik == $null) { %flooddetekt_csatik = #csati1 #csati2 }
  if (%checkmail_ssl == $null) { %checkmail_ssl = 0 }
  if (%checkmail_gmailmode == $null) { %checkmail_gmailmode = 0 }
  if (%checkmail_deletecounter == $null) { %checkmail_deletecounter = 1 }
  if (%highlight_ignore_szavak2 == $null) { %highlight_ignore_szavak2 = top10(words) }
  ; 2.103
  if (%skype_hasznalat == $null) { %skype_hasznalat = 0 }
  if (%skype_separator == $null) { %skype_separator = $chr(124) }
  if (%skype_winamp_szoveg == $null) { %skype_winamp_szoveg = plays: }
  if (%skype_winamp_kijelzes == $null) { %skype_winamp_kijelzes = 1 }
  if (%skype_winamp_hossz_kijelzes == $null) { %skype_winamp_hossz_kijelzes = 1 }
  if (%skype_winamp_bitrata_kijelzes == $null) { %skype_winamp_bitrata_kijelzes = 1 }
  if (%skype_away_kijelzes == $null) { %skype_away_kijelzes = 1 }
  if (%skype_away_szoveg == $null) { %skype_away_szoveg = away: }
  if (%skype_awaymsg_kiiras == $null) { %skype_awaymsg_kiiras = 1 }
  if (%skype_away_follow == $null) { %skype_away_follow = 1 }
  if (%skype_away_mod == $null) { %skype_away_mod = na }
  if (%skype_delay == $null) { %skype_delay = 5 }
  ; 2.104
  if (%tooltip_priviknel == $null) { %tooltip_priviknel = 1 }
  if (%highlight_tooltip == $null) { %highlight_tooltip = 1 }
  if (%checkmail_tooltip == $null) { %checkmail_tooltip = 1 }
  if (%tooltip_dccnel == $null) { %tooltip_dccnel = 1 }
  ; 2.105
  if (%auto_orignick == $null) { %auto_orignick = 1 }
  if (%tooltip_pagenel == $null) { %tooltip_pagenel = 1 }
  if (%tooltip_noticenal == $null) { %tooltip_noticenal = 1 }
  if (%away_memoria == $null) { %away_memoria = 1 }
  if (%ophop == $null) { %ophop = 1 }
  ; 2.106
  if (%tooltip_multiline == $null) { %tooltip_multiline = 1 }
}
;END

;OTHERCHECK
/othercheck {
  ; egyeb, 2.8 ota ujabb dolgokat ellenoriz

  ; 2.96
  if ($hget(uzenet) == $null) { .hmake uzenet 10 }
  ; timestamp formatum
  .timestamp -f %timestamp_format
  ; 2.102
  if (%uptime_meres) {
    if ($timer(Uptime) == $null) { .timerUptime -i 0 60 /tuptime }
  }
  else {
    .timerUptime off
  }
  if (%netsplit_detect) {
    ; minden szerver kapcsolatra vegigmegyunk
    var %j $scon(0)
    while (%j > 0) {
      scon %j
      if ($scon(%j).$server) {
        if (!$channel(&servers)) { .timer 1 5 .join -n &servers }
      }
      scon -r
      dec %j 1
    }
  }
  else {
    ; minden szerver kapcsolatra vegigmegyunk
    var %j $scon(0)
    while (%j > 0) {
      scon %j
      if ($scon(%j).$server) {
        if ($channel(&servers)) { .timer 1 0 .part &servers }
      }
      scon -r
      dec %j 1
    }
  }
  if (%flooddetekt) {
    if ($hget(flood) == $null) { .hmake flood 100 }
  }
  else {
    if ($hget(flood) != $null) {
      .hfree flood
    }
  }

  if (%checkmail) { .autocheckmail on }
  else { .autocheckmail off }

  ; 2.103
  if (%highlight_szavak != $null) {
    %highlight_szavak2 = $replace(%highlight_szavak,$chr(32),$chr(44) $+ $chr(32))
    unset %highlight_szavak
  }
  if (%highlight_ignore_szavak != $null) {
    %highlight_ignore_szavak2 = $replace(%highlight_ignore_szavak,$chr(32),$chr(44) $+ $chr(32))
    unset %highlight_ignore_szavak
  }

  ; 2.104
  initjobs
}
;END

;RELOADSCRIPT
/reloadscript {
  .timer 1 0 .reload -a system\aliases\netzalias1.mrc
  .timer 1 0 .reload -a system\aliases\netzalias2.mrc
  .timer 1 0 .reload -a system\aliases\design.mrc
  .timer 1 0 .reload -a system\aliases\winamp.mrc
  .timer 1 0 .reload -a system\aliases\reset.mrc
  .timer 1 0 .reload -a system\aliases\mass.mrc
  .timer 1 0 .reload -a system\aliases\job.mrc
  .timer 1 0 .reload -ps system\popups.ini
  .timer 1 0 .reload -pc system\popups.ini
  .timer 1 0 .reload -pq system\popups.ini
  .timer 1 0 .reload -pn system\popups.ini
  .timer 1 0 .reload -pm system\popups.ini
  .timer 1 0 .reload -rs system\modules\main.mrc
  .timer 1 0 .reload -rs system\modules\events.mrc
  .timer 1 0 .reload -rs system\modules\mode.mrc
  .timer 1 0 .reload -rs system\modules\addons.mrc
  .timer 1 0 .reload -rs system\modules\raw.mrc
  .timer 1 0 .reload -rs system\modules\whiteboard.mrc
  .timer 1 0 .reload -rs system\modules\setupdialog.mrc
  .timer 1 0 .reload -rs system\modules\setup.mrc
  .timer 1 0 .reload -rs system\modules\update.mrc
  .timer 1 0 .reload -rs system\modules\checkmail.mrc
  .timer 1 0 .reload -rs system\modules\telnet.mrc
  .timer 1 0 .reload -rs system\modules\dl.mrc
}
;END
