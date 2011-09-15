'
' Skeleton Slayer - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TPlayer.bmx"
Include "TSkeleton.bmx"

Type TPerson Extends LTAngularSprite
	Const TotalActionFrames:Int = 26

	Field TileX:Int, TileY:Int
	Field Phase:Int
	Field WalkingAnimationSpeed:Double = 0.5
	Field TileType:Int
	Field Health:Int
	Field MaxSearchDistance:Int
	
	Method Init()
		TileX = Floor( X )
		TileY = Floor( Y )
		Game.CollisionMap.Value[ TileX, TileY ] = TileType
		AttachModel( New TStanding )
	End Method
	
	Method Act()
		Super.Act()
		Frame = ( Frame Mod TotalActionFrames ) + TotalActionFrames * Phase
	End Method
	
	Method RecalculatePath( Model:TMovingAlongPath )
	End Method
	
	Method IsNear:Int( Person:TPerson )
		Return Abs( Person.TileX - TileX ) <= 1 And Abs( Person.TileY - TileY ) <= 1
	End Method
End Type



Type TStanding Extends LTBehaviorModel
	Const AnimationStart:Int = 0
	Const AnimationSize:Int = 4
	Const AnimationSpeed:Double = 0.3
	
	Field StartingTime:Int
	
	Method Activate( Shape:LTShape )
		StartingTime = Game.Time
	End Method
	
	Method ApplyTo( Shape:LTShape )
		LTSprite( Shape ).Animate( Game, AnimationSpeed, AnimationSize, AnimationStart, StartingTime, True )
	End Method
End Type



Type TMovingAlongPath Extends LTBehaviorModel
	Const AnimationStart:Int = 4
	Const AnimationSize:Int = 8
	
	Field StartingTime:Int
	Field Position:LTTileMapPosition
	
	Function Create:TMovingAlongPath( FirstPosition:LTTileMapPosition )
		Local Model:TMovingAlongPath = New TMovingAlongPath
		Model.Position = FirstPosition
		Return Model
	End Function
	
	Method Activate( Shape:LTShape )
		RemoveSame( Shape )
		Shape.RemoveModel( "TStanding" )
		StartingTime = Game.Time
	End Method

	Method ApplyTo( Shape:LTShape )
		If Position Then
			Local Person:TPerson = TPerson( Shape )
			
			Local PosX:Double = 0.5 + Person.TileX
			Local PosY:Double = 0.5 + Person.TileY
			If Person.X = PosX And Person.Y = PosY Then
				Position = Position.NextPosition
				If Position Then
					If Game.CollisionMap.Value[ Position.X, Position.Y ] <> Game.EmptyTile Then
						Person.RecalculatePath( Self )
					Else
						Game.CollisionMap.Value[ Person.TileX, Person.TileY ] = Game.EmptyTile
						Person.TileX = Position.X
						Person.TileY = Position.Y
						Game.CollisionMap.Value[ Person.TileX, Person.TileY ] = Person.TileType
					End If
				End If
				Local Follow:TFollow = TFollow( Person.FindModel( "TFollow" ) )
				If Follow Then If Follow.Active Then Follow.Activate( Person )
			Else
				Person.Phase = ( 5 + L_Round( Person.DirectionToPoint( PosX, PosY ) / 45.0 ) ) Mod 8
				Person.MoveTowardsPoint( PosX, PosY, Person.Velocity )
			End If
			Person.Animate( Game, Person.WalkingAnimationSpeed / Person.Velocity, AnimationSize, AnimationStart, StartingTime )
		Else
			Remove( Shape )
		End If
	End Method
	
	Method Deactivate( Shape:LTShape )
		Shape.AttachModel( New TStanding )
		Shape.ActivateModel( "TWander" )
	End Method
End Type



