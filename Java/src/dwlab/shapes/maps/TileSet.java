/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.shapes.maps;

import dwlab.base.Obj;
import dwlab.base.Service;
import dwlab.base.Sys;
import dwlab.shapes.Shape;
import dwlab.visualizers.Image;
import dwlab.xml.XMLObject;
import java.util.LinkedList;

/**
 * Tileset stores image and collision shapes of tiles for tilemaps. Also tile replacing/enframing rules are stored here.
 */
public class TileSet extends Obj {
	/**
	* Prolonging tiles flag.
	* Defines the method of recognizing tiles outside tilemap for tile replacing/enframing algorythm.

	* @see #enframe example
	*/
	public static boolean prolongTiles = true;
	
	public String name;
	public Image image;
	public Shape collisionShape[];
	public int blockWidth[];
	public int blockHeight[];
	public LinkedList<TileCategory> categories = new LinkedList<TileCategory>();
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
	public final void refreshTilesQuantity() {
		if( image == null ) return;
		int newTilesQuantity = image.framesQuantity();
		Shape newCollisionShape[] = new Shape[ newTilesQuantity ];
		int newBlockWidth[] = new int[ newTilesQuantity ];
		int newBlockHeight[] = new int[ newTilesQuantity ];
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
		int catNum = tileCategory[ tileMap.value[ y ][ x ] ];
		if( catNum < 0 ) return;
		TileCategory category = categories.get( catNum );
		for( TileRule rule: category.tileRules ) {
			if( x % rule.xDivider != rule.x || y % rule.yDivider != rule.y ) continue;

			boolean passed = true;
			for( TilePos pos: rule.tilePositions ) {
				int tileCat = getTileCategory( tileMap, x + pos.dX, y + pos.dY );
				if( pos.category == -1 ) {
					if( tileCat == catNum ) {
						passed = false;
						break;
					}
				} else {
					if( tileCat != pos.category ) {
						passed = false;
						break;
					}
				}
			}

			if( passed ) {
				for( int tileNum: rule.tileNums ) {
					if( tileNum == tileMap.value[ y ][ x ] ) return;
				}
				tileMap.value[ y ][ x ] = rule.tileNums[ 0 ];
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
		return tileCategory[ tileMap.value[ y ][ x ] ];
	}


	/**
	 * Updates tileset information.
	 * This method will be automatically executed after loading tileset. Also execute it after forming or changing tileset categories.
	 */
	@Override
	public void update() {
		tileCategory = new int[ tilesQuantity ];
		for( int n=0; n <= tilesQuantity; n++ ) {
			tileCategory[ n ] = -1;
		}

		int catNum = 0;
		for( TileCategory category: categories ) {
			category.num = catNum;
			for( TileRule rule: category.tileRules ) {
				for( int n=0; n <= rule.tileNums.length; n++ ) {
					if( rule.tileNums[ n ] >= tilesQuantity ) rule.tileNums[ n ] = tilesQuantity - 1;
					tileCategory[ rule.tileNums[ n ] ] = category.num;
				}
			}
			catNum += 1;
		}

		for( TileCategory category: categories ) {
			for( TileRule rule: category.tileRules ) {
				if( rule.x >= rule.xDivider ) rule.x = rule.xDivider - 1;
				if( rule.y >= rule.yDivider ) rule.y = rule.yDivider - 1;
				for( TilePos pos: rule.tilePositions ) {
					if( pos.tileNum >= tilesQuantity ) pos.tileNum = tilesQuantity - 1;
					pos.category = tileCategory[ pos.tileNum ];
				}
			}
		}
	}


	/**
	 * Creates tileset with given image and empty tile number.
	 * @return Created tileset.
	 */
	public TileSet( Image image, int emptyTile ) {
		this.image = image;
		this.emptyTile = emptyTile;
		this.refreshTilesQuantity();
	}
	
	public TileSet( Image image ) {
		this.image = image;
		this.refreshTilesQuantity();
	}


	@Override
	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageStringAttribute( "name", name );
		image = xMLObject.manageObjectField( "image", image );
		tilesQuantity = xMLObject.manageIntAttribute( "tiles-quantity", tilesQuantity );
		blockWidth = xMLObject.manageIntArrayAttribute( "block-width", blockWidth, Service.getChunkLength( image.getXCells() ) );
		blockHeight = xMLObject.manageIntArrayAttribute( "block-height", blockHeight, Service.getChunkLength( image.getYCells() ) );
		emptyTile = xMLObject.manageIntAttribute( "empty-tile", emptyTile, -1 );
		xMLObject.manageChildList( categories );

		if( Sys.xMLGetMode() ) {
			collisionShape = new Shape[ tilesQuantity ];

			XMLObject arrayXMLObject = xMLObject.getField( "collision-shapes" );
			if( arrayXMLObject != null ) {
				int n = 0;
				for( XMLObject childXMLObject: arrayXMLObject.children ) {
					if( !childXMLObject.name.equals( "null" ) ) collisionShape[ n ] = (Shape) childXMLObject.manageObject( null );
					n += 1;
				}
			}

			update();
		} else {
			XMLObject arrayXMLObject = new XMLObject();
			arrayXMLObject.name = "ShapeArray";
			xMLObject.setField( "collision-shapes", arrayXMLObject );
			for( int n=0; n <= collisionShape.length; n++ ) {
				XMLObject newXMLObject = new XMLObject();
				if( collisionShape[ n ] != null ) {
					newXMLObject.manageObject( collisionShape[ n ] );
				} else {
					newXMLObject.name = "Null";
				}
				arrayXMLObject.children.addLast( newXMLObject );
			}
		}

		//If Not L_EditorData.Tilesets.Contains( Self ) L_EditorData.Tilesets.AddLast( Self )
	}


	public class TileCategory extends Obj {
		public String name;
		public int num;
		public LinkedList<TileRule> tileRules = new LinkedList<TileRule>();


		@Override
		public void xMLIO( XMLObject xMLObject ) {
			super.xMLIO( xMLObject );

			name = xMLObject.manageStringAttribute( "name", name );
			xMLObject.manageChildList( tileRules );
		}
	}


	public class TileRule extends Obj {
		public int tileNums[];
		public LinkedList<TilePos> tilePositions = new LinkedList<TilePos>();
		public int x, y;
		public int xDivider = 1, yDivider = 1;


		public int tilesQuantity() {
			return tileNums.length;
		}


		@Override
		public void xMLIO( XMLObject xMLObject ) {
			super.xMLIO( xMLObject );

			tileNums = xMLObject.manageIntArrayAttribute( "tilenums", tileNums );
			x = xMLObject.manageIntAttribute( "x", x );
			y = xMLObject.manageIntAttribute( "y", y );
			xDivider = xMLObject.manageIntAttribute( "xdiv", xDivider, 1 );
			yDivider = xMLObject.manageIntAttribute( "ydiv", yDivider, 1 );
			xMLObject.manageChildList( tilePositions );
		}
	}


	public class TilePos extends Obj {
		public int dX, dY;
		public int tileNum;
		public int category;


		@Override
		public void xMLIO( XMLObject xMLObject ) {
			super.xMLIO( xMLObject );

			xMLObject.manageIntAttribute( "dx", dX );
			xMLObject.manageIntAttribute( "dy", dY );
			xMLObject.manageIntAttribute( "tilenum", tileNum );
		}
	}
}