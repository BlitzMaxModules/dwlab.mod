/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.visualizers;
import dwlab.maps.TileMap;
import dwlab.shapes.LineSegment;
import dwlab.sprites.Sprite;
import dwlab.xml.XMLObject;
import java.util.LinkedList;

/**
 * Visualizer is object which contains parameters for drawing the shape.
 */
public class Visualizer extends Color {
	/**
	 * Horizontal shift of displaying image from the center of drawing shape in units .
	 * @see #setDXDY
	 */
	public double dX = 0.0;

	/**
	 * Vertical shift of displaying image from the center of drawing shape in units .
	 * @see #setDXDY
	 */
	public double dY = 0.0;

	/**
	 * Horizontal scaling of displaying image relative to the width of the drawing shape.
	 * @see #setVisualizerScale
	 */
	public double xScale = 1.0;

	/**
	 * Vertical scaling of displaying image relative to the height of the drawing shape.
	 * @see #setVisualizerScale
	 */
	public double yScale = 1.0;

	/**
	 * Scaling flag.
	 * If False then image will be drawn with no scaling at all.
	 */
	public boolean scaling = true;

	/**
	 * Rotating flag.
	 * If False then Angle parameter will not be used.
	 */
	public boolean rotating = true;

	/**
	 * Image field.
	 */
	public Image image;

	// ==================== Creating ====================

	/**
	 * Creates new visualizer from image file.
	 * @return New visualizer.
	 * @see #fromImage, #fromColor, #fromHexColor
	 */
	public static Visualizer fromFile( String filename, int xCells = 1, int yCells = 1 ) {
		Visualizer visualizer = new Visualizer();
		visualizer.image = Image.fromFile( filename, xCells, yCells );
		return visualizer;
	}



	/**
	 * Creates new visualizer from existing image (LTImage).
	 * @return New visualizer.
	 * @see #fromFile, #fromRGBColor, #fromHexColor
	 */
	public static Visualizer fromImage( Image image ) {
		Visualizer visualizer = new Visualizer();
		visualizer.image = image;
		return visualizer;
	}



	/**
	 * Creates new visualizer using given color RGB components and transparency.
	 * @return New visualizer.
	 * @see #fromFile, #fromImage, #fromHexColor
	 */
	public static Visualizer fromRGBColor( double red, double green, double blue, double alpha, double scale, int scaling ) {
		Visualizer visualizer = new Visualizer();
		visualizer.setColorFromRGB( red, green, blue );
		visualizer.alpha = alpha;
		visualizer.setVisualizerScales( scale );
		visualizer.scaling = scaling;
		return visualizer;
	}



	/**
	 * Creates new visualizer using given hexadecimal color representation and transparency.
	 * @return New visualizer.
	 * @see #fromFile, #fromImage, #fromRGBColor, #overlaps example.
	 */
	public static Visualizer fromHexColor( String hexColor, double alpha, double scale, int scaling ) {
		Visualizer visualizer = new Visualizer();
		visualizer.setColorFromHex( hexColor );
		visualizer.alpha = alpha;
		visualizer.setVisualizerScales( scale );
		visualizer.scaling = scaling;
		return visualizer;
	}

	// ==================== Parameters ====================

	/**
	 * Sets shifts of the visualizer.
	 * Works only with images.
	 */
	public void setDXDY( double newDX, double newDY ) {
		dX = newDX;
		dY = newDY;
	}



	/**
	 * Sets vertical and horizontal scaling of the visualizer
	 * Works only with images.
	 * 
	 * @see #clone example
	 */
	public void setVisualizerScale( double newXScale, double newYScale ) {
		xScale = newXScale;
		yScale = newYScale;
	}



	/**
	 * Sets scalings of the visualizer to one value
	 * Works only with images.
	 */
	public void setVisualizerScales( double newScale ) {
		xScale = newScale;
		yScale = newScale;
	}



	// Deprecated
	public Image getImage() {
		return image;
	}



	// Deprecated
	public void setImage( Image newImage ) {
		image = newImage;
	}

