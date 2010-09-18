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
LevelExtractor.Execute()'; End


Game.Execute()

Type TGame Extends LTProject
	Field Ball:TBall = New TBall
	Field BlockVisual:LTImageVisual = New LTImageVisual
	Field FlashingVisual:LTFlashingVisual = New LTFlashingVisual
	Field CurrentLevel:TLevel
	Field CollisionMap:LTCollisionMap
	Field TileMap:LTTileMap = New LTTileMap
	Field KeyCollected:Int
	Field Score:Int
	Field EnemyVisual:LTImageVisual[]
	
	
	
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
		Ball.Visual = BallVisual
		Ball.SetCoords( 0, -3.0 )
		
		BlockVisual.Image = LTImage.FromFile( "media\tiles.png", 16, 4 )
		FlashingVisual.Image = BlockVisual.Image
		
		TileMap.Visual = BlockVisual
		TileMap.SetSize( 15.0, 14.0 )
		TileMap.ActorArray = New LTActor[ TilesQuantity ]
		
		EnemyVisual = New LTImageVisual[ 9 ]
		EnemyVisual[ Angels ] = LTImageVisual.FromFile( "angels.png", 4, 1 )
		EnemyVisual[ BallWithSquare ] = LTImageVisual.FromFile( "ballwithsquare.png", 4, 1 )
		EnemyVisual[ BeachBall ] = LTImageVisual.FromFile( "beachball.png", 4, 1 )
		EnemyVisual[ Mushroom ] = LTImageVisual.FromFile( "mushroom.png", 4, 1 )
		EnemyVisual[ Pacman ] = LTImageVisual.FromFile( "pacman.png", 4, 1 )
		EnemyVisual[ Pad ] = LTImageVisual.FromFile( "pad.png", 4, 1 )
		EnemyVisual[ Reel ] = LTImageVisual.FromFile( "reel.png", 4, 1 )
		EnemyVisual[ Sandwitch ] = LTImageVisual.FromFile( "sandwitch.png", 4, 1 )
		EnemyVisual[ Ufo ] = LTImageVisual.FromFile( "ufo.png", 4, 1 )

		
		For Local N:Int = 1 Until TilesQuantity
			Local Actor:LTActor
			Select N
				Case 1
					Actor = New TExitBlock
					Actor.Shape = L_Rectangle
				Case 16, 17, 32, 33, 34, 35, 36, 37, 38
					Local Block:TCollectableBlock = New TCollectableBlock
					Select N
						Case 16
							Block.BlockType = Block.Key
						Case 17
							Block.BlockType = Block.Diamond
						Case 32
							Block.BlockType = Block.Bomb
						Case 33
							Block.BlockType = Block.Badge
						Default
							Block.BlockType = Block.Score
					End Select
					Actor = Block
					Actor.Shape = L_Circle
				Default
					Actor = New TBlock
					Actor.Shape = L_Rectangle
			End Select
			Actor.SetCoords( 0.5, 0.5 )
			TileMap.ActorArray[ N ] = Actor
		Next
		
		CurrentLevel = TLevel.FromFile( "levels\01.xml" )
	End Method
	
	
	
	Method Logic()
		CurrentLevel.Objects.Act()
		FlashingVisual.Act()
		Ball.Act()
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		TileMap.Draw()
		Ball.Draw()
		CurrentLevel.Objects.Draw()
	End Method
End Type





