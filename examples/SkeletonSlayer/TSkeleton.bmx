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
		AttachModel( New TWander )
		AttachModel( New TFollow )
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



Type TFollow Extends LTBehaviorModel
	Const SeekingRange:Double = 10.0
	Const PathFinderPeriod:Double = 0.1
	Const MaxSearchDistance:Int = 20
	
	Field LastSearchTime:Double
	
	Method ApplyTo( Shape:LTShape )
		Local Person:TPerson = TPerson( Shape )
		If Game.Time > LastSearchTime + PathFinderPeriod Then
			If Person.DistanceTo( Game.Player ) <= SeekingRange And Person.TileDistanceToPerson( Game.Player ) > 1 Then
				Shape.FindModel( "TMovingAlongPath" )
				Shape.AttachModel( .Create( Game.PathFinder.FindPath( Person.TileX, Person.TileY, Game.Player.TileX, Game.Player.TileY, True, MaxSearchDistance ) ) )
				LastSearchTime = Game.Time
			End If
		End If
	End Method
End Type



Type TFight Extends LTBehaviorModel
	Const AnimationStart:Int = 12
	Const AnimationSize:Int = 4
	Const AnimationSpeed:Double = 0.3
	
	Field Opponent:TPerson
	Field StartingTime:Double
	
	Method Create:TFight( Opponent:TPerson )
		Local Fight:TFight = New TFight
		Fight.Opponent = Opponent
		Return Fight
	End Method
	
	Method Activate( Shape:LTShape )
		StartingTime = Game.Time
	End Method

	Method ApplyTo( Shape:LTShape )
		Local Person:TPerson = TPerson( Shape )
		If Person.TileDistanceToPerson( Opponent ) > 1 Then
			DeactivateModel( Shape )
		Else
			Person.Animate( Game, AnimationSpeed, AnimationSize, AnimationStart, StartingTime, True )
		End If
	End Method
End Type