	// ==================== Drawing ===================	

	/**
	 * Draws given sprite using this visualizer.
	 * Change this method if you are making your own visualizer.
	 */
	public void drawUsingSprite( Sprite sprite, Sprite spriteShape ) {
		if( ! sprite.visible ) return;

		if( ! spriteShape ) spriteShape == sprite;

		spritesDisplayed += 1;

		applyColor();

		double sX, double sY, double sWidth, double sHeight;

		if( image ) {
			Camera.current.fieldToScreen( spriteShape.x, spriteShape.y, sX, sY );

			if( rotating ) {
				setRotation( spriteShape.displayingAngle + spriteShape.angle );
			} else {
				setRotation( spriteShape.displayingAngle );
			}

			if( sprite.frame < 0 || sprite.frame >= image.framesQuantity() ) error( "Incorrect frame number ( " + sprite.frame + " ) for sprite \"" + sprite.getTitle() + "\", must be less than " + image.framesQuantity() );

			if( scaling ) {
				Camera.current.sizeFieldToScreen( spriteShape.width, spriteShape.height, sWidth, sHeight );
				double scaledWidth = sWidth * xScale;
				double scaledHeight = sHeight * yScale;
				image.draw( sX + dX * scaledWidth, sY + dY * scaledHeight, scaledWidth, scaledHeight, sprite.frame );
			} else {
				double scaledWidth = imageWidth( image.bMaxImage ) * xScale;
				double scaledHeight = imageHeight( image.bMaxImage ) * yScale;
				image.draw( sX + dX * scaledWidth, sY + dY * scaledHeight, scaledWidth, scaledHeight, sprite.frame );
			}

			setScale( 1.0, 1.0 );
			setRotation( 0.0 );
		} else {
			drawSpriteShape( sprite, spriteShape );
		}

		resetColor();
	}



	/**
	 * Draws sprite shape.
	 * Isometric camera deformations are also applied.
	 */
	public void drawSpriteShape( Sprite sprite, Sprite spriteShape ) {
		if( ! spriteShape ) spriteShape = sprite;

		double sX, double sY, double sWidth, double sHeight;
		if( sprite.shapeType == Sprite.pivot ) {
			Camera.current.fieldToScreen( sprite.x, sprite.y, sX, sY );
			drawOval( sX - 2.5 * xScale + 0.5, sY - 2.5 * yScale + 0.5, 5 * xScale, 5 * yScale );
		} else if( Camera.current.isometric ) {
			switch( sprite.shapeType ) {
				case Sprite.circle:
					drawIsoOval( sprite.x, sprite.y, sprite.width, sprite.height );
				case Sprite.rectangle:
					drawIsoRectangle( spriteShape.x, sprite.y, spriteShape.width, sprite.height );
			}
		} else {
			Camera.current.fieldToScreen( spriteShape.x, spriteShape.y, sX, sY );
			Camera.current.sizeFieldToScreen( spriteShape.width * xScale, spriteShape.height * yScale, sWidth, sHeight );
			sX += dX * sWidth;
			sY += dY * sHeight;

			if( sprite.shapeType == Sprite.raster ) {
				if( image ) {
					int blend = getBlend();
					setBlend mASKBLEND ;
					drawUsingSprite( sprite );
					setBlend blend;
				}
			} else {
				drawShape( sprite.shapeType, sX, sY, sWidth, sHeight, sprite.physics() || sprite.shapeType == Sprite.ray ? 0: spriteShape.angle );
			}
		}
	}



