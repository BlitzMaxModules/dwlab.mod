package dwlab.sprites;
import java.lang.Math;
import dwlab.base.DWLabObject;
import dwlab.shapes.LineSegment;
import dwlab.shapes.Line;
import dwlab.maps.TileMap;
import dwlab.visualizers.Visualizer;
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

// Collision handlers, functions and detection modules

/**
 * Constant for dealing with inaccuracy of double type operations.
 */
public double inaccuracy = 0.000001;

// ------------------------------------------------ Handlers ---------------------------------------------------

/**
 * Sprite collision handling class.
 * Sprite collision check method with specified collision handler will execute this handler's method on collision one sprite with another.

 * @see #active example
 */
public class SpriteCollisionHandler extends DWLabObject {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
	}
}



/**
 * Sprite and tile collision handling class.
 * Collision check method with specified collision handler will execute this handler's method on collision sprite with tile.

 * @see #active example
 */
public class SpriteAndTileCollisionHandler extends DWLabObject {
	public void handleCollision( Sprite sprite, TileMap tileMap, int tileX, int tileY, Sprite collisionSprite ) {
	}
}



/**
 * Sprite and line collision handling class.
 * Collision check method with specified collision handler will execute this handler's method on collision sprite with line.

 * @see #active example
 */
public class SpriteAndLineSegmentCollisionHandler extends DWLabObject {
	public void handleCollision( Sprite sprite, LineSegment lineSegment ) {
	}
}

// ------------------------------------------------ Collision ---------------------------------------------------

for( int n=0; n <= 3; n++ ) {
	Collision.servicePivots[ n ] = Sprite.fromShape( 0, 0, 0, 0, Sprite.pivot );
}

public class Collision {
	public Sprite servicePivot1 = Sprite.fromShape( 0, 0, 0, 0, Sprite.pivot );
	public Sprite servicePivot2 = Sprite.fromShape( 0, 0, 0, 0, Sprite.pivot );
	public Sprite servicePivot3 = Sprite.fromShape( 0, 0, 0, 0, Sprite.pivot );
	public Sprite servicePivot4 = Sprite.fromShape( 0, 0, 0, 0, Sprite.pivot );
	public Sprite servicePivots[] = new Sprite()[ 4 ];
	public Sprite serviceOval1 = Sprite.fromShapeType( Sprite.oval );
	public Sprite serviceOval2 = Sprite.fromShapeType( Sprite.oval );
	public Line serviceLine1 = new Line();
	public Line serviceLine2 = new Line();
	public LineSegment serviceLineSegment = new LineSegment();



	public static int pivotWithOval( Sprite pivot, Sprite oval ) {
		oval = oval.toCircle( pivot, serviceOval1 );
		double radius = 0.5 * oval.width - inaccuracy;
		if( pivot.distance2to( oval ) < radius * radius ) return true;
	}



	public static int pivotWithRectangle( Sprite pivot, Sprite rectangle ) {
		if( 2.0 * Math.abs( pivot.x - rectangle.x ) < rectangle.width - inaccuracy && 2.0 * Math.abs( pivot.y - rectangle.y ) < rectangle.height - inaccuracy ) return true;
	}



	public static int pivotWithTriangle( Sprite pivot, Sprite triangle ) {
		if( pivotWithRectangle( pivot, triangle ) ) {
			triangle.getHypotenuse( serviceLine1 );
			triangle.getRightAngleVertex( servicePivot1 );
			if( serviceLine1.pivotOrientation( pivot ) == serviceLine1.pivotOrientation( servicePivot1 ) ) return true;
		}
	}



	public static int ovalWithOval( Sprite oval1, Sprite oval2 ) {
		oval1 = oval1.toCircle( oval2, serviceOval1 );
		oval2 = oval2.toCircle( oval1, serviceOval2 );
		double radiuses = 0.5 * ( oval1.width + oval2.width ) - inaccuracy;
		if( oval1.distance2to( oval2 ) < radiuses * radiuses ) return true;
	}



