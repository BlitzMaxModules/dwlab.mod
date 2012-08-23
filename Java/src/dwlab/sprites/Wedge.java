/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.sprites;

import dwlab.base.Service;
import dwlab.shapes.Line;
import dwlab.shapes.Vector;
import dwlab.sprites.Sprite.ShapeType;

public class Wedge {
	private static Line serviceLines[] = { new Line(), new Line(), new Line() };
	private static Sprite servicePivots[] =  { new Sprite(), new Sprite(), new Sprite(), new Sprite() };
	private static Sprite serviceOval1 = new Sprite( ShapeType.OVAL );
	private static Sprite serviceOval2 = new Sprite( ShapeType.OVAL );


	public static void pivotAndOval( Sprite pivot, Sprite oval, Vector impulse ) {
		oval = oval.toCircle( pivot, serviceOval1 );
		double k = 0.5 * oval.getDiameter() / oval.distanceTo( pivot ) - 1.0;
		impulse.x = ( pivot.getX() - oval.getX() ) * k;
		impulse.y = ( pivot.getY() - oval.getY() ) * k;
	}


	public static void pivotAndRectangle( Sprite pivot, Sprite rectangle, Vector impulse ) {
		if( Math.abs( pivot.getY() - rectangle.getY() ) * rectangle.getWidth() >= Math.abs( pivot.getX() - rectangle.getX() ) * rectangle.getHeight() ) {
			impulse.y = rectangle.getY() + 0.5 * rectangle.getHeight() * Math.signum( pivot.getY() - rectangle.getY() ) - pivot.getY();
		} else {
			impulse.x = rectangle.getX() + 0.5 * rectangle.getWidth() * Math.signum( pivot.getX() - rectangle.getX() ) - pivot.getX();
		}
	}


	public static void pivotAndTriangle( Sprite pivot, Sprite triangle, Vector impulse ) {
		impulse.y = serviceLines[ 0 ].getY( pivot.getX() ) - pivot.getY();

		pivotAndRectangle( pivot, triangle, dX1, dY1 );
		if( Service.distance2( dX1, dY1 ) < dY * dY ) {
			impulse.x = dX1;
			impulse.y = dY1;
		}
	}

	
	public static void ovalAndOval( Sprite oval1, Sprite oval2, Vector impulse ) {
		oval1 = oval1.toCircle( oval2, serviceOval1 );
		oval2 = oval2.toCircle( oval1, serviceOval2  );
		double k = 0.5 * ( oval1.getWidth() + oval2.getWidth() ) / oval1.distanceTo( oval2 ) - 1.0;
		impulse.x = ( oval1.getX() - oval2.getX() ) * k;
		impulse.y = ( oval1.getY() - oval2.getY() ) * k;
	}


	public static void ovalAndRectangle( Sprite oval, Sprite rectangle, Vector impulse ) {
		boolean a = ( Math.abs( oval.getY() - rectangle.getY() ) * rectangle.getWidth() >= Math.abs( oval.getX() - rectangle.getX() ) * rectangle.getHeight() );
		if( ( oval.getX() > rectangle.leftX() && oval.getX() < rectangle.rightX() ) && a ) {
			impulse.x = 0;
			impulse.y = ( 0.5 * ( rectangle.getHeight() + oval.getHeight() ) - Math.abs( rectangle.getY() - oval.getY() ) ) * Math.signum( oval.getY() - rectangle.getY() );
		} else if( oval.getY() > rectangle.topY() && oval.getY() < rectangle.bottomY() && ! a ) {
			impulse.x = ( 0.5 * ( rectangle.getWidth() + oval.getWidth() ) - Math.abs( rectangle.getX() - oval.getX() ) ) * Math.signum( oval.getX() - rectangle.getX() );
			impulse.y = 0;
		} else {
			servicePivots[ 0 ].setCoords( rectangle.getX() + 0.5 * rectangle.getWidth() * Math.signum( oval.getX() - rectangle.getX() ),
					rectangle.getY() + 0.5 * rectangle.getHeight() * Math.signum( oval.getY() - rectangle.getY() ) );
			oval = oval.toCircle( servicePivots[ 0 ], serviceOval1 );
			double k = 1.0 - 0.5 * oval.getWidth() / oval.distanceTo( servicePivots[ 0 ] );
			impulse.x = ( servicePivots[ 0 ].getX() - oval.getX() ) * k;
			impulse.y = ( servicePivots[ 0 ].getY() - oval.getY() ) * k;
		}
	}


