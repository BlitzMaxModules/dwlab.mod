/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.shapes.sprites;

import dwlab.base.Service;
import dwlab.shapes.Line;
import dwlab.base.Vector;
import dwlab.shapes.sprites.Sprite.ShapeType;

public class Wedge {
	private static Vector serviceVector1 = new Vector();
	private static Vector serviceVector2 = new Vector();
	private static Sprite servicePivots[] =  { new Sprite(), new Sprite(), new Sprite(), new Sprite() };
	private static Sprite serviceOval1 = new Sprite( ShapeType.OVAL );
	private static Sprite serviceOval2 = new Sprite( ShapeType.OVAL );
	private static Line serviceLines[] = { new Line(), new Line(), new Line() };


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

		pivotAndRectangle( pivot, triangle, serviceVector1 );
		if( Service.distance2( serviceVector1.x, serviceVector1.y ) < serviceVector1.y * serviceVector1.y ) {
			impulse.x = serviceVector1.x;
			impulse.y = serviceVector1.y;
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
		double vDistance = 0.5 * Service.distance( triangle.getWidth(), triangle.getHeight() ) * serviceOval1.getWidth() / triangle.getWidth();
		double dHeight = 0.5 * ( oval.getHeight() - serviceOval1.getHeight() );
		double dDX = 0.5 * serviceOval1.getWidth() / vDistance * Service.cathetus( vDistance, 0.5 * serviceOval1.getWidth() );
		double dir = -1d;
		if( triangle.shapeType == ShapeType.BOTTOM_LEFT_TRIANGLE || triangle.shapeType == ShapeType.BOTTOM_RIGHT_TRIANGLE ) dir = 1d;
		if( triangle.shapeType == ShapeType.TOP_RIGHT_TRIANGLE || triangle.shapeType == ShapeType.BOTTOM_RIGHT_TRIANGLE ) dDX = -dDX;
		if( serviceOval1.getX() < triangle.leftX() + dDX ) {
			impulse.y = servicePivots[ 0 ].getY() - dir * Service.cathetus( serviceOval1.getWidth() * 0.5, serviceOval1.getX() - servicePivots[ 0 ].getX() ) - serviceOval1.getY();
		} else if( serviceOval1.getX() > triangle.rightX() + dDX ) {
			impulse.y = servicePivots[ 1 ].getY() - dir * Service.cathetus( serviceOval1.getWidth() * 0.5, serviceOval1.getX() - servicePivots[ 1 ].getX() ) - serviceOval1.getY();
		} else {
			impulse.y = serviceLines[ 0 ].getY( serviceOval1.getX() ) - dir * ( vDistance + dHeight ) - oval.getY();
		}

		ovalAndRectangle( oval, triangle, serviceVector1 );
		if( Service.distance2( serviceVector1.x, serviceVector1.y ) < impulse.y * impulse.y ) {
			impulse.x = serviceVector1.x;
			impulse.y = serviceVector1.y;
		}
	}


	public static void rectangleAndRectangle( Sprite rectangle1, Sprite rectangle2, Vector impulse ) {
		impulse.x = 0.5 * ( rectangle1.getWidth() + rectangle2.getWidth() ) - Math.abs( rectangle1.getX() - rectangle2.getX() );
		impulse.y = 0.5 * ( rectangle1.getHeight() + rectangle2.getHeight() ) - Math.abs( rectangle1.getY() - rectangle2.getY() );

		if( impulse.x < impulse.y ) {
			impulse.x *= Math.signum( rectangle1.getX() - rectangle2.getX() );
			impulse.y = 0;
		} else {
			impulse.x = 0;
			impulse.y *= Math.signum( rectangle1.getY() - rectangle2.getY() );
		}
	}


	public static void rectangleAndTriangle( Sprite rectangle, Sprite triangle, Vector impulse ) {
		double x;
		if( triangle.shapeType == ShapeType.TOP_LEFT_TRIANGLE || triangle.shapeType == ShapeType.BOTTOM_LEFT_TRIANGLE ) {
			x = rectangle.leftX();
		} else {
			x = rectangle.rightX();
		}

		triangle.getHypotenuse( serviceLines[ 0 ] );
		if( triangle.shapeType == ShapeType.TOP_LEFT_TRIANGLE || triangle.shapeType == ShapeType.TOP_RIGHT_TRIANGLE ) {
			impulse.y = Math.min( serviceLines[ 0 ].getY( x ), triangle.bottomY() ) - rectangle.topY();
		} else {
			impulse.y = Math.max( serviceLines[ 0 ].getY( x ), triangle.topY() ) - rectangle.bottomY();
		}

		rectangleAndRectangle( rectangle, triangle, serviceVector1 );
		if( Service.distance2( serviceVector1.x, serviceVector1.y ) < impulse.y * impulse.y ) {
			impulse.x = serviceVector1.x;
			impulse.y = serviceVector1.y;
		}
	}


