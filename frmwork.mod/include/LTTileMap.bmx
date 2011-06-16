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
	Field TileSet:LTTileset
	Field FrameMap:LTIntMap = New LTIntMap
	Field TilesQuantity:Int
	Field Wrapped:Int = False
	
	' ==================== Parameters ===================	
	
	Method GetCellWidth:Double()
			Return Width / FrameMap.XQuantity
	End Method

	
	
	Method GetCellHeight:Double()
		Return Height / FrameMap.YQuantity
	End Method
	
	
	
	Method GetTileCollisionShape:LTShape( TileX:Int, TileY:Int )
		Return Tileset.CollisionShape[ FrameMap.Value[ TileX, TileY ] ]
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
	
	' ==================== Other ===================	
	
	Method Enframe( ByTileset:LTTileset = Null )
		If Not ByTileset Then ByTileset = Tileset
		For Local Y:Int = 0 Until FrameMap.YQuantity
			For Local X:Int = 0 Until FrameMap.XQuantity
				ByTileset.Enframe( Self, X, Y )
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
	
	
	
	Method RefreshTilesQuantity()
		If Not TileSet Then Return
		If TileSet.TilesQuantity < TilesQuantity Then
			For Local Y:Int = 0 Until FrameMap.YQuantity
				For Local X:Int = 0 Until FrameMap.XQuantity
					If FrameMap.Value[ X, Y ] >= TileSet.TilesQuantity Then FrameMap.Value[ X, Y ] = TileSet.TilesQuantity - 1
				Next
			Next
		End If
		TilesQuantity = TileSet.TilesQuantity
	End Method
	
	' ==================== Creating ===================
	
	Function Create:LTTileMap( TileSet:LTTileSet, XQuantity:Int, YQuantity:Int )
		Local TileMap:LTTileMap = New LTTileMap
		TileMap.FrameMap = New LTIntMap
		TileMap.FrameMap.SetResolution( XQuantity, YQuantity )
		TileMap.TileSet = TileSet
		If TileSet Then TileMap.TilesQuantity = TileSet.TilesQuantity
		TileMap.Visualizer = New LTVisualizer
		Return TileMap
	End Function
	
	' ==================== Saving / loading ===================
	
	Method Clone:LTShape()
		Local NewTileMap:LTTileMap = New LTTileMap
		CopyTo( NewTileMap )
		Return NewTileMap
	End Method
	
	
	
	Method CopyTo( Shape:LTShape )
		Super.CopyTo( Shape )
		Local TileMap:LTTileMap = LTTileMap( Shape )
		
		?debug
		If Not TileMap Then L_Error( "Trying to copy tilemap ~q" + Shape.Name + "~q data to non-tilemap" )
		?
		
		TileMap.TileSet = TileSet
		TileMap.TilesQuantity = TilesQuantity
		TileMap.Wrapped = Wrapped
		TileMap.SetResolution( FrameMap.XQuantity, FrameMap.YQuantity )
		For Local Y:Int = 0 Until FrameMap.YQuantity
			For Local X:Int = 0 Until FrameMap.XQuantity
				TileMap.FrameMap.Value[ X, Y ] = FrameMap.Value[ X, Y ]
			Next
		Next
		TileMap.Visualizer = New LTVisualizer
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		FrameMap = LTIntMap( XMLObject.ManageObjectField( "framemap", FrameMap ) )
		TileSet = LTTileSet( XMLObject.ManageObjectField( "tileset", TileSet ) )
		XMLObject.ManageIntAttribute( "tiles-quantity", TilesQuantity )
		XMLObject.ManageIntAttribute( "wrapped", Wrapped )
	End Method
End Type