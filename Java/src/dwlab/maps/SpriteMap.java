package dwlab.maps;
import java.util.HashMap;
import java.util.LinkedList;
import dwlab.base.XMLObject;
import java.lang.Math;
import dwlab.sprites.SpriteGroup;
import dwlab.shapes.Shape;
import dwlab.visualizers.Visualizer;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */


/**
 * Sprite map is a structure which can contain sprites, draw and perform collision checks between them and other shapes.
 * Operations like drawing and checking collision between large groups of sprites will be faster with use of collision maps.
 */
public class SpriteMap extends Map {
	public HashMap sprites = new HashMap();
	public Sprite lists[][ , ];
	public int listSize[ , ];

	/**
	 * Width of sprite map cell in units.
	 * @see #setCellSize
	 */
	public double cellWidth = 1.0;

	/**
	 * Height of sprite map cell in units.
	 * @see #setCellSize
	 */
	public double cellHeight = 1.0;

	/**
	 * Margins for drawing sprite map in units.
	 * When drawing sprite map, margins define the size of rectangular frame around camera's rectangle in which objects will be also drawn.
	 * Will be handy if you draw sprite map with objects with XScale / YScale parameters greater than 1.0.
	 */
	public double leftMargin, double rightMargin, double topMargin, double bottomMargin;

	/**
	 * Flag which defines will be the sprite map sorted by sprite Y coordinates.
	 * False by default.
	 */
	public int sorted = false;

	/**
	 * Flag which defines will be all objects recognized as pivots.
	 * False by default.
	 */
	public int pivotMode = false;

	public int initialArraysSize = 8;



	public int wrapX( int value ) {
		return value & xMask;
	}



	public int wrapY( int value ) {
		return value & yMask;
	}



	public String getClassTitle() {
		return "Sprite map";
	}

	// ==================== Parameters ====================

	public void setResolution( int newXQuantity, int newYQuantity ) {
		super.setResolution( newXQuantity, newYQuantity );

		if( ! masked ) error( "Map resoluton must be power of 2" );

		lists = new Sprite()[][ newXQuantity, newYQuantity ];
		listSize = new int()[ newXQuantity, newYQuantity ];
		for( int y=0; y <= newYQuantity; y++ ) {
			for( int x=0; x <= newXQuantity; x++ ) {
				lists[ x, y ] = new Sprite()[ initialArraysSize ];
			}
		}
	}



	/**
	 * Sets cell size of sprite map.
	 */
	public void setCellSize( double newCellWidth, double newCellHeight ) {
		cellWidth = newCellWidth;
		cellHeight = newCellHeight;
	}



	/**
	 * Sets all margins to single value.
	 */
	public void setBorder( double border ) {
		setMargins( border, border, border, border );
	}



	/**
	 * Sets margins of the map.
	 */
	public void setMargins( double newLeftMargin, double newTopMargin, double newRightMargin, double newBottomMargin ) {
		leftMargin = newLeftMargin;
		topMargin = newTopMargin;
		rightMargin = newRightMargin;
		bottomMargin = newBottomMargin;
	}



	//Deprecated
	public HashMap getSprites() {
		return sprites;
	}


	// ==================== Drawing ===================	

	/**
	 * Draws all objects of sprite map which are in cells under camera's rectangle plus margins.
	 */
	public void draw() {
		drawUsingVisualizer( null );
	}



