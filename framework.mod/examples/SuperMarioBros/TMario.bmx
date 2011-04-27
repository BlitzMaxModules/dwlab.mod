'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TMario Extends TMovingObject
	Field MovingStartTime:Float
	Field OnLand:Int

	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		PushFromTile( TileMap, TileX, TileY )
		If CollisionType = L_Up Or CollisionType = L_Down Then DY = 0
		If CollisionType = L_Down Then OnLand = True
		If CollisionType = L_Up Then
			Local TileNum:Int = TileMap.FrameMap.Value[ TileX, TileY ]
			Select TileNum
				Case 10, 27
					Game.BreakBlockSound.Play()
					TBricks.FromTile( TileX, TileY, TileNum )
				Case 9, 11, 13, 16, 17, 18
					Game.BumpSound.Play()
					TBlock.FromTile( TileX, TileY, TileNum )
			End Select
		End If
	End Method
	
	
	
	Method Act()
		Local Direction:Float = 0.0
		If KeyDown( Key_Left ) Then Direction = -1.0
		If KeyDown( Key_Right ) Then Direction = 1.0
		
		If KeyDown( Key_Up ) And OnLand Then
			Game.JumpSound.Play()
			DY = -17.0
			Frame = 4
		ElseIf Direction = 0.0 Then 
			MovingStartTime = Game.Time
			Local DDX:Float = L_DeltaTime * 32.0
			If DDX < Abs( DX ) Then
				DX :- Sgn( DX ) * DDX
			Else
				DX = 0.0
			End If
			If OnLand Then Frame = 0
		Else
			If OnLand Then Animate( Game, 0.15, 3, 1, MovingStartTime )
			If Sgn( DX ) = Direction Then
				Visualizer.XScale = Direction
				'DX :+ Direction * L_DeltaTime * 8.0
				'If Abs( DX ) > 10.0 Then DX = Sgn( DX ) * 10.0
				DX = Direction * 5.0
			Else
				If OnLand Then Frame = 5
				DX :+ Direction * L_DeltaTime * 32.0
			End If
			'Move( 5.0 * Direction, 0.0 )
		End If
		
		DY :+ L_DeltaTime * 32.0
		
		MoveVertically()
		CollisionsWithTilemap( Game.Tilemap )
		CollisionsWithCollisionMap( Game.CollisionMap )
		
		MoveHorizontally()
		
		LimitWith( Game.MainLayer.FindTilemap() )
		
		L_CurrentCamera.JumpTo( Self )
		L_CurrentCamera.LimitWith( Game.MainLayer.FindTilemap() )
		
		OnLand = False
	End Method
End Type