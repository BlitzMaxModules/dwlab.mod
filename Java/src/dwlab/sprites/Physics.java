package dwlab.sprites;
import java.lang.Math;
import dwlab.shapes.Line;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php


for( int n=0; n <= 3; n++ ) {
	if( n < 2 ) Wedge.serviceLines[ n ] == new Line();
	Wedge.servicePivots[ n ] = Sprite.fromShape( 0, 0, 0, 0, Sprite.pivot );
}

public class Wedge {
	public Line serviceLines[] = new Line()[ 2 ];
	public Sprite servicePivots[] = new Sprite()[ 4 ];
	public Sprite serviceOval1 = Sprite.fromShapeType( Sprite.oval );
	public Sprite serviceOval2 = Sprite.fromShapeType( Sprite.oval );



	public static void pivotAndOval( Sprite pivot, Sprite oval, double dX var, double dY var ) {
		oval = oval.toCircle( pivot, serviceOval1 );
		double k = 0.5 * oval.width / oval.distanceTo( pivot ) - 1.0;
		dX = ( pivot.x - oval.x ) * k;
		dY = ( pivot.y - oval.y ) * k;
	}



	public static void pivotAndRectangle( Sprite pivot, Sprite rectangle, double dX var, double dY var ) {
		if( Math.abs( pivot.y - rectangle.y ) * rectangle.width >= Math.abs( pivot.x - rectangle.x ) * rectangle.height ) {
			dY = rectangle.y + 0.5 * rectangle.height * sgn( pivot.y - rectangle.y ) - pivot.y;
		} else {
			dX = rectangle.x + 0.5 * rectangle.width * sgn( pivot.x - rectangle.x ) - pivot.x;
		}
	}



	public static void pivotAndTriangle( Sprite pivot, Sprite triangle, double dX var, double dY var ) {
		dY = serviceLines[ 0 ].getY( pivot.x ) - pivot.y;

		double dX1, double dY1;
		pivotAndRectangle( pivot, triangle, dX1, dY1 );
		if( distance2( dX1, dY1 ) < dY * dY ) {
			dX = dX1;
			dY = dY1;
		}
	}



	public static void ovalAndOval( Sprite oval1, Sprite oval2, double dX var, double dY var ) {
		oval1 = oval1.toCircle( oval2, serviceOval1 );
		oval2 = oval2.toCircle( oval1, serviceOval2  );
		double k = 0.5 * ( oval1.width + oval2.width ) / oval1.distanceTo( oval2 ) - 1.0;
		dX = ( oval1.x - oval2.x ) * k;
		dY = ( oval1.y - oval2.y ) * k;
	}



	public static void ovalAndRectangle( Sprite oval, Sprite rectangle, double dX var, double dY var ) {
		int a = ( Math.abs( oval.y - rectangle.y ) * rectangle.width >= Math.abs( oval.x - rectangle.x ) * rectangle.height );
		if( ( oval.x > rectangle.leftX() && oval.x < rectangle.rightX() ) && a ) {
			dX = 0;
			dY = ( 0.5 * ( rectangle.height + oval.height ) - Math.abs( rectangle.y - oval.y ) ) * sgn( oval.y - rectangle.y );
		} else if( oval.y > rectangle.topY() && oval.y < rectangle.bottomY() && ! a then ) {
			dX = ( 0.5 * ( rectangle.width + oval.width ) - Math.abs( rectangle.x - oval.x ) ) * sgn( oval.x - rectangle.x );
			dY = 0;
		} else {
			servicePivots[ 0 ].x = rectangle.x + 0.5 * rectangle.width * sgn( oval.x - rectangle.x );
			servicePivots[ 0 ].y = rectangle.y + 0.5 * rectangle.height * sgn( oval.y - rectangle.y );
			oval = oval.toCircle( servicePivots[ 0 ], serviceOval1 );
			double k = 1.0 - 0.5 * oval.width / oval.distanceTo( servicePivots[ 0 ] );
			dX = ( servicePivots[ 0 ].x - oval.x ) * k;
			dY = ( servicePivots[ 0 ].y - oval.y ) * k;
		}
	}



	public static void ovalAndTriangle( Sprite oval, Sprite triangle, double dX var, double dY var ) {
		triangle.getRightAngleVertex( servicePivots[ 2 ] );
		triangle.getOtherVertices( servicePivots[ 0 ], servicePivots[ 1 ] );
		serviceOval1 = oval.toCircle( servicePivots[ 2 ], serviceOval1 );
		double vDistance = 0.5 * distance( triangle.width, triangle.height ) * serviceOval1.width / triangle.width;
		double dHeight = 0.5 * ( oval.height - serviceOval1.height );
		double dDX = 0.5 * serviceOval1.width / vDistance * cathetus( vDistance, 0.5 * serviceOval1.width );
		int dir = -1;
		if( triangle.shapeType = Sprite.bottomLeftTriangle || triangle.shapeType = Sprite.bottomRightTriangle ) dir == 1;
		if( triangle.shapeType = Sprite.topRightTriangle || triangle.shapeType = Sprite.bottomRightTriangle ) dDX == -dDX;
		if( serviceOval1.x < triangle.leftX() + dDX ) {
			dY = servicePivots[ 0 ].y - dir * cathetus( serviceOval1.width * 0.5, serviceOval1.x - servicePivots[ 0 ].x ) - serviceOval1.y;
		} else if( serviceOval1.x > triangle.rightX() + dDX then ) {
			dY = servicePivots[ 1 ].y - dir * cathetus( serviceOval1.width * 0.5, serviceOval1.x - servicePivots[ 1 ].x ) - serviceOval1.y;
		} else {
			dY = serviceLines[ 0 ].getY( serviceOval1.x ) - dir * ( vDistance + dHeight ) - oval.y;
		}

		double dX1, double dY1;
		ovalAndRectangle( oval, triangle, dX1, dY1 );
		if( distance2( dX1, dY1 ) < dY * dY ) {
			dX = dX1;
			dY = dY1;
		}
	}



