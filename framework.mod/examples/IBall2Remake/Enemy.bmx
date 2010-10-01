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
	Field Bulletproof:Int
	
	
	
	Const Angel:Int = 0
	Const BallWithSquare:Int = 1
	Const BeachBall:Int = 2
	Const Mushroom:Int = 3
	Const Pacman:Int = 4
	Const Pad:Int = 5
	Const Reel:Int = 6
	Const Sandwitch:Int = 7
	Const Ufo:Int = 8
	
	
	
	Function Create:TEnemy( X:Float, Y:Float, EnemyType:Int, DX:Float, DY:Float, HexColor:String )
		Local Enemy:TEnemy = New TEnemy
		Enemy.SetCoords( X, Y )
		Enemy.SetDXDY( DX, DY )
		Enemy.SetDiameter( 0.95 )
		
		Local ImageVisual:LTImageVisual = New LTImageVisual
		ImageVisual.Image = Game.EnemyImage[ EnemyType ]
		ImageVisual.Rotating = False
		ImageVisual.SetColorFromHex( HexColor )
		Enemy.Visual = ImageVisual
		
		Select EnemyType
			Case Sandwitch, Pad
				Enemy.Shape = L_Rectangle
			Default
				Enemy.Shape = L_Circle
		End Select
		
		Select EnemyType
			Case Angel, Mushroom, Sandwitch
				Enemy.ChangeFacing = True
		End Select
		
		Game.CollisionMap.InsertActor( Enemy )
		Game.Objects.AddLast( Enemy )
		Return Enemy
	End Function
	
	
	
	Method Bounce( DX:Float, DY:Float )
		If Abs( DY ) > Abs( DX ) Then
			SetDY( -GetDY() )
		Else
			SetDX( -GetDX() )
		End If
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
		If TBall( Shape ) Then
			Shape.Destroy()
		Else
			WedgeOffWith( Shape, 0.0, 1.0 )
			Local Actor:LTActor = LTActor( Shape )
			Bounce( X - Actor.X, Y - Actor.Y )
		End If
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int )
		PushFromTile( TileMap, TileX, TileY )
		Local Actor:LTActor = TileMap.GetTile( TIleX, TileY )
		Bounce( X - Actor.X, Y - Actor.Y )
	End Method
	
	
	
	Method Act()
		'debugstop
		MoveForward()
		If ChangeFacing Then Visual.XScale = Sgn( GetDX() )
		Frame = L_WrapInt( Floor( X * 8.0 ), 4 )
		Game.CollisionMap.CollisionsWithActor( Self )
		Game.TileMap.CollisionsWithActor( Self )
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageIntAttribute( "changefacing", ChangeFacing )
		XMLObject.ManageIntAttribute( "bulletproof", Bulletproof )
	End Method
End Type





Type TEnemyGenerator Extends LTActor
	Field GenerationStartTime:Float
	Field NextEnemy:Float
	Field EnemyType:Int
	Field EnemyColor:String
	Field EnemyTemplate:LTActor
	
	Const GenerationTime:Float = 1.5
	Const GenerationSpeed:Float = 72.0
	Const FromPeriod:Float = 1.0
	Const ToPeriod:Float = 20.0
	
	
	
	Function Create:TEnemyGenerator( X:Float, Y:Float, DX:Float, DY:Float, EnemyType:Int, EnemyColor:String )
		Local Generator:TEnemyGenerator = New TEnemyGenerator
		Generator.SetCoords( X, Y )
		Generator.SetDXDY( DX, DY )
		Generator.EnemyType = EnemyType
		Generator.EnemyColor = EnemyColor
		Generator.Visual = LTImageVisual.FromImage( Game.GeneratorImage )
		Game.Objects.AddLast( Generator )
		Return Generator
	End Function
	
	
	
	Method Act()
		If GenerationStartTime Then
			Frame = L_WrapInt2( Floor( ( Game.ProjectTime - GenerationStartTime ) * GenerationSpeed ), 18, 36 )
			If Game.ProjectTime > GenerationStartTime + GenerationTime Then
				Local Collision:Int = False
				For Local Actor:LTActor = Eachin Game.Objects.List
					If EnemyTemplate.CollidesWith( Actor ) And Actor <> Self Then
						Collision = True
						Exit
					End If
				Next
				
				If Not Collision Then
					TEnemy.Create( X, Y, EnemyType, GetDX(), GetDY(), EnemyColor )
					NextEnemy = Game.ProjectTime + Rnd( FromPeriod, ToPeriod )
					GenerationStartTime = 0
					Frame = 0
					EnemyTemplate.Visual.Alpha = 0.0
				Else
					EnemyTemplate.Visual.Alpha = 1.0
				End If
			Else
				EnemyTemplate.Visual.Alpha = 1.0 * ( Game.ProjectTime - GenerationStartTime ) / GenerationTime
			End If
		ElseIf NextEnemy < Game.ProjectTime Then
			GenerationStartTime = Game.ProjectTime
			EnemyTemplate = New LTActor
			EnemyTemplate.Visual = LTImageVisual.FromImage( Game.EnemyImage[ EnemyType ] )
			EnemyTemplate.SetCoords( X, Y )
			EnemyTemplate.SetSize( 1.0, 1.0 )
			EnemyTemplate.Shape = L_Rectangle
			EnemyTemplate.Visual.SetColorFromHex( EnemyColor )
			EnemyTemplate.Visual.Alpha = 0.0
		End If
	End Method
	
	
	
	Method Draw()
		EnemyTemplate.Draw()
		Super.Draw()
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageIntAttribute( "enemy-type", EnemyType )
		XMLObject.ManageStringAttribute( "enemy-color", EnemyColor )
	End Method
End Type