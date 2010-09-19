'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTSimpleTileMap Extends LTTileMap
	' ==================== Parameters ===================	
	
	Method GetCellXSize:Float()
		Return 1.0
	End Method
	
	
	
	Method GetCellYSize:Float()
		Return 1.0
	End Method
	
	
	
	Method GetTile:LTActor( TileX:Int, TileY:Int )
		Local Template:LTActor = GetTileTemplate( TileX, TileY )
		Local Actor:LTActor = New Template
		Actor.X = Template.X + TileX
		Actor.Y = Template.Y + TileY
		Actor.XSize = Template.XSize
		Actor.YSize = Template.YSize
		Actor.Shape = Template.Shape
		Return Actor
	End Method
	
	
	
	Method GetTileTemplate:LTActor( TileX:Int, TileY:Int )
		Return ActorArray[ FrameMap.Value[ TileX, TileY ] ]
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visual.DrawUsingSimpleTileMap( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
		Vis.DrawUsingSimpleTileMap( Self )
	End Method
	
	' ==================== Collisions ===================
	
	Method CollisionsWithActor( Actor:LTActor )
		Select Actor.Shape
			Case L_Pivot
				Local X:Int = Floor( Actor.X )
				Local Y:Int = Floor( Actor.Y )
				
				If X >= 0 And Y >= 0 And X < FrameMap.XQuantity And Y < FrameMap.YQuantity Then
					Local Actor2:LTActor = ActorArray[ FrameMap.Value[ X, Y ] ]
					If Actor2 Then
						If Actor.CollidesWithSimpleTile( Actor2, X, Y ) Then Actor.HandleCollisionWithTile( Self, X, Y )
					End If
				End If
			Case L_Circle, L_Rectangle
				Local X1:Int = L_LimitInt( Floor( Actor.X - 0.5 * Actor.XSize ), 0, FrameMap.XQuantity )
				Local Y1:Int = L_LimitInt( Floor( Actor.Y - 0.5 * Actor.YSize ), 0, FrameMap.YQuantity )
				Local X2:Int = L_LimitInt( Floor( Actor.X + 0.5 * Actor.XSize - 0.000001 ), 0, FrameMap.XQuantity - 1 )
				Local Y2:Int = L_LimitInt( Floor( Actor.Y + 0.5 * Actor.YSize - 0.000001 ), 0, FrameMap.YQuantity - 1 )
				
				For Local Y:Int = Y1 To Y2
					For Local X:Int = X1 To X2
						Local Actor2:LTActor = ActorArray[ FrameMap.Value[ X, Y ] ]
						If Actor2 Then
							If Actor.CollidesWithSimpleTile( Actor2, X, Y ) Then Actor.HandleCollisionWithTile( Self, X, Y )
						End If
					Next
				Next
		End Select
	End Method
	
	
	
	Method Update()
		XSize = FrameMap.XQuantity
		YSize = FrameMap.YQuantity
		X = 0.5 * XSize
		Y = 0.5 * YSize
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		FrameMap = LTIntMap( XMLObject.ManageObjectField( "framemap", FrameMap ) )
	End Method
End Type