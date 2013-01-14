'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTTileSet.bmx"
Include "LTTileMapPathFinder.bmx"

Rem
bbdoc: Tilemap is displayable rectangular tile-based shape with 2d array of tile indexes and tileset with tile images.
End Rem
Type LTTileMap Extends LTIntMap
	Global LoadingErrorHandler:LTTileMapLoadingErrorHandler = New LTTileMapLoadingErrorHandler
	Global FileNum:Int = 0
	
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
	bbdoc: Margins for drawing tile map in units.
	about: When drawing tile map, margins define the size of rectangular frame around camera's rectangle in which tiles will be also drawn.
	Will be handy if tilemap's XScale / YScale parameters are greater than 1.0.
	End Rem
	Field LeftMargin:Double, RightMargin:Double, TopMargin:Double, BottomMargin:Double
	
	Rem
	bbdoc: Wrapping flag.
	about: If this flag will be set to True, then map will be repeated (tiled, wrapped) enlessly in all directions.
	End Rem
	Field Wrapped:Int = False
	
	Rem
	bbdoc: Horizontal displaying order.
	about: 1 means drawing tile columns from left to right, -1 means otherwise.
	End Rem
	Field HorizontalOrder:Int = 1
	
	Rem
	bbdoc: Vertical displaying order.
	about: 1 means drawing tile rows from top to bottom, -1 means otherwise.
	End Rem
	Field VerticalOrder:Int = 1	
	
	Field LoadingTime:Int
	
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
		?debug
		If TileX < 0 Or TileX >= XQuantity Then L_Error( "Incorrect tile X position" )
		If TileY < 0 Or TileY >= YQuantity Then L_Error( "Incorrect tile Y position" )
		?
		
		Return Tileset.CollisionShape[ Value[ TileX, TileY ] ]
	End Method
	
	
	
	Rem
	bbdoc: Returns tile coordinates for given field coordinates.
	returns: Tile coordinates for given point.
	End Rem	
	Method GetTileForPoint( X:Double, Y:Double, TileX:Int Var, TileY:Int Var )
		TileX = Floor( ( X - LeftX() ) / GetTileWidth() )
		TileY = Floor( ( Y - TopY() ) / GetTileHeight() )
	End Method
	
	
	
	Method GetClassTitle:String()
		Return "Tile map"
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw( DrawingAlpha:Double = 1.0 )
		If Visible Then Visualizer.DrawUsingTileMap( Self, , DrawingAlpha )
	End Method
	
	
	
	Method DrawUsingVisualizer( Visualizer:LTVisualizer, DrawingAlpha:Double = 1.0 )
		If Visible Then Visualizer.DrawUsingTileMap( Self, , DrawingAlpha )
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
	about: See also: #SetTile, #SetAsTile example
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
	about: See also: #GetTile, #GetTileForPoint example, #Stretch example
	End Rem
	Method SetTile( TileX:Int, TileY:Int, TileNum:Int )
		?debug
		If TileNum < 0 Or TileNum >= TilesQuantity Then L_Error( "Incorrect tile number" )
		If TileX < 0 Or TileX >= XQuantity Then L_Error( "Incorrect tile X position" )
		If TileY < 0 Or TileY >= YQuantity Then L_Error( "Incorrect tile Y position" )
		?
		Value[ TileX, TileY ] = TileNum
	End Method
	
	
	
	Method SwapTiles( TileX1:Int, TileY1:Int, TileX2:Int, TileY2:Int )
		Local Z:Int = GetTile( TileX1, TileY1 )
		SetTile( TileX1, TileY1, GetTile( TileX2, TileY2 ) )
		SetTile( TileX2, TileY2, Z )
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
		Return TileMap
	End Function
	
	' ==================== Cloning ===================
	
	Method Clone:LTShape()
		Local NewTileMap:LTTileMap = New LTTileMap
		CopyTileMapTo( NewTileMap )
		Return NewTileMap
	End Method
	
	
	
	Method CopyTileMapTo( TileMap:LTTileMap )
		CopyShapeTo( TileMap )
		
		TileMap.TileSet = TileSet
		TileMap.TilesQuantity = TilesQuantity
		TileMap.Wrapped = Wrapped
		TileMap.SetResolution( XQuantity, YQuantity )
		For Local Y:Int = 0 Until YQuantity
			For Local X:Int = 0 Until XQuantity
				TileMap.Value[ X, Y ] = Value[ X, Y ]
			Next
		Next
	End Method
	
	
	
	Method CopyTo( Shape:LTShape )
		Local TileMap:LTTileMap = LTTileMap( Shape )
		
		?debug
		If Not TileMap Then L_Error( "Trying to copy tilemap ~q" + Shape.GetTitle() + "~q data to non-tilemap" )
		?
		
		CopyTileMapTo( TileMap )
	End Method
	
	' ==================== Saving / loading ===================
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		TileSet = LTTileSet( XMLObject.ManageObjectField( "tileset", TileSet ) )
		XMLObject.ManageIntAttribute( "tiles-quantity", TilesQuantity )
		XMLObject.ManageDoubleAttribute( "left-margin", LeftMargin )
		XMLObject.ManageDoubleAttribute( "right-margin", RightMargin )
		XMLObject.ManageDoubleAttribute( "top-margin", TopMargin )
		XMLObject.ManageDoubleAttribute( "bottom-margin", BottomMargin )
		XMLObject.ManageIntAttribute( "wrapped", Wrapped )
		XMLObject.ManageIntAttribute( "horizontal-order", HorizontalOrder, 1 )
		XMLObject.ManageIntAttribute( "vertical-order", VerticalOrder, 1 )
		XMLObject.ManageIntAttribute( "loading-time", LoadingTime )
		XMLObject.ManageIntAttribute( "file-num", FileNum )
			
		Local ChunkLength:Int = L_GetChunkLength( TilesQuantity )
		If L_XMLMode = L_XMLGet Then
			Local Time:Int = Millisecs()
			
			If FileNum Then
				Local FileName:String = LTObject.ObjectFileName + "_tilemaps\" + FileNum + ".bin"
				Local File:TStream = ReadFile( FileName )
				If Not File Then
					LoadingErrorHandler.HandleError( FileName )
				Else
					If TilesQuantity <= 256 Then
						For Local Y:Int = 0 Until YQuantity
							For Local X:Int = 0 Until XQuantity
								Value[ X, Y ] = ReadByte( File )
							Next
						Next
					ElseIf TilesQuantity <= 65536 Then
						For Local Y:Int = 0 Until YQuantity
							For Local X:Int = 0 Until XQuantity
								Value[ X, Y ] = ReadShort( File )
							Next
						Next
					Else
						For Local Y:Int = 0 Until YQuantity
							For Local X:Int = 0 Until XQuantity
								Value[ X, Y ] = ReadInt( File )
							Next
						Next
					End If
					CloseFile( File )
				End If
			Else
				Value = New Int[ XQuantity, YQuantity ]
				Local Y:Int = 0
				For Local XMLRow:LTXMLObject = Eachin XMLObject.Children
					Local Data:String = XMLRow.GetAttribute( "data" )
					Local Pos:Int = 0
					Local X:Int = 0
					While Pos < Data.Length
						Value[ X, Y ] = L_Decode( Data[ Pos..Pos + ChunkLength ] )
						Pos :+ ChunkLength
						X :+ 1
					Wend
					Y :+ 1
				Next
			End If
			
			L_LoadingTime :+ LoadingTime
			LoadingTime = MilliSecs() - Time
			L_NewTotalLoadingTime :+ LoadingTime
			L_LoadingProgress = 1.0 * L_LoadingTime / L_TotalLoadingTime
			If L_LoadingUpdater Then L_LoadingUpdater.Update()
		Else
			Local DirName:String = LTObject.ObjectFileName + "_tilemaps"
			If FileType( DirName ) < 2 Then CreateDir( DirName )
			Local File:TStream = WriteFile( DirName + "\" + FileNum + ".bin" )
			If TilesQuantity <= 256 Then
				For Local Y:Int = 0 Until YQuantity
					For Local X:Int = 0 Until XQuantity
						WriteByte( File, Value[ X, Y ] )
					Next
				Next
			ElseIf TilesQuantity <= 65536 Then
				For Local Y:Int = 0 Until YQuantity
					For Local X:Int = 0 Until XQuantity
						WriteShort( File, Value[ X, Y ] )
					Next
				Next
			Else
				For Local Y:Int = 0 Until YQuantity
					For Local X:Int = 0 Until XQuantity
						WriteInt( File, Value[ X, Y ] )
					Next
				Next
			End If
			CloseFile( File )
			
			FileNum :+ 1			
		End If
	End Method
End Type





Type LTTileMapLoadingErrorHandler
	Method HandleError( FileName:String )
		L_Error( "Tile map " + FileName + " cannot be loaded or not found." )
	End Method
End Type