Type TLevel Extends LTObject
	Field FrameMap:LTIntMap
	Field Objects:LTList
	
	
	
	Function FromFile:TLevel( Filename:String )
		Local Level:TLevel = TLevel( L_LoadFromFile( Filename ) )
		
		Game.CollisionMap = New LTCollisionMap
		Game.CollisionMap.SetResolution( 8, 8 )
		Game.CollisionMap.SetMapScale( 2.0, 2.0 )
	
		For Local Actor:LTActor = Eachin Level.Objects.List
			Game.CollisionMap.InsertActor( Actor )
		Next
		
		Return Level
	End Function
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		FrameMap = LTIntMap( XMLObject.ManageObjectField( "framemap", FrameMap ) )
		Objects = LTList( XMLObject.ManageObjectField( "objects", Objects ) )
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
	
	
	
	Method Bounce( DX:Float, DY:Float )
		If DY > Abs( DX ) Then
			Model.SetDY( -GetDY() * VerticalBounce )
			If KeyDown( Key_Up ) Then SetDY( JumpingPower )
		ElseIf DY < -Abs( DX ) Then
			Model.SetDY( -GetDY() * VerticalBounce )
		Else
			Model.SetDX( -GetDX() * HorizontalBounce )
		End If
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
		'debugstop
		Push( Shape, 0.0, 1.0 )
		
		Local Actor:LTActor = LTActor( Shape )
		Bounce( Actor.X - X, Actor.Y - Y )
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int )
		Local Template:LTActor = TileMap.GetTileTemplate( TileX, TileY )
		Local Block:TCollectableBlock = TCollectableBlock( Template )
		If Block Then
			Select Block.BlockType
				Case TCollectableBlock.Key
					Game.Score :+ 250
					Game.KeyCollected = True
				Case TCollectableBlock.Bomb
					Game.Score :+ 100
				Case TCollectableBlock.Badge
					Game.Score :+ 50
				Case TCollectableBlock.Diamond
					Game.Score :+ 100
				Case TCollectableBlock.Score
					Game.Score :+ 500
			End Select
			TileMap.FrameMap.Value[ TileX, TileY ] = 0
		Else
			If TExitBlock( Template ) And Game.KeyCollected Then End
			Local Actor:LTActor = TileMap.GetTile( TileX, TileY )
			Push( Actor, 0.0, 1.0 )
			Bounce( Actor.X - X, Actor.Y - Y )
		End If
	End Method
	
	
	
	Method Act()
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
		
		MoveForward()
		Game.CollisionMap.CollisionsWithActor( Self )
		'debugstop
		Game.TileMap.CollisionsWithActor( Self )
	End Method
	
	
	
	Method Destroy()
	End Method
End Type





Type TEnemy Extends TGameActor
	Field BulletProof:Int
	
	
	
	Const Angels:Int = 0
	Const BallWithSquare:Int = 1
	Const BeachBall:Int = 2
	Const Mushroom:Int = 3
	Const Pacman:Int = 4
	Const Pad:Int = 5
	Const Reel:Int = 6
	Const Sandwitch:Int = 7
	Const Ufo:Int = 8
	
	
	
	Method Create:TEnemy( X:Float, Y:Float, VisualNum:Int )
		Game.Objects.Add
	End Method
	
	
	
	Method Bounce( DX:Float, DY:Float )
			If Abs( DY ) > Abs( DX ) Then
				Model.SetDY( -Model.GetDY() )
			Else
				Model.SetDX( -Model.GetDX() )
			End If
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
		If TBall( Shape ) Then
			Shape.Destroy()
		ElseIf TBullet( Shape ) Then
			Shape.Destroy()
			If Not BulletProof Then Destroy()
		Else
			Push( Shape, 0.0, 1.0 )
			Local Pivot:LTActor = LTActor( Shape )
			Bounce( Pivot.X - X, Pivot.Y - Y )
		End If
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int )
		Local Actor:LTActor = LTActor( TileMap.GetTile( TIleX, TileY ) )
		Push( Actor, 0.0, 1.0 )
		Bounce( Actor.X - X, Actor.Y - Y )
	End Method
	
	
	
	Method Act()
		Game.CollisionMap.RemoveActor( Self )
		MoveForward()
		Game.CollisionMap.InsertActor( Self )
		Game.CollisionMap.CollisionsWithActor( Self )
	End Method
	
	
	
	Method Destroy()
	End Method
End Type





Type TEnemyGenerator Extends LTActor
	Method Update()
	End Method
End Type





Type TBullet Extends LTActor
End Type





Type TBlock Extends LTActor
End Type





Type TMovingBlock Extends LTActor
	Field BlockType:Int
	
	
	
	Const MovingBlock:Int = 0
	Const FallingBlock:Int = 1
	Const PinnedBlock:Int = 2
	
	
	
	Method Act()
		Select BlockType
			Case MovingBlock, FallingBlock
				MoveForward()
				Game.CollisionMap.CollisionsWithActor( Self )
		End Select
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
		If TGameActor( Shape ) Then
			Shape.Destroy()
		Else
			Push( Shape, 0.0, 1.0 )
			If BlockType = MovingBlock Then SetDY( -GetDY() )
		End If
	End Method
End Type





Type TExitBlock Extends TBlock
End Type





Type THazardousBlock Extends TBlock
	Method New()
		Visual = Game.FlashingVisual
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
		If TGameActor( Shape ) Then Shape.Destroy()
	End Method
End Type





Type TCollectableBlock Extends TBlock
	Field BlockType:Int
	
	
	
	Const Key:Int = 0 ' 250pts
	Const Bomb:Int = 1 ' 100pts
	Const Badge:Int = 2 ' 50pts
	Const Diamond:Int = 3 ' 100pts
	Const Score:Int = 4 ' 500pts
	Const Nothing:Int = 5
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