Type TFollow Extends LTBehaviorModel
	Const SeekingRange:Double = 10.0
	
	Field Opponent:TPerson
	
	Function Create:TFollow( Opponent:TPerson )
		Local Follow:TFollow = New TFollow
		Follow.Opponent = Opponent
		Return Follow
	End Function
	
	Method Watch( Shape:LTShape )
		Local Person:TPerson = TPerson( Shape )
		If Person.DistanceTo( Opponent ) <= SeekingRange And Not Person.IsNear( Opponent ) Then ActivateModel( Shape )
	End Method
	
	Method Activate( Shape:LTShape )
		Local Person:TPerson = TPerson( Shape )
		Local Model:TMovingAlongPath = TMovingAlongPath( Shape.FindModel( "TMovingAlongPath" ) )
		Local Position:LTTileMapPosition = Game.PathFinder.FindPath( Person.TileX, Person.TileY, Opponent.TileX, Opponent.TileY, True, Person.MaxSearchDistance )
		If Model Then
			Model.Position = Position
		Else
			Person.AttachModel( TMovingAlongPath.Create( Position ) )
		End If
	End Method
	
	Method ApplyTo( Shape:LTShape )
		Local Person:TPerson = TPerson( Shape )
		If Person.DistanceTo( Game.Player ) > SeekingRange Or Person.IsNear( Opponent ) Then DeactivateModel( Shape )
	End Method
End Type



Type TFight Extends LTBehaviorModel
	Const AnimationStart:Int = 12
	Const AnimationSize:Int = 4
	Const AnimationSpeed:Double = 0.1
	
	Field Opponent:TPerson
	Field StartingTime:Double
	Field NextHitTime:Double
	
	Function Create:TFight( Opponent:TPerson )
		Local Fight:TFight = New TFight
		Fight.Opponent = Opponent
		Return Fight
	End Function
	
	Method Watch( Shape:LTShape )
		If TPerson( Shape ).IsNear( Opponent ) And Not Shape.FindModel( "TMovingAlongPath" ) Then ActivateModel( Shape )
	End Method
	
	Method Activate( Shape:LTShape )
		StartingTime = Game.Time
		NextHitTime = StartingTime + AnimationSpeed * 2
		Shape.DeactivateModel( "TWander" )
		Shape.DeactivateModel( "TStanding" )
	End Method

	Method ApplyTo( Shape:LTShape )
		Local Person:TPerson = TPerson( Shape )
		If Person.IsNear( Opponent ) Then
			Person.Phase = ( 5 + L_Round( Person.DirectionToPoint( Opponent.X, Opponent.Y ) / 45.0 ) ) Mod 8
			Person.Animate( Game, AnimationSpeed, AnimationSize, AnimationStart, StartingTime, True )
			If Game.Time > NextHitTime Then
				TMessage.ApplyDamage( Opponent )
				If Opponent = Game.Player Then If Not Opponent.FindModel( "TFight" ) Then Opponent.AttachModel( TFight.Create( Person ) )
				If Opponent.Health <= 0 Then
					Opponent.RemoveModel( "TFight" )
					If Opponent = Game.Player Then
						For Local Skeleton:TPerson = Eachin Game.Objects
							Skeleton.RemoveModel( "TFollow" )
							Skeleton.RemoveModel( "TFight" )
						Next
					Else
						Person.RemoveModel( "TFight" )
					End If
				End If
				NextHitTime :+ AnimationSpeed * ( AnimationSize * 2 - 2 )
			End If
		Else
			DeactivateModel( Shape )
		End If
	End Method
	
	Method Deactivate( Shape:LTShape )
		Shape.ActivateModel( "TWander" )
		Shape.ActivateModel( "TStanding" )
	End Method
End Type



Type TDeath Extends LTBehaviorModel
	Const AnimationStart:Int = 16
	Const AnimationSize:Int = 6
	Const AnimationSpeed:Double = 0.2

	Field StartingTime:Double
	
	Method Activate( Shape:LTShape )
		StartingTime = Game.Time
	End Method
	
	Method ApplyTo( Shape:LTShape )
		Local Person:TPerson = TPerson( Shape )
		Person.Animate( Game, AnimationSpeed, AnimationSize, AnimationStart, StartingTime )
		If Person.Frame = AnimationStart + AnimationSize - 1 Then DeactivateModel( Shape )
	End Method
	
	Method Deactivate( Shape:LTShape )
		Local Person:TPerson = TPerson( Shape )
		Game.Level.Remove( Person )
		Game.Bodies.InsertSprite( Person )
		Game.CollisionMap.Value[ Person.TileX, Person.TileY ] = Game.EmptyTile
		Person.Active = False
	End Method
End Type