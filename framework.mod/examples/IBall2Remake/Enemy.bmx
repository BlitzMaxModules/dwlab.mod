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

Type TEnemy Extends TGameActor
	Field ChangeFacing:Int
	Field BulletProof:Int
	
	
	
	Const Angel:Int = 0
	Const BallWithSquare:Int = 1
	Const BeachBall:Int = 2
	Const Mushroom:Int = 3
	Const Pacman:Int = 4
	Const Pad:Int = 5
	Const Reel:Int = 6
	Const Sandwitch:Int = 7
	Const Ufo:Int = 8
	
	
	
	Function Create:TEnemy( X:Float, Y:Float, VisualNum:Int, DX:Float, DY:Float, HexColor:String )
		Local Enemy:TEnemy = New TEnemy
		Enemy.SetCoords( X, Y )
		Enemy.SetDXDY( DX, DY )
		Enemy.SetDiameter( 0.95 )
		
		Local ImageVisual:LTImageVisual = New LTImageVisual
		ImageVisual.Image = Game.EnemyImage[ VisualNum ]
		ImageVisual.Rotating = False
		ImageVisual.SetColorFromHex( HexColor )
		Enemy.Visual = ImageVisual
		
		Select VisualNum
			Case Sandwitch, Pad
				Enemy.Shape = L_Rectangle
			Default
				Enemy.Shape = L_Circle
		End Select
		
		Select VisualNum
			Case Angel, Mushroom, Sandwitch
				Enemy.ChangeFacing = True
		End Select
		
		Game.CollisionMap.InsertActor( Enemy )
		Game.Objects.AddLast( Enemy )
		Return Enemy
	End Function
	
	
	
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
		'debugstop
		MoveForward()
		If ChangeFacing Then Visual.XScale = Sgn( GetDX() )
		Frame = L_Wrap( Floor( X * 8.0 ), 4 )
		Game.CollisionMap.CollisionsWithActor( Self )
		Game.TileMap.CollisionsWithActor( Self )
	End Method
End Type





Type TEnemyGenerator Extends LTActor
	Method Update()
	End Method
End Type