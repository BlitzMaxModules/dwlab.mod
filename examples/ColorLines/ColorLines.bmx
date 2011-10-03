'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

SuperStrict

Framework brl.basic

Import brl.pngloader
Import brl.oggloader
Import brl.freetypefont

Import dwlab.frmwork
Import dwlab.gui
Import dwlab.sound

Include "TGame.bmx"
Include "TVisualizer.bmx"
Include "TPopUpBall.bmx"
Include "TCursor.bmx"
Include "TSelected.bmx"
Include "TMoveAlongPath.bmx"
Include "TCheckLines.bmx"
Include "TMoveBall.bmx"
Include "TExplosion.bmx"
Include "HUD.bmx"
Include "TIntro.bmx"
Include "TLevel.bmx"
Include "mouse_menu/Menu.bmx"

Incbin "font.png"
Incbin "font.lfn"
Incbin "stop.ogg"
Incbin "rush.ogg"
Incbin "explosion.ogg"
Incbin "select.ogg"
Incbin "swap.ogg"
Include "levels_incbin.bmx"

Global Game:TGame = New TGame
Game.Execute()