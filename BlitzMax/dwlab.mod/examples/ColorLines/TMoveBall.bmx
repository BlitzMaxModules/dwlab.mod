'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TMoveBall Extends LTBehaviorModel
	Const Period:Double = 0.3
	Const Bump:Double = 0.4
	
	Field X:Int, Y:Int, DX:Int, DY:Int
	Field StartingTime:Double
	Field CheckLines:Int
	
	Function Create( X:Int, Y:Int, DX:Int, DY:Int, CheckLines:Int )
		Local Model:TMoveBall = New TMoveBall
		Model.X = X
		Model.Y = Y
		Model.DX = DX
		Model.DY = DY
		Model.StartingTime = Game.Time
		Model.CheckLines = CheckLines
		Profile.TileToSprite( Model, X, Y )
		Game.HiddenBalls[ X, Y ] = True
		Game.Locked = True
	End Function
	
	Method ApplyTo( Shape:LTShape )
		If Game.Time > StartingTime + Period Then
			Deactivate( Shape )
		Else
			Shape.PositionOnTileMap( Profile.GameField, X, Y )
			Local K:Double = ( Game.Time - StartingTime ) / Period
			Shape.AlterCoords( DX * K + DY * Sin( K * 180 ) * Bump, DY * K * 0.75 + DX * Sin( K * 180 ) * Bump )
		End If
	End Method
	
	Method Deactivate( Shape:LTShape )
		Game.CheckBall( Shape, X + DX, Y + DY, CheckLines )
	End Method
End Type