	public static int ovalWithRectangle( Sprite oval, Sprite rectangle ) {
		oval = oval.toCircle( rectangle, serviceOval1 );
		if( ( rectangle.x - rectangle.width * 0.5 <= oval.x && oval.x <= rectangle.x + rectangle.width * 0.5 ) || ( rectangle.y - rectangle.height * 0.5 <= oval.y && oval.y <= rectangle.y + rectangle.height * 0.5 ) ) {
			if( 2.0 * Math.abs( oval.x - rectangle.x ) < oval.width + rectangle.width - inaccuracy && 2.0 * Math.abs( oval.y - rectangle.y ) < oval.width + rectangle.height - inaccuracy ) return true;
		} else {
			double dX = Math.abs( rectangle.x - oval.x ) - 0.5 * rectangle.width;
			double dY = Math.abs( rectangle.y - oval.y ) - 0.5 * rectangle.height;
			double radius = 0.5 * oval.width - inaccuracy;
			if( dX * dX + dY * dY < radius * radius ) return true;
		}
	}



	public static int ovalWithLineSegment( Sprite oval, Sprite lSPivot1, Sprite lSPivot2 ) {
		serviceOval1.x = 0.5 * ( lSPivot1.x + lSPivot2.x );
		serviceOval1.y = 0.5 * ( lSPivot1.y + lSPivot2.y );
		serviceOval1.width = 0.5 * lSPivot1.distanceTo( lSPivot2 );
		if( ovalWithOval( oval, serviceOval1 ) ) {
			Line.fromPivots( lSPivot1, lSPivot2, serviceLine1 );
			oval = oval.toCircleUsingLine( serviceLine1, serviceOval2 );
			if( serviceLine1.distanceTo( oval ) < 0.5 * Math.max( oval.width, oval.height ) - inaccuracy ) {
				serviceLine1.pivotProjection( oval, servicePivot1 );
				if( pivotWithOval( servicePivot1, serviceOval1 ) && servicePivot1.distanceTo( serviceOval2 ) < serviceOval1.width - inaccuracy ) return true;
			}
		}
	}



	public static int ovalWithTriangle( Sprite oval, Sprite triangle ) {
		if( ovalWithRectangle( oval, triangle ) ) {
			triangle.getHypotenuse( serviceLine1 );
			oval = oval.toCircleUsingLine( serviceLine1, serviceOval1 );
			triangle.getRightAngleVertex( servicePivot1 );
			if( serviceLine1.pivotOrientation( oval ) == serviceLine1.pivotOrientation( servicePivot1 ) ) return true;
			if( ! serviceLine1.collisionPointsWithCircle( oval, servicePivot1, servicePivot2 ) ) return false;
			if( pivotWithRectangle( servicePivot1, triangle ) || pivotWithRectangle( servicePivot2, triangle ) ) return true;
		}
	}



	public static int ovalWithRay( Sprite oval, Sprite ray ) {
		ray.toLine( serviceLine1 );
		oval.toCircleUsingLine( serviceLine1, serviceOval1 );
		if( serviceLine1.collisionPointsWithCircle( serviceOval1, servicePivot1, servicePivot2 ) ) {
			if( ray.hasPivot( servicePivot1 ) ) return true;
			if( ray.hasPivot( servicePivot2 ) ) return true;
		}
		if( pivotWithOval( ray, oval ) ) return true;
	}



	public static int rectangleWithRectangle( Sprite rectangle1, Sprite rectangle2 ) {
		if( 2.0 * Math.abs( rectangle1.x - rectangle2.x ) < rectangle1.width + rectangle2.width - inaccuracy && 2.0 * Math.abs( rectangle1.y - rectangle2.y ) < rectangle1.height + rectangle2.height - inaccuracy ) return true;
	}