	public static void drawShape( Sprite.ShapeType shapeType, double sX, double sY, double sWidth, double sHeight, double angle ) {
		setRotation( angle );

		switch( shapeType ) {
			case OVAL:
				if( sWidth == sHeight ) {
					setHandle( 0.5 * sWidth, 0.5 * sHeight );
					drawOval( sX, sY, sWidth, sHeight );
					setHandle( 0.0, 0.0 );
				} else if( sWidth > sHeight ) {
					double dWidth = sWidth - sHeight;
					setHandle( 0.5 * sWidth, 0.5 * sHeight );
					drawOval( sX, sY, sHeight, sHeight );
					setHandle( sHeight - 0.5 * sWidth, 0.5 * sHeight );
					drawOval( sX, sY, sHeight, sHeight );
					setHandle( 0.5 * dWidth, 0.5 * sHeight );
					drawRect( sX, sY, dWidth, sHeight );
					setHandle( 0.0, 0.0 );
				} else {
					double dHeight = sHeight - sWidth;
					setHandle( 0.5 * sWidth, 0.5 * sHeight );
					drawOval( sX, sY, sWidth, sWidth );
					setHandle( 0.5 * sWidth, sWidth - 0.5 * sHeight );
					drawOval( sX, sY, sWidth, sWidth );
					setHandle( 0.5 * sWidth, 0.5 * dHeight );
					drawRect( sX, sY, sWidth, dHeight );
					setHandle( 0.0, 0.0 );
				}
				setOrigin( 0.0, 0.0 );
				break;
			case RECTANGLE:
				setHandle( 0.5 * sWidth, 0.5 * sHeight );
				drawRect( sX, sY, sWidth, sHeight );
				setHandle( 0.0, 0.0 );
				break;
			case RAY:
				setRotation( 0.0 );
				drawOval( sX - 2, sY - 2, 5, 5 );
				double ang = wrapDouble( angle, 360.0 );
				if( ang < 45.0 || ang >= 315.0 ) {
					double width = Camera.current.viewport.rightX() - sX;
					if( width > 0 ) drawLine( sX, sY, sX + width, sY + width * Math.tan( ang ) );
				} else if( ang < 135.0 ) {
					double height = Camera.current.viewport.bottomY() - sY;
					if( height > 0 ) drawLine( sX, sY, sX + height / Math.tan( ang ), sY + height );
				} else if( ang < 225.0 ) {
					double width = Camera.current.viewport.leftX() - sX;
					if( width < 0 ) drawLine( sX, sY, sX + width, sY + width * Math.tan( ang ) );
				} else {
					double height = Camera.current.viewport.topY() - sY;
					if( height < 0 ) drawLine( sX, sY, sX + height / Math.tan( ang ), sY + height );
				}
				break;
			default:
				setOrigin( sX, sY );
				switch( shapeType ) {
					case TOP_LEFT_TRIANGLE:
						drawPoly( [ float( -0.5 * sWidth ), float( -0.5 * sHeight ), float( 0.5 * sWidth ), float( -0.5 * sHeight ),
								float( -0.5 * sWidth ), float( 0.5 * sHeight ) ] );
					case TOP_RIGHT_TRIANGLE:
						drawPoly( [ float( -0.5 * sWidth ), float( -0.5 * sHeight ), float( 0.5 * sWidth ), float( -0.5 * sHeight ),
								float( 0.5 * sWidth ), float( 0.5 * sHeight ) ] );
					case BOTTOM_LEFT_TRIANGLE:
						drawPoly( [ float( -0.5 * sWidth ), float( 0.5 * sHeight ), float( 0.5 * sWidth ), float( 0.5 * sHeight ),
								float( -0.5 * sWidth ), float( -0.5 * sHeight ) ] );
					case BOTTOM_RIGHT_TRIANGLE:
						drawPoly( [ float( -0.5 * sWidth ), float( 0.5 * sHeight ), float( 0.5 * sWidth ), float( 0.5 * sHeight ),
								float( 0.5 * sWidth ), float( -0.5 * sHeight ) ] );
				}
				setOrigin( 0.0, 0.0 );
		}

		setRotation( 0.0 );
	}



	/**
	 * Draws rectangle for isometric camera using given field coordinates and size.
	 */
	public void drawIsoRectangle( double x, double y, double width, double height ) {
		float s[] = new float()[ 8 ];
		Camera.current.fieldToScreenFloat( x - 0.5 * width, y - 0.5 * height, s[ 0 ], s[ 1 ] );
		Camera.current.fieldToScreenFloat( x - 0.5 * width, y + 0.5 * height, s[ 2 ], s[ 3 ] );
		Camera.current.fieldToScreenFloat( x + 0.5 * width, y + 0.5 * height, s[ 4 ], s[ 5 ] );
		Camera.current.fieldToScreenFloat( x + 0.5 * width, y - 0.5 * height, s[ 6 ], s[ 7 ] );
		drawPoly( s );
	}



