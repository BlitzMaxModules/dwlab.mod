'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTTileMap Extends LTIntMap
	Field TileSet:LTTileset
	Field TilesQuantity:Int
	Field Wrapped:Int = False
	
	' ==================== Parameters ===================	
	
	Method GetCellWidth:Double()
			Return Width / XQuantity
	End Method

	
	
	Method GetCellHeight:Double()
		Return Height / YQuantity
	End Method
	
	
	
	Method GetTileCollisionShape:LTShape( TileX:Int, TileY:Int )
		Return Tileset.CollisionShape[ Value[ TileX, TileY ] ]
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw()
		If Visible Then Visualizer.DrawUsingTileMap( Self )
	End Method
	
	
	
	Method DrawUsingVisualizer( Visualizer:LTVisualizer )
		If Visible Then Visualizer.DrawUsingTileMap( Self )
	End Method
	
	' ==================== Other ===================	
	
	Method Enframe( ByTileSet:LTTileset = Null )
		If Not ByTileSet Then ByTileSet = TileSet
		For Local Y:Int = 0 Until YQuantity
			For Local X:Int = 0 Until XQuantity
				ByTileSet.Enframe( Self, X, Y )
			Next
		Next
	End Method
	
	
	
	Method GetTile:Int( TileX:Int, TileY:Int )
		?debug
		If TileX < 0 Or TileX >= XQuantity Then L_Error( "Incorrect tile X position" )
		If TileY < 0 Or TileY >= YQuantity Then L_Error( "Incorrect tile Y position" )
		?
		Return Value[ TileX, TileY ]
	End Method
	
	
	
	Method SetTile( TileX:Int, TileY:Int, TileNum:Int )
		?debug
		If TileNum < 0 Or TileNum >= TilesQuantity Then L_Error( "Incorrect tile number" )
		If TileX < 0 Or TileX >= XQuantity Then L_Error( "Incorrect tile X position" )
		If TileY < 0 Or TileY >= YQuantity Then L_Error( "Incorrect tile Y position" )
		?
		Value[ TileX, TileY ] = TileNum
	End Method
	
	
	
	Method RefreshTilesQuantity()
		If Not TileSet Then Return
		If TileSet.TilesQuantity < TilesQuantity Then
			For Local Y:Int = 0 Until YQuantity
				For Local X:Int = 0 Until XQuantity
					If Value[ X, Y ] >= TileSet.TilesQuantity Then Value[ X, Y ] = TileSet.TilesQuantity - 1
				Next
			Next
		End If
		TilesQuantity = TileSet.TilesQuantity
	End Method
	
	' ==================== Creating ===================
	
	Function Create:LTTileMap( TileSet:LTTileSet, XQuantity:Int, YQuantity:Int )
		Local TileMap:LTTileMap = New LTTileMap
		TileMap.SetResolution( XQuantity, YQuantity )
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
		TileMap.SetResolution( XQuantity, YQuantity )
		For Local Y:Int = 0 Until YQuantity
			For Local X:Int = 0 Until XQuantity
				TileMap.Value[ X, Y ] = Value[ X, Y ]
			Next
		Next
		TileMap.Visualizer = New LTVisualizer
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		TileSet = LTTileSet( XMLObject.ManageObjectField( "tileset", TileSet ) )
		XMLObject.ManageIntAttribute( "tiles-quantity", TilesQuantity )
		XMLObject.ManageIntAttribute( "wrapped", Wrapped )
	End Method
End Type