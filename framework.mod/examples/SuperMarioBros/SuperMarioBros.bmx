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

'Import maxgui.win32maxgui

SetAudioDriver( "DirectSound" )
'SetGraphicsDriver( GLMax2DDriver() )

Include "../../framework.bmx"
Include "../../editor/editor.bmx"

Include "Game.bmx"
Include "Mario.bmx"
Include "Enemy.bmx"
Include "Mushrooms.bmx"

InitGraphics( 800, 600 )

Global Game:TGame = New TGame
Game.Execute()