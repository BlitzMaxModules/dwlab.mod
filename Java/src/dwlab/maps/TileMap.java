package dwlab.maps;
import dwlab.base.XMLObject;
import java.lang.Math;
import dwlab.shapes.Shape;
import dwlab.visualizers.Visualizer;

//
// Digital Wizard's Lab - game development framework
// Copyright (C) 2012, Matt Merkulov
//
// All rights reserved. Use of this code is allowed under the
// Artistic License 2.0 terms, as specified in the license.txt
// file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php
//




/**
 * Tilemap is displayable rectangular tile-based shape with 2d array of tile indexes and tileset with tile images.
 */
public class TileMap extends IntMap {
	/**
	 * Tilemap's default tileset.
	 * @see #lTTileSet
	 */
	public TileSet tileSet;

	/**
	 * Tiles quantity of tilemap.
	 * All map tile indexes should be in 0...TilesQuantity - 1 interval.
	 */
	public int tilesQuantity;

	/**
	 * Margins for drawing tile map in units.
	 * When drawing tile map, margins define the size of rectangular frame around camera's rectangle in which tiles will be also drawn.
	 * Will be handy if tilemap's XScale / YScale parameters are greater than 1.0.
	 */
	public double leftMargin, double rightMargin, double topMargin, double bottomMargin;

	/**
	 * Wrapping flag.
	 * If this flag will be set to True, then map will be repeated (tiled, wrapped) enlessly in all directions.
	 */
	public int wrapped = false;

	/**
	 * Horizontal displaying order.
	 * 1 means drawing tile columns from left to right, -1 means otherwise.
	 */
	public int horizontalOrder = 1;

	/**
	 * Vertical displaying order.
	 * 1 means drawing tile rows from top to bottom, -1 means otherwise.
	 */
	public int verticalOrder = 1	;

	// ==================== Parameters ===================	

	/**
	 * Returns tilemap tile width.
	 * @return Tile width of the tilemap in units.
	 * @see #getTileHeight
	 */
	public double getTileWidth() {
			return width / xQuantity;
	}



	/**
	 * Returns tilemap tile height.
	 * @return Tile height of the tilemap in units.
	 */
	public double getTileHeight() {
		return height / yQuantity;
	}



	/**
	 * Returns tile collision shape.
	 * @return Tile collision shape of tilemap's tile with given coordinates using default tilemap tileset.
	 */
	public Shape getTileCollisionShape( int tileX, int tileY ) {
		if( tileX < 0 || tileX >= xQuantity ) error( "Incorrect tile X position" );
		if( tileY < 0 || tileY >= yQuantity ) error( "Incorrect tile Y position" );

		return tileset.collisionShape[ value[ tileX, tileY ] ];
	}



	/**
	 * Returns tile coordinates for given field coordinates.
	 * @return Tile coordinates for given point.
	 */	
	public void getTileForPoint( double x, double y, int tileX var, int tileY var ) {
		tileX = Math.floor( ( x - leftX() ) / getTileWidth() );
		tileY = Math.floor( ( y - topY() ) / getTileHeight() );
	}



	public String getClassTitle() {
		return "Tile map";
	}

	// ==================== Drawing ===================	

	public void draw() {
		if( visible ) visualizer.drawUsingTileMap( this );
	}



	public void drawUsingVisualizer( Visualizer visualizer ) {
		if( visible ) visualizer.drawUsingTileMap( this );
	}

	// ==================== Other ===================	

	/**
	 * Enframes tilemap.
	 * You can specify tileset for enframing. If no tileset will be specified, tilemap's default tileset will be used.
	 * 
	 * @see #lTTileSet
	 */
	public void enframe( TileSet byTileSet = null ) {
		if( ! byTileSet ) byTileSet == tileSet;
		for( int y=0; y <= yQuantity; y++ ) {
			for( int x=0; x <= xQuantity; x++ ) {
				byTileSet.enframe( this, x, y );
			}
		}
	}



	/**
	 * Returns tile index for given coordinates.
	 * @return Tile index for given tile coordinates.
	 * @see #setTile, #setAsTile example
	 */
	public int getTile( int tileX, int tileY ) {
		if( tileX < 0 || tileX >= xQuantity ) error( "Incorrect tile X position" );
		if( tileY < 0 || tileY >= yQuantity ) error( "Incorrect tile Y position" );
		return value[ tileX, tileY ];
	}



