SuperStrict

Framework brl.d3d7max2d
'Import brl.glmax2d

Import brl.directsoundaudio
'Import brl.freeaudioaudio

Import brl.random
Import brl.pngloader
Import brl.jpgloader
Import brl.reflection
Import brl.wavloader
Import brl.retro
Import brl.map

Import brl.eventqueue
Import maxgui.win32maxguiex

SetAudioDriver( "DirectSound" )
'SetGraphicsDriver( GLMax2DDriver() )

Include "../../framework.bmx"

Include "TGame.bmx"
Include "TMovingObject.bmx"

Global Game:TGame = New TGame
Game.Execute()