/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.sprites;

import dwlab.base.Graphics;
import dwlab.base.Service.Margins;
import dwlab.shapes.Line;
import dwlab.shapes.LineSegment;
import dwlab.sprites.Sprite.ShapeType;
import dwlab.visualizers.Image;
import dwlab.visualizers.Visualizer;

public class Collision {
	/**
	* Constant for dealing with inaccuracy of double type operations.
	*/
	public static double inaccuracy = 0.000001;

	public static Sprite servicePivot1 = new Sprite();
	public static Sprite servicePivot2 = new Sprite();
	public static Sprite servicePivot3 = new Sprite();
	public static Sprite servicePivot4 = new Sprite();
	public static Sprite servicePivots[] = { new Sprite(), new Sprite(), new Sprite(), new Sprite() };
	public static Sprite serviceOval1 = new Sprite( ShapeType.OVAL );
	public static Sprite serviceOval2 = new Sprite( ShapeType.OVAL );
	public static Line serviceLine1 = new Line();
	public static Line serviceLine2 = new Line();
	public static LineSegment serviceLineSegment = new LineSegment( null, null );
	public static Margins serviceMargins = new Margins();



	public static boolean pivotWithOval( Sprite pivot, Sprite oval ) {
		oval = oval.toCircle( pivot, serviceOval1 );
		double radius = 0.5 * oval.getWidth() - inaccuracy;
		if( pivot.distance2to( oval ) < radius * radius ) return true; else return false;
	}



	public static boolean pivotWithRectangle( Sprite pivot, Sprite rectangle ) {
		if( 2.0 * Math.abs( pivot.getX() - rectangle.getX() ) < rectangle.getWidth() - inaccuracy && 2.0 * Math.abs( pivot.getY() - rectangle.getY() )
				< rectangle.getHeight() - inaccuracy ) return true; else return false; 
	}



	public static boolean pivotWithTriangle( Sprite pivot, Sprite triangle ) {
		if( pivotWithRectangle( pivot, triangle ) ) {
			triangle.getHypotenuse( serviceLine1 );
			triangle.getRightAngleVertex( servicePivot1 );
			if( serviceLine1.pivotOrientation( pivot ) == serviceLine1.pivotOrientation( servicePivot1 ) ) return true;
		}
		return false;
	}



	public static boolean ovalWithOval( Sprite oval1, Sprite oval2 ) {
		oval1 = oval1.toCircle( oval2, serviceOval1 );
		oval2 = oval2.toCircle( oval1, serviceOval2 );
		double radiuses = 0.5 * ( oval1.getWidth() + oval2.getWidth() ) - inaccuracy;
		if( oval1.distance2to( oval2 ) < radiuses * radiuses ) return true; else return false;
	}



	public static boolean ovalWithRectangle( Sprite oval, Sprite rectangle ) {
		oval = oval.toCircle( rectangle, serviceOval1 );
		if( ( rectangle.getX() - rectangle.getWidth() * 0.5d <= oval.getX() && oval.getX() <= rectangle.getX() + rectangle.getWidth() * 0.5d )
				|| ( rectangle.getY() - rectangle.getHeight() * 0.5d <= oval.getY() && oval.getY() <= rectangle.getY() + rectangle.getHeight() * 0.5d ) ) {
			if( 2d * Math.abs( oval.getX() - rectangle.getX() ) < oval.getWidth() + rectangle.getWidth() - inaccuracy && 2d * Math.abs( oval.getY() - rectangle.getY() )
					< oval.getWidth() + rectangle.getHeight() - inaccuracy ) return true;
		} else {
			double dX = Math.abs( rectangle.getX() - oval.getX() ) - 0.5 * rectangle.getWidth();
			double dY = Math.abs( rectangle.getY() - oval.getY() ) - 0.5 * rectangle.getHeight();
			double radius = 0.5 * oval.getWidth() - inaccuracy;
			if( dX * dX + dY * dY < radius * radius ) return true;
		}
		return false;
	}



