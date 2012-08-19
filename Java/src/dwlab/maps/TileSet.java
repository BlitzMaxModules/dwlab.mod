package dwlab.maps;
import java.util.LinkedList;
import dwlab.base.XMLObject;
import java.lang.Math;
import dwlab.base.DWLabObject;
import dwlab.shapes.Shape;
import dwlab.visualizers.Image;

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
 * Prolonging tiles flag.
 * Defines the method of recognizing tiles outside tilemap for tile replacing/enframing algorythm.

 * @see #enframe example
 */
public int prolongTiles = true;

/**
 * Tileset stores image and collision shapes of tiles for tilemaps. Also tile replacing/enframing rules are stored here.
 */
public class TileSet extends DWLabObject {
	public String name;
	public Image image;
	public Shape collisionShape[];
	public int blockWidth[];
	public int blockHeight[];
	public LinkedList categories = new LinkedList();
	public int tilesQuantity;
	public int tileCategory[];

	/**
	 * Number of undrawable tile.
	 * If this number will be set to 0 or more, the tile with this index will not be drawn.
	 */
	public int emptyTile = -1;



	/**
	 * Updates tileset when tiles quantity was changed.
	 * Execute this method every time you change TilesQuantity parameter.
	 */
	public void refreshTilesQuantity() {
		if( ! image ) return;
		int newTilesQuantity = image.framesQuantity();
		Shape newCollisionShape[] = new Shape()[ newTilesQuantity ];
		int newBlockWidth[] = new int()[ newTilesQuantity ];
		int newBlockHeight[] = new int()[ newTilesQuantity ];
		for( int n=0; n <= Math.min( tilesQuantity, newTilesQuantity ); n++ ) {
			newBlockWidth[ n ] = blockWidth[ n ];
			newBlockHeight[ n ] = blockHeight[ n ];
			newCollisionShape[ n ] = collisionShape[ n ];
		}
		blockWidth = newBlockWidth;
		blockHeight = newBlockHeight;
		collisionShape = newCollisionShape;
		tilesQuantity = newTilesQuantity;
		update();
	}



	/**
	 * Enframes the tile of given tilemap with given coordinates.
	 */
	public void enframe( TileMap tileMap, int x, int y ) {
		int catNum = tileCategory[ tileMap.value[ x, y ] ];
		if( catNum < 0 ) return;
		TileCategory category = TileCategory( categories.get( catNum ) );
		for( TileRule rule: category.tileRules ) {
			if( x mod rule.xDivider != rule.x || y mod rule.yDivider != rule.y ) continue;

			int passed = true;
			for( TilePos pos: rule.tilePositions ) {
				int tileCategory = getTileCategory( tileMap, x + pos.dX, y + pos.dY );
				if( pos.category == -1 ) {
					if( tileCategory == catNum ) {
						passed = false;
						exit;
					}
				} else {
					if( tileCategory != pos.category ) {
						passed = false;
						exit;
					}
				}
			}

			if( passed ) {
				for( int tileNum: rule.tileNums ) {
					if( tileNum == tileMap.value[ x, y ] ) return;
				}
				tileMap.value[ x, y ] = rule.tileNums[ 0 ];
				return;
			}
		}
	}



	public int getTileCategory( TileMap tileMap, int x, int y ) {
		if( tileMap.wrapped ) {
			if( tileMap.masked ) {
				x = x & tileMap.xMask;
				y = y & tileMap.yMask;
			} else {
				x = tileMap.wrapX( x );
				y = tileMap.wrapY( y );
			}
		} else {
			if( prolongTiles ) {
				if( x < 0 ) {
					x = 0;
				} else if( x >= tileMap.xQuantity ) {
					x = tileMap.xQuantity - 1;
				}

				if( y < 0 ) {
					y = 0;
				} else if( y >= tileMap.yQuantity ) {
					y = tileMap.yQuantity - 1;
				}
			} else {
				if( x < 0 || x >= tileMap.xQuantity || y < 0 || y >= tileMap.yQuantity ) return -1;
			}
		}
		return tileCategory[ tileMap.value[ x, y ] ];
	}



