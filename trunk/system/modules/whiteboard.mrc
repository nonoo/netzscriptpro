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

;WHITEBOARD.MRC - WhiteBoard v3.0 Script

;WHITEBOARD
alias WhiteboardVersion return 3.0
alias WhiteboardVersionBase return 3.0
alias wbProtocolVersion return 1.2
on 1:start {
  if ($wbSetting(Status) = $null) { whiteboard -on }
  wbCheckState
  if (none = $mSetting(Global,ShowGreeting,whiteboard)) { return }
}
alias GetNextWin {
  .timer 1 0 window -r $active
  window -h $active
  if (@Whiteboard: = $left($active,12)) { return $active }
  else { beep | halt }
}

alias txtSockErr {
  if ($sockerr = 3) { return 4 Hiba a kapcsolódás során! }
  elseif ($sockerr = 4) { return 4 Hiba a kapcsolódás során! }
  elseif ($sockerr > 0) { return 4 Socket hiba: $sockerr }
  else { return $1- }
}

alias wbSetting {
  set %tmpSetting $readini(system\whiteboard.ini,-n,Whiteboard,$1)
  if (%tmpSetting = $null) { return $2- }
  else { return %tmpSetting }
  /unset %tmpSetting
}

alias whiteboard {
  if ($1 = -on) || ($1 = -off) || ($1 = -auto) {
    writeini system\whiteboard.ini Whiteboard Status $1
    wbCheckState
    return 
  }
  set %tempWbWin $iif($2 = $null,Main,$2)
  if ($window( [ @Whiteboard: $+ [ %tempWbWin ] ] ) != $null) { window -a @Whiteboard: $+ %tempWbWin }
  else {
    set %wbColour $rgb(0,0,0)
    .disable #wbGetAddress #wbDropper #wbPaintbrush #wbDots #wbLine #wbRectangle #wbFilled #wbCircle #wbFill #wbText #wbPicture
    wbToolbar
    window -kapef +tsnxe @Whiteboard: $+ %tempWbWin 0 35 600 250 @wbTool
    wbClear @Whiteboard: $+ %tempWbWin
  }  
  wbCheckState %tempWbWin
  if ($1 != $null) && ($1 != -l) {
    titlebar @Whiteboard: $+ %tempWbWin $window( [ @Whiteboard: $+ [ %tempWbWin ] ] ).title - Kapcsolódás: $1
    if (. isin $1) { set -u2 %tempHost $1 }
    else { set -u2 %tempHost $ial( [ $1 $+ !*@* ] ,1).host }
    if (%tempHost != $null) { sockopen wbDraw: $+ %tempWbWin $+ : $+ %tempHost %tempHost 831 }
    else { .enable #wbGetAddress | set %wbTempWin %tempWbWin | .quote userhost $1 }
  }
  unset %tempWbWin
}
#wbGetAddress off
raw 302:* {
  set %tempHost $gettok($2,2,64)
  if (%tempHost = $null) { echo $colour(info) -is * Whiteboard: nem lehet kapcsolódni! | halt }
  titlebar @Whiteboard: $+ %wbTempWin $window( [ @Whiteboard: $+ [ %wbTempWin ] ] ).title - Kapcsolódás: %tempHost
  if ($sock( [ wbDraw: $+ [ %wbTempWin ] $+ : $+ [ %tempHost ] ] ) = $null) { sockopen wbDraw: $+ %wbTempWin $+ : $+ %tempHost %tempHost 831 }
  unset %wbTempWin
  .disable #wbGetAddress
  halt
}
#wbGetAddress end
alias wbToolbar {
  window -kfp +d @Whiteboard-Toolbar 0 0 $window(-1).w 35 @wbToolbar
  drawfill -rn @Whiteboard-Toolbar $rgb(face) 595013 3 3
  drawpic -ntc @Whiteboard-Toolbar $rgb(204,204,204) 0 0 0 0 660 35 system\img\whiteboard.bmp
  drawline -rn @Whiteboard-Toolbar $rgb(hilight) 1 0 0 $window(-1).w 0
  drawline -rn @Whiteboard-Toolbar $rgb(shadow) 1 0 34 $window(-1).w 34
  wbToolDiv 120
  wbToolDiv 155
  wbToolDiv 393
  wbToolDiv 415
  wbToolBox 420 443
  wbToolBox 445 542
  wbToolBox 544 637
  wbToolbarBtnPress 159 #wbPaintbrush
  wbToolbarLinePress 397 2 16 7 1
  drawdot @Whiteboard-Toolbar
}

alias -l wbToolDiv {
  drawline -rn @Whiteboard-Toolbar $rgb(shadow) 1 $1 6 $1 29
  drawline -rn @Whiteboard-Toolbar $rgb(hilight) 1 $calc($1 + 1) 6 $calc($1 + 1) 29
}

alias -l wbToolBox {
  drawline -rn @Whiteboard-Toolbar $rgb(shadow) 1 $1 2 $1 32
  drawline -rn @Whiteboard-Toolbar $rgb(shadow) 1 $1 2 $2 2
  drawline -rn @Whiteboard-Toolbar $rgb(hilight) 1 $1 32 $calc($2 + 1) 32
  drawline -rn @Whiteboard-Toolbar $rgb(hilight) 1 $2 2 $2 32
}


menu @wbToolbar {
  sclick {
    if $inrect($mouse.x,$mouse.y,2,3,28,28) { wbDo wbClear $GetNextWin }
    elseif $inrect($mouse.x,$mouse.y,31,3,28,28) { whiteboard $$?="Kihez kapcsolódjak?:" $gettok($GetNextWin,2,58) }
    elseif $inrect($mouse.x,$mouse.y,60,3,28,28) { wbFileOpen $GetNextWin }
    elseif $inrect($mouse.x,$mouse.y,89,3,28,28) { wbFileSaveAs $GetNextWin }
    elseif $inrect($mouse.x,$mouse.y,124,3,28,28) { wbDo wbUndo $GetNextWin }
    if $inrect($mouse.x,$mouse.y,159,3,28,28) { wbToolbarBtnPress 159 #wbPaintbrush }
    if $inrect($mouse.x,$mouse.y,188,3,28,28) { wbToolbarBtnPress 188 #wbLine }
    if $inrect($mouse.x,$mouse.y,217,3,28,28) { wbToolbarBtnPress 217 #wbDots }
    if $inrect($mouse.x,$mouse.y,246,3,28,28) { wbToolbarBtnPress 246 #wbRectangle #wbFilled }
    if $inrect($mouse.x,$mouse.y,275,3,28,28) { wbToolbarBtnPress 275 #wbCircle }
    if $inrect($mouse.x,$mouse.y,304,3,28,28) { wbToolbarBtnPress 304 #wbText }
    if $inrect($mouse.x,$mouse.y,333,3,28,28) { wbToolbarBtnPress 333 #wbFill }
    if $inrect($mouse.x,$mouse.y,362,3,28,28) { wbToolbarBtnPress 362 #wbPicture }
    if $inrect($mouse.x,$mouse.y,397,2,15,6) { wbToolbarLinePress 397 2 16 7 1 }
    if $inrect($mouse.x,$mouse.y,397,9,15,6) { wbToolbarLinePress 397 9 16 7 2 }
    if $inrect($mouse.x,$mouse.y,397,16,15,7) { wbToolbarLinePress 397 16 16 8 3 }
    if $inrect($mouse.x,$mouse.y,397,24,15,8) { wbToolbarLinePress 397 24 16 9 5 }
    if $inrect($mouse.x,$mouse.y,447,4,94,27) || $inrect($mouse.x,$mouse.y,546,4,90,27) { set %wbColour $getdot(@Whiteboard-Toolbar,$mouse.x,$mouse.y) | drawrect -fr @Whiteboard-Toolbar %wbColour 0 425 7 13 20 }
    if $inrect($mouse.x,$mouse.y,639,2,16,16) { wbToolbarDropperPress 639 2 18 18 | .timer -m 1 1 window -a $GetNextWin }
    if $inrect($mouse.x,$mouse.y,639,19,16,13) { whiteboardInfo }
  }
  mouse {
    if $inrect($mouse.x,$mouse.y,447,4,94,27) || $inrect($mouse.x,$mouse.y,546,4,90,27) { drawrect -fr @Whiteboard-Toolbar $getdot(@Whiteboard-Toolbar,$mouse.x,$mouse.y) 0 425 12 13 10 }
  }
  leave { drawrect -fr @Whiteboard-Toolbar %wbColour 0 425 7 13 20 }
  $wbRclick:return
}

alias -l wbRclick {
  if $inrect($mouse.x,$mouse.y,447,4,94,27) || $inrect($mouse.x,$mouse.y,546,4,90,27) || ($left($active,12) = @Whiteboard:) { set %wbColour2 $getdot(@Whiteboard-Toolbar,$mouse.x,$mouse.y) | drawrect -fr @Whiteboard-Toolbar %wbColour2 0 421 3 21 28 | drawrect -fr @Whiteboard-Toolbar %wbColour 0 425 7 13 20 }
}

alias wbToolbarBtnPress {
  if ($2 = #wbRectangle) && ($group($2) = on) {
    .disable %wbTool
    .enable $3
    set %wbTool $3
    drawrect -rf @Whiteboard-Toolbar $getdot($active,250,10) 0 251 8 18 18
    return
  }
  if (%wbTool != $null) { .disable %wbTool }
  .enable $2
  set %wbTool $2
  if (%wbBtnPressed != $null) { wbToolbarReset %wbBtnPressed 3 29 29 }
  drawpic -tc @Whiteboard-Toolbar $rgb(204,204,204) $1 3 1199 3 29 29 system\img\whiteboard.bmp
  drawpic -tc @Whiteboard-Toolbar $rgb(204,204,204) $1 3 $1 3 29 29 system\img\whiteboard.bmp
  if ($3 != $null) { drawpic -tc @Whiteboard-Toolbar $rgb(204,204,204) $1 3 1228 3 28 28 system\img\whiteboard.bmp }
  set %wbBtnPressed $1 3 28 28
}
alias wbToolbarLinePress {
  if (%wbLinePressed != $null) { wbToolbarReset %wbLinePressed }
  drawpic -tc @Whiteboard-Toolbar $rgb(204,204,204) $1 $2 1257 $2 16 $4 system\img\whiteboard.bmp
  drawpic -tc @Whiteboard-Toolbar $rgb(204,204,204) $1 $2 $1 $2 $3 $4 system\img\whiteboard.bmp
  set %wbWidth $5
  set %wbLinePressed $1-
}
alias wbToolbarDropperPress {
  drawpic -tc @Whiteboard-Toolbar $rgb(204,204,204) $1 2 1273 2 17 17 system\img\whiteboard.bmp
  drawpic -tc @Whiteboard-Toolbar $rgb(204,204,204) $1 $2 $1 $2 $3 $4 system\img\whiteboard.bmp
  .enable #wbDropper
}
alias wbToolbarReset {
  drawrect -fr @Whiteboard-Toolbar $rgb(face) 0 $1-
  drawpic -tc @Whiteboard-Toolbar $rgb(204,204,204) $1 $2 $1 $2 $3 $4 system\img\whiteboard.bmp
}
alias wbClear {
  if ($left($1,12) != @Whiteboard:) { return }
  wbSaveUndo $1
  clear $1
  drawfill -r $1 $rgb(255,255,255) $rgb(3,20,100) 2 2
}
alias wbFileOpen {
  if ($2 = $null) { set -u0 %tmpFile $dir="Megnyitás" c:\ }
  else { set -u0 %tmpFile $2- }
  if (%tmpFile = $null) { return }
  wbClear $1
  if ($exists( [ $wbSetting(GraphicsFolder) $+ [ $gettok(%tmpFile,$gettok(%tmpFile,0,92),92) ] ] ) = $false) { copy %tmpFile $wbSetting(GraphicsFolder) }
  drawpic -h $1 0 0 %tmpFile
  if ($sock(wbDraw*,0) > 0) {
    sockwrite -n wbDraw* wbClear $1
    sockwrite -n wbDraw* drawpic -h $1 0 0 $gettok(%tmpFile,$gettok(%tmpFile,0,92),92)
  }
}
alias wbFileSaveAs {
  set -u0 %tmpFile $iif($2 = $null, [ $dir="Mentés másként..." c:\ ] ,$2-)
  if (%tmpFile != $null) { drawsave $1 %tmpFile }
}
alias wbUndo {
  if ($left($1,12) != @Whiteboard:) { return }
  clear $1
  drawcopy @WhiteboardUndo: $+ [ $gettok($1,2,58) ] 0 0 $window(-1).w $window(-1).h $1 0 0
}
alias wbSaveUndo {
  window -kph @WhiteboardUndo: $+ [ $gettok($1,2,58) ] 0 0 $window(-1).w $window(-1).h
  drawcopy $1 0 0 $window(-1).w $window(-1).h @WhiteboardUndo: $+ [ $gettok($1,2,58) ] 0 0
}
#wbDropper off
menu @wbTool {
  mouse:drawrect -fr @Whiteboard-Toolbar $getdot($active,$mouse.x,$mouse.y) 0 425 12 13 10
  sclick {
    set %wbColour $getdot($active,$mouse.x,$mouse.y)
    drawrect -fr @Whiteboard-Toolbar %wbColour 0 425 7 13 20
    .disable #wbDropper
    wbToolbarReset 639 2 16 16
  }
  $wbRclick:return
}
#wbDropper end
#wbPaintbrush off
menu @wbTool {
  mouse {
    if ($mouse.key = 1) {
      wbDo drawline -hr $active %wbColour %wbWidth %wbLastX %wbLastY $mouse.x $mouse.y
      set %wbLastX $mouse.x
      set %wbLastY $mouse.y
    }
    else { unset %wbLastX %wbLastY }
  }
  sclick {
    wbDo wbSaveUndo $active
    wbDo drawline -hr $active %wbColour %wbWidth $mouse.x $mouse.y $mouse.x $mouse.y
    set %wbLastX $mouse.x
    set %wbLastY $mouse.y
  }
}
#wbPaintbrush end
#wbDots off
menu @wbTool {
  mouse {
    if ($mouse.key = 1) && ($rand(0,3) = 1) {
      wbDo drawdot -hr $active %wbColour %wbWidth $mouse.x $mouse.y
    }
  }
  sclick {
    wbDo wbSaveUndo $active
    wbDo drawdot -hr $active %wbColour %wbWidth $mouse.x $mouse.y
  }
}
#wbDots end
#wbLine off
menu @wbTool {
  mouse {
    if ($mouse.key = 1) && (%wbOriginX != $null) {
      drawline -i $active 1 %wbWidth %wbOriginX %wbOriginY %wbLastX %wbLastY
      drawline -i $active 1 %wbWidth %wbOriginX %wbOriginY $mouse.x $mouse.y
      set %wbLastX $mouse.x
      set %wbLastY $mouse.y
    }
    elseif (%wbOriginX != $null) {
      drawline -i $active 1 %wbWidth %wbOriginX %wbOriginY %wbLastX %wbLastY
      unset %wbOriginX %wbOriginY %wbLastX %wbLastY
    }
  }
  sclick {
    wbDo wbSaveUndo $active
    set %wbOriginX $mouse.x
    set %wbOriginY $mouse.y
    set %wbLastX $mouse.x
    set %wbLastY $mouse.y
    drawline -i $active 1 %wbWidth %wbOriginX %wbOriginY %wbLastX %wbLastY
  }
  drop {
    if (%wbOriginX != $null) {
      drawline -i $active 1 %wbWidth %wbOriginX %wbOriginY %wbLastX %wbLastY
      wbDo drawline -hr $active %wbColour %wbWidth %wbOriginX %wbOriginY $mouse.x $mouse.y
      unset %wbOriginX %wbOriginY %wbLastX %wbLastY
    }
  }
}
#wbLine end
#wbRectangle off
menu @wbTool {
  mouse {
    if ($mouse.key = 1) {
      drawrect -i $active 1 %wbWidth %wbOriginX %wbOriginY $calc(%wbLastX - %wbOriginX) $calc(%wbLastY - %wbOriginY)
      drawrect -i $active 1 %wbWidth %wbOriginX %wbOriginY $calc($mouse.x - %wbOriginX) $calc($mouse.y - %wbOriginY)
      set %wbLastX $mouse.x
      set %wbLastY $mouse.y
    }
    elseif (%wbOriginX != $null) {
      drawrect -i $active 1 %wbWidth %wbOriginX %wbOriginY $calc(%wbLastX - %wbOriginX) $calc(%wbLastY - %wbOriginY)
      unset %wbOriginX %wbOriginY %wbLastX %wbLastY
    }
  }
  sclick {
    wbDo wbSaveUndo $active
    set %wbOriginX $mouse.x
    set %wbOriginY $mouse.y
    set %wbLastX $mouse.x
    set %wbLastY $mouse.y
    drawrect -i $active 1 %wbWidth %wbOriginX %wbOriginY $calc(%wbLastX - %wbOriginX) $calc(%wbLastY - %wbOriginY)
  }
  drop {
    drawrect -i $active 1 %wbWidth %wbOriginX %wbOriginY $calc(%wbLastX - %wbOriginX) $calc(%wbLastY - %wbOriginY)
    wbDo drawrect -hr $active %wbColour %wbWidth %wbOriginX %wbOriginY $calc($mouse.x - %wbOriginX) $calc($mouse.y - %wbOriginY)
    unset %wbOriginX %wbOriginY %wbLastX %wbLastY
  }
}
#wbRectangle end
#wbFilled off
menu @wbTool {
  mouse {
    if ($mouse.key = 1) {
      drawrect -if $active 1 %wbWidth %wbOriginX %wbOriginY $calc(%wbLastX - %wbOriginX) $calc(%wbLastY - %wbOriginY)
      drawrect -if $active 1 %wbWidth %wbOriginX %wbOriginY $calc($mouse.x - %wbOriginX) $calc($mouse.y - %wbOriginY)
      set %wbLastX $mouse.x
      set %wbLastY $mouse.y
    }
    elseif (%wbOriginX != $null) {
      drawrect -if $active 1 %wbWidth %wbOriginX %wbOriginY $calc(%wbLastX - %wbOriginX) $calc(%wbLastY - %wbOriginY)
      unset %wbOriginX %wbOriginY %wbLastX %wbLastY
    }
  }
  sclick {
    wbDo wbSaveUndo $active
    set %wbOriginX $mouse.x
    set %wbOriginY $mouse.y
    set %wbLastX $mouse.x
    set %wbLastY $mouse.y
    drawrect -if $active 1 %wbWidth %wbOriginX %wbOriginY $calc(%wbLastX - %wbOriginX) $calc(%wbLastY - %wbOriginY)
  }
  drop {
    drawrect -if $active 1 %wbWidth %wbOriginX %wbOriginY $calc(%wbLastX - %wbOriginX) $calc(%wbLastY - %wbOriginY)
    wbDo drawrect -hrf $active %wbColour %wbWidth %wbOriginX %wbOriginY $calc($mouse.x - %wbOriginX) $calc($mouse.y - %wbOriginY)
    unset %wbOriginX %wbOriginY %wbLastX %wbLastY
  }
}
#wbFilled end
#wbCircle off
menu @wbTool {
  mouse {
    if ($mouse.key = 1) {
      drawrect -ie $active 1 %wbWidth %wbOriginX %wbOriginY $calc(%wbLastX - %wbOriginX) $calc(%wbLastY - %wbOriginY)
      drawrect -ie $active 1 %wbWidth %wbOriginX %wbOriginY $calc($mouse.x - %wbOriginX) $calc($mouse.y - %wbOriginY)
      set %wbLastX $mouse.x
      set %wbLastY $mouse.y
    }
    elseif (%wbOriginX != $null) {
      drawrect -ie $active 1 %wbWidth %wbOriginX %wbOriginY $calc(%wbLastX - %wbOriginX) $calc(%wbLastY - %wbOriginY)
      unset %wbOriginX %wbOriginY %wbLastX %wbLastY
    }
  }
  sclick {
    wbDo wbSaveUndo $active
    set %wbOriginX $mouse.x
    set %wbOriginY $mouse.y
    set %wbLastX $mouse.x
    set %wbLastY $mouse.y
    drawrect -ie $active 1 %wbWidth %wbOriginX %wbOriginY $calc(%wbLastX - %wbOriginX) $calc(%wbLastY - %wbOriginY)
  }
  drop {
    drawrect -ie $active 1 %wbWidth %wbOriginX %wbOriginY $calc(%wbLastX - %wbOriginX) $calc(%wbLastY - %wbOriginY)
    wbDo drawrect -hre $active %wbColour %wbWidth %wbOriginX %wbOriginY $calc($mouse.x - %wbOriginX) $calc($mouse.y - %wbOriginY)
    unset %wbOriginX %wbOriginY %wbLastX %wbLastY
  }
}
#wbCircle end
#wbFill off
menu @wbTool {
  sclick {
    wbDo wbSaveUndo $active
    wbDo drawfill -hrs $active %wbColour $getdot($active,$mouse.x,$mouse.y) $mouse.x $mouse.y
  }
}
#wbFill end
#wbText on
menu @wbTool {
  sclick {
    wbDo wbSaveUndo $active
    wbDo drawtext -hro $active %wbColour Arial $$?="Mekkora legyen a szöveg? (Pl. 12)" $mouse.x $mouse.y $$?="Nyomasd ide a dumát:"
  }
}
#wbText end
#wbPicture off
menu @wbTool {
  sclick {
    wbDo wbSaveUndo $active
    set %tmppos $mouse.x $mouse.y
    set %tempFile $$dir="Kép mentése..." $wbSetting(GraphicsFolder) $+ [ \*.bmp ]
    if ($exists( [ $wbSetting(GraphicsFolder) $+ [ $gettok(%tempFile,$gettok(%tempFile,0,92),92) ] ] ) = $false) { copy %tempFile $wbSetting(GraphicsFolder) }
    drawpic -h $active %tmppos %tempFile
    if ($sock(wbDraw*,0) > 0) { sockwrite -n wbDraw* drawpic -h $active %tmppos $gettok(%tempFile,$gettok(%tempFile,0,92),92) }
    unset %tempFile %c %tmppos
  }
}
#wbPicture end
alias wbCheckState {
  if ($window(@Whiteboard:*,0) = 0) { window -c @Whiteboard-Toolbar }
  if ($wbSetting(Status) = -off) || (($wbSetting(Status) = -auto) && ($window(@Whiteboard-Toolbar) = $null)) { sockclose wbListen }
  elseif ($portfree(831)) { socklisten wbListen 831 }
  wbInfoRefresh $1
}
on 1:socklisten:wbListen {
  set -u2 %tmps wbLogon $+ $ticks
  sockaccept %tmps
  set -u8 %wbRequests $+ $sock(%tmps).ip $calc( [ %wbRequests [ $+ [ $sock(%tmps).ip ] ] ] + 1)
  if ( [ %wbRequests [ $+ [ $sock(%tmps).ip ] ] ] > 3) { echo $colour(info) -is *** Flood! ->  $sock(%tmps).ip | sockclose %tmps | sockclose wbListen | .timer -o 1 60 wbCheckState }
}
on 1:sockopen:wbDraw* {
  .timer 1 1 wbInfoRefresh $gettok($sockname,2,58)
  echo $colour(info) -s *** Whiteboard $txtsockerr(connected to [ $sock($sockname).ip ] )
  if ($sockerr > 0) { return }
  sockwrite -n $sockname WHITEBOARD $wbProtocolVersion [ [ [ $host ] ] ] [ [ [ $me ] ] ] $gettok($sockname,2,58)
  if ($gettok($sockname,$gettok($sockname,0,46),46) !isnum) { sockrename $sockname $gettok($sockname,1-2,58) $+ : $+ $sock($sockname).ip }
}
on 1:sockread:wbLogon* {
  sockread %temp
  set %1 $gettok(%temp,1,32)  
  if (%1 = WHITEBOARD) {
    sockwrite -n $sockname WHITEBOARD $wbProtocolVersion [ [ [ $host ] ] ] [ [ [ $me ] ] ] <unknown>
    if ($sock( [ wbDraw: $+ [ $gettok(%temp,5,32) $] + : $+ [ $sock($sockname).ip ] ] ) != $null) { sockclose $sockname }
    set %tc $sock( [ wbDraw: $+ [ $gettok(%temp,5,32) ] $+ :* ] ,0)
    :nxtC
    if (%tc = 0) { goto cont }
    set %tempIP $sock( [ wbDraw: $+ [ $gettok(%temp,5,32) ] $+ :* ] ,%tc).ip
    if (%tempIP != $sock($sockname).ip) { sockwrite -n $sockname WhiteboardConnectedTo %tempIP }
    dec %tc
    goto nxtC
    :cont
    unset %tc %tempIP
    if ($window( [ @Whiteboard: $+ [ $gettok(%temp,5,32) ] ] ) = $null) {
      if ($wbSetting(Status) = -on) { whiteboard -l $gettok(%temp,5,32) }
      else { sockclose $sockname | halt }
    }
    echo $colour(info) -is *** Whiteboard ' $+ $gettok(%temp,5,32) $+ ' - Kapcsolódva a következõ géppel: $sock($sockname).ip  -  $gettok(%temp,4,32)
    sockmark $sockname $gettok(%temp,4,32)
    if ($gettok($gettok(%temp,2,32),1,46) != $gettok($wbProtocolVersion,1,46)) {
      echo $colour(info) -is *** $gettok(%temp,4,32) más verziójú Whiteboardot használ! A verzióknak egyezniük kell, úgyhogy szólj neki hogy töltse le õ is a netZ Script Pro-t! (http://netz.nonoo.hu)
      sockclose $sockname
      return
    }
    elseif ($gettok(%temp,2,32) != $wbProtocolVersion) {
      echo $colour(info) -is *** $gettok(%temp,4,32) más verziójú Whiteboardot használ! A verzióknak egyezniük kell, úgyhogy szólj neki hogy töltse le õ is a netZ Script Pro-t! (http://netz.nonoo.hu)
    }
    sockrename $sockname wbDraw: $+ $gettok(%temp,5,32) $+ : $+ $sock($sockname).ip
    wbInfoRefresh $gettok(%temp,5,32)
  }
  elseif (%1 = WhiteboardGetPic) {
    sockmark $sockname $wbSetting(GraphicsFolder) $+ $gettok(%temp,2-,32)
    bread $sock($sockname).mark 0 4096 &temp
    sockwrite $sockname &temp
    sockrename $sockname wbSendPic $+ $ticks $+ \ $+ $lof($sock($sockname).mark)
    wbInfoRefresh
  }
  else {
    echo $colour(info) -is *** Nem lehet kapcsolódni! ( $+ $sock($sockname).ip $+ )
    sockclose $sockname
  }
}

on 1:sockread:wbDraw* {
  sockread %temp
  set %1 $gettok(%temp,1,32)  
  if ((%1 = drawdot) || (%1 = drawline) || (%1 = drawrect) || (%1 = drawfill) || (%1 = drawtext) || (%1 = drawscroll) || (%1 = drawcopy)) && ($window($gettok(%temp,3,32)) != $null) && ($left($gettok(%temp,3,32),12) = @Whiteboard:) {
    %temp
    return
  }
  elseif (((%1 = wbSaveUndo) || (%1 = wbUndo) || (%1 = clear) || (%1 = wbClear)) && ($window($gettok(%temp,2,32)) != $null) && ($left($gettok(%temp,2,32),12) = @Whiteboard:)) {
    %temp
  }
  elseif (%1 = drawpic) {
    if ($exists( [ $wbSetting(GraphicsFolder) $+ [ $gettok(%temp,6-,32) ] ] )) { $gettok(%temp,1-5,32) $wbSetting(GraphicsFolder) $+ $gettok(%temp,6-,32) }
    else {
      set -u2 %tempSock wbGetPic $+ $ticks
      sockopen %tempSock $sock($sockname).ip 831
      sockmark %tempSock %temp
    }
  }
  elseif (%1 = WhiteboardMessage) {
    wbChatWindow $gettok($sockname,2,58)
    echo -i2 @Whiteboard-Chat: $+ $gettok($sockname,2,58) < $+ $sock($sockname).mark $+ > $gettok(%temp,2-,32)
  }
  elseif (%1 = WhiteboardAction) {
    wbChatWindow $gettok($sockname,2,58)
    echo $colour(action) -i2 @Whiteboard-Chat: $+ $gettok($sockname,2,58) * $sock($sockname).mark $gettok(%temp,2-,32)
  }
  elseif (%1 = WhiteboardConnectedTo) {
    if ($sock( [ wbDraw: $+ [ $gettok($sockname,2,58) ] $+ : $+ [ $gettok(%temp,2,32) ] ] ) = $null) { echo $colour(info) -is *** $sock($sockname).mark has another participant on this whiteboard, $gettok(%temp,2,32) $+ . Connecting there now... | whiteboard $gettok(%temp,2,32) $gettok($sockname,2,58) }
  }
  elseif (%1 = WHITEBOARD) {
    echo $colour(info) -is *** Whiteboard ' $+ $gettok($sockname,2,58) $+ ' - Kapcsolódás: $sock($sockname).ip ( $+ $gettok(%temp,3,32) $+ ) - $gettok(%temp,4,32)
    sockmark $sockname $gettok(%temp,4,32)
    wbInfoRefresh $gettok($sockname,2,58)
  }
}

alias wbDo {
  if ($sock( [ wbDraw: $+ [ $gettok($active,2,58) ] $+ :* ] ,0) > 0) { sockwrite -n wbDraw: $+ $gettok($active,2,58) $+ :* $1- }
  $1-
}
on 1:close:@Whiteboard-*:return
on 1:close:@Whiteboard* {
  window -c @WhiteboardUndo: $+ [ $gettok($target,2,58) ]
  sockclose wbDraw: $+ $gettok($target,2,58) $+ :*
  .timer -m 1 100 wbCheckState
}
on 1:sockclose:wbDraw* {
  echo $colour(info) -s *** Whiteboard ' $+ $gettok($sockname,2,58) $+ - $sock($sockname).mark ( $+ $sock($sockname).ip $+ ) - A kapcsolódás során hiba történt!
  .timer 1 1 wbInfoRefresh $gettok($sockname,2,58)
}
on 1:sockwrite:wbSendPic* {
  if ($sockerr > 0) { halt }
  if ($sock($sockname).sent >= $gettok($sockname,2,92)) {
    sockclose $sockname
    wbInfoRefresh
    return
  }
  bread $sock($sockname).mark $sock($sockname).sent 4096 &temp
  sockwrite $sockname &temp
}
on 1:sockopen:wbGetPic* {
  ;  1:drawpic 2:-h 3:$active 4:$mouse.x 5:$mouse.y 6:$gettok(%tempFile,$gettok(%tempFile,0,92),92)
  sockwrite -n $sockname WhiteboardGetPic $gettok($sock($sockname).mark,6-,32)
  wbInfoRefresh
}
on 1:sockread:wbGetPic* {
  set %tempFile $wbSetting(GraphicsFolder) $+ [ $gettok($sock($sockname).mark,6-,32) ]
  :NextPacket
  sockread &temp
  bwrite %tempFile -1 &temp
  if ($sock($sockname).rq > 0) goto NextPacket
}
on 1:sockclose:wbGetPic* {
  if ($exists( [ $wbSetting(GraphicsFolder) $+ [ $gettok($sock($sockname).mark,6-,32) ] ] )) { $gettok($sock($sockname).mark,1-5,32) $wbSetting(GraphicsFolder) $+ $gettok($sock($sockname).mark,6-,32) }
  else { echo $colour(info) -s *** Hiba a kép letöltése közben! ( $+ $gettok($sock($sockname).mark,6-,32) - $sock($sockname).ip $+ ) }
  .timer 1 1 wbInfoRefresh
}
on 1:input:@Whiteboard* {
  if ($left($1,1) = /) && ($1 != /me) { return }
  wbChatWindow $gettok($active,2,58)
  if ($1 = /me) {
    if ($sock(wbDraw*,0) > 0) { sockwrite -n wbDraw: $+ $gettok($active,2,58) $+ :* WhiteboardAction $2- }
    echo $colour(action) -i @Whiteboard-Chat: $+ $gettok($active,2,58) * $me $2-
  }
  else {
    if ($sock(wbDraw*,0) > 0) { sockwrite -n wbDraw: $+ $gettok($active,2,58) $+ :* WhiteboardMessage $1- }
    echo $colour(own) -i @Whiteboard-Chat: $+ $gettok($active,2,58) < $+ $me $+ > $1-
  }
  halt
}
alias wbChatWindow {
  if ($window( [ @Whiteboard-Chat: $+ [ $1 ] ] ) != $null) { return }
  set %tempPos $readini($mircini,Windows,wquery)
  set %tempPos $gettok($replace(%tempPos,$chr(44),$chr(32)),1-4,32)
  set %tempPos $gettok(%tempPos,1,32) $gettok(%tempPos,3,32) $gettok(%tempPos,2,32) $gettok(%tempPos,4,32)
  set %tempFont $readini($mircini,Fonts,fquery)
  set %tempFont $gettok(%tempFont,1,44)
  window -ke @Whiteboard-Chat: $+ $1 %tempPos %tempFont
  unset %tempPos %tempFont
}
alias whiteboardInfo {
  window -kal -t12,22,37,45,53,61 @Whiteboard-Info 50 50 306 180 @Whiteboard-Info
  wbInfoRefresh
}
alias wbInfoRefresh {
  if ($1 != $null) { titlebar @Whiteboard: $+ $1 - $sock( [ wbDraw: $+ [ $1 ] $+ :* ] ,0) kapcsolat }
  if ($window(@Whiteboard-Info) = $null) { return }
  if ($sock(wbListen) = $null) { titlebar @Whiteboard-Info - nem fut a szerver }
  else { titlebar @Whiteboard-Info }
  clear @Whiteboard-Info
  aline @Whiteboard-Info Double-Click - új kapcsolat
  aline @Whiteboard-Info $str(_,79)
  aline @Whiteboard-Info Nick	Usando	IP	Inativo	Des.	Enviado	Envios inativos
  aline @Whiteboard-Info $str($chr(0175),79)
  set %temp 1
  :n1
  if ($sock(wbDraw*,%temp) = $null) { goto pics }
  aline @Whiteboard-Info $sock(wbDraw*,%temp).mark $+ $chr(9) $+ $gettok($sock(wbDraw*,%temp),2,58) $+ $chr(9) $+ $sock(wbDraw*,%temp).ip $+ $chr(9) $+ $gettok($duration($sock(wbDraw*,%temp).lr),1,32) $+ $chr(9) $+ $sock(wbDraw*,%temp).rcvd $+ $chr(9) $+ $sock(wbDraw*,%temp).sent $+ $chr(9) $+ $gettok($duration($sock(wbDraw*,%temp).ls),1,32)
  inc %temp
  goto n1
  :pics
  aline @Whiteboard-Info $str(_,79)
  aline @Whiteboard-Info File	IP	Átvitel
  aline @Whiteboard-Info $str($chr(0175),79)
  set %temp 1
  :n2
  if ($sock(wbGetPic*,%temp) = $null) { goto more }
  aline @Whiteboard-Info $gettok($sock(wbGet*,%temp).mark,6-,32) $+ $chr(9) $+ $sock(wbGet*,%temp).ip $+ $chr(9) $+ $sock(wbGet*,%temp).rcvd rcvd
  inc %temp
  goto n2
  :more
  set %temp 1
  :n3
  if ($sock(wbSend*,%temp) = $null) { goto end }
  aline @Whiteboard-Info $gettok($sock(wbSend*,%temp).mark,$gettok($sock(wbSend*,%temp).mark,0,92),92) $chr(9) $+ $sock(wbSend*,%temp).ip $+ $chr(9) $+ $sock(wbSend*,%temp).sent sent
  inc %temp
  goto n3
  :end
  unset %temp
}
menu @Whiteboard-Info {
  dclick {
    if ($sline(@Whiteboard-Info,1).ln = 1) { whiteboard $$?="Írj be egy nicket vagy egy ipt!" }
  }
  &Disconnect: {
    if ($sline(@Whiteboard-Info,1).ln < 5) { return }
    echo $colour(info) -s *** Whiteboard kapcsolódás: $gettok($sock(wbDraw*,$calc( [ $sline(@Whiteboard-Info,1).ln ] - 2)),2,46) ( $+ $gettok($sock(wbDraw*,$calc( [ $sline(@Whiteboard-Info,1).ln ] - 2)),3-,46) $+ )
    sockclose $sock(wbDraw*,$calc( [ $sline(@Whiteboard-Info,1).ln ] - 4))
    .timer 1 1 wbInfoRefresh
  }
  -
  &Refresh:wbInfoRefresh
}
;END