	public static double popAngle( Sprite triangle1, Sprite triangle2, double dY ) {
		triangle2.getRightAngleVertex( servicePivots[ 0 ] );
		triangle2.getHypotenuse( serviceLines[ 0 ] );
		triangle1.getOtherVertices( servicePivots[ 1 ], servicePivots[ 2 ] );
		int o = serviceLines[ 0 ].pivotOrientation( servicePivots[ 0 ] );
		for( int n=1; n <= 2; n++ ) {
			if( o == serviceLines[ 0 ].pivotOrientation( servicePivots[ n ] ) ) {
				if( Service.inLimits( servicePivots[ n ].getX(), triangle2.leftX(), triangle2.rightX() ) ) {
					return Math.max( dY, Math.abs( serviceLines[ 0 ].getY( servicePivots[ n ].getX() ) - servicePivots[ n ].getY() ) );
				}
			}
		}
		return dY;
	}


	public static void triangleAndTriangle( Sprite triangle1, Sprite triangle2, Vector impulse ) {
		rectangleAndTriangle( triangle1, triangle2, serviceVector1 );
		double d1 = serviceVector1.length2();

		rectangleAndTriangle( triangle2, triangle1, serviceVector2 );
		double d2 = serviceVector2.length2();

		cycle: while( true ) {
			switch( triangle1.shapeType ) {
				case TOP_LEFT_TRIANGLE:
					if( triangle2.shapeType != ShapeType.BOTTOM_RIGHT_TRIANGLE ) break cycle;
					break;
				case TOP_RIGHT_TRIANGLE:
					if( triangle2.shapeType != ShapeType.BOTTOM_LEFT_TRIANGLE ) break cycle;
					break;
				case BOTTOM_LEFT_TRIANGLE:
					if( triangle2.shapeType != ShapeType.TOP_RIGHT_TRIANGLE ) break cycle;
					break;
				case BOTTOM_RIGHT_TRIANGLE:
					if( triangle2.shapeType != ShapeType.TOP_LEFT_TRIANGLE ) break cycle;
					break;
			}

			double dY3 = 0;
			dY3 = popAngle( triangle1, triangle2, dY3 );
			dY3 = popAngle( triangle2, triangle1, dY3 );
			if( dY3 == 0 ) break;

			double dY32 = dY3 * dY3;
			if( dY32 < d1 && dY32 < d2 ) {
				triangle1.getRightAngleVertex( servicePivots[ 0 ] );
				triangle2.getRightAngleVertex( servicePivots[ 1 ] );
				impulse.x = 0;
				impulse.y = dY3 * Math.signum( servicePivots[ 0 ].getY() - servicePivots[ 1 ].getY() );
				return;
			} else {
				break;
			}
		}

		if( d1 < d2 ) {
			impulse.x = serviceVector1.x;
			impulse.y = serviceVector1.y;
		} else {
			impulse.x = -serviceVector2.x;
			impulse.y = -serviceVector2.y;
		}
	}


	public static void separate( Sprite pivot1, Sprite pivot2, Vector impulse, double pivot1movingResistance, double pivot2movingResistance ) {
		if( pivot1movingResistance < 0 ) {
			if( pivot2movingResistance < 0 ) return;
			pivot1movingResistance = 1.0;
			pivot2movingResistance = 0.0;
		} else if( pivot2movingResistance < 0 ) {
			pivot1movingResistance = 0.0;
			pivot2movingResistance = 1.0;
		}

		double k1, k2;
		double movingResistanceSum = pivot1movingResistance + pivot2movingResistance;
		if( movingResistanceSum != 0 ) {
			k1 = pivot2movingResistance / movingResistanceSum;
			k2 = pivot1movingResistance / movingResistanceSum;
		} else {
			k1 = 0.5d;
			k2 = 0.5d;
		}

		if( k1 != 0.0 ) pivot1.alterCoords( k1 * impulse.x, k1 * impulse.y );
		if( k2 != 0.0 ) pivot2.alterCoords( -k2 * impulse.x, -k2 * impulse.y );
	}
}