	public static boolean ovalWithLineSegment( Sprite oval, Sprite lSPivot1, Sprite lSPivot2 ) {
		serviceOval1.setCoords( 0.5d * ( lSPivot1.getX() + lSPivot2.getX() ), 0.5d * ( lSPivot1.getY() + lSPivot2.getY() ) );
		serviceOval1.setDiameter( 0.5d * lSPivot1.distanceTo( lSPivot2 ) );
		if( ovalWithOval( oval, serviceOval1 ) ) {
			serviceLine1.usePivots( lSPivot1, lSPivot2 );
			oval = oval.toCircleUsingLine( serviceLine1, serviceOval2 );
			if( serviceLine1.distanceTo( oval ) < 0.5 * Math.max( oval.getWidth(), oval.getHeight() ) - inaccuracy ) {
				serviceLine1.pivotProjection( oval, servicePivot1 );
				if( pivotWithOval( servicePivot1, serviceOval1 ) && servicePivot1.distanceTo( serviceOval2 ) < serviceOval1.getWidth() - inaccuracy ) return true;
			}
		}
		return false;
	}



	public static boolean ovalWithTriangle( Sprite oval, Sprite triangle ) {
		if( ovalWithRectangle( oval, triangle ) ) {
			triangle.getHypotenuse( serviceLine1 );
			oval = oval.toCircleUsingLine( serviceLine1, serviceOval1 );
			triangle.getRightAngleVertex( servicePivot1 );
			if( serviceLine1.pivotOrientation( oval ) == serviceLine1.pivotOrientation( servicePivot1 ) ) return true;
			if( ! serviceLine1.collisionPointsWithCircle( oval, servicePivot1, servicePivot2 ) ) return false;
			if( pivotWithRectangle( servicePivot1, triangle ) || pivotWithRectangle( servicePivot2, triangle ) ) return true;
		}
		return false;
	}



	public static boolean ovalWithRay( Sprite oval, Sprite ray ) {
		ray.toLine( serviceLine1 );
		oval.toCircleUsingLine( serviceLine1, serviceOval1 );
		if( serviceLine1.collisionPointsWithCircle( serviceOval1, servicePivot1, servicePivot2 ) ) {
			if( ray.hasPivot( servicePivot1 ) ) return true;
			if( ray.hasPivot( servicePivot2 ) ) return true;
		}
		if( pivotWithOval( ray, oval ) ) return true; else return false;
	}



	public static boolean rectangleWithRectangle( Sprite rectangle1, Sprite rectangle2 ) {
		if( 2.0 * Math.abs( rectangle1.getX() - rectangle2.getX() ) < rectangle1.getWidth() + rectangle2.getWidth() - inaccuracy
				&& 2.0 * Math.abs( rectangle1.getY() - rectangle2.getY() ) < rectangle1.getHeight() + rectangle2.getHeight() - inaccuracy ) return true; else return false;
	}



	public static boolean rectangleWithTriangle( Sprite rectangle, Sprite triangle ) {
		if( rectangleWithRectangle( rectangle, triangle ) ) {
			triangle.getHypotenuse( serviceLine1 );
			triangle.getRightAngleVertex( servicePivot1 );
			if( serviceLine1.pivotOrientation( rectangle ) == serviceLine1.pivotOrientation( servicePivot1 ) ) return true;
			rectangle.getBounds( serviceMargins );
			int o = serviceLine1.pointOrientation( serviceMargins.min.x, serviceMargins.min.y );
			if( o != serviceLine1.pointOrientation( serviceMargins.max.x, serviceMargins.min.y ) ) return true;
			if( o != serviceLine1.pointOrientation( serviceMargins.min.x, serviceMargins.max.y ) ) return true;
			if( o != serviceLine1.pointOrientation( serviceMargins.max.x, serviceMargins.max.y ) ) return true;
		}
		return false;
	}



