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
Import maxgui.win32maxguiex

SetAudioDriver( "DirectSound" )
'SetGraphicsDriver( GLMax2DDriver() )

Include "../../framework.bmx"
Include "../../../editor.mod/editor.bmx"

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
Global Prim:LTFilledPrimitive = New LTFilledPrimitive
Prim.SetColorFromHex( "FF0000" )
Prim.Alpha = 0.5
Global ShapeList:TList = New TList

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
		Ball.SetCoords( -2.45, 0 )
		Ball.Diameter = 0.9
		
		' ==================== Tilemap ====================	
	
		TileMap.FrameMap = LTIntMap.FromFile( "levels\03.dat" )
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
		Ball.MoveForward()
		TileMap.CollidesWithCircle( Ball )
		Ball.Control()
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		TileMap.Draw()
		Ball.Draw()
		'Ball.DrawUsingVisual( Prim )
		'For Local Y:Int = 0 Until TileMap.FrameMap.YQuantity
		'	For Local X:Int = 0 Until TileMap.FrameMap.XQuantity
		'		Local Shape:LTShape = TileMap.ShapeMap[ X, Y ]
				'If Shape Then 
		'	Next
		'Next
		'For Local Shape:LTShape = Eachin ShapeList
		'	Shape.DrawUsingVisual( Prim )
		'Next
		'ShapeList.Clear()
	End Method
End Type





Type TBall Extends LTCircle
	Const Acceleration:Float = 20.0
	Const AccelerationLimit:Float = 5.0
	Const Gravity:Float = 10.0
	Const JumpingPower:Float = -9.2
	Const HorizontalBounce:Float = 0.6
	Const VerticalBounce:Float = 0.3
	
	
	
	Method HandleCollision( Shape:LTShape )
		'debugstop
		Push( Shape )
		
		Local Pivot:LTPivot = LTPivot( Shape )
		'ShapeList.AddLast( Shape )
		Local DX:Float = Pivot.X - X
		Local DY:Float = Pivot.Y - Y
		If DY > Abs( DX ) Then
			Model.SetDY( -GetDY() * VerticalBounce )
			If KeyDown( Key_Up ) Then SetDY( JumpingPower )
		ElseIf DY < -Abs( DX ) Then
			Model.SetDY( -GetDY() * VerticalBounce )
		Else
			Model.SetDX( -GetDX() * HorizontalBounce )
		End If
		'debuglog GetDX()
	End Method
	
	
	
	Method Control()
		If KeyDown( Key_Left ) Then AlterDX( -L_DeltaTime * Acceleration ); Visual.XScale = -1.0
		If KeyDown( Key_Right ) Then AlterDX( L_DeltaTime * Acceleration ); Visual.XScale = 1.0
		SetDX( L_LimitFloat( GetDX(), -5.0, 5.0 ) )
		AlterDY( L_DeltaTime * Gravity )
		If Not KeyDown( Key_Left ) And Not KeyDown( Key_Right ) Then
			If Abs( GetDX() ) < 0.5 Then SetDX( 0 )
		End If
	End Method
End Type