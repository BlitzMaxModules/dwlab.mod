'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTTileMap Extends LTShape
	Field FrameMap:LTIntMap = New LTIntMap
	Field TileShape:LTShape[]
	Field TilesQuantity:Int
	Field Wrapped:Int = False
	
	' ==================== Parameters ===================	
	
	Method GetCellWidth:Float()
			Return Width / FrameMap.XQuantity
	End Method

	
	
	Method GetCellHeight:Float()
		Return Height / FrameMap.YQuantity
	End Method
	
	
	
	Method GetTileTemplate:LTShape( TileX:Int, TileY:Int )
		Return TileShape[ FrameMap.Value[ TileX, TileY ] ]
	End Method
	
	
	
	Method SetResolution( NewXQuantity:Int, NewYQuantity:Int )
		FrameMap.SetResolution( NewXQuantity, NewYQuantity )
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw()
		If Visible Then Visualizer.DrawUsingTileMap( Self )
	End Method
	
	
	
	Method DrawUsingVisualizer( Visizer:LTVisualizer )
		If Visible Then Visizer.DrawUsingTileMap( Self )
	End Method
	
	' ==================== Collisions ===================
		
	Method GetTileCollisionType:Int( Shape:LTShape, TileX:Float, TileY:Float )
		Local DX:Float = Shape.X - TileX
		Local DY:Float = Shape.Y - TileY
		If Abs( DX ) > Abs( DY ) Then
			If DX < 0 Then Return L_Left Else Return L_Right
		Else	
			If DY < 0 Then Return L_Up Else Return L_Down
		End If
	End Method
	
	
	
	Method TileCollisionsWithGroup( Group:LTGroup )
		For Local Shape:LTShape = Eachin Group
			Local Sprite:LTSprite = LTSprite( Shape )
			If Sprite Then
				TileCollisionsWithSprite( Sprite )
			Else
				Local ChildGroup:LTGroup = LTGroup( Shape )
				If ChildGroup Then TileCollisionsWithGroup( ChildGroup )
			End If
		Next
	End Method
	
	
	
	Method TileCollisionsWithSprite( Sprite:LTSprite )
		Local X0:Float = CornerX()
		Local Y0:Float = CornerY()
		Local CellWidth:Float = GetCellWidth()
		Local CellHeight:Float = GetCellHeight()
				
		Select Sprite.ShapeType
			Case L_Pivot
				Local X1:Int = Floor( ( Sprite.X - X0 ) / CellWidth )
				Local Y1:Int = Floor( ( Sprite.Y - Y0 ) / CellHeight )
				
				If X1 >= 0 And Y1 >= 0 And X1 < FrameMap.XQuantity And Y1 < FrameMap.YQuantity Then
					Local Shape:LTShape = TileShape[ FrameMap.Value[ X1, Y1 ] ]
					If Shape Then
						Local TileX:Float = X0 + CellWidth * X1
						Local TileY:Float = Y0 + CellHeight * Y1
						If Shape.TileCollidesWithSprite( Sprite, TileX, TileY, CellWidth, CellHeight ) Then Sprite.HandleCollisionWithTile( Self, X1, Y1, GetTileCollisionType( Sprite, Shape.X * CellWidth + TileX, Shape.Y * CellHeight + TileY ) )
					End If
				End If
			Case L_Circle, L_Rectangle
				Local X1:Int = L_LimitInt( Floor( ( Sprite.X - 0.5 * Sprite.Width - X0 ) / CellWidth ), 0, FrameMap.XQuantity )
				Local Y1:Int = L_LimitInt( Floor( ( Sprite.Y - 0.5 * Sprite.Height - Y0 ) / CellHeight ), 0, FrameMap.YQuantity )
				Local X2:Int = L_LimitInt( Floor( ( Sprite.X + 0.5 * Sprite.Width - X0 - 0.000001 ) / CellWidth ), 0, FrameMap.XQuantity - 1 )
				Local Y2:Int = L_LimitInt( Floor( ( Sprite.Y + 0.5 * Sprite.Height - Y0 - 0.000001 ) / CellHeight ), 0, FrameMap.YQuantity - 1 )
				
				For Local Y:Int = Y1 To Y2
					For Local X:Int = X1 To X2
						Local Shape:LTShape = TileShape[ FrameMap.Value[ X, Y ] ]
						If Shape Then
							Local TileX:Float = X0 + CellWidth * X
							Local TileY:Float =Y0 + CellHeight * Y
							If Shape.TileCollidesWithSprite( Sprite, TileX, TileY, CellWidth, CellHeight ) Then
								Sprite.HandleCollisionWithTile( Self, X, Y, GetTileCollisionType( Sprite, Shape.X * CellWidth + TileX, Shape.Y * CellHeight + TileY ) )
							End If
						End If
					Next
				Next
		End Select
	End Method
	
	' ==================== Enframing ===================	
	
	Method EnframeBy( Tileset:LTTileset )
		For Local Y:Int = 0 Until FrameMap.YQuantity
			For Local X:Int = 0 Until FrameMap.XQuantity
				Tileset.Enframe( Self, X, Y )
			Next
		Next
	End Method
	
	' ==================== Creating ===================
	
	Function Create:LTTileMap( XQuantity:Int, YQuantity:Int, TileWidth:Int, TileHeight:Int, TilesQuantity:Int )
		Local TileMap:LTTileMap = New LTTileMap
		TileMap.FrameMap = New LTIntMap
		TileMap.FrameMap.SetResolution( XQuantity, YQuantity )
		TileMap.TileShape = New LTShape[ TilesQuantity ]
		Local Visualizer:LTImageVisualizer = New LTImageVisualizer
		Visualizer.Image = LTImage.Create( TileWidth, TileHeight, TilesQuantity )
		TileMap.Visualizer = New Visualizer
		Return TileMap
	End Function
	
	' ==================== Saving / loading ===================
	
	Method Clone:LTShape()
		Local NewTileMap:LTTileMap = New LTTileMap
		CopyShapeTo( NewTileMap )
		NewTileMap.TileShape = TileShape
		NewTileMap.TilesQuantity = TilesQuantity
		NewTileMap.Wrapped = Wrapped
		NewTileMap.SetResolution( FrameMap.XQuantity, FrameMap.YQuantity )
		For Local Y:Int = 0 Until FrameMap.YQuantity
			For Local X:Int = 0 Until FrameMap.XQuantity
				NewTileMap.FrameMap.Value[ X, Y ] = FrameMap.Value[ X, Y ]
			Next
		Next
		Return NewTileMap
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		FrameMap = LTIntMap( XMLObject.ManageObjectField( "framemap", FrameMap ) )
		XMLObject.ManageIntAttribute( "tiles-quantity", TilesQuantity )
		XMLObject.ManageIntAttribute( "wrapped", Wrapped )
		
		If L_XMLMode = L_XMLGet Then
			TileShape = New LTSprite[ TilesQuantity ]
			Local N:Int = 0
			For Local ChildXMLObject:LTXMLObject = EachIn XMLObject.Children
				TileShape[ N ] = LTShape( ChildXMLObject.ManageObject( Null ) )
				N :+ 1
			Next
		Else
			For Local Obj:LTObject = EachIn TileShape
				Local NewXMLObject:LTXMLObject = New LTXMLObject
				NewXMLObject.ManageObject( Obj )
				XMLObject.Children.AddLast( NewXMLObject )
			Next
		End If
	End Method
End Type