	public static void rectangleAndRectangle( Sprite rectangle1, Sprite rectangle2, double dX var, double dY var ) {
		dX = 0.5 * ( rectangle1.width + rectangle2.width ) - Math.abs( rectangle1.x - rectangle2.x );
		dY = 0.5 * ( rectangle1.height + rectangle2.height ) - Math.abs( rectangle1.y - rectangle2.y );

		if( dX < dY ) {
			dX *= sgn( rectangle1.x - rectangle2.x );
			dY = 0;
		} else {
			dX = 0;
			dY *= sgn( rectangle1.y - rectangle2.y );
		}
	}



	public static void rectangleAndTriangle( Sprite rectangle, Sprite triangle, double dX var, double dY var ) {
		double x;
		if( triangle.shapeType = Sprite.topLeftTriangle || triangle.shapeType == Sprite.bottomLeftTriangle ) {
			x = rectangle.leftX();
		} else {
			x = rectangle.rightX();
		}

		triangle.getHypotenuse( serviceLines[ 0 ] );
		if triangle.shapeType = Sprite.topLeftTriangle || triangle.shapeType == Sprite.topRightTriangle;
			dY = Math.min( serviceLines[ 0 ].getY( x ), triangle.bottomY() ) - rectangle.topY();
		} else {
			dY = Math.max( serviceLines[ 0 ].getY( x ), triangle.topY() ) - rectangle.bottomY();
		}

		double dX1, double dY1;
		rectangleAndRectangle( rectangle, triangle, dX1, dY1 );
		if( distance2( dX1, dY1 ) < dY * dY ) {
			dX = dX1;
			dY = dY1;
		}
	}



	public static void popAngle( Sprite triangle1, Sprite triangle2, double dY var ) {
		triangle2.getRightAngleVertex( servicePivots[ 0 ] );
		triangle2.getHypotenuse( serviceLines[ 0 ] );
		triangle1.getOtherVertices( servicePivots[ 1 ], servicePivots[ 2 ] );
		int o = serviceLines[ 0 ].pivotOrientation( servicePivots[ 0 ] );
		for( int n=1; n <= 2; n++ ) {
			if( o == serviceLines[ 0 ].pivotOrientation( servicePivots[ n ] ) ) {
				if( doubleInLimits( servicePivots[ n ].x, triangle2.leftX(), triangle2.rightX() ) ) {
					dY = Math.max( dY, Math.abs( serviceLines[ 0 ].getY( servicePivots[ n ].x ) - servicePivots[ n ].y ) );
				}
			}
		}
	}



	public static void triangleAndTriangle( Sprite triangle1, Sprite triangle2, double dX var, double dY var ) {
		double dX1, double dY1;
		rectangleAndTriangle( triangle1, triangle2, dX1, dY1 );
		double d1 = distance2( dX1, dY1 );

		double dX2, double dY2;
		rectangleAndTriangle( triangle2, triangle1, dX2, dY2 );
		double d2 = distance2( dX2, dY2 );

		while( true ) {
			switch( triangle1.shapeType ) {
				case Sprite.topLeftTriangle:
					if( triangle2.shapeType != Sprite.bottomRightTriangle ) exit;
				case Sprite.topRightTriangle:
					if( triangle2.shapeType != Sprite.bottomLeftTriangle ) exit;
				case Sprite.bottomLeftTriangle:
					if( triangle2.shapeType != Sprite.topRightTriangle ) exit;
				case Sprite.bottomRightTriangle:
					if( triangle2.shapeType != Sprite.topLeftTriangle ) exit;
			}

			double dY3 = 0;
			popAngle( triangle1, triangle2, dY3 );
			popAngle( triangle2, triangle1, dY3 );
			if( dY3 == 0 ) exit;

			double dY32 = dY3 * dY3;
			if( dY32 < d1 && dY32 < d2 ) {
				triangle1.getRightAngleVertex( servicePivots[ 0 ] );
				triangle2.getRightAngleVertex( servicePivots[ 1 ] );
				dX = 0;
				dY = dY3 * sgn( servicePivots[ 0 ].y - servicePivots[ 1 ].y );
				return;
			} else {
				exit;
			}
		}

		if( d1 < d2 ) {
			dX = dX1;
			dY = dY1;
		} else {
			dX = -dX2;
			dY = -dY2;
		}
	}



	public static void separate( Sprite pivot1, Sprite pivot2, double dX, double dY, double pivot1movingResistance, double pivot2movingResistance ) {
		double k1, double k2;

		if( pivot1movingResistance < 0 ) {
			if( pivot2movingResistance < 0 ) {
				return;
			}
			pivot1movingResistance = 1.0;
			pivot1movingResistance = 0.0;
		} else if( pivot2movingResistance < 0 then ) {
			pivot1movingResistance = 0.0;
			pivot2movingResistance = 1.0		;
		}

		double movingResistanceSum = pivot1movingResistance + pivot2movingResistance;
		if( movingResistanceSum ) {
			k1 = pivot2movingResistance / movingResistanceSum;
			k2 = pivot1movingResistance / movingResistanceSum;
		} else {
			k1 = 0.5;
			k2 = 0.5;
		}

		if( k1 != 0.0 ) pivot1.alterCoords( k1 * dX, k1 * dY );
		if( k2 != 0.0 ) pivot2.alterCoords( -k2 * dX, -k2 * dY );
	}
}