	/**
	 * Updates tileset information.
	 * This method will be automatically executed after loading tileset. Also execute it after forming or changing tileset categories.
	 */
	public void update() {
		tileCategory = new int()[ tilesQuantity ];
		for( int n=0; n <= tilesQuantity; n++ ) {
			tileCategory[ n ] = -1;
		}

		int catNum = 0;
		for( TileCategory category: categories ) {
			category.num = catNum;
			for( TileRule rule: category.tileRules ) {
				for( int n=0; n <= rule.tileNums.dimensions()[ 0 ]; n++ ) {
					if( rule.tileNums[ n ] >= tilesQuantity ) rule.tileNums[ n ] == tilesQuantity - 1;
					tileCategory[ rule.tileNums[ n ] ] = category.num;
				}
			}
			catNum += 1;
		}

		for( TileCategory category: categories ) {
			for( TileRule rule: category.tileRules ) {
				if( rule.x >= rule.xDivider ) rule.x == rule.xDivider - 1;
				if( rule.y >= rule.yDivider ) rule.y == rule.yDivider - 1;
				for( TilePos pos: rule.tilePositions ) {
					if( pos.tileNum >= tilesQuantity ) pos.tileNum == tilesQuantity - 1;
					pos.category = tileCategory[ pos.tileNum ];
				}
			}
		}
	}



	/**
	 * Creates tileset with given image and empty tile number.
	 * @return Created tileset.
	 */
	public static TileSet create( Image image, int emptyTile = -1 ) {
		TileSet tileSet = new TileSet();
		tileSet.image = image;
		tileSet.emptyTile = emptyTile;
		tileSet.refreshTilesQuantity();
		return tileSet;
	}



	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageStringAttribute( "name", name );
		image = Image( xMLObject.manageObjectField( "image", image ) );
		xMLObject.manageIntAttribute( "tiles-quantity", tilesQuantity );
		xMLObject.manageIntArrayAttribute( "block-width", blockWidth, getChunkLength( image.xCells ) );
		xMLObject.manageIntArrayAttribute( "block-height", blockHeight, getChunkLength( image.yCells ) );
		xMLObject.manageIntAttribute( "empty-tile", emptyTile, -1 );
		xMLObject.manageChildList( categories );

		if( XML.mode == XMLMode.GET ) {
			collisionShape = new Shape()[ tilesQuantity ];

			XMLObject arrayXMLObject = xMLObject.getField( "collision-shapes" );
			if( arrayXMLObject ) {
				int n = 0;
				for( XMLObject childXMLObject: arrayXMLObject.children ) {
					if( childXMLObject.name != "null" ) collisionShape[ n ] == Shape( childXMLObject.manageObject( null ) );
					n += 1;
				}
			}

			update();
		} else {
			XMLObject arrayXMLObject = new XMLObject();
			arrayXMLObject.name = "ShapeArray";
			xMLObject.setField( "collision-shapes", arrayXMLObject );
			for( int n=0; n <= collisionShape.dimensions()[ 0 ]; n++ ) {
				XMLObject newXMLObject = new XMLObject();
				if( collisionShape[ n ] ) {
					newXMLObject.manageObject( collisionShape[ n ] );
				} else {
					newXMLObject.name = "Null";
				}
				arrayXMLObject.children.addLast( newXMLObject );
			}
		}

		//If Not L_EditorData.Tilesets.Contains( Self ) L_EditorData.Tilesets.AddLast( Self )
	}
}





public class TileCategory extends DWLabObject {
	public String name;
	public int num;
	public LinkedList tileRules = new LinkedList();



	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageStringAttribute( "name", name );
		xMLObject.manageChildList( tileRules );
	}
}





public class TileRule extends DWLabObject {
	public int tileNums[];
	public LinkedList tilePositions = new LinkedList();
	public int x, int y;
	public int xDivider = 1, int yDivider = 1;



	public int tilesQuantity() {
		return tileNums.dimensions()[ 0 ];
	}



	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageIntArrayAttribute( "tilenums", tileNums );
		xMLObject.manageIntAttribute( "x", x );
		xMLObject.manageIntAttribute( "y", y );
		xMLObject.manageIntAttribute( "xdiv", xDivider, 1 );
		xMLObject.manageIntAttribute( "ydiv", yDivider, 1 );
		xMLObject.manageChildList( tilePositions );
	}
}





public class TilePos extends DWLabObject {
	public int dX, int dY;
	public int tileNum;
	public int category;



	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageIntAttribute( "dx", dX );
		xMLObject.manageIntAttribute( "dy", dY );
		xMLObject.manageIntAttribute( "tilenum", tileNum );
	}
}