	public static boolean rectangleWithLineSegment( Sprite rectangle, Sprite lSPivot1, Sprite lSPivot2 ) {
		if( pivotWithRectangle( lSPivot1, rectangle ) ) return true;
		rectangle.getPivots( servicePivots[ 0 ], servicePivots[ 1 ], servicePivots[ 2 ], servicePivots[ 3 ] );
		for( int n=0; n <= 3; n++ ) {
			if( lineSegmentWithLineSegment( servicePivots[ n ], servicePivots[ ( n + 1 ) % 4 ], lSPivot1, lSPivot2 ) ) return true;
		}
		return false;
	}



	public static boolean rectangleWithRay( Sprite rectangle, Sprite ray ) {
		rectangle.getPivots( servicePivots[ 0 ], servicePivots[ 1 ], servicePivots[ 2 ], servicePivots[ 3 ] );
		for( int n=0; n <= 3; n++ ) {
			if( rayWithLineSegment( ray, servicePivots[ n ], servicePivots[ ( n + 1 ) % 4 ] ) ) return true;
		}
		return false;
	}



	public static boolean triangleWithTriangle( Sprite triangle1, Sprite triangle2 ) {
		if( rectangleWithRectangle( triangle1, triangle2 ) ) {
			triangle1.getRightAngleVertex( servicePivot3 );
			triangle2.getRightAngleVertex( servicePivot4 );

			triangle1.getOtherVertices( servicePivot1, servicePivot2 );
			triangle2.getHypotenuse( serviceLine1 );
			int o1 = serviceLine1.pivotOrientation( servicePivot4 );
			if( pivotWithRectangle( servicePivot1, triangle2 ) ) if ( o1 == serviceLine1.pivotOrientation( servicePivot1 ) ) return true;
			if( pivotWithRectangle( servicePivot2, triangle2 ) ) if ( o1 == serviceLine1.pivotOrientation( servicePivot2 ) ) return true;
			if( pivotWithRectangle( servicePivot3, triangle2 ) ) if ( o1 == serviceLine1.pivotOrientation( servicePivot3 ) ) return true;
			boolean o3 = ( serviceLine1.pivotOrientation( servicePivot3 ) != serviceLine1.pivotOrientation( servicePivot1 ) );

			triangle2.getOtherVertices( servicePivots[ 0 ], servicePivots[ 1 ] );
			triangle1.getHypotenuse( serviceLine1 );
			int o2 = serviceLine1.pivotOrientation( servicePivot3 );
			if( pivotWithRectangle( servicePivots[ 0 ], triangle1 ) ) if ( o2 == serviceLine1.pivotOrientation( servicePivots[ 0 ] ) ) return true;
			if( pivotWithRectangle( servicePivots[ 1 ], triangle1 ) ) if ( o2 == serviceLine1.pivotOrientation( servicePivots[ 1 ] ) ) return true;
			if( pivotWithRectangle( servicePivot4, triangle1 ) ) if ( o2 == serviceLine1.pivotOrientation( servicePivot4 ) ) return true;

			if( lineSegmentWithLineSegment( servicePivot1, servicePivot2, servicePivots[ 0 ], servicePivots[ 1 ] ) ) return true;
			if( o3 ) if ( serviceLine1.pivotOrientation( servicePivot4 ) != serviceLine1.pivotOrientation( servicePivots[ 0 ] ) ) return true;
		}
		return false;
	}



	public static boolean triangleWithLineSegment( Sprite triangle, Sprite lSPivot1, Sprite lSPivot2 ) {
		if( pivotWithTriangle( lSPivot1, triangle ) ) return true;
		triangle.getOtherVertices( servicePivots[ 0 ], servicePivots[ 1 ] );
		triangle.getRightAngleVertex( servicePivots[ 2 ] );
		for( int n=0; n <= 2; n++ ) {
			if( lineSegmentWithLineSegment( servicePivots[ n ], servicePivots[ ( n + 1 ) % 3 ], lSPivot1, lSPivot2 ) ) return true;
		}
		return false;
	}



