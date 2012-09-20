'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TMoveAlongPath Extends LTBehaviorModel
	Const Speed:Double = 10.0
	
	Field StartingTime:Double
	Field Position:LTTileMapPosition
	Field Pos:Double

	Function Create( Position:LTTileMapPosition, TileX:Int, TileY:Int )
		If Position = Null Then
			L_CurrentProfile.PlaySnd( Game.WrongTurnSound )
			Return
		End If
		Local Model:TMoveAlongPath = New TMoveAlongPath
		Model.StartingTime = Game.Time
		Model.Position = Position
		Game.Locked = True
		Profile.TileToSprite( Model, Position.X, Position.Y, False )
		Profile.Balls.SwapTiles( TileX, TileY, Game.Selected.X, Game.Selected.Y )
		Profile.Modifiers.SwapTiles( TileX, TileY, Game.Selected.X, Game.Selected.Y )
		Game.HiddenBalls[ TileX, TileY ] = True
		Game.Selected = Null
		L_CurrentProfile.PlaySnd( Game.RushSound )
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Pos:Double = ( Game.Time - StartingTime ) * Speed + 0.5
		'DebugStop
		If Not Position.NextPosition And Pos > 0.5 Then
			Pos = 0.5
		Else
			While Pos >= 1.0
				If Not Position.NextPosition Then
					Pos = 0.5
					Exit
				End If
				Position = Position.NextPosition
				StartingTime :+ 1.0 / Speed
				Pos :- 1.0
			Wend
		End If
		Local PrevPosition:LTTileMapPosition = Position.PrevPosition
		Local NextPosition:LTTileMapPosition = Position.NextPosition
		If PrevPosition = Null Then
			Shape.PositionOnTileMap( Profile.Balls, Position.X + ( NextPosition.X - Position.X ) * ( Pos - 0.5 ), ..
					Position.Y+ ( NextPosition.Y- Position.Y) * ( Pos - 0.5 ) )
		ElseIf NextPosition = Null Then
			Shape.PositionOnTileMap( Profile.Balls, PrevPosition.X + ( Position.X - PrevPosition.X ) * ( Pos + 0.5 ), ..
					PrevPosition.Y+ ( Position.Y- PrevPosition.Y) * ( Pos + 0.5 ) )
		ElseIf Abs( Position.PrevPosition.X - Position.NextPosition.X ) And Abs( Position.PrevPosition.Y - Position.NextPosition.Y ) Then
			Local CenterX:Double = 0.5 * ( PrevPosition.X + NextPosition.X )
			Local CenterY:Double = 0.5 * ( PrevPosition.Y + NextPosition.Y )
			Local StartingAngle:Double = ATan2( 0.5 * ( Position.Y + PrevPosition.Y ) - CenterY, 0.5 * ( Position.X + PrevPosition.X ) - CenterX )
			Local FinalAngle:Double = StartingAngle
			If PrevPosition.X = Position.X Then
				FinalAngle :- 90 * Sgn( Position.Y - PrevPosition.Y ) * Sgn( NextPosition.X - Position.X )
			Else
				FinalAngle :+ 90 * Sgn( Position.X - PrevPosition.X ) * Sgn( NextPosition.Y - Position.Y )
			End If
			Local Angle:Double = StartingAngle + ( FinalAngle - StartingAngle ) * Pos
			Shape.PositionOnTileMap( Profile.Balls, CenterX + 0.5 * Cos( Angle ), CenterY + 0.5 * Sin( Angle ) )
		Else
			Shape.PositionOnTileMap( Profile.Balls, PrevPosition.X + ( NextPosition.X - PrevPosition.X ) * ( 0.5 * Pos + 0.25 ), ..
					PrevPosition.Y+ ( NextPosition.Y- PrevPosition.Y) * ( 0.5 * Pos + 0.25 ) )
		End If
		If Not Position.NextPosition And Pos >= 0.5 Then DeactivateModel( Shape )
	End Method
	
	Method Deactivate( Shape:LTShape )
		L_CurrentProfile.PlaySnd( Game.StopSound )
		
		Game.CheckBall( Shape, Position.X, Position.Y, True )
	End Method
End Type