	/**
	 * Draws oval for isometric camera using given field coordinates and size.
	 */
	public void drawIsoOval( double x, double y, double width, double height ) {
		float s[] = new float()[ 16 ];
		double xRadius = 0.5 * width;
		double yRadius = 0.5 * height;
		for( int n=0; n <= 16 step 2; n++ ) {
			double angle = 22.5 * n;
			Camera.current.fieldToScreenFloat( x + xRadius * Math.cos( angle ), y + yRadius * Math.sin( angle ), s[ n ], s[ n + 1 ] );
		}
		drawPoly( s );
	}



	/**
	 * Draws given line using this visualizer.
	 * Change this method if you are making your own visualizer.
	 */
	public void drawUsingLineSegment( LineSegment lineSegment ) {
		if( ! lineSegment.visible ) return;

		applyColor();

		double sX1, double sY1, double sX2, double sY2;
		Camera.current.fieldToScreen( lineSegment.pivot[ 0 ].x, lineSegment.pivot[ 0 ].y, sX1, sY1 );
		Camera.current.fieldToScreen( lineSegment.pivot[ 1 ].x, lineSegment.pivot[ 1 ].y, sX2, sY2 );

		drawLine( sX1, sY1, sX2, sY2 );

		resetColor();
	}



	/**
	 * Draws given tilemap using this visualizer.
	 * Change this method if you are making your own visualizer.
	 */
	public void drawUsingTileMap( TileMap tileMap, LinkedList shapes ) {
		if( ! tileMap.visible ) return;

		TileSet tileSet = tileMap.tileSet;
		if( ! tileSet ) return;

		Image image = tileSet.image;

		applyColor();

		double cellWidth = tileMap.getTileWidth();
		double cellHeight = tileMap.getTileHeight();

		double minX, double minY, double maxX, double maxY;
		getEscribedRectangle( tileMap.leftMargin, tileMap.topMargin, tileMap.rightMargin, tileMap.bottomMargin, minX, minY, maxX, maxY );

		double cornerX = tileMap.leftX();
		double cornerY = tileMap.topY();
		int minTileX = Math.floor( ( minX - cornerX ) / cellWidth );
		int minTileY = Math.floor( ( minY - cornerY ) / cellHeight );
		int maxTileX = Math.ceil( ( maxX - cornerX ) / cellWidth );
		int maxTileY = Math.ceil( ( maxY - cornerY ) / cellHeight );

		if( ! tileMap.wrapped ) {
			minTileX = limitInt( minTileX, 0, tileMap.xQuantity - 1 );
			minTileY = limitInt( minTileY, 0, tileMap.yQuantity - 1 );
			maxTileX = limitInt( maxTileX, 0, tileMap.xQuantity - 1 );
			maxTileY = limitInt( maxTileY, 0, tileMap.yQuantity - 1 );
		}

		int tileDX = tileMap.horizontalOrder, int tileDY = tileMap.verticalOrder;
		double sDX = cellWidth * tileDX, double sDY = cellHeight * tileDY;

		double sWidth, double sHeight;
		Camera.current.sizeFieldToScreen( cellWidth, cellHeight, sWidth, sHeight );

		if( ! Camera.current.isometric then if ! image ) return;

		int tileY;
		if( tileDY = 1 ) tileY = minTileY; else tileY == maxTileY;
		double y = cornerY + cellHeight * ( 0.5 + tileY );
		while( true ) {
			if( tileDY == 1 ) {
				if( tileY > maxTileY ) exit;
			} else {
				if( tileY < minTileY ) exit;
			}

			int tileX;
			if( tileDX = 1 ) tileX = minTileX; else tileX == maxTileX;

			double x = cornerX + cellWidth * ( 0.5 + tileX );

			while( true ) {
				if( tileDX == 1 ) {
					if( tileX > maxTileX ) exit;
				} else {
					if( tileX < minTileX ) exit;
				}

				if( shapes ) {
					for( Shape shape: shapes ) {
						TileMap childTileMap = TileMap( shape );
						if( childTileMap ) {
							drawTile( childTileMap, x, y, sWidth, sHeight, tileX, tileY );
						} else {
							drawSpriteMapTile( SpriteMap( shape ), x, y );
						}
					}
				} else {
					drawTile( tileMap, x, y, sWidth, sHeight, tileX, tileY );
				}

				x += sDX;
				tileX += tileDX;
			}

			y+= sDY;
			tileY += tileDY;
		}

		resetColor();
		setScale( 1.0, 1.0 );
	}



