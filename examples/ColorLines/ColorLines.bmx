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

Import brl.jpgloader
Import brl.pngloader
Import brl.oggloader
Import brl.freetypefont
Import brl.freeaudioaudio
Import brl.openalaudio
Import brl.glmax2d
Import brl.eventqueue

Import dwlab.frmwork
Import dwlab.gui
Import dwlab.profiles
Import dwlab.sound

Include "TGame.bmx"
Include "THUD.bmx"
Include "TGameProfile.bmx"
Include "TBallTileMapVisualizer.bmx"
Include "TPathFinder.bmx"
Include "TPopUpBall.bmx"
Include "TCursor.bmx"
Include "TSelected.bmx"
Include "TMoveAlongPath.bmx"
Include "TCheckLines.bmx"
Include "TMoveBall.bmx"
Include "TExplosion.bmx"
Include "MouseMenu/Menu.bmx"
Include "TRestartButton.bmx"

Incbin "stop.ogg"
Incbin "rush.ogg"
Incbin "explosion.ogg"
Incbin "select.ogg"
Incbin "swap.ogg"
Include "levels_incbin.bmx"

AppTitle = "Color Lines 1.0 beta 3"

EnableOpenALAudio()

Global Game:TGame = New TGame
Game.Execute()