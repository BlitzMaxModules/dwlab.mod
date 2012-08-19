package dwlab.visualizers;
import java.util.LinkedList;
import java.lang.Math;
import dwlab.maps.TileMap;
import dwlab.sprites.Sprite;

//
// Digital Wizard's Lab world editor
// Copyright (C) 2012, Matt Merkulov
//
// All rights reserved. Use of this code is allowed under the
// Attribution-NonCommercial-ShareAlike 3.0 License terms, as
// specified in the license2.txt file distributed with this
// code, or available from
// http/=/creativecommons.org/licenses/by-nc-sa/3.0/
//

/**
 * This visualizer draws rectangular animated dashed frame around the shape.
 */
public class MarchingAnts extends Visualizer {
	public void drawUsingSprite( Sprite sprite, Sprite spriteShape = null ) {
		if( ! spriteShape ) spriteShape == sprite;

		if( ! sprite.visible ) return;
		applyColor();

		if( Camera.current.isometric ) {
			double sX11, double sY11, double sX12, double sY12;
			double sX21, double sY21, double sX22, double sY22;
			Camera.current.fieldToScreen( spriteShape.leftX(), spriteShape.topY(), sX11, sY11 );
			Camera.current.fieldToScreen( spriteShape.leftX(), spriteShape.bottomY(), sX12, sY12 );
			Camera.current.fieldToScreen( spriteShape.rightX(), spriteShape.topY(), sX21, sY21 );
			Camera.current.fieldToScreen( spriteShape.rightX(), spriteShape.bottomY(), sX22, sY22 );

			int pos = int( millisecs() / 100 ) mod 8;

			int width = distance( sX12 - sX11, sY12 -sY11 );
			if( width > 0 ) {
				tImage lineImage = makeMALine( width, pos );
				drawMALine( lineImage, sX11, sY11, sX12, sY12 );
				drawMALine( lineImage, sX22, sY22, sX21, sY21 );
			}

			int height = distance( sX21 - sX11, sY21 - sY11 );
			if( height > 0 ) {
				tImage lineImage = makeMALine( height, pos );
				drawMALine( lineImage, sX12, sY12, sX22, sY22 );
				drawMALine( lineImage, sX21, sY21, sX11, sY11 );
			}
		} else {
			double sX, double sY, double sWidth, double sHeight;
			Camera.current.fieldToScreen( spriteShape.x, spriteShape.y, sX, sY );
			Camera.current.sizeFieldToScreen( spriteShape.width * xScale, spriteShape.height * yScale, sWidth, sHeight );

			drawMARect( sX - 0.5 * sWidth, sY - 0.5 * sHeight, round( sWidth ), round( sHeight ) );
		}

		resetColor();
	}



	public void drawUsingTileMap( TileMap tileMap, LinkedList shapes = null ) {
		if( ! tileMap.visible ) return;
		Sprite sprite = new Sprite();
		sprite.jumpTo( tileMap );
		sprite.setSize( tileMap.width, tileMap.height );
		drawUsingSprite( sprite );
	}



	/**
	 * Draws voluntary marching ants rectangle.
	 */
	public static void drawMARect( int x, int y, int width, int height ) {
		int pos = int( millisecs() / 100 ) mod 8;

		if( width ) {
			tImage lineImage = makeMALine( width, pos );
			setScale( -1.0, 1.0 );
			drawImage( lineImage, x + width, y );
			setScale( 1.0, 1.0 );
			drawImage( lineImage, x, y + height - 1 );
		}

		if( height ) {
			tImage lineImage = makeMALine( height, pos );
			setRotation( 90.0 );
			drawImage( lineImage, x, y );
			setRotation( -90.0 );
			drawImage( lineImage, x + width - 1, y + height );
			setRotation( 0.0 );
		}
	}



	/**
	 * Creates marching ants line.
	 */
	public static tImage makeMALine( int width, int pos var ) {
		tImage image = createImage( width, 1 );
		tPixmap pixmap = lockImage( image );
		for( int xX=0; xX <= width; xX++ ) {
			pixmap.writePixel( xX, 0, $fF000000 + $fFFFFF * ( pos >= 4 ) );
			pos = ( pos + 1 ) mod 8;
		}
		unlockImage( image );
		return image;
	}



	public static void drawMALine( tImage image, int x1, int y1, int x2, int y2 ) {
		setRotation( Math.atan2( y2 - y1, x2 - x1 ) );
		drawImage( image, x1, y1 );
		setRotation( 0.0 );
	}
}
