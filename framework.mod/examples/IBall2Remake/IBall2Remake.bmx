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
Import brl.eventqueue
Import maxgui.win32maxguiex

SetAudioDriver( "DirectSound" )
'SetGraphicsDriver( GLMax2DDriver() )

Include "../../framework.bmx"
Global L_EditorPath:String = "../../../editor.mod"
Include "../../../editor.mod/editor.bmx"

Include "Tools.bmx"

Init( 800, 600 )

'Global Editor:LTEditor = New LTEditor
'Editor.Execute()

Const TilesQuantity:Int = 64
Const TileXSize:Int = 16
Const TileYSize:Int = 16

Global Pri:LTFilledPrimitive = New LTFilledPrimitive
Pri.SetColorFromHex( "FF0000" )
Pri.Alpha = 0.5

LTVectorModel.SetDefault()
Global ShapeList:TList = New TList

Global Game:TGame = New TGame


Global LevelExtractor:TLevelExtractor = New TLevelExtractor
LevelExtractor.Execute(); End


Game.Execute()

Type TGame Extends LTProject
	Field Ball:TBall = New TBall
	Field TileMapVisual:LTImageVisual = New LTImageVisual
	Field FlashingVisual:LTFlashingVisual = New LTFlashingVisual
	Field CurrentLevel:TLevel
	
	
	
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
		Ball.SetDiameter( 0.9 )
		
		' ==================== Visuals ====================	
		
		TileMapVisual.Image = LTImage.FromFile( "media\tiles.png", 16, 4 )
		FlashingVisual.Image = TileMapVisual.Image
		
		' ==================== Tilemap ====================	
	
		'CurrentLevel = TLevel( L_LoadFromFile( "levels\03.xml" ) )
		CurrentLevel = New TLevel
		
		CurrentLevel.TileMap = New LTTileMap
		CurrentLevel.TileMap.FrameMap = LTIntMap.FromFile( "levels\03.dat" )
		CurrentLevel.TileMap.SetSize( 15.0, 14.0 )
		CurrentLevel.TileMap.Visual = TileMapVisual
		
		CurrentLevel.TileMap.SetName( "tilemap" )
		CurrentLevel.Objects = New LTList
		
		CurrentLevel.SaveToFile( "levels\03.xml" )
		
		'Objects = LTList( L_LoadFromFile( "levels\03.xml" ) )
		
		Local Rectangle:LTActor = New LTActor
		Rectangle.SetCoords( 0.5, 0.5 )
		Local CollisionArray:LTActor[] = New LTActor[ TilesQuantity ]
		For Local N:Int = 1 Until TilesQuantity
			CollisionArray[ N ] = Rectangle
		Next
		CurrentLevel.TileMap.FillShapeMap( CollisionArray )
	End Method
	
	
	
	Method Logic()
		Ball.MoveForward()
		CurrentLevel.TileMap.CollidesWithActor( Ball )
		Ball.Control()
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		CurrentLevel.TileMap.Draw()
		'debugstop
		CurrentLevel.Objects.Draw()
		Ball.Draw()
		DrawText( Ball.X, 0, 0 )
		DrawText( Ball.Y, 0, 16 )
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





Type TLevel Extends LTObject
	Field Objects:LTList
	Field TileMap:LTTileMap
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		Objects = LTList( XMLObject.ManageObjectField( "objects", Objects ) )
		TileMap = LTTileMap( XMLObject.ManageObjectField( "tilemap", TileMap ) )
	End Method
End Type





Type TBall Extends LTActor
	Const Acceleration:Float = 20.0
	Const AccelerationLimit:Float = 5.0
	Const Gravity:Float = 10.0
	Const JumpingPower:Float = -9.2
	Const HorizontalBounce:Float = 0.6
	Const VerticalBounce:Float = 0.3
	
	
	
	Method New()
		Shape = L_Circle
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
		'debugstop
		Push( Shape, 0.0, 1.0 )
		
		Local Pivot:LTActor = LTActor( Shape )
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



Type TBulletProofEnemy Extends LTActor
End Type



Type TEnemy Extends TBulletProofEnemy
End Type



Type TMovingBlock Extends LTActor
	Method New()
		Visual = Game.FlashingVisual
	End Method
	
	
	
	Function Create( X:Float, Y:Float )
		Local MovingBlock:TMovingBlock = New TMovingBlock
		MovingBlock.SetCoords( X, Y )
		Game.CurrentLevel.Objects.AddLast( MovingBlock )
	End Function
End Type



Type TFallingBlock Extends LTActor
End Type



Type TEnemyGenerator Extends LTActor
End Type



Type THazardousBlock Extends LTActor
	Method New()
		Visual = Game.FlashingVisual
	End Method
End Type



Type LTFlashingVisual Extends LTImageVisual
	Method Update()
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