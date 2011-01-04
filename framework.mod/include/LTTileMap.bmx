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
	Field TileActor:LTActor[]
	Field TilesQuantity:Int
	Field Wrapped:Int = False
	
	' ==================== Parameters ===================	
	
	Method GetCellWidth:Float()
			Return Width / FrameMap.XQuantity
	End Method

	
	
	Method GetCellHeight:Float()
			Return Height / FrameMap.YQuantity
	End Method
	
	
	
	Method GetTile:LTActor( TileX:Int, TileY:Int )
		Local Template:LTActor = GetTileTemplate( TileX, TileY )
		Local Actor:LTActor = New Template
		Local CellWidth:Float = GetCellWidth()
		Local CellHeight:Float = GetCellHeight()
		Actor.X = ( Template.X + TileX ) * CellWidth + CornerX()
		Actor.Y = ( Template.Y + TileY ) * CellHeight + CornerY()
		Actor.Width = Template.Width * CellWidth
		Actor.Height = Template.Height * CellHeight
		Actor.Shape = Template.Shape
		Return Actor
	End Method
	
	
	
	Method GetTileTemplate:LTActor( TileX:Int, TileY:Int )
		Return TileActor[ FrameMap.Value[ TileX, TileY ] ]
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
		Local CellWidth:Float = GetCellWidth()
		Local CellHeight:Float = GetCellHeight()
				
		Select Actor.Shape
			Case L_Pivot
				Local X1:Int = Floor( ( Actor.X - X0 ) / CellWidth )
				Local Y1:Int = Floor( ( Actor.Y - Y0 ) / CellHeight )
				
				If X1 >= 0 And Y1 >= 0 And X1 < FrameMap.XQuantity And Y1 < FrameMap.YQuantity Then
					Local Actor2:LTActor = TileActor[ FrameMap.Value[ X1, Y1 ] ]
					If Actor2 Then
						Local DX:Float = X0 + CellWidth * X1
						Local DY:Float = Y0 + CellHeight * Y1
						If Actor.CollidesWithTile( Actor2, DX, DY, CellWidth, CellHeight ) Then Actor.HandleCollisionWithTile( Self, X1, Y1 )
					End If
				End If
			Case L_Circle, L_Rectangle
				Local X1:Int = L_LimitInt( Floor( ( Actor.X - 0.5 * Actor.Width - X0 ) / CellWidth ), 0, FrameMap.XQuantity )
				Local Y1:Int = L_LimitInt( Floor( ( Actor.Y - 0.5 * Actor.Height - Y0 ) / CellHeight ), 0, FrameMap.YQuantity )
				Local X2:Int = L_LimitInt( Floor( ( Actor.X + 0.5 * Actor.Width - X0 - 0.000001 ) / CellWidth ), 0, FrameMap.XQuantity - 1 )
				Local Y2:Int = L_LimitInt( Floor( ( Actor.Y + 0.5 * Actor.Height - Y0 - 0.000001 ) / CellHeight ), 0, FrameMap.YQuantity - 1 )
				
				For Local Y:Int = Y1 To Y2
					For Local X:Int = X1 To X2
						Local TileActor:LTActor = TileActor[ FrameMap.Value[ X, Y ] ]
						If TileActor Then
							If Actor.CollidesWithTile( TileActor, X0 + CellWidth * X, Y0 + CellHeight * Y, CellWidth, CellHeight ) Then Actor.HandleCollisionWithTile( Self, X, Y )
						End If
					Next
				Next
		End Select
	End Method
	
	' ==================== Creating ===================
	
	Function Create:LTTileMap( XQuantity:Int, YQuantity:Int, TileWidth:Int, TileHeight:Int, TilesQuantity:Int )
		Local TileMap:LTTileMap = New LTTileMap
		TileMap.FrameMap = New LTIntMap
		TileMap.FrameMap.SetResolution( XQuantity, YQuantity )
		TileMap.TileActor = New LTActor[ TilesQuantity ]
		Local Visualizer:LTImageVisualizer = New LTImageVisualizer
		Visualizer.Image = LTImage.Create( TileWidth, TileHeight, TilesQuantity )
		TileMap.Visualizer = New Visualizer
		Return TileMap
	End Function
	
	' ==================== Saving / loading ===================
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		FrameMap = LTIntMap( XMLObject.ManageObjectField( "framemap", FrameMap ) )
		XMLObject.ManageIntAttribute( "tiles-quantity", TilesQuantity )
		XMLObject.ManageIntAttribute( "wrapped", Wrapped )
		
		If L_XMLMode = L_XMLGet Then
			TileActor = New LTActor[ XMLObject.Children.Count() ]
			Local N:Int = 0
			For Local XMLObject:LTXMLObject = EachIn XMLObject.Children
				TileActor[ N ] = LTActor( XMLObject.ManageObject( Null ) )
				N :+ 1
			Next
		Else
			For Local Obj:LTObject = EachIn TileActor
				Local NewXMLObject:LTXMLObject = New LTXMLObject
				NewXMLObject.ManageObject( Obj )
				XMLObject.Children.AddLast( NewXMLObject )
			Next
		End If
	End Method
End Type