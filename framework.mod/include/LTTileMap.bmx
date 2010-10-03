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
	Field ActorArray:LTActor[]
	Field Wrapped:Int = False
	
	' ==================== Parameters ===================	
	
	Method GetCellXSize:Float()
			Return XSize / FrameMap.XQuantity
	End Method

	
	
	Method GetCellYSize:Float()
			Return YSize / FrameMap.YQuantity
	End Method
	
	
	
	Method GetTile:LTActor( TileX:Int, TileY:Int )
		Local Template:LTActor = GetTileTemplate( TileX, TileY )
		Local Actor:LTActor = New Template
		Local CellXSize:Float = GetCellXSize()
		Local CellYSize:Float = GetCellYSize()
		Actor.X = ( Template.X + TileX ) * CellXSize + CornerX()
		Actor.Y = ( Template.Y + TileY ) * CellYSize + CornerY()
		Actor.XSize = Template.XSize * CellXSize
		Actor.YSize = Template.YSize * CellYSize
		Actor.Shape = Template.Shape
		Return Actor
	End Method
	
	
	
	Method GetTileTemplate:LTActor( TileX:Int, TileY:Int )
		Return ActorArray[ FrameMap.Value[ TileX, TileY ] ]
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visualizer.DrawUsingTileMap( Self )
	End Method
	
	
	
	Method DrawUsingVisualizer( Visizer:LTVisualizer )
		Visizer.DrawUsingTileMap( Self )
	End Method
	
	' ==================== Collisions ===================
	
	Method CollisionsWithActor( Actor:LTActor )
		Local X0:Float = CornerX()
		Local Y0:Float = CornerY()
		Local CellXSize:Float = GetCellXSize()
		Local CellYSize:Float = GetCellYSize()
				
		Select Actor.Shape
			Case L_Pivot
				Local X1:Int = Floor( ( Actor.X - X0 ) / CellXSize )
				Local Y1:Int = Floor( ( Actor.Y - Y0 ) / CellYSize )
				
				If X1 >= 0 And Y1 >= 0 And X1 < FrameMap.XQuantity And Y1 < FrameMap.YQuantity Then
					Local Actor2:LTActor = ActorArray[ FrameMap.Value[ X1, Y1 ] ]
					If Actor2 Then
						Local DX:Float = X0 + CellXSize * X1
						Local DY:Float = Y0 + CellYSize * Y1
						If Actor.CollidesWithTile( Actor2, DX, DY, CellXSize, CellYSize ) Then Actor.HandleCollisionWithTile( Self, X1, Y1 )
					End If
				End If
			Case L_Circle, L_Rectangle
				Local X1:Int = L_LimitInt( Floor( ( Actor.X - 0.5 * Actor.XSize - X0 ) / CellXSize ), 0, FrameMap.XQuantity )
				Local Y1:Int = L_LimitInt( Floor( ( Actor.Y - 0.5 * Actor.YSize - Y0 ) / CellYSize ), 0, FrameMap.YQuantity )
				Local X2:Int = L_LimitInt( Floor( ( Actor.X + 0.5 * Actor.XSize - X0 - 0.000001 ) / CellXSize ), 0, FrameMap.XQuantity - 1 )
				Local Y2:Int = L_LimitInt( Floor( ( Actor.Y + 0.5 * Actor.YSize - Y0 - 0.000001 ) / CellYSize ), 0, FrameMap.YQuantity - 1 )
				
				For Local Y:Int = Y1 To Y2
					For Local X:Int = X1 To X2
						Local TileActor:LTActor = ActorArray[ FrameMap.Value[ X, Y ] ]
						If TileActor Then
							If Actor.CollidesWithTile( TileActor, X0 + CellXSize * X, Y0 + CellYSize * Y, CellXSize, CellYSize ) Then Actor.HandleCollisionWithTile( Self, X, Y )
						End If
					Next
				Next
		End Select
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		FrameMap = LTIntMap( XMLObject.ManageObjectField( "framemap", FrameMap ) )
	End Method
End Type