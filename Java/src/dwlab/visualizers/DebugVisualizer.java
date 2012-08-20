package dwlab.visualizers;
import java.util.LinkedList;
import java.lang.Math;
import dwlab.layers.Layer;
import dwlab.shapes.Shape;
import dwlab.maps.SpriteMap;
import dwlab.maps.TileMap;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php\r\n */


/**
 * Global variable for debug visualizer.
 */
public DebugVisualizer debugVisualizer = new DebugVisualizer();

public Color collisionColors[] = [ Color.fromHex( "FF007F", 0.5 ), Color.fromHex( "007FFF", 0.5 ), ..;
		Color.fromHex( "00FF7F", 0.5 ), Color.fromHex( "7F00FF", 0.5 ), Color.fromHex( "7FFF00", 0.5 ), ..;
		Color.fromHex( "FF7F00", 0.5 ), Color.fromHex( "FFFFFF", 0.5 ), Color.fromHex( "000000", 0.5 ) ];
public int maxCollisionColor = collisionColors.length - 1;

/**
 * This visualizer can draw collision shape, vector and name of the shape with this shape itself.
 * See also #wedgeOffWithSprite example
 */
public class DebugVisualizer extends Visualizer {
	public int showCollisionShapes = true;
	public int showVectors = true;
	public int showNames = true;
	public double alphaOfInvisible = 0.5;



	public void drawUsingSprite( Sprite sprite, Sprite spriteShape = null ) {
		if( ! spriteShape ) spriteShape == sprite;

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

		double sX1, double sY1, double sWidth, double sHeight;
		Camera.current.fieldToScreen( spriteShape.x, spriteShape.y, sX1, sY1 );
		Camera.current.sizeFieldToScreen( spriteShape.width, spriteShape.height, sWidth, sHeight );

		collisionColors[ sprite.collisionLayer & maxCollisionColor ].applyColor();
		if showCollisionShapes then	drawSpriteShape( spriteShape );

		if( showVectors ) {
			double size = Math.max( sWidth, sHeight );
			if( size ) {
				double sX2 = sX1 + Math.cos( sprite.angle ) * size;
				double sY2 = sY1 + Math.sin( sprite.angle ) * size;
				drawLine( sX1, sY1, sX2, sY2 );
				for( double d=-135; d <= 135; d += 270 ) {
					drawLine( sX2, sY2, sX2 + 5.0 * Math.cos( sprite.angle + d ), sY2 + 5.0 * Math.sin( sprite.angle + d ) );
				}
			}
		}

		resetColor();

		if( showNames ) {
			String titles[] = sprite.getTitle().split( "|" );
			sY1 -= titles.length * 8;
			for( String title: titles ) {
				int txtWidth = 0.5 * textWidth( title );
				setColor( 0, 0, 0 );
				for( int dY=-1; dY <= 1; dY++ ) {
					for( int dX=-( dY = 0 ); dX <= Math.abs( dY = 0 ); dX += 2 ) {
						drawText( title, sX1 + dX - txtWidth, sY1 + dY );
					}
				}
				resetColor();
				drawText( title, sX1 - txtWidth, sY1 );
				sY1 += 14;
			}
		}
	}



	public void drawUsingTileMap( TileMap tileMap, LinkedList shapes = null ) {
		tileMap.visualizer.drawUsingTileMap( tileMap, shapes );
		if( showCollisionShapes ) super.drawUsingTileMap( tileMap, shapes );
	}



	public void drawTile( TileMap tileMap, double x, double y, double width, double height, int tileX, int tileY ) {
		Shape shape = tileMap.getTileCollisionShape( tileMap.wrapX( tileX ), tileMap.wrapY( tileY ) );
		if( ! shape ) return;

		setScale( 1.0, 1.0 );
		Sprite sprite = Sprite( shape );
		if( sprite ) {
			drawCollisionSprite( tileMap, x, y, sprite );
		} else {
			for( sprite: Layer( shape ) ) {
				drawCollisionSprite( tileMap, x, y, sprite );
			}
		}
	}



	public void drawCollisionSprite( TileMap tileMap, double x, double y, Sprite sprite ) {
		collisionColors[ sprite.collisionLayer & maxCollisionColor ].applyColor();

		double tileWidth = tileMap.getTileWidth();
		double tileHeight = tileMap.getTileHeight();

		if( Camera.current.isometric ) {
			double shapeX = x + ( sprite.x - 0.5 ) * tileWidth;
			double shapeY = y + ( sprite.y - 0.5 ) * tileHeight;
			double shapeWidth = sprite.width * tileWidth;
			double shapeHeight = sprite.height * tileHeight;
			switch( sprite.shapeType ) {
				case Sprite.pivot:
					double sX, double sY;
					Camera.current.fieldToScreen( shapeX, shapeY, sX, sY );
					drawOval( sX - 2, sY - 2, 5, 5 );
				case Sprite.circle:
					drawIsoOval( shapeX, shapeY, shapeWidth, shapeHeight );
				case Sprite.rectangle:
					drawIsoRectangle( shapeX, shapeY, shapeWidth, shapeHeight );
			}
		} else {
			double sX, double sY;
			Camera.current.fieldToScreen( x + ( sprite.x - 0.5 ) * tileWidth, y + ( sprite.y - 0.5 ) * tileHeight, sX, sY );

			double sWidth, double sHeight;
			Camera.current.sizeFieldToScreen( sprite.width * tileWidth, sprite.height * tileHeight, sWidth, sHeight );

			drawShape( sprite.shapeType, sX, sY, sWidth, sHeight );
		}
	}



	public void drawSpriteMapTile( SpriteMap spriteMap, double x, double y ) {
		setScale( 1.0, 1.0 );
		int tileX = int( Math.floor( x / spriteMap.cellWidth ) ) & spriteMap.xMask;
		int tileY = int( Math.floor( y / spriteMap.cellHeight ) ) & spriteMap.yMask;
		for( int n=0; n <= spriteMap.listSize[ tileX, tileY ]; n++ ) {
			drawUsingSprite( spriteMap.lists[ tileX, tileY ][ n ] );
		}
	}
}
