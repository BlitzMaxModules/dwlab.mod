'
' I, Ball 2 Remake - Digital Wizard's Lab example
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
'Global L_EditorPath:String = "../../../editor.mod"
'Include "../../../editor.mod/editor.bmx"

Include "Tools.bmx"
Include "Levels.bmx"

Include "Game.bmx"
Include "Ball.bmx"
Include "Enemy.bmx"
Include "Blocks.bmx"

InitGraphics( 800, 600 )

'Global Editor:LTEditor = New LTEditor
'Editor.Execute()

Const TilesQuantity:Int = 176
Const EnemiesQuantity:Int = 9
Const TileWidth:Int = 16
Const TileHeight:Int = 16

Global Pri:LTFilledPrimitive = New LTFilledPrimitive
Pri.SetColorFromHex( "FF0000" )
Pri.Alpha = 0.5

'Global TileExtrSprite:TTileExtrSprite = New TTileExtrSprite
'TileExtrSprite.Execute(); End

Global Game:TGame = New TGame

'Global LevelExtrSprite:TLevelExtrSprite = New TLevelExtrSprite
'LevelExtrSprite.Execute()'; End
'GenerateLevels()

'include "../../tests.bmx"
'CreateEnemyGeneratorImage
'DebugLog Min( 0.5, 0.6 )
ConvertLevels()
'Game.Execute()