	public static boolean triangleWithRay( Sprite triangle, Sprite ray ) {
		triangle.getOtherVertices( servicePivots[ 0 ], servicePivots[ 1 ] );
		triangle.getRightAngleVertex( servicePivots[ 2 ] );
		for( int n=0; n <= 2; n++ ) {
			if( rayWithLineSegment( ray, servicePivots[ n ], servicePivots[ ( n + 1 ) % 3 ] ) ) return true;
		}
		return false;
	}



	public static boolean rayWithLineSegment( Sprite ray, Sprite lSPivot1, Sprite lSPivot2 ) {
		ray.toLine( serviceLine1 );
		if( serviceLine1.intersectionWithLineSegment( lSPivot1, lSPivot2, servicePivot1 ) != null ) {
			if( ray.hasPivot( servicePivot1 ) ) return true;
		}
		return false;
	}



	public static boolean lineSegmentWithLineSegment( Sprite lS1pivot1, Sprite lS1pivot2, Sprite lS2pivot1, Sprite lS2pivot2 ) {
		serviceLine1.usePivots( lS1pivot1, lS1pivot2 );
		if( serviceLine1.pivotOrientation( lS2pivot1 ) == serviceLine1.pivotOrientation( lS2pivot2 ) ) return false;
		serviceLine1.usePivots( lS2pivot1, lS2pivot2 );
		if( serviceLine1.pivotOrientation( lS1pivot1 ) != serviceLine1.pivotOrientation( lS1pivot2 ) ) return true; else return false;
	}



	public static boolean rayWithRay( Sprite ray1, Sprite ray2 ) {
		ray1.toLine( serviceLine1 );
		ray2.toLine( serviceLine2 );
		serviceLine1.intersectionWithLine( serviceLine2, servicePivot1 );
		if( ! ray1.hasPivot( servicePivot1 ) ) return false;
		if( ray2.hasPivot( servicePivot1 ) ) return true; else return false;
	}



	public static boolean rasterWithRaster( Sprite raster1, Sprite raster2 ) {
		Visualizer visualizer1 = raster1.visualizer;
		Visualizer visualizer2 = raster2.visualizer;
		Image image1 = visualizer1.image;
		Image image2 = visualizer2.image;
		if( image1 != null || image2 != null ) return false;
		if( raster1.angle == 0d && raster2.angle == 0d && raster1.getWidth() * image2.getWidth() == raster2.getWidth() * image2.getWidth()
				&& raster1.getHeight() * image2.getHeight() == raster2.getHeight() * image2.getHeight() ) {
			double xScale = image1.getWidth() / raster1.getWidth();
			double yScale = image1.getHeight() / raster1.getHeight();
			return Graphics.imagesCollide( image1, raster1.frame, raster1.getX() * xScale, raster1.getY() * yScale, 
					image2, raster2.frame, raster2.getX() * xScale, raster2.getY() * yScale );
		} else {
			double xScale1 = image1.getWidth() / raster1.getWidth();
			double yScale1 = image1.getHeight() / raster1.getHeight();
			double xScale2 = image2.getWidth() / raster2.getWidth();
			double yScale2 = image2.getHeight() / raster2.getHeight();
			double xScale = Math.max( xScale1, xScale2 );
			double yScale = Math.max( yScale1, yScale2 );
			return Graphics.imagesCollide( image1, raster1.frame, raster1.getX() * xScale, raster1.getY() * yScale, xScale / xScale1, yScale / yScale1, 
					raster1.angle, image2, raster2.frame, raster2.getX() * xScale, raster2.getY() * yScale, xScale / xScale2, yScale / yScale2, raster2.angle );
		}
	}
}