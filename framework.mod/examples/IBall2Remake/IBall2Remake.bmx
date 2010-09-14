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


'Global LevelExtractor:TLevelExtractor = New TLevelExtractor
'LevelExtractor.Execute(); End


Game.Execute()

Type TGame Extends LTProject
	Field Ball:TBall = New TBall
	Field TileMapVisual:LTImageVisual = New LTImageVisual
	Field FlashingVisual:LTFlashingVisual = New LTFlashingVisual
	Field CurrentLevel:TLevel
	Field CollisionMap:LTCollisionMap
	
	
	
	Method Init()
		Local TileSize:Float = L_ScreenXSize / 16
		L_CurrentCamera.Viewport.SetCoords( TileSize * 6.5, TileSize * 6.0 )
		L_CurrentCamera.Viewport.SetSize( TileSize * 13.0, TileSize * 12.0 )
		L_CurrentCamera.SetSize( 13.0, 12.0 )
		'L_CurrentCamera.SetMagnification( TileSize, TileSize )
		'L_CurrentCamera.SetCoords( 0.0, 0.0 )
		'debugstop
		L_CurrentCamera.Update()
		
		Local BallVisual:LTImageVisual = LTImageVisual.FromFile( "media\ball.png" )
		BallVisual.Rotating = False
		BlockVisual.Image = LTImage.FromFile( "media\tiles.png", 16, 4 )
		FlashingVisual.Image = TileMapVisual.Image
	
		CurrentLevel = TLevel.FromFile( "levels\03.xml" )
	End Method
	
	
	
	Method Logic()
		Objects.Update()
		FlashingVisual.Update()
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		CurrentLevel.Objects.Draw()
	End Method
End Type





Type TLevel Extends LTObject
	Field FrameMap:LTIntMap
	Field ObjectMap:LTIntMap
	Field CollisionMap:LTCollisionMap
	Field Objects:LTList
	
	
	
	Function FromFile:TLevel( Filename:String )
		Local Level:TLevel = TLevel( L_LoadFromFile( Filename ) )
		
		Game.CollisionMap = New LTCollisionMap
		Game.CollisionMap.SetResolution( 8, 8 )
		Game.CollisionMap.SetMapScale( 2.0, 2.0 )
		
		For Local Actor:LTActor = Eachin Objects
			Game.CollisionMap.InsertActor( Actor )
		Next
	End Function
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		Objects = LTList( XMLObject.ManageObjectField( "objects", Objects ) )
		TileMap = LTTileMap( XMLObject.ManageObjectField( "tilemap", TileMap ) )
	End Method
End Type





Type TGameActor Extends LTActor
End Type





Type TBall Extends TGameActor
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
	
	
	
	Method Update()
		If KeyDown( Key_Left ) Then
			AlterDX( -L_DeltaTime * Acceleration )
			Visual.XScale = -1.0
		End If
		If KeyDown( Key_Right ) Then
			AlterDX( L_DeltaTime * Acceleration )
			Visual.XScale = 1.0
		End If
		SetDX( L_LimitFloat( GetDX(), -5.0, 5.0 ) )
		AlterDY( L_DeltaTime * Gravity )
		If Not KeyDown( Key_Left ) And Not KeyDown( Key_Right ) Then
			If Abs( GetDX() ) < 0.5 Then SetDX( 0 )
		End If
		Game.CollisionMap.CollisionsWithActor( Self )
	End Method
End Type





Type TEnemy Extends TGameActor
	Field BulletProof:Int
	
	
	
	Method Update()
		
	End Method
	
	
	
	Method Destroy()
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
		If TBall( Shape ) Then
			Shape.Destroy()
		ElseIf TBullet( Shape ) Then
			Shape.Destroy()
			Destroy()
		Else
			Push( Shape, 0.0, 1.0 )
			Local Pivot:LTActor = LTActor( Shape )
			If Abs( Pivot.Y - Y ) > Abs( Pivot.X - X ) Then
				Model.SetDY( -GetDY() )
			Else
				Model.SetDX( -GetDX() )
			End If
		End If
	End Method
End Type





Type TEnemyGenerator Extends LTActor
	Method Update()
	End Method
End Type





Type TBullet
End Type





Type TBlock Extends LTActor
End Type





Type TMovingBlock Extends LTActor
	Field BlockType:Int
	
	
	
	Const MovingBlock:Int = 0
	Const FallingBlock:Int = 1
	
	
	
	Method Update()
		Select BlockType
			Case MovingBlock, FallingBlock
				MoveForward()
				Game.CurrentLevel.CollisionMap.CollisionsWithActor( Self )
		End Select
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
		If TMovingActor( Shape ) Then
			Shape.Destroy()
		Else
			Push( Shape, 0.0, 1.0 )
			If BlockType = MovingBlock Then SetDY( -GetDY() )
		End If
	End Method
End Type





Type TExitBlock Extends TBlock
End Type





Type THazardousBlock Extends LTBlock
	Method New()
		Visual = Game.FlashingVisual
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
		If TMovingActor( Shape ) Then Shape.Destroy()
	End Method
End Type





Type TCollectableBlock
	Field BlockType:Int
	
	
	
	Const Key:Int = 0
	Const Bomb:Int = 1
	Const Badge:Int = 2
	Const Score:Int = 3
	Const Nothing:Int = 4
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