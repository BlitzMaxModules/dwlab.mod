'
' Skeleton Slayer - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TPerson Extends LTAngularSprite
	Const TotalActionFrames:Int = 32

	Field TileX:Int, TileY:Int
	Field Phase:Int
	Field WalkingAnimationSpeed:Double = 0.5
	Field TileType:Int
	
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
	
	Method TileDistanceToPerson( Person:TPerson )
		Return Abs( Game.Player.TileX - TileX ) + Abs( Game.Player.TileY - TileY )
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