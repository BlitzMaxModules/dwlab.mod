'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

SuperStrict

Framework brl.d3d7max2d
'Import brl.glmax2d
Import brl.random
Import brl.pngloader
Import brl.jpgloader
Import brl.reflection
'Import brl.audio
'Import brl.freeaudioaudio
Import brl.directsoundaudio
Import brl.wavloader
Import brl.retro
Import brl.map
'Import maxgui.win32maxgui

SetAudioDriver( "DirectSound" )
'SetGraphicsDriver( GLMax2DDriver() )

Include "../../framework.bmx"

Include "Weapons.bmx"

Type LTGame Extends LTProject
	Field Player:LTCircle = New LTCircle
	Field Brain:LTImageVisual = New LTImageVisual
	Field Visor:LTImageVisual = New LTImageVisual
	
	
	
	Method Init()
		Player.Diameter = 0.9
	End Method
	
	
	
	Method Render()
		Player.DrawUsingVisual( Brain )
		Player.DrawUsingVisual( Visor )
		
	End Method
End Type