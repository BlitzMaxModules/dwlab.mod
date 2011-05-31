'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

SuperStrict

Framework brl.d3d7max2d
'Import brl.glmax2d

Import brl.directsoundaudio
'Import brl.freeaudioaudio

Import brl.random
Import brl.reflection
Import brl.retro
Import brl.map

Import brl.pngloader
Import brl.jpgloader
Import brl.wavloader
Import brl.oggloader

Include "../../framework.bmx"

'SetGraphicsDriver( GLMax2DDriver() )
'SetAudioDriver( "DirectSound" )

Include "TGame.bmx"
Include "CommonBehaviorModels.bmx"
Include "TMovingObject.bmx"
Include "TBricks.bmx"
Include "TBlock.bmx"
Include "TCoin.bmx"
Include "TScore.bmx"
Include "TPole.bmx"
Include "TFlag.bmx"

Global Game:TGame = New TGame
Game.Execute()