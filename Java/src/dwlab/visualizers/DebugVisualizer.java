package dwlab.visualizers;
import dwlab.base.Graphics;
import dwlab.base.Service;
import java.util.LinkedList;
import java.lang.Math;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.Shape;
import dwlab.shapes.maps.SpriteMap;
import dwlab.shapes.maps.TileMap;
import dwlab.shapes.Vector;
import dwlab.shapes.sprites.Camera;
import dwlab.shapes.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */


/**
 * Global variable for debug visualizer.
 */
/**
 * This visualizer can draw collision shape, vector and name of the shape with this shape itself.
 * See also #wedgeOffWithSprite example
 */
public class DebugVisualizer extends Visualizer {
	public DebugVisualizer instance = new DebugVisualizer();
	public Color colors[] = { new Color( "7FFF007F" ), new Color( "7F007FFF" ), new Color( "7F00FF7F" ), new Color( "7F7F00FF" ), new Color( "7F7FFF00" ),
			new Color( "7FFF7F00" ), new Color( "7FFFFFFF" ), new Color( "7F000000" ) };
	public final int maxColor = 7;

	public boolean showCollisionShapes = true;
	public boolean showVectors = true;
	public boolean showNames = true;
	public double alphaOfInvisible = 0.5d;


	private static Vector serviceVector = new Vector();
	private static Vector serviceSizes = new Vector();

	@Override
	public void drawUsingSprite( Sprite sprite, Sprite spriteShape ) {
		if( sprite.visible ) {
			sprite.visualizer.drawUsingSprite( sprite, spriteShape );
		} else {
			double oldAlpha = sprite.visualizer.alpha;
			sprite.visualizer.alpha *= alphaOfInvisible;
			sprite.visible = true;

			sprite.visualizer.drawUsingSprite( sprite );

			sprite.visualizer.alpha = oldAlpha;
			sprite.visible = false;
		}

		Camera.current.fieldToScreen( spriteShape, serviceVector );
		Camera.current.sizeFieldToScreen( spriteShape, serviceSizes );

		Color color = colors[ sprite.collisionLayer & maxColor ];
		if( showCollisionShapes ) drawSpriteShape( spriteShape, color );

		if( showVectors ) {
			double size = Math.max( serviceSizes.x, serviceSizes.y );
			if( size != 0d ) {
				double sX2 = serviceVector.x + Math.cos( sprite.angle ) * size;
				double sY2 = serviceVector.y + Math.sin( sprite.angle ) * size;
				Graphics.drawLine( serviceVector.x, serviceVector.y, sX2, sY2 );
				for( double d=-135; d <= 135; d += 270 ) {
					Graphics.drawLine( sX2, sY2, sX2 + 5.0 * Math.cos( sprite.angle + d ), sY2 + 5.0 * Math.sin( sprite.angle + d ) );
				}
			}
		}

		if( showNames ) {
			String titles[] = sprite.getTitle().split( "|" );
			serviceVector.y -= titles.length * 8;
			for( String title: titles ) {
				double txtWidth = 0.5 * Graphics.textWidth( title );
				for( int dy=-1; dy <= 1; dy++ ) {
					for( int dx=-( dy = 0 ); dx <= Math.abs( dy = 0 ); dx += 2 ) {
						Graphics.drawText( title, serviceVector.x + dx - txtWidth, serviceVector.y + dy );
					}
				}
				Graphics.drawText( title, serviceVector.x - txtWidth, serviceVector.y );
				serviceVector.y += 14;
			}
		}
	}


	@Override
	public void drawUsingTileMap( TileMap tileMap, LinkedList shapes ) {
		tileMap.visualizer.drawUsingTileMap( tileMap, shapes );
		if( showCollisionShapes ) super.drawUsingTileMap( tileMap, shapes );
	}


	@Override
	public void drawTile( TileMap tileMap, double x, double y, double width, double height, int tileX, int tileY ) {
		Shape shape = tileMap.getTileCollisionShape( tileMap.wrapX( tileX ), tileMap.wrapY( tileY ) );
		if( shape == null ) return;

		Sprite sprite = shape.toSprite();
		if( sprite != null ) {
			drawCollisionSprite( tileMap, x, y, sprite );
		} else {
			for( Shape childShape: shape.toLayer().children ) {
				drawCollisionSprite( tileMap, x, y, childShape.toSprite() );
			}
		}
	}



	public void drawCollisionSprite( TileMap tileMap, double x, double y, Sprite sprite ) {
		Color color = colors[ sprite.collisionLayer & maxColor ];

		double tileWidth = tileMap.getTileWidth();
		double tileHeight = tileMap.getTileHeight();

		if( Camera.current.isometric ) {
			double shapeX = x + ( sprite.getX() - 0.5 ) * tileWidth;
			double shapeY = y + ( sprite.getY() - 0.5 ) * tileHeight;
			double shapeWidth = sprite.getWidth() * tileWidth;
			double shapeHeight = sprite.getHeight() * tileHeight;
			switch( sprite.shapeType ) {
				case PIVOT:
					Camera.current.fieldToScreen( shapeX, shapeY, serviceVector );
					Graphics.drawOval( serviceVector.x - 2d, serviceVector.y - 2d, 5d, 5d, 0d, color );
					break;
				case OVAL:
					drawIsoOval( shapeX, shapeY, shapeWidth, shapeHeight, color );
					break;
				case RECTANGLE:
					drawIsoRectangle( shapeX, shapeY, shapeWidth, shapeHeight, color );
					break;
			}
		} else {
			Camera.current.fieldToScreen( x + ( sprite.getX() - 0.5d ) * tileWidth, y + ( sprite.getY() - 0.5d ) * tileHeight, serviceVector );
			Camera.current.sizeFieldToScreen( sprite.getWidth() * tileWidth, sprite.getHeight() * tileHeight, serviceSizes );

			drawShape( sprite.shapeType, serviceVector.x, serviceVector.y, serviceSizes.x, serviceSizes.y, 0d, color );
		}
	}


	@Override
	public void drawSpriteMapTile( SpriteMap spriteMap, double x, double y ) {
		int tileX = Service.floor( x / spriteMap.cellWidth ) & spriteMap.xMask;
		int tileY = Service.floor( y / spriteMap.cellHeight ) & spriteMap.yMask;
		for( int n = 0; n <= spriteMap.listSize[ tileY ][ tileX ]; n++ ) {
			drawUsingSprite( spriteMap.lists[ tileY ][ tileX ][ n ] );
		}
	}
}