	/**
	 * Draws tile of given tilemap with given coordinates using this visualizer.
	 * X and Y are center coordinates of this tile on the screen.
	 * If you want to make your own tilemap visualizer, make class which extends LTVisualizer and rewrite this method.
	 * 
	 * @see #drawUsingTileMap
	 */
	public void drawTile( TileMap tileMap, double x, double y, double width, double height, int tileX, int tileY ) {
		applyColor();

		TileSet tileSet =tilemap.tileSet;
		int tileValue = getTileValue( tileMap, tileX, tileY );
		if( tileValue == tileSet.emptyTile ) return;

		Image image = tileSet.image;
		if( ! image ) return;

		double sX, double sY;
		Camera.current.fieldToScreen( x, y, sX, sY );

		Visualizer visualizer = tileMap.visualizer;
		width *= visualizer.xScale;
		height *= visualizer.yScale;

		image.draw( sX + visualizer.dX * width, sY + visualizer.dY * height, width, height, tileValue );

		tilesDisplayed += 1;
	}


	/**
	 * Function which defines which tile to draw.
	 * @return Tile number for given tilemap and tile coordinates.
	 */
	public int getTileValue( TileMap tileMap, int tileX, int tileY ) {
		return tileMap.value[ tileMap.wrapX( tileX ), tileMap.wrapY( tileY ) ];
	}



	public void drawSpriteMapTile( SpriteMap spriteMap, double x, double y ) {
		if( ! spriteMap.visible ) return;
		int tileX = int( Math.floor( x / spriteMap.cellWidth ) ) & spriteMap.xMask;
		int tileY = int( Math.floor( y / spriteMap.cellHeight ) ) & spriteMap.yMask;
		for( int n=0; n <= spriteMap.listSize[ tileX, tileY ]; n++ ) {
			spriteMap.lists[ tileX, tileY ][ n ].draw();
		}
	}



	public double getFacing() {
		return sgn( xScale );
	}



	public void setFacing( double newFacing ) {
		xScale = Math.abs( xScale ) * newFacing;
	}

	// ==================== Other ====================

	/**
	 * Clones the visualizer.
	 * @return Clone of the visualizer.
	 */
	@Override
	public Visualizer clone() {
		Visualizer visualizer = new Visualizer();
		copyVisualizerTo( visualizer );
		return visualizer;
	}



	public void copyVisualizerTo( Visualizer visualizer ) {
		copyColorTo( visualizer );

		visualizer.dX = dX;
		visualizer.dY = dY;
		visualizer.xScale = xScale;
		visualizer.yScale = yScale;
		visualizer.scaling = scaling;
		visualizer.rotating = rotating;
		visualizer.image = image;
	}



	@Override
	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageDoubleAttribute( "dx", dX );
		xMLObject.manageDoubleAttribute( "dy", dY );
		xMLObject.manageDoubleAttribute( "xscale", xScale, 1.0 );
		xMLObject.manageDoubleAttribute( "yscale", yScale, 1.0 );
		xMLObject.manageIntAttribute( "scaling", scaling, 1 );
		xMLObject.manageIntAttribute( "rotating", rotating, 1 );
		image = Image( xMLObject.manageObjectField( "image", image ) );
	}
}