	public void drawUsingVisualizer( Visualizer vis ) {
		if( visible ) {
			double screenMinX, double screenMinY, double screenMaxX, double screenMaxY;
			getEscribedRectangle( leftMargin, topMargin, rightMargin, bottomMargin, screenMinX, screenMinY, screenMaxX, screenMaxY );

			int mapX1 = Math.floor( screenMinX / cellWidth );
			int mapY1 = Math.floor( screenMinY / cellHeight );
			int mapX2 = Math.floor( screenMaxX / cellWidth );
			int mapY2 = Math.floor( screenMaxY / cellHeight );

			HashMap spriteMap = new HashMap();

			int xN[];
			if( sorted ) xN == new int()[ mapX2 - mapX1 + 1 ];

			for( int y=mapY1; y <= mapY2; y++ ) {
				int maskedY = y & yMask;
				double maxY = ( y + 1 ) * cellHeight;
				if( sorted ) {
					while( true ) {
						double minY;
						int storedX;
						Sprite storedSprite = null;
						for( int x=0; x <= mapX2 - mapX1; x++ ) {
							int maskedX = x & yMask;
							int n = xN[ x ];
							if( n >= listSize[ maskedX, maskedY ] ) continue;
							Sprite sprite = lists[ maskedX, maskedY ][ n ];
							if( sprite.y >= maxY ) continue;
							if( ! storedSprite || sprite.y < minY ) {
								minY = sprite.y;
								storedX = x;
								storedSprite = sprite;
							}
						}
						if( ! storedSprite ) exit;

						if( ! spriteMap.contains( storedSprite ) ) {
							if( vis ) {
								vis.drawUsingSprite( storedSprite );
							} else {
								storedSprite.draw();
							}
							spriteMap.put( storedSprite, null );
						}

						xN[ storedX ] += 1;
					}
				} else {
					for( int x=mapX1; x <= mapX2; x++ ) {
						int maskedX = x & xMask;
						Sprite array[] = lists[ maskedX, maskedY ];
						for( int n=0; n <= listSize[ maskedX, maskedY ]; n++ ) {
							Sprite sprite = Sprite( array[ n ] );
							if( ! spriteMap.contains( sprite ) ) {
								if( vis ) {
									sprite.drawUsingVisualizer( vis );
								} else {
									sprite.draw();
								}
								spriteMap.put( sprite, null );
							}
						}
					}
				}
			}
		}
	}

	// ==================== Insert / remove objects ====================

	/**
	 * Inserts a sprite into sprite map
	 * When PivotMode is set to True, insertion will be faster.
	 * 
	 * @see #removeSprite
	 */
	public void insertSprite( Sprite sprite, int changeSpriteMapField = true ) {
		sprites.put( sprite, null );
		if( pivotMode ) {
			insertSpriteIntoList( sprite, int( sprite.x / cellWidth ) & xMask, int( sprite.y / cellHeight ) & yMask );
		} else {
			int mapX1 = Math.floor( ( sprite.x - 0.5 * sprite.width ) / cellWidth );
			int mapY1 = Math.floor( ( sprite.y - 0.5 * sprite.height ) / cellHeight );
			int mapX2 = Math.floor( ( sprite.x + 0.5 * sprite.width - inaccuracy ) / cellWidth );
			int mapY2 = Math.floor( ( sprite.y + 0.5 * sprite.height - inaccuracy ) / cellHeight );

			for( int y=mapY1; y <= mapY2; y++ ) {
				for( int x=mapX1; x <= mapX2; x++ ) {
					insertSpriteIntoList( sprite, x & xMask, y & yMask );
				}
			}
		}
		if( changeSpriteMapField ) sprite.spriteMap == this;
	}



	public void insertSpriteIntoList( Sprite sprite, int mapX, int mapY ) {
		Sprite array[] = lists[ mapX, mapY ];
		int size = listSize[ mapX, mapY ];
		if( array.length == size ) {
			array = array + array;
			lists[ mapX, mapY ] = array;
		}

		array[ size ] = sprite;
		if( sorted ) {
			for( int n=0; n <= size; n++ ) {
				if( sprite.y < array[ n ].y ) {
					for( int m=size - 1; m <= n; m += -1 ) {
						array[ m + 1 ] = array[ m ];
					}
					array[ n ] = sprite;
					exit;
				}
			}
		}

		listSize[ mapX, mapY ] += 1;
	}



