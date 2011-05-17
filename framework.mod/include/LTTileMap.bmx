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
		
	Method TileCollisionsWithSprite( Sprite:LTSprite )
	End Method
	
	' ==================== Other ===================	
	
	Method EnframeBy( Tileset:LTTileset )
		For Local Y:Int = 0 Until FrameMap.YQuantity
			For Local X:Int = 0 Until FrameMap.XQuantity
				Tileset.Enframe( Self, X, Y )
			Next
		Next
	End Method
	
	
	
	Method GetTile:Int( TileX:Int, TileY:Int )
		?debug
		If TileX < 0 Or TileX >= FrameMap.XQuantity Then L_Error( "Incorrect tile X position" )
		If TileY < 0 Or TileY >= FrameMap.YQuantity Then L_Error( "Incorrect tile Y position" )
		?
		Return FrameMap.Value[ TileX, TileY ]
	End Method
	
	
	
	Method SetTile( TileX:Int, TileY:Int, TileNum:Int )
		?debug
		If TileNum < 0 Or TileNum >= TilesQuantity Then L_Error( "Incorrect tile number" )
		If TileX < 0 Or TileX >= FrameMap.XQuantity Then L_Error( "Incorrect tile X position" )
		If TileY < 0 Or TileY >= FrameMap.YQuantity Then L_Error( "Incorrect tile Y position" )
		?
		FrameMap.Value[ TileX, TileY ] = TileNum
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
		CopyTileMapTo( NewTileMap )
		Return NewTileMap
	End Method
	
	
	
	Method CopyTileMapTo( TileMap:LTTileMap )
		CopyShapeTo( TileMap )
		TileMap.TileShape = TileShape
		TileMap.TilesQuantity = TilesQuantity
		TileMap.Wrapped = Wrapped
		TileMap.SetResolution( FrameMap.XQuantity, FrameMap.YQuantity )
		For Local Y:Int = 0 Until FrameMap.YQuantity
			For Local X:Int = 0 Until FrameMap.XQuantity
				TileMap.FrameMap.Value[ X, Y ] = FrameMap.Value[ X, Y ]
			Next
		Next
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