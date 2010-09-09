'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTTileMap Extends LTActor
	Field FrameMap:LTIntMap
	Field ActorMap:LTActor[ , ]
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visual.DrawUsingTileMap( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
		Vis.DrawUsingTileMap( Self )
	End Method
	
	' ==================== Collisions ===================
	
	Method CollidesWithActor:Int( Actor:LTActor )
		Select Actor.Shape
			Case L_Pivot
				Local RX:Float = X - 0.5 * XSize
				Local RY:Float = Y - 0.5 * YSize
				Local CellXSize:Float = XSize / FrameMap.XQuantity
				Local CellYSize:Float = YSize / FrameMap.YQuantity
				Local X1:Int = Int( ( Actor.X - RX ) / CellXSize )
				Local Y1:Int = Int( ( Actor.Y - RY ) / CellYSize )
				
				If X1 >= 0 And Y1 >= 0 And X1 < FrameMap.XQuantity And Y1 < FrameMap.YQuantity Then
					Local Actor2:LTActor = ActorMap[ X1, Y1 ]
					If Actor2 Then
						Local Collision:Int = Actor.CollidesWithActor( Actor2 )
						If Collision Then
							Actor.HandleCollision( Actor2 )
							Actor2.HandleCollision( Actor )
						End If
						Return Collision
					End If
				End If
			Case L_Circle, L_Rectangle
				Local RX:Float = X - 0.5 * XSize
				Local RY:Float = Y - 0.5 * YSize
				Local CellXSize:Float = XSize / FrameMap.XQuantity
				Local CellYSize:Float = YSize / FrameMap.YQuantity
				Local X1:Int = L_LimitInt( Int( ( Actor.X - 0.5 * Actor.XSize - RX ) / CellXSize ), 0, FrameMap.XQuantity )
				Local Y1:Int = L_LimitInt( Int( ( Actor.Y - 0.5 * Actor.YSize - RY ) / CellYSize ), 0, FrameMap.YQuantity )
				Local X2:Int = L_LimitInt( Int( ( Actor.X + 0.5 * Actor.XSize - RX ) / CellXSize ), 0, FrameMap.XQuantity - 1 )
				Local Y2:Int = L_LimitInt( Int( ( Actor.Y + 0.5 * Actor.YSize - RY ) / CellYSize ), 0, FrameMap.YQuantity - 1 )
				
				Local Collided:Int = False
				For Local Y:Int = Y1 To Y2
					For Local X:Int = X1 To X2
						Local Actor2:LTActor = ActorMap[ X, Y ]
						If Actor2 Then
							Local Collision:Int = Actor.CollidesWithActor( Actor2 )
							If Collision Then
								Actor.HandleCollision( Actor2 )
								Actor2.HandleCollision( Actor )
								Collided = True
							End If
						End If
					Next
				Next
				Return Collided
		End Select
	End Method
	
	
	
	Method FillShapeMap( ActorArray:LTActor[] )
		Local CellXSize:Float = XSize / FrameMap.XQuantity
		Local CellYSize:Float = YSize / FrameMap.YQuantity
		Local DX:Float = X - 0.5 * XSize' + 0.5 * CellXSize
		Local DY:Float = Y - 0.5 * YSize' + 0.5 * CellYSize
	
		ActorMap = New LTActor[ FrameMap.XQuantity, FrameMap.YQuantity ]
		For Local Y:Int = 0 Until FrameMap.YQuantity
			For Local X:Int = 0 Until FrameMap.XQuantity
				Local Actor:LTActor = ActorArray[ FrameMap.Value[ X, Y ] ]
				If Actor Then
					ActorMap[ X, Y ] = Actor.CloneActor( DX + CellXSize * X, DY + CellYSize * Y, CellXSize, CellYSize )
					ActorMap[ X, Y ].SetMass( -1.0 )
				End If
			Next
		Next
	End Method
End Type