	/**
	 * Removes sprite from sprite map.
	 * When PivotMode is set to True, removal will be faster.
	 * 
	 * @see #insertSprite
	 */
	public void removeSprite( Sprite sprite, int changeSpriteMapField = true ) {
		sprites.remove( sprite );
		if( pivotMode ) {
			removeSpriteFromList( sprite, int( sprite.x / cellWidth ) & xMask, int( sprite.y / cellHeight ) & yMask );
		} else {
			int mapX1 = Math.floor( ( sprite.x - 0.5 * sprite.width ) / cellWidth );
			int mapY1 = Math.floor( ( sprite.y - 0.5 * sprite.height ) / cellHeight );
			int mapX2 = Math.floor( ( sprite.x + 0.5 * sprite.width - inaccuracy ) / cellWidth );
			int mapY2 = Math.floor( ( sprite.y + 0.5 * sprite.height - inaccuracy ) / cellHeight );

			for( int y=mapY1; y <= mapY2; y++ ) {
				for( int x=mapX1; x <= mapX2; x++ ) {
					removeSpriteFromList( sprite, x & xMask, y & yMask );
				}
			}
		}
		if( changeSpriteMapField ) sprite.spriteMap == null;
	}



	public void removeSpriteFromList( Sprite sprite, int mapX, int mapY ) {
		Sprite array[] = lists[ mapX, mapY ];
		int size = listSize[ mapX, mapY ];
		for( int n=0; n <= size; n++ ) {
			if( array[ n ] == sprite ) {
				if( sorted ) {
					for( int m=n + 1; m <= size; m++ ) {
						array[ m - 1 ] = array[ m ];
					}
				} else {
					array[ n ] = array[ size - 1 ];
				}
				listSize[ mapX, mapY ] -= 1;
				return;
			}
		}
	}


	/**
	 * Clears sprite map.
	 */
	public void clear() {
		sprites.clear();
		for( int y=0; y <= yQuantity; y++ ) {
			for( int x=0; x <= xQuantity; x++ ) {
				listSize[ x, y ] = 0;
			}
		}
	}

	// ==================== Shape management ====================

	public Shape load() {
		SpriteMap newSpriteMap = SpriteMap( loadShape() );
		for( Sprite childSprite: sprites.keySet() ) {
			newSpriteMap.insertSprite( Sprite( childSprite.loadShape() ) );
		}
		return newSpriteMap;
	}



	public Shape findShapeWithParameterID( String parameterName, String parameterValue, tTypeID shapeTypeID, int ignoreError = false ) {
		for( Shape childShape: sprites.keySet() ) {
			if( ! shapeTypeID || tTypeId.forObject( childShape ) == shapeTypeID ) {
				if( ! parameterName || childShape.getParameter( parameterName ) == parameterValue ) return this;
			}

			SpriteGroup spriteGroup = SpriteGroup( childShape );
			if( spriteGroup ) {
				Shape shape = spriteGroup.findShapeWithParameterID( parameterName, parameterValue, shapeTypeID, true );
				if( shape ) return shape;
			}
		}

		super.findShapeWithParameterID( parameterName, parameterValue, shapeTypeID, ignoreError );
	}



	public int insertBeforeShape( Shape shape = null, LinkedList shapesList = null, Shape beforeShape ) {
		if( sprites.contains( beforeShape ) ) {
			Sprite sprite = Sprite( shape );
			if( sprite ) insertSprite( sprite );
			if( shapesList ) {
				for( Sprite listSprite: shapesList ) {
					insertSprite( listSprite );
				}
			}
		} else {
			for( SpriteGroup spriteGroup: sprites.keySet() ) {
				spriteGroup.insertBeforeShape( shape, shapesList, beforeShape );
			}
		}
	}



	public void remove( Shape shape ) {
		Sprite sprite = Sprite( shape );
		if( sprite ) {
			removeSprite( sprite );
			for( SpriteGroup spriteGroup: sprites.keySet() ) {
				spriteGroup.remove( sprite );
			}
		}
	}



	public void removeAllOfTypeID( tTypeID typeID ) {
		for( tKeyValue keyValue: sprites ) {
			if( tTypeId.forObject( keyValue.key() ) == typeID ) {
				Sprite sprite = Sprite( keyValue.value() );
				removeSprite( sprite );
			}

			SpriteGroup spriteGroup = SpriteGroup( keyValue.value() );
			if( spriteGroup ) spriteGroup.removeAllOfTypeID( typeID );
		}
	}

	// ==================== Other ===================	

	public tNodeEnumerator objectEnumerator() {
		return sprites.keySet().objectEnumerator();
	}



