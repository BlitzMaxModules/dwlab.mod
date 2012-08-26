/* Digital Wizard's Lab world editor
 * Copyright (C) 2012, Matt Merkulov 
 *
 * All rights reserved. Use of this code is allowed under the
 * Attribution-NonCommercial-ShareAlike 3.0 License terms, as
 * specified in the license2.txt file distributed with this
 * code, or available from
 * http//creativecommons.org/licenses/by-nc-sa/3.0/
 */

package dwlab.visualizers;

import dwlab.base.Image;
import dwlab.base.Graphics;
import dwlab.base.Service;
import java.util.LinkedList;
import java.lang.Math;
import dwlab.shapes.maps.TileMap;
import dwlab.shapes.Vector;
import dwlab.shapes.sprites.Camera;
import dwlab.shapes.sprites.Sprite;

/**
 * This visualizer draws rectangular animated dashed frame around the shape.
 */
public class MarchingAnts extends Visualizer {
	private static Vector serviceVector = new Vector();
	private static Vector serviceSizes = new Vector();
	private static Vector serviceVector11 = new Vector();
	private static Vector serviceVector12 = new Vector();
	private static Vector serviceVector21 = new Vector();
	private static Vector serviceVector22 = new Vector();
	
	
	@Override
	public void drawUsingSprite( Sprite sprite, Sprite spriteShape ) {
		if( !sprite.visible ) return;

		int pos = Service.round( System.currentTimeMillis() / 100 ) % 8;

		if( Camera.current.isometric ) {
			Camera.current.fieldToScreen( spriteShape.leftX(), spriteShape.topY(), serviceVector11 );
			Camera.current.fieldToScreen( spriteShape.leftX(), spriteShape.bottomY(), serviceVector12 );
			Camera.current.fieldToScreen( spriteShape.rightX(), spriteShape.topY(), serviceVector21 );
			Camera.current.fieldToScreen( spriteShape.rightX(), spriteShape.bottomY(), serviceVector22 );

			double width = Service.distance( serviceVector12.x - serviceVector11.x, serviceVector12.y - serviceVector11.y );
			if( width > 0 ) {
				Image lineImage = makeMALine( (int) width, pos );
				lineImage.drawAsLine( serviceVector11.x, serviceVector11.y, serviceVector12.x, serviceVector12.y );
				lineImage.drawAsLine( serviceVector22.x, serviceVector22.y, serviceVector21.x, serviceVector21.y );
			}

			double height = Service.distance( serviceVector21.x - serviceVector11.x, serviceVector21.y - serviceVector11.y );
			if( height > 0 ) {
				Image lineImage = makeMALine( (int) height, pos );
				lineImage.drawAsLine( serviceVector12.x, serviceVector12.y, serviceVector22.x, serviceVector22.y );
				lineImage.drawAsLine( serviceVector21.x, serviceVector21.y, serviceVector11.x, serviceVector11.y );
			}
		} else {
			Camera.current.fieldToScreen( spriteShape, serviceVector );
			Camera.current.sizeFieldToScreen( spriteShape.getWidth() * xScale, spriteShape.getHeight() * yScale, serviceSizes );
			drawMARect( serviceVector.x - 0.5d * serviceSizes.x, serviceVector.y - 0.5d * serviceSizes.y, serviceSizes.x, serviceSizes.y, pos );
		}
	}



	@Override
	public void drawUsingTileMap( TileMap tileMap, LinkedList shapes ) {
		if( !tileMap.visible ) return;
		Sprite sprite = new Sprite();
		sprite.jumpTo( tileMap );
		sprite.setSize( tileMap.getWidth(), tileMap.getHeight() );
		drawUsingSprite( sprite );
	}



	/**
	 * Draws voluntary marching ants rectangle.
	 */
	public static void drawMARect( double x, double y, double width, double height, int pos ) {
		if( width != 0d ) {
			Image lineImage = makeMALine( Service.round( width ), pos );
			lineImage.draw( 0, x + 0.5d * width, y, 1d, width, 180d );
			lineImage.draw( 0, x + 0.5d * width, y + height, 1d, width, 0d );
		}

		if( height != 0d ) {
			Image lineImage = makeMALine( Service.round( height ), pos );
			lineImage.draw( 0, x, y + 0.5d * height, height, 1d, -90d );
			lineImage.draw( 0, x + width, y + 0.5d * height, height, 1d, 90d );
		}
	}



	/**
	 * Creates marching ants line.
	 */
	public static Image makeMALine( int width, int pos ) {
		Image image = new Image( width, 1 );
		for( int xX=0; xX <= width; xX++ ) {
			image.setPixel( xX, 0, ( pos >= 4 ? Color.white : Color.black ) );
			pos = ( pos + 1 ) % 8;
		}
		return image;
	}
}
