'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Tilemap is displayable rectangular tile-based shape with 2d array of tile indexes and tileset with tile images.
End Rem
Type LTTileMap Extends LTIntMap
	Rem
	bbdoc: Tilemap's default tileset.
	about: See also: #LTTileSet
	End Rem
	Field TileSet:LTTileset
	
	Rem
	bbdoc: Tiles quantity of tilemap.
	about: All map tile indexes should be in 0...TilesQuantity - 1 interval.
	End Rem
	Field TilesQuantity:Int
	
	Rem
	bbdoc: Wrapping flag.
	about: If this flag will be set to True, then map will be repeated (tiled, wrapped) enlessly in all directions.
	End Rem
	Field Wrapped:Int = False
	
	' ==================== Parameters ===================	
	
	Rem
	bbdoc: Returns tilemap tile width.
	returns: Tile width of the tilemap in units.
	about: See also: #GetTileHeight
	End Rem
	Method GetTileWidth:Double()
			Return Width / XQuantity
	End Method

	
	
	Rem
	bbdoc: Returns tilemap tile height.
	returns: Tile height of the tilemap in units.
	End Rem
	Method GetTileHeight:Double()
		Return Height / YQuantity
	End Method
	
	
	
	Rem
	bbdoc: Returns tile collision shape.
	returns: Tile collision shape of tilemap's tile with given coordinates using default tilemap tileset.
	End Rem
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
	
	
	
	Method DrawIsoTile( X:Double, Y:Double, TileX:Int, TileY:Int )
		Local TileValue:Int = Value[ TileX, TileY ]
		If TileValue = TileSet.EmptyTile Then Return
		Local Image:TImage = TileSet.Image.BMaxImage
		Local Scale:Double = 4.0 * L_CurrentCamera.K / ImageWidth( Image )
		SetScale( Scale * Visualizer.XScale, Scale * Visualizer.YScale )
		DrawImage( Image, X + Visualizer.DX, Y + Visualizer.DY, TileValue )
		
		?debug
		L_TilesDisplayed :+ 1
		?
	End Method

	' ==================== Other ===================	
	
	Rem
	bbdoc: Enframes tilemap.
	about: You can specify tileset for enframing. If no tileset will be specified, tilemap's default tileset will be used.
	
	See also: #LTTileSet
	End Rem
	Method Enframe( ByTileSet:LTTileset = Null )
		If Not ByTileSet Then ByTileSet = TileSet
		For Local Y:Int = 0 Until YQuantity
			For Local X:Int = 0 Until XQuantity
				ByTileSet.Enframe( Self, X, Y )
			Next
		Next
	End Method
	
	
	
	Rem
	bbdoc: Returns tile index for given coordinates.
	returns: Tile index for given tile coordinates.
	about: See also: #SetTile
	End Rem
	Method GetTile:Int( TileX:Int, TileY:Int )
		?debug
		If TileX < 0 Or TileX >= XQuantity Then L_Error( "Incorrect tile X position" )
		If TileY < 0 Or TileY >= YQuantity Then L_Error( "Incorrect tile Y position" )
		?
		Return Value[ TileX, TileY ]
	End Method
	
	
	
	Rem
	bbdoc: Sets tile index for given tile coordinates.
	about: See also: #GetTile
	End Rem
	Method SetTile( TileX:Int, TileY:Int, TileNum:Int )
		?debug
		If TileNum < 0 Or TileNum >= TilesQuantity Then L_Error( "Incorrect tile number" )
		If TileX < 0 Or TileX >= XQuantity Then L_Error( "Incorrect tile X position" )
		If TileY < 0 Or TileY >= YQuantity Then L_Error( "Incorrect tile Y position" )
		?
		Value[ TileX, TileY ] = TileNum
	End Method
	
	
	
	Rem
	bbdoc: Refreshes tile indexes of tilemap.
	about: Execute this method after lowering tiles quantity of this tilemap or its tileset to avoid errors.
	Tile indexes will be limited to 0...TilesQuantity - 1 interval.
	End Rem
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