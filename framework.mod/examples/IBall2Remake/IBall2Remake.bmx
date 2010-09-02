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
Import brl.bmploader
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

Include "Extractors.bmx"

Init( 800, 600 )

'Global TileExtractor:TTileExtractor = New TTileExtractor
'TileExtractor.Execute()

Const TilesQuantity:Int = 64
Const TileXSize:Int = 16
Const TileYSize:Int = 16

Global Pri:LTFilledPrimitive = New LTFilledPrimitive
Pri.Alpha = 0.5

'Global LevelExtractor:TLevelExtractor = New TLevelExtractor
'LevelExtractor.Execute()

LTVectorModel.SetDefault()

Global Game:TGame = New TGame
Game.Execute()

Type TGame Extends LTProject
	Field Ball:TBall = New TBall
	Field TileMapVisual:LTImageVisual = New LTImageVisual
	Field TileMapRectangle:LTRectangle = New LTRectangle
	Field TileMap:LTTileMap = New LTTileMap
	
	
	
	Method Init()
		Local TileSize:Float = L_ScreenXSize / 16
		L_CurrentCamera.Viewport.SetCoords( TileSize * 6.5, TileSize * 6.0 )
		L_CurrentCamera.Viewport.SetSize( TileSize * 13.0, TileSize * 12.0 )
		L_CurrentCamera.SetSize( 13.0, 12.0 )
		'L_CurrentCamera.SetMagnification( TileSize, TileSize )
		'L_CurrentCamera.SetCoords( 0.0, 0.0 )
		'debugstop
		L_CurrentCamera.Update()
		
		' ==================== Player ====================	
		
		Local BallVisual:LTImageVisual = LTImageVisual.FromFile( "media\ball.png" )
		BallVisual.Rotating = False
		Ball.Visual = BallVisual
		Ball.SetCoords( -1.6, 0 )
		Ball.Diameter = 0.9
		Ball.Model.SetMass( 1.0 )
		
		' ==================== Tilemap ====================	
	
		TileMap.FrameMap = LTIntMap.FromFile( "levels\02.dat" )
		TileMapVisual.Image = LTImage.FromFile( "media\tiles.png", 16, 4 )
		TileMap.SetSize( 15.0, 14.0 )
		TileMap.SetCoords( 0.0, 0.0 )
		TileMap.Visual = TileMapVisual
		
		Local Rectangle:LTRectangle = New LTRectangle
		Rectangle.SetCoords( 0.5, 0.5 )
		Local CollisionArray:LTShape[] = New LTShape[ TilesQuantity ]
		For Local N:Int = 1 Until TilesQuantity
			CollisionArray[ N ] = Rectangle
		Next
		TileMap.FillShapeMap( CollisionArray )
	End Method
	
	
	
	Method Logic()
		Ball.Model.AlterDY( 5.0 * L_DeltaTime )
		Ball.MoveForward()
		TileMap.CollidesWithCircle( Ball )
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		TileMap.Draw()
		Ball.Draw()
	End Method
End Type





Type TBall Extends LTCircle
	Method HandleCollision( Shape:LTShape )
		'debugstop
		Push( Shape )
		Model.SetDY( -Model.GetDY() * 0.5 )
	End Method
End Type