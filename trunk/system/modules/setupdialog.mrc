dialog setupdialog {
  title "netZ Script Pro Setup"
  size -1 -1 339 435
  option pixels notheme
  tab "&Winamp", 1, 0 0 337 401
  tab "&Away", 2
  tab "&Flood", 33
  tab "&Design", 59
  tab "&Design2", 218
  tab "&Egy�b", 145
  tab "E&gy�b 2", 251
  tab "&Beep", 166
  tab "E&mail", 194
  tab "&Skype", 282
  box "", 252, 8 25 322 365, tab 251
  box "", 195, 8 25 322 365, tab 194
  box "", 56, 8 25 322 365, tab 33
  box "", 219, 8 25 322 365, tab 218
  box " Nick lista sz�nek ", 230, 16 134 306 160, tab 218
  box "", 169, 8 25 322 365, tab 166
  box " Priv�t �zenet �rkez�sekor ", 196, 17 34 304 106, tab 166
  box "", 146, 8 25 322 365, tab 145
  box " Timestamp ", 165, 16 340 168 41, tab 145
  box "", 5, 8 25 322 365, tab 1
  box " Kijelz�sn�l legyen: ", 13, 22 68 116 150, tab 1
  button "&OK", 3, 165 407 92 25, ok flat
  button "&M�gsem", 4, 269 407 65 25, cancel flat
  text "Sz�veg a kijelz�shez: /me", 6, 23 43 136 17, tab 1
  edit "", 7, 161 40 153 20, tab 1 result autohs
  check "cs�k", 8, 30 89 100 17, tab 1
  check "eltelt id�", 9, 30 113 100 17, tab 1
  check "�sszes id�", 10, 30 137 100 17, tab 1
  check "f�jlm�ret", 11, 30 185 100 17, tab 1
  check "f�jlt�pus", 12, 30 161 100 17, tab 1
  box " Cs�k be�ll�t�sai ", 14, 149 68 166 150, tab 1 disable
  text "Hossza (karakter):", 15, 160 88 99 17, tab 1 disable
  text "Bal keret:", 16, 160 114 53 17, tab 1 disable
  text "Jobb keret:", 17, 160 140 60 17, tab 1 disable
  text "Cs�k karakter:", 18, 160 166 74 17, tab 1 disable
  text "Poz�ci� jelz�:", 19, 160 192 71 17, tab 1 disable
  edit "", 20, 264 86 42 20, tab 1 disable autohs
  edit "", 21, 264 112 42 20, tab 1 disable autohs
  edit "", 22, 264 138 42 20, tab 1 disable autohs
  edit "", 23, 264 164 42 20, tab 1 disable autohs
  edit "", 24, 264 190 42 20, tab 1 disable autohs
  box " Automata kijelz�s ", 25, 22 231 292 147, tab 1
  check "Automata kijelz�s", 26, 30 252 111 17, tab 1
  radio "�sszes csatira", 27, 30 278 100 17, tab 1 disable
  radio "Akt�v csatira", 28, 30 299 100 17, tab 1 disable
  radio "Csak ezekre a csatikra:", 29, 30 320 136 17, tab 1 disable
  edit "", 30, 30 346 175 20, tab 1 disable autohs
  check "Titlebarban", 31, 226 252 77 17, tab 1
  box "", 32, 8 25 322 365, tab 2
  check "/me", 34, 14 40 39 17, tab 2
  edit "", 35, 59 40 260 20, tab 2 disable autohs
  check "Awaynick:", 36, 14 62 70 17, tab 2
  edit "", 37, 91 62 100 20, tab 2 disable autohs
  check "Auto away", 38, 14 85 74 17, tab 2
  edit "", 39, 96 85 30 20, tab 2 disable autohs
  text "perc ut�n", 40, 131 85 52 17, tab 2
  edit "", 42, 136 108 183 20, tab 2 disable autohs
  check "Away-backn�l: /me", 43, 14 132 115 17, tab 2
  edit "", 44, 136 132 182 20, tab 2 disable autohs
  check "Sz�veg be�r�s�ra away kikapcsol�sa", 45, 14 159 213 17, tab 2
  check "Away eset�n pager bekapcsol�sa (csak akkor enged�lyezett ha az alap pager nem akt�v)", 46, 14 183 309 30, tab 2 multi
  box " Page eset�n (/ctcp nick page) (/page nick) ", 47, 17 147 304 129, tab 166
  check "jelz�s a PC speakeren", 48, 28 231 135 17, tab 166
  check "windows beep", 49, 28 210 92 17, tab 166
  check "pager �lland�an akt�v", 51, 28 167 134 17, tab 166
  button "Away kapcsol�sa az �sszes kapcsolaton (/aaway)", 52, 35 360 271 25, tab 2
  check "Auto awayn�l: /me", 41, 14 108 115 17, tab 2 disable
  box " Away �zenetek ki�r�sa: ", 50, 17 270 303 63, tab 2
  radio "Minden csatira", 53, 28 290 93 17, tab 2
  radio "Csak ezekre:", 54, 28 308 86 17, tab 2
  edit "", 55, 136 308 182 20, tab 2 disable autohs
  check "Flood detektor", 57, 18 41 94 17, tab 33
  text "Csati �zenet:", 58, 19 82 83 17, tab 33
  text "Invite:", 60, 19 103 48 17, tab 33
  text "DCC Chat:", 61, 19 125 55 17, tab 33
  text "DCC Send:", 62, 19 147 58 17, tab 33
  text "Cycle:", 63, 19 169 35 17, tab 33
  text "Kick:", 64, 19 190 27 17, tab 33
  text "Ban:", 65, 19 214 29 17, tab 33
  text "Deop:", 66, 19 235 33 17, tab 33
  text "Nickv�lt�s:", 67, 19 256 56 17, tab 33
  text "Max", 68, 151 57 26 17, tab 33
  text "Sec.", 69, 191 57 27 17, tab 33
  text "Kick", 71, 246 57 25 17, tab 33
  text "Kickban", 72, 280 57 39 17, tab 33
  edit "", 73, 148 80 30 20, tab 33 disable autohs
  check "Oposokat ne b�ntsa", 74, 19 304 118 17, tab 33 disable
  edit "", 75, 188 80 30 20, tab 33 disable autohs
  edit "", 78, 148 101 30 20, tab 33 disable autohs
  edit "", 79, 188 101 30 20, tab 33 disable autohs
  edit "", 80, 148 123 30 20, tab 33 disable autohs
  edit "", 81, 188 123 30 20, tab 33 disable autohs
  edit "", 82, 148 146 30 20, tab 33 disable autohs
  edit "", 83, 188 146 30 20, tab 33 disable autohs
  edit "", 84, 148 167 30 20, tab 33 disable autohs
  edit "", 85, 188 167 30 20, tab 33 disable autohs
  edit "", 86, 148 188 30 20, tab 33 disable autohs
  edit "", 87, 188 188 30 20, tab 33 disable autohs
  edit "", 88, 148 211 30 20, tab 33 disable autohs
  edit "", 89, 188 211 30 20, tab 33 disable autohs
  edit "", 90, 148 234 30 20, tab 33 disable autohs
  edit "", 91, 188 234 30 20, tab 33 disable autohs
  edit "", 92, 148 255 30 20, tab 33 disable autohs
  edit "", 93, 188 255 30 20, tab 33 disable autohs
  text "/", 94, 181 81 4 17, tab 33
  text "/", 96, 181 102 4 17, tab 33
  text "/", 97, 181 125 4 17, tab 33
  text "/", 98, 181 147 4 17, tab 33
  text "/", 99, 181 168 4 17, tab 33
  text "/", 100, 181 188 4 17, tab 33
  text "/", 101, 181 211 4 17, tab 33
  text "/", 102, 181 235 4 17, tab 33
  text "/", 103, 181 256 4 17, tab 33 disable
  check "", 70, 247 81 18 17, tab 33 disable
  check "", 104, 287 81 18 17, tab 33 disable
  check "", 105, 247 168 18 17, tab 33 disable
  check "", 106, 287 168 18 17, tab 33 disable
  check "", 107, 247 189 18 17, tab 33 disable
  check "", 108, 287 189 18 17, tab 33 disable
  check "", 109, 247 212 18 17, tab 33 disable
  check "", 110, 287 212 18 17, tab 33 disable
  check "", 111, 247 235 18 17, tab 33 disable
  check "", 112, 287 235 18 17, tab 33 disable
  check "", 113, 247 256 18 17, tab 33 disable
  check "", 114, 287 256 18 17, tab 33 disable
  check "Voiceosokat ne b�ntsa", 116, 148 304 131 17, tab 33 disable
  box "", 76, 8 25 322 365, tab 59
  box " Nick kieg�sz�t�s ", 77, 16 39 306 42, tab 59
  edit "", 95, 23 56 51 20, tab 59 autohs
  text "nick", 117, 83 57 22 17, tab 59
  edit "", 118, 114 56 51 20, tab 59 autohs
  box " �zenetek ", 119, 16 85 306 114, tab 59
  box " Saj�t sz�veged ", 120, 23 101 292 44, tab 59
  edit "", 121, 31 120 51 20, tab 59 autohs
  text "nick (nick color sz�n�)", 122, 86 121 105 17, tab 59
  edit "", 123, 189 120 51 20, tab 59 autohs
  button "default", 124, 246 120 65 18, tab 59
  button "default", 125, 246 56 65 18, tab 59
  button "default", 126, 246 168 65 18, tab 59
  box " M�sok sz�vege ", 127, 23 149 292 44, tab 59
  edit "", 128, 189 168 51 20, tab 59 autohs
  text "nick (nick color sz�n�)", 129, 85 169 105 17, tab 59
  edit "", 130, 31 168 51 20, tab 59 autohs
  box " Titlebar sz�veg ", 131, 16 207 306 42, tab 59
  button "default", 132, 246 224 65 18, tab 59
  edit "", 133, 114 224 51 20, tab 59 autohs
  text "text", 134, 83 225 22 17, tab 59
  edit "", 135, 23 224 51 20, tab 59 autohs
  box " Men�k ", 136, 16 255 306 42, tab 59
  button "default", 137, 246 272 65 18, tab 59
  edit "", 138, 114 272 51 20, tab 59 autohs
  text "men�", 139, 81 273 28 17, tab 59
  edit "", 140, 23 272 51 20, tab 59 autohs
  box " Quit message ", 141, 16 303 306 76, tab 59
  check "V�letlenszer� a quit.txt-b�l", 142, 24 324 149 17, tab 59
  edit "", 143, 23 350 291 20, tab 59 autohs
  button "default", 144, 246 324 65 18, tab 59
  box " Autojoin ", 147, 16 85 306 41, tab 145
  check "Akt�v", 148, 22 103 51 17, tab 145
  edit "", 149, 74 101 241 20, tab 145 disable autohs
  box " Kedvenc csatik (F2-re bel�p) ", 150, 16 134 306 39, tab 145
  edit "", 151, 21 149 294 20, tab 145 autohs
  box " Kapcsol�d�skor... ", 152, 16 184 306 37, tab 145
  check "MOTD ki�r�s", 153, 22 200 83 17, tab 145
  check "Lusers ki�r�s", 154, 204 200 85 17, tab 145
  box " Titlebar ", 155, 16 302 306 76, tab 218
  check "Winamp kijelz�s", 156, 22 318 92 17, tab 218
  check "Internet id� kijelz�s", 157, 204 318 112 17, tab 218
  check "Lag kijelz�s", 158, 22 335 73 17, tab 218
  text "Lag detekt�l�s intervalluma:", 159, 39 355 142 17, tab 218
  edit "", 160, 204 352 31 20, tab 218 disable autohs
  text "sec.", 161, 241 355 28 17, tab 218
  box " netZ AutoUpdate ", 162, 16 229 306 38, tab 145
  check "�j verzi� keres�se ind�t�skor", 163, 22 246 177 17, tab 145
  text "Form�tum:", 167, 25 359 57 17, tab 145
  edit "", 168, 94 356 85 20, tab 145 autohs
  check "Email figyel�s", 170, 15 40 85 17, tab 194
  text "POP szerver:", 171, 55 98 68 17, tab 194
  edit "", 172, 132 96 144 20, tab 194 autohs
  edit "", 173, 132 141 100 20, tab 194 autohs
  text "Username:", 174, 55 143 58 17, tab 194
  text "Pass:", 175, 55 165 31 17, tab 194
  edit "", 176, 132 162 100 20, tab 194 pass autohs
  text "Port:", 177, 55 121 31 17, tab 194
  edit "", 178, 132 119 43 20, tab 194 autohs
  edit "", 180, 103 39 28 20, tab 194 disable autohs
  text "percenk�nt.", 181, 137 41 62 17, tab 194
  check "Beep haszn�lata email figyel�sn�l ha van �j emailed (l�sd Beep be�ll�t�sok)", 182, 15 216 307 31, tab 194 disable multi
  check "Emailez� ind�t�sa email figyel�sn�l ha j�tt email", 183, 15 260 307 17, tab 194 disable
  text "El�r�si �tja:", 184, 16 285 100 14, tab 194
  edit "", 185, 15 300 308 20, tab 194 autohs
  button "tall�z", 186, 255 284 65 16, tab 194
  box " netZ Downloader ", 164, 16 274 306 62, tab 145
  check "Akt�v ezekre:", 179, 22 290 92 17, tab 145
  edit "", 187, 112 289 201 20, tab 145 disable autohs
  edit "", 188, 112 312 139 20, tab 145 autohs
  text "Ide t�lts�n:", 189, 22 314 81 17, tab 145 right
  button "tall�z", 190, 253 313 58 17, tab 145
  box " K�sz�n�sek ", 191, 187 340 134 42, tab 145
  button "szerkeszt�s", 192, 194 356 118 21, tab 145
  check "flash:", 193, 28 55 52 17, tab 166
  edit "", 197, 88 54 109 20, tab 166 disable autohs
  check "windows beep", 198, 28 76 94 17, tab 166
  check "jelz�s PC speakeren", 199, 28 97 117 17, tab 166
  text "percen bel�l j�n �j �zenet, nem villog/beepel", 200, 98 117 221 16, tab 166
  edit "", 201, 54 115 34 20, tab 166 autohs
  text "Ha", 202, 28 117 18 17, tab 166
  check "beep csak akkor ha sz�l a winamp", 203, 124 76 186 17, tab 166 disable
  check "beep csak akkor ha sz�l a winamp", 204, 124 210 184 17, tab 166 disable
  check "flash:", 205, 28 189 52 17, tab 166 disable
  edit "", 206, 88 189 109 20, tab 166 disable autohs
  text "Ha", 207, 28 253 18 17, tab 166
  edit "", 208, 54 251 34 20, tab 166 disable autohs
  text "percen bel�l j�n �j page, nem villog/beepel", 209, 98 253 211 16, tab 166
  box " Email �rkez�sekor ", 210, 17 282 304 86, tab 166
  check "flash:", 211, 28 303 52 17, tab 166 disable
  edit "", 212, 88 302 109 20, tab 166 disable autohs
  check "windows beep", 213, 28 324 94 17, tab 166 disable
  check "beep csak akkor ha sz�l a winamp", 214, 124 324 186 17, tab 166 disable
  check "jelz�s PC speakeren", 215, 28 345 117 17, tab 166 disable
  check "Highlightkor is", 216, 220 49 88 17, tab 166
  box "", 217, 210 39 106 31, tab 166
  box " Ablak nev�nek ki�r�sa a h�tt�rbe ", 220, 16 43 306 82, tab 218
  check "Akt�v", 221, 25 60 53 17, tab 218
  text "Font:", 222, 26 80 31 17, tab 218
  edit "", 223, 60 77 167 20, tab 218 disable autohs
  text "M�ret:", 224, 240 80 37 17, tab 218
  edit "", 225, 280 77 32 20, tab 218 disable autohs
  text "Sz�n (pl. 80,80,80):", 226, 26 103 103 17, tab 218
  edit "", 227, 138 100 89 20, tab 218 disable autohs
  box " Sz�nt�ma v�lt�s ", 228, 208 247 109 42, tab 218
  button "eredeti", 229, 216 264 92 18, tab 218
  text "Alap sz�n (0 perc idle):", 231, 25 174 119 17, tab 218
  check "Idle id� alap� sz�nez�s haszn�lata", 232, 25 150 194 17, tab 218
  edit "", 233, 151 173 32 20, tab 218 autohs
  text "10 perc idle:", 234, 25 198 76 17, tab 218
  text "20 perc idle:", 235, 25 222 76 17, tab 218
  text "40 perc idle:", 236, 25 247 76 17, tab 218
  edit "", 238, 151 197 32 18, tab 218 disable autohs
  edit "", 239, 151 221 32 20, tab 218 disable autohs
  edit "", 240, 151 245 32 20, tab 218 disable autohs
  edit "", 241, 151 269 32 20, tab 218 disable autohs
  box " Autoconnect ", 242, 16 37 306 41, tab 145
  check "Akt�v", 243, 22 55 50 17, tab 145
  edit "", 244, 74 53 241 20, tab 145 disable autohs
  check "60 perc idle:", 237, 25 271 100 17, tab 218 disable
  check "Lag kijelz�s cs�kkal", 245, 204 335 114 17, tab 218 disable
  text "A script az auto-away id�t a rendszer idle idej�b�l sz�molja, teh�t ha nem mozgatod az egeret 20 percig, akkor fog bekapcsolni az auto-away (�rtelemszer�en ha 20 percre van �ll�tva)", 246, 15 218 310 53, tab 2
  check "CTCP v�delem", 247, 19 280 92 17, tab 33 disable
  edit "", 248, 148 278 30 20, tab 33 disable autohs
  text "/", 249, 181 279 4 17, tab 33 disable
  edit "", 250, 188 278 30 20, tab 33 disable autohs
  box " Log bem�sol�sa �j query ablak nyit�sakor ", 253, 15 33 308 40, tab 251
  check "Akt�v", 254, 22 50 55 17, tab 251
  text "Sorok:", 255, 229 51 37 17, tab 251
  edit "", 256, 268 48 42 20, tab 251 disable
  check "F10 az �sszes kapcsolaton kapcsolja az awayt", 257, 14 338 276 17, tab 2
  box " URL-ek kiemel�se ", 258, 15 75 308 38, tab 251
  check "Akt�v", 259, 22 91 51 17, tab 251
  text "St�lus:", 260, 126 92 41 17, tab 251
  edit "", 261, 174 89 42 20, tab 251 autohs
  text "+http:// v. ftp://", 262, 226 91 86 17, tab 251
  box " Highlight ", 263, 15 116 308 128, tab 251
  text "A nickeden k�v�l a k�vetkez� sz�r�szletekre aktiv�l�djon (spaceszel elv�lasztva):", 264, 23 133 282 26, tab 251
  edit "", 265, 24 163 290 20, tab 251 autohs
  box " Uptime m�r�s ", 266, 16 247 308 60, tab 251
  check "Akt�v", 267, 22 264 50 17, tab 251
  check "Nagyobb id�kn�l figyelmeztet�s", 268, 129 264 177 17, tab 251 disable
  check "�j rekordn�l figyelmeztet�s", 269, 129 285 162 17, tab 251 disable
  box " Netsplit figyel�s ", 270, 15 309 308 40, tab 251
  check "Akt�v", 271, 22 327 53 17, tab 251
  check "Csak a magyar szervereket figyelje", 272, 129 327 188 17, tab 251
  check "Az awaynick az �ppen akt�v nick kisbet�s v�ltozata legyen", 273, 196 62 127 41, tab 2 disable multi
  check "Flood detekt csak ezeken a csatikon:", 274, 19 343 202 17, tab 33 disable
  edit "", 115, 19 362 302 20, tab 33 disable autohs
  check "SSL haszn�lata", 275, 181 120 100 17, tab 194
  check "GMail", 276, 132 78 51 17, tab 194 multi
  button "Be�ll�t�sok ellen�rz�se", 277, 97 348 145 25, tab 194
  button "cookie t�rl�se", 278, 182 78 93 18, tab 194 hide
  check "Emailez� ind�t�sa ut�n a checkmail sz�ml�l�j�nak null�z�sa", 279, 15 323 307 17, tab 194
  text "Ezeket a szavakat tartalmaz� sorokat figyelmen k�v�l hagyja:", 281, 23 187 282 26, tab 251
  edit "", 280, 24 219 290 20, tab 251 autohs
  box "", 283, 8 25 322 365, tab 282
  check "Skype haszn�lat", 284, 19 40 115 17, tab 282
  box " Away ", 285, 18 61 302 126, tab 282
  check "Away kijelz�s", 286, 27 82 87 17, tab 282
  text "Sz�veg:", 287, 27 106 47 17, tab 282
  edit "", 288, 77 104 100 20, tab 282 autohs
  check "Awaymessage ki�r�sa", 289, 185 105 129 17, tab 282
  check "Ha awaybe megy�nk, a Skype is menjen", 290, 27 137 276 17, tab 282
  text "Skype away m�d:", 291, 27 161 91 17, tab 282
  combo 292, 125 157 100 70, tab 282 drop
  box " Winamp kijelz�s ", 293, 18 189 302 71, tab 282
  check "Winamp kijelz�s haszn�lata", 294, 27 210 152 17, tab 282
  edit "", 295, 77 232 100 20, tab 282 autohs
  text "Sz�veg:", 296, 27 234 47 17, tab 282
  text "Elv�laszt� karakter:", 297, 187 42 101 17, tab 282
  edit "", 298, 291 39 24 20, tab 282 autohs
  edit "A Skype haszn�lat enged�lyez�se ut�n a Skype meg fogja k�rdezni, hogy enged�lyezed-e a mirc.exe-nek, hogy el�rje �t. ha itt v�letlen�l az elutas�t�sra nyomt�l, a Skype be�ll�t�sainak Advanced -> Advanced settings -> Manage other programs' access to Skype men�pontn�l tudod �jra enged�lyezni a mircet.", 299, 19 333 302 51, tab 282 read multi vsbar
  check "Hossz kijelz�s", 301, 211 210 100 17, tab 282
  check "Bitr�ta kijelz�s", 302, 211 234 100 17, tab 282
  box " Ki�r�sok a winamp kijelz�s el�tt �s ut�n ", 300, 18 263 302 65, tab 282
  edit "", 303, 24 280 290 20, tab 282 autohs
  edit "", 304, 24 304 290 20, tab 282 autohs
}