	public static void ovalAndTriangle( Sprite oval, Sprite triangle, Vector impulse ) {
		triangle.getRightAngleVertex( servicePivots[ 2 ] );
		triangle.getOtherVertices( servicePivots[ 0 ], servicePivots[ 1 ] );
		serviceOval1 = oval.toCircle( servicePivots[ 2 ], serviceOval1 );
		double vDistance = 0.5 * distance( triangle.getWidth(), triangle.getHeight() ) * serviceOval1.getWidth() / triangle.getWidth();
		double dHeight = 0.5 * ( oval.getHeight() - serviceOval1.getHeight() );
		double dimpulse.x = 0.5 * serviceOval1.getWidth() / vDistance * cathetus( vDistance, 0.5 * serviceOval1.getWidth() );
		int dir = -1;
		if( triangle.shapeType = Sprite.bottomLeftTriangle || triangle.shapeType = Sprite.bottomRightTriangle ) dir = 1;
		if( triangle.shapeType = Sprite.topRightTriangle || triangle.shapeType = Sprite.bottomRightTriangle ) dDX = -dDX;
		if( serviceOval1.getX() < triangle.leftX() + dDX ) {
			impulse.y = servicePivots[ 0 ].getY() - dir * cathetus( serviceOval1.getWidth() * 0.5, serviceOval1.getX() - servicePivots[ 0 ].getX() ) - serviceOval1.getY();
		} else if( serviceOval1.getX() > triangle.rightX() + dDX ) {
			impulse.y = servicePivots[ 1 ].getY() - dir * cathetus( serviceOval1.getWidth() * 0.5, serviceOval1.getX() - servicePivots[ 1 ].getX() ) - serviceOval1.getY();
		} else {
			impulse.y = serviceLines[ 0 ].getY( serviceOval1.getX() ) - dir * ( vDistance + dHeight ) - oval.getY();
		}

		double dX1, double dY1;
		ovalAndRectangle( oval, triangle, dX1, dY1 );
		if( distance2( dX1, dY1 ) < dY * dY ) {
			impulse.x = dX1;
			impulse.y = dY1;
		}
	}


	public static void rectangleAndRectangle( Sprite rectangle1, Sprite rectangle2, Vector impulse ) {
		impulse.x = 0.5 * ( rectangle1.getWidth() + rectangle2.getWidth() ) - Math.abs( rectangle1.getX() - rectangle2.getX() );
		impulse.y = 0.5 * ( rectangle1.getHeight() + rectangle2.getHeight() ) - Math.abs( rectangle1.getY() - rectangle2.getY() );

		if( dX < dY ) {
			dX *= sgn( rectangle1.getX() - rectangle2.getX() );
			impulse.y = 0;
		} else {
			impulse.x = 0;
			dY *= sgn( rectangle1.getY() - rectangle2.getY() );
		}
	}


	public static void rectangleAndTriangle( Sprite rectangle, Sprite triangle, Vector impulse ) {
		double x;
		if( triangle.shapeType = Sprite.topLeftTriangle || triangle.shapeType == Sprite.bottomLeftTriangle ) {
			x = rectangle.leftX();
		} else {
			x = rectangle.rightX();
		}

		triangle.getHypotenuse( serviceLines[ 0 ] );
		if triangle.shapeType = Sprite.topLeftTriangle || triangle.shapeType == Sprite.topRightTriangle;
			impulse.y = Math.min( serviceLines[ 0 ].getY( x ), triangle.bottomY() ) - rectangle.topY();
		} else {
			impulse.y = Math.max( serviceLines[ 0 ].getY( x ), triangle.topY() ) - rectangle.bottomY();
		}

		double dX1, double dY1;
		rectangleAndRectangle( rectangle, triangle, dX1, dY1 );
		if( distance2( dX1, dY1 ) < dY * dY ) {
			impulse.x = dX1;
			impulse.y = dY1;
		}
	}


	public static void popAngle( Sprite triangle1, Sprite triangle2, double dY var ) {
		triangle2.getRightAngleVertex( servicePivots[ 0 ] );
		triangle2.getHypotenuse( serviceLines[ 0 ] );
		triangle1.getOtherVertices( servicePivots[ 1 ], servicePivots[ 2 ] );
		int o = serviceLines[ 0 ].pivotOrientation( servicePivots[ 0 ] );
		for( int n=1; n <= 2; n++ ) {
			if( o == serviceLines[ 0 ].pivotOrientation( servicePivots[ n ] ) ) {
				if( doubleInLimits( servicePivots[ n ].getX(), triangle2.leftX(), triangle2.rightX() ) ) {
					impulse.y = Math.max( dY, Math.abs( serviceLines[ 0 ].getY( servicePivots[ n ].getX() ) - servicePivots[ n ].getY() ) );
				}
			}
		}
	}


	public static void triangleAndTriangle( Sprite triangle1, Sprite triangle2, Vector impulse ) {
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
				impulse.x = 0;
				impulse.y = dY3 * sgn( servicePivots[ 0 ].getY() - servicePivots[ 1 ].getY() );
				return;
			} else {
				exit;
			}
		}

		if( d1 < d2 ) {
			impulse.x = dX1;
			impulse.y = dY1;
		} else {
			impulse.x = -dX2;
			impulse.y = -dY2;
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
		} else if( pivot2movingResistance < 0 ) {
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
