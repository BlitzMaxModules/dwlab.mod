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
		
		'debugstop
		MoveForward()
		'Game.CollisionMap.CollisionsWithActor( Self )
		Game.TileMap.CollisionsWithActor( Self )
	End Method
	
	
	
	Method Destroy()
	End Method
End Type





Type TBullet Extends LTActor
End Type