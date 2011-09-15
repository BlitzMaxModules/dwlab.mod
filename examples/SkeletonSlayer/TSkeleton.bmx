'
' Skeleton Slayer - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TSkeleton Extends TPerson
	Method Init()
		TileType = Game.EnemyTile
		Velocity = 3.0
		WalkingAnimationSpeed = 0.3
		Health = 10
		MaxSearchDistance = 20
		AttachModel( New TWander )
		AttachModel( TFollow.Create( TPerson( Game.Level.FindShapeWithType( "TPlayer" ) ) ), False )
		AttachModel( TFight.Create( TPerson( Game.Level.FindShapeWithType( "TPlayer" ) ) ) )
		Super.Init()
	End Method
	
	Method RecalculatePath( Model:TMovingAlongPath )
		Model.Position = Null
	End Method
End Type



Type TWander Extends LTBehaviorModel
	Const MinWaitingTime:Double = 4.0
	Const MaxWaitingTime:Double = 15.0
	Const MinMovingDistance:Int = 2
	Const MaxMovingDistance:Int = 6
	
	Field NextMovingTime:Double
	
	Method Activate( Shape:LTShape )
		NextMovingTime = Game.Time + Rnd( MinWaitingTime, MaxWaitingTime )
	End Method
	
	Method ApplyTo( Shape:LTShape )
		If Game.Time > NextMovingTime Then
			Local DX:Int, DY:Int
			While DX = 0 And DY = 0
				DX = Rand( -1, 1 )
				DY = Rand( -1, 1 )
			WEnd
			
			Local Person:TPerson = TPerson( Shape )
			Local FirstPosition:LTTileMapPosition = New LTTileMapPosition
			FirstPosition.X = Person.TileX
			FirstPosition.Y = Person.TileY
			
			Local PrevPosition:LTTileMapPosition = FirstPosition
			For Local N:Int = 1 To Rand( MinMovingDistance, MaxMovingDistance )
				If PrevPosition.X + DX < 0 Or PrevPosition.X + DX >= Game.CollisionMap.XQuantity Or ..
						PrevPosition.Y + DY < 0 Or PrevPosition.Y + DY >= Game.CollisionMap.YQuantity Then Exit
						
				Local NextPosition:LTTileMapPosition = New LTTileMapPosition
				NextPosition.X = PrevPosition.X + DX
				NextPosition.Y = PrevPosition.Y + DY
				NextPosition.PrevPosition = PrevPosition
				PrevPosition.NextPosition = NextPosition
				PrevPosition = NextPosition
			Next
			
			Shape.AttachModel( TMovingAlongPath.Create( FirstPosition ) )
			DeactivateModel( Shape )
		End If
	End Method
End Type