	public static int rectangleWithTriangle( Sprite rectangle, Sprite triangle ) {
		if( rectangleWithRectangle( rectangle, triangle ) ) {
			triangle.getHypotenuse( serviceLine1 );
			triangle.getRightAngleVertex( servicePivot1 );
			if( serviceLine1.pivotOrientation( rectangle ) == serviceLine1.pivotOrientation( servicePivot1 ) ) return true;
			double leftX, double topY, double rightX, double bottomY;
			rectangle.getBounds( leftX, topY, rightX, bottomY );
			int o = serviceLine1.pointOrientation( leftX, topY );
			if( o != serviceLine1.pointOrientation( rightX, topY ) ) return true;
			if( o != serviceLine1.pointOrientation( leftX, bottomY ) ) return true;
			if( o != serviceLine1.pointOrientation( rightX, bottomY ) ) return true;
		}
	}



	public static int rectangleWithLineSegment( Sprite rectangle, Sprite lSPivot1, Sprite lSPivot2 ) {
		if( pivotWithRectangle( lSPivot1, rectangle ) ) return true;
		rectangle.getBounds( servicePivots[ 0 ].x, servicePivots[ 0 ].y, servicePivots[ 2 ].x, servicePivots[ 2 ].y );
		rectangle.getBounds( servicePivots[ 1 ].x, servicePivots[ 3 ].y, servicePivots[ 3 ].x, servicePivots[ 1 ].y );
		for( int n=0; n <= 3; n++ ) {
			if( lineSegmentWithLineSegment( servicePivots[ n ], servicePivots[ ( n + 1 ) mod 4 ], lSPivot1, lSPivot2 ) ) return true;
		}
	}



	public static int rectangleWithRay( Sprite rectangle, Sprite ray ) {
		rectangle.getBounds( servicePivots[ 0 ].x, servicePivots[ 0 ].y, servicePivots[ 2 ].x, servicePivots[ 2 ].y );
		rectangle.getBounds( servicePivots[ 1 ].x, servicePivots[ 3 ].y, servicePivots[ 3 ].x, servicePivots[ 1 ].y );
		for( int n=0; n <= 3; n++ ) {
			if( rayWithLineSegment( ray, servicePivots[ n ], servicePivots[ ( n + 1 ) mod 4 ] ) ) return true;
		}
	}



	public static int triangleWithTriangle( Sprite triangle1, Sprite triangle2 ) {
		if( rectangleWithRectangle( triangle1, triangle2 ) ) {
			triangle1.getRightAngleVertex( servicePivot3 );
			triangle2.getRightAngleVertex( servicePivot4 );

			triangle1.getOtherVertices( servicePivot1, servicePivot2 );
			triangle2.getHypotenuse( serviceLine1 );
			int o1 = serviceLine1.pivotOrientation( servicePivot4 );
			if( pivotWithRectangle( servicePivot1, triangle2 ) then if o1 == serviceLine1.pivotOrientation( servicePivot1 ) ) return true;
			if( pivotWithRectangle( servicePivot2, triangle2 ) then if o1 == serviceLine1.pivotOrientation( servicePivot2 ) ) return true;
			if( pivotWithRectangle( servicePivot3, triangle2 ) then if o1 == serviceLine1.pivotOrientation( servicePivot3 ) ) return true;
			int o3 = ( serviceLine1.pivotOrientation( servicePivot3 ) != serviceLine1.pivotOrientation( servicePivot1 ) );

			triangle2.getOtherVertices( servicePivots[ 0 ], servicePivots[ 1 ] );
			triangle1.getHypotenuse( serviceLine1 );
			int o2 = serviceLine1.pivotOrientation( servicePivot3 );
			if( pivotWithRectangle( servicePivots[ 0 ], triangle1 ) then if o2 == serviceLine1.pivotOrientation( servicePivots[ 0 ] ) ) return true;
			if( pivotWithRectangle( servicePivots[ 1 ], triangle1 ) then if o2 == serviceLine1.pivotOrientation( servicePivots[ 1 ] ) ) return true;
			if( pivotWithRectangle( servicePivot4, triangle1 ) then if o2 == serviceLine1.pivotOrientation( servicePivot4 ) ) return true;

			if( lineSegmentWithLineSegment( servicePivot1, servicePivot2, servicePivots[ 0 ], servicePivots[ 1 ] ) ) return true;
			if( o3 then if serviceLine1.pivotOrientation( servicePivot4 ) != serviceLine1.pivotOrientation( servicePivots[ 0 ] ) ) return true;
		}
	}