	/**
	 * Sets tile index for given tile coordinates.
	 * @see #getTile, #getTileForPoint example, #stretch example
	 */
	public void setTile( int tileX, int tileY, int tileNum ) {
		if( tileNum < 0 || tileNum >= tilesQuantity ) error( "Incorrect tile number" );
		if( tileX < 0 || tileX >= xQuantity ) error( "Incorrect tile X position" );
		if( tileY < 0 || tileY >= yQuantity ) error( "Incorrect tile Y position" );
		value[ tileX, tileY ] = tileNum;
	}



	public void swapTiles( int tileX1, int tileY1, int tileX2, int tileY2 ) {
		int z = getTile( tileX1, tileY1 );
		setTile( tileX1, tileY1, getTile( tileX2, tileY2 ) );
		setTile( tileX2, tileY2, z );
	}



	/**
	 * Refreshes tile indexes of tilemap.
	 * Execute this method after lowering tiles quantity of this tilemap or its tileset to avoid errors.
	 * Tile indexes will be limited to 0...TilesQuantity - 1 interval.
	 */
	public void refreshTilesQuantity() {
		if( ! tileSet ) return;
		if( tileSet.tilesQuantity < tilesQuantity ) {
			for( int y=0; y <= yQuantity; y++ ) {
				for( int x=0; x <= xQuantity; x++ ) {
					if( value[ x, y ] >= tileSet.tilesQuantity ) value[ x, y ] == tileSet.tilesQuantity - 1;
				}
			}
		}
		tilesQuantity = tileSet.tilesQuantity;
	}

	// ==================== Creating ===================

	public static TileMap create( TileSet tileSet, int xQuantity, int yQuantity ) {
		TileMap tileMap = new TileMap();
		tileMap.setResolution( xQuantity, yQuantity );
		tileMap.tileSet = tileSet;
		if( tileSet ) tileMap.tilesQuantity == tileSet.tilesQuantity;
		return tileMap;
	}

	// ==================== Cloning ===================

	public Shape clone() {
		TileMap newTileMap = new TileMap();
		copyTileMapTo( newTileMap );
		return newTileMap;
	}



	public void copyTileMapTo( TileMap tileMap ) {
		copyShapeTo( tileMap );

		tileMap.tileSet = tileSet;
		tileMap.tilesQuantity = tilesQuantity;
		tileMap.wrapped = wrapped;
		tileMap.setResolution( xQuantity, yQuantity );
		for( int y=0; y <= yQuantity; y++ ) {
			for( int x=0; x <= xQuantity; x++ ) {
				tileMap.value[ x, y ] = value[ x, y ];
			}
		}
	}



	public void copyTo( Shape shape ) {
		TileMap tileMap = TileMap( shape );

		if( ! tileMap ) error( "Trying to copy tilemap \"" + shape.getTitle() + "\" data to non-tilemap" );

		copyTileMapTo( tileMap );
	}

	// ==================== Saving / loading ===================

	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		tileSet = TileSet( xMLObject.manageObjectField( "tileset", tileSet ) );
		xMLObject.manageIntAttribute( "tiles-quantity", tilesQuantity );
		xMLObject.manageDoubleAttribute( "left-margin", leftMargin );
		xMLObject.manageDoubleAttribute( "right-margin", rightMargin );
		xMLObject.manageDoubleAttribute( "top-margin", topMargin );
		xMLObject.manageDoubleAttribute( "bottom-margin", bottomMargin );
		xMLObject.manageIntAttribute( "wrapped", wrapped );
		xMLObject.manageIntAttribute( "horizontal-order", horizontalOrder, 1 );
		xMLObject.manageIntAttribute( "vertical-order", verticalOrder, 1 );

		int chunkLength = getChunkLength( tilesQuantity );
		if( XML.mode == XMLMode.GET ) {
			value = new int()[ xQuantity, yQuantity ];
			int y = 0;
			for( XMLObject xMLRow: xMLObject.children ) {
				String data = xMLRow.getAttribute( "data" );
				int pos = 0;
				int x = 0;
				while( pos < data.length ) {
					value[ x, y ] = decode( data[ pos..pos + chunkLength ] );
					pos += chunkLength;
					x += 1;
				}
				y += 1;
			}
		} else {
			for( int y=0; y <= yQuantity; y++ ) {
				XMLObject xMLRow = new XMLObject();
				xMLRow.name = "Row";
				String arrayData = "";
				for( int x=0; x <= xQuantity; x++ ) {
					arrayData += encode( value[ x, y ], chunkLength );
				}
				xMLRow.setAttribute( "data", arrayData );
				xMLObject.children.addLast( xMLRow );
			}
		}
	}
}
