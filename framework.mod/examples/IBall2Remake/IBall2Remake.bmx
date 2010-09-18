'
' I, Ball 2 Remake - Digital Wizard's Lab example
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
Import brl.bmploader
Import brl.reflection
'Import brl.audio
'Import brl.freeaudioaudio
Import brl.directsoundaudio
Import brl.wavloader
Import brl.retro
Import brl.map
Import brl.eventqueue
Import maxgui.win32maxguiex

SetAudioDriver( "DirectSound" )
'SetGraphicsDriver( GLMax2DDriver() )

Include "../../framework.bmx"
Global L_EditorPath:String = "../../../editor.mod"
Include "../../../editor.mod/editor.bmx"

Include "Tools.bmx"

Include "Game.bmx"
Include "Ball.bmx"
Include "Enemy.bmx"
Include "Blocks.bmx"

Init( 800, 600 )

'Global Editor:LTEditor = New LTEditor
'Editor.Execute()

Const TilesQuantity:Int = 176
Const EnemiesQuantity:Int = 9
Const TileXSize:Int = 16
Const TileYSize:Int = 16

Global Pri:LTFilledPrimitive = New LTFilledPrimitive
Pri.SetColorFromHex( "FF0000" )
Pri.Alpha = 0.5

LTVectorModel.SetDefault()
Global ShapeList:TList = New TList

Global Game:TGame = New TGame


'Global TileExtractor:TTileExtractor = New TTileExtractor
'TileExtractor.Execute(); End

'Global LevelExtractor:TLevelExtractor = New TLevelExtractor
'LevelExtractor.Execute()'; End


Game.Execute()





Type TEnemyGenerator Extends LTActor
	Method Update()
	End Method
End Type





Type LTFlashingVisual Extends LTImageVisual
	Method Act()
		Local Time:Float = L_WrapFloat( Game.ProjectTime, 3.0 )
		If Time < 1.0 Then
			R = Time
			G = 0.0
			B = 1.0 - Time
		ElseIf Time >= 1.0 And Time < 2.0 Then
			R = 2.0 - Time
			G = Time - 1.0
			B = 0.0
		Else
			R = 0.0
			G = 3.0 - Time
			B = Time - 2.0
		End If
	End Method
End Type