	public static int triangleWithLineSegment( Sprite triangle, Sprite lSPivot1, Sprite lSPivot2 ) {
		if( pivotWithTriangle( lSPivot1, triangle ) ) return true;
		triangle.getOtherVertices( servicePivots[ 0 ], servicePivots[ 1 ] );
		triangle.getRightAngleVertex( servicePivots[ 2 ] );
		for( int n=0; n <= 2; n++ ) {
			if( lineSegmentWithLineSegment( servicePivots[ n ], servicePivots[ ( n + 1 ) mod 3 ], lSPivot1, lSPivot2 ) ) return true;
		}
	}



	public static int triangleWithRay( Sprite triangle, Sprite ray ) {
		triangle.getOtherVertices( servicePivots[ 0 ], servicePivots[ 1 ] );
		triangle.getRightAngleVertex( servicePivots[ 2 ] );
		for( int n=0; n <= 2; n++ ) {
			if( rayWithLineSegment( ray, servicePivots[ n ], servicePivots[ ( n + 1 ) mod 3 ] ) ) return true;
		}
	}



	public static int rayWithLineSegment( Sprite ray, Sprite lSPivot1, Sprite lSPivot2 ) {
		ray.toLine( serviceLine1 );
		if( serviceLine1.intersectionWithLineSegment( lSPivot1, lSPivot2, servicePivot1 ) ) {
			if( ray.hasPivot( servicePivot1 ) ) return true;
		}
	}



	public static int lineSegmentWithLineSegment( Sprite lS1pivot1, Sprite lS1pivot2, Sprite lS2pivot1, Sprite lS2pivot2 ) {
		Line.fromPivots( lS1pivot1, lS1pivot2, serviceLine1 );
		if( serviceLine1.pivotOrientation( lS2pivot1 ) == serviceLine1.pivotOrientation( lS2pivot2 ) ) return false;
		Line.fromPivots( lS2pivot1, lS2pivot2, serviceLine1 );
		if( serviceLine1.pivotOrientation( lS1pivot1 ) != serviceLine1.pivotOrientation( lS1pivot2 ) ) return true;
	}



	public static int rayWithRay( Sprite ray1, Sprite ray2 ) {
		ray1.toLine( serviceLine1 );
		ray2.toLine( serviceLine2 );
		serviceLine1.intersectionWithLine( serviceLine2, servicePivot1 );
		if( ! ray1.hasPivot( servicePivot1 ) ) return false;
		if( ray2.hasPivot( servicePivot1 ) ) return true;
	}



	public static int rasterWithRaster( Sprite raster1, Sprite raster2 ) {
		Visualizer visualizer1 = raster1.visualizer;
		Visualizer visualizer2 = raster2.visualizer;
		Image image1 = visualizer1.image;
		Image image2 = visualizer2.image;
		if( ! image1 || ! image2 ) return false;
		if raster1.angle = 0 && raster2.angle =0 && raster1.width * image2.width() == raster2.width * image2.width() && ..;
				raster1.height * image2.height() = raster2.height * image2.height() then;
			double xScale = image1.width() / raster1.width;
			double yScale = image1.height() / raster1.height;
			return imagesCollide( image1.bMaxImage, raster1.x * xScale, raster1.y * yScale, raster1.frame, ..;
					image2.bMaxImage, raster2.x * xScale, raster2.y * yScale, raster2.frame );
		} else {
			double xScale1 = image1.width() / raster1.width;
			double yScale1 = image1.height() / raster1.height;
			double xScale2 = image2.width() / raster2.width;
			double yScale2 = image2.height() / raster2.height;
			double xScale = Math.max( xScale1, xScale2 );
			double yScale = Math.max( yScale1, yScale2 );
			return imagesCollide2( image1.bMaxImage, raster1.x * xScale, raster1.y * yScale, raster1.frame, raster1.angle, ..;
					xScale / xScale1, yScale / yScale1, image2.bMaxImage, raster2.x * xScale, raster2.y * yScale, ..;
					raster2.frame, raster2.angle, xScale / xScale2, yScale / yScale2 );
		}
	}
}


// ------------------------------------------------ Overlapping ---------------------------------------------------

public class Overlap {
	public Sprite servicePivot1 = Sprite.fromShape( 0, 0, 0, 0, Sprite.pivot );
	public Sprite servicePivot2 = Sprite.fromShape( 0, 0, 0, 0, Sprite.pivot );
	public Sprite serviceOval1 = Sprite.fromShapeType( Sprite.oval );



	public static int circleAndPivot( Sprite circle, Sprite pivot ) {
		if( 4.0 * circle.distance2to( pivot ) <= circle.width * circle.width ) return true;
	}



	public static int circleAndOval( Sprite circle, Sprite oval ) {
		if( oval.width == oval.height ) return circleAndCircle( circle, oval );

		if( oval.width > oval.height ) {
			double dWidth = oval.width - oval.height;
			serviceOval1.x = oval.x - dWidth;
			serviceOval1.y = oval.y;
			serviceOval1.width = oval.height;
			if( ! circleAndCircle( circle, serviceOval1 ) ) return false;
			serviceOval1.x = oval.x + dWidth;
		} else {
			double dHeight = oval.height - oval.width;
			serviceOval1.x = oval.x;
			serviceOval1.y = oval.y - dHeight;
			serviceOval1.width = oval.width;
			if( ! circleAndCircle( circle, serviceOval1 ) ) return false;
			serviceOval1.y = oval.y + dHeight;
		}
		return circleAndCircle( circle, serviceOval1 );
	}



	public static int circleAndCircle( Sprite circle1, Sprite circle2 ) {
		double diameters = circle1.width + circle2.width;
		if( 4.0 * circle1.distance2to( circle2 ) <= diameters * diameters ) return true;
	}



	public static int circleAndRectangle( Sprite circle, Sprite rectangle ) {
		if( rectangleAndRectangle( circle, rectangle ) ) {
			double leftX, double topY, double rightX, double bottomY;
			rectangle.getBounds( leftX, topY, rightX, bottomY );
			servicePivot1.x = leftX;
			servicePivot1.y = topY;
			if( ! circleAndPivot( circle, servicePivot1 ) ) return false;
			servicePivot1.x = rightX;
			if( ! circleAndPivot( circle, servicePivot1 ) ) return false;
			servicePivot1.y = bottomY;
			if( ! circleAndPivot( circle, servicePivot1 ) ) return false;
			servicePivot1.x = leftX;
			if( circleAndPivot( circle, servicePivot1 ) ) return true;
		}
	}



	public static int circleAndTriangle( Sprite circle, Sprite triangle ) {
		triangle.getRightAngleVertex( servicePivot1 );
		if( ! circleAndPivot( circle, servicePivot1 ) ) return false;
		triangle.getOtherVertices( servicePivot1, servicePivot2 );
		if( ! circleAndPivot( circle, servicePivot1 ) ) return false;
		if( ! circleAndPivot( circle, servicePivot2 ) ) return false;
		return true;
	}



	public static int rectangleAndPivot( Sprite rectangle, Sprite pivot ) {
		if ( rectangle.x - 0.5 * rectangle.width <= pivot.x ) && ( rectangle.y - 0.5 * rectangle.height <= pivot.y ) && ..;
				( rectangle.x + 0.5 * rectangle.width >= pivot.x ) && ( rectangle.y + 0.5 * rectangle.height >= pivot.y ) then return true;
	}



	public static int rectangleAndRectangle( Sprite rectangle1, Sprite rectangle2 ) {
		if ( rectangle1.x - 0.5 * rectangle1.width <= rectangle2.x - 0.5 * rectangle2.width ) && ( rectangle1.y - 0.5 * rectangle1.height <= rectangle2.y - 0.5 * rectangle2.height ) && ..;
			( rectangle1.x + 0.5 * rectangle1.width >= rectangle2.x + 0.5 * rectangle2.width ) && ( rectangle1.y + 0.5 * rectangle1.height >= rectangle2.y + 0.5 * rectangle2.height ) then return true;
	}
}