	public void init() {
		for( Sprite sprite: sprites.keySet() ) {
			sprite.init();
		}
	}



	public void act() {
		for( Sprite sprite: sprites.keySet() ) {
			sprite.act();
		}
	}



	public void update() {
		for( Shape obj: sprites.keySet() ) {
			obj.update();
		}
	}



	/**
	 * Creates collision map.
	 * You should specify cell quantities and size.
	 * 
	 * @see #createForShape
	 */
	public static SpriteMap create( int xQuantity, int yQuantity, double cellWidth = 1.0, double cellHeight = 1.0, int sorted = false, int pivotMode = false ) {
		SpriteMap map = new SpriteMap();
		map.setResolution( xQuantity, yQuantity );
		map.cellWidth = cellWidth;
		map.cellHeight = cellHeight;
		map.sorted = sorted;
		map.pivotMode = pivotMode;
		return map;
	}



	public void copyTo( Shape shape ) {
		copyShapeTo( shape );
		SpriteMap spriteMap = SpriteMap( shape );

		if( ! spriteMap ) error( "Trying to copy sprite map \"" + shape.getTitle() + "\" data to non-sprite-map" );

		spriteMap.setResolution( xQuantity, yQuantity );
		spriteMap.cellWidth = cellWidth;
		spriteMap.cellHeight = cellHeight;
		spriteMap.leftMargin = leftMargin;
		spriteMap.rightMargin = rightMargin;
		spriteMap.topMargin = topMargin;
		spriteMap.bottomMargin = bottomMargin;
		spriteMap.sorted = sorted;
		spriteMap.pivotMode = pivotMode;
	}



	public Shape clone() {
		SpriteMap newSpriteMap = new SpriteMap();
		copyTo( newSpriteMap );
		for( Sprite sprite: sprites ) {
			newSpriteMap.insertSprite( sprite );
		}
		return newSpriteMap;
	}



	/**
	 * Creates collision map using existing shape.
	 * Collision map with size not less than shape size will be created. You can specify cell size either.
	 * Use this function ob layer bounds or layer tilemap which are covers all level to maximize performance.
	 */
	public static SpriteMap createForShape( Shape shape, double cellSize = 1.0, int sorted = false ) {
		return create( toPowerOf2( shape.width / cellSize ), toPowerOf2( shape.height / cellSize ), cellSize, cellSize, sorted );
	}



	public int showModels( int y = 0, String shift = "" ) {
		if( behaviorModels.isEmpty() ) {
			if( sprites.isEmpty() ) return y;
			drawText( shift + getTitle() + " ", 0, y );
	    	y += 16;
		} else {
			y = super.showModels( y, shift );
		}
		for( Shape shape: sprites.keySet() ) {
			y = shape.showModels( y, shift + " " );
		}
		return y;
	}



	public void xMLIO( XMLObject xMLObject ) {
		xMLObject.manageDoubleAttribute( "cell-width", cellWidth, 1.0 );
		xMLObject.manageDoubleAttribute( "cell-height", cellHeight, 1.0 );
		xMLObject.manageDoubleAttribute( "left-margin", leftMargin );
		xMLObject.manageDoubleAttribute( "right-margin", rightMargin );
		xMLObject.manageDoubleAttribute( "top-margin", topMargin );
		xMLObject.manageDoubleAttribute( "bottom-margin", bottomMargin );
		xMLObject.manageIntAttribute( "sorted", sorted );
		xMLObject.manageIntAttribute( "pivot-mode", pivotMode );
		xMLObject.manageIntAttribute( "arrays-size", initialArraysSize, 8 );

		super.xMLIO( xMLObject );

		if( Sys.xMLMode == XMLMode.GET ) {
			for( XMLObject spriteXMLObject: xMLObject.children ) {
				insertSprite( Sprite( spriteXMLObject.manageObject( null ) ) );
			}
		} else {
			for( Sprite sprite: sprites.keySet() ) {
				XMLObject newXMLObject = new XMLObject();
				newXMLObject.manageObject( sprite );
				xMLObject.children.addLast( newXMLObject );
			}
		}
	}
}
