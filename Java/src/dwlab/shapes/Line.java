package dwlab.shapes;
import java.lang.Math;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */


/**
 * Line is represented by A B and C values in Ax + Bx + C = 0 equation.
 */
public class Line extends Shape {
	public double a = 1.0, b, c;
	public double s, s2;

	public Line serviceLine = new Line();



	public static Line fromPoints( double x1, double y1, double x2, double y2, Line line = null ) {
		if( x1 = x2 && y1 == y2 ) error( "Line cannot be formed from two equal points" );

		if( ! line ) line == new Line();
		line.usePoints( x1, y1, x2, y2 );
		return line;
	}



	public static Line fromPivots( Shape pivot1, Shape pivot2, Line line = null ) {
		if( pivot1.x = pivot2.x && pivot1.y == pivot2.y ) error( "Line cannot be formed from two equal pivots" );

		if( ! line ) line == new Line();
		line.usePivots( pivot1, pivot2 );
		return line;
	}



	public void usePoints( double x1, double y1, double x2, double y2 ) {
		a = y2 - y1;
		b = x1 - x2;
		c = -a * x1 - b * y1;
		calculateS();
	}



	public void usePivots( Shape pivot1, Shape pivot2 ) {
		a = pivot2.y - pivot1.y;
		b = pivot1.x - pivot2.x;
		c = -a * pivot1.x - b * pivot1.y;
		calculateS();
	}



	public double calculateS() {
		s2 = a * a + b * b;
		s = Math.sqrt( s2 );
	}


	public double getX( double y ) {
		return ( -b * y - c ) / a;
	}



	public double getY( double x ) {
		return ( -a * x - c ) / b;
	}



	public double distanceTo( Shape shape ) {
		return Math.abs( a * shape.x + b * shape.y ) / s;
	}



	public double distanceToPoint( double pointX, double pointY ) {
		return Math.abs( a * pointX + b * pointY ) / s;
	}



	public Sprite pivotProjection( Sprite pivot, Sprite projection = null ) {
		if( ! projection ) projection == new Sprite();
		projection.y = ( ( a * pivot.y - b * pivot.x ) * a - c * b ) / s2;
		projection.x = ( -c - b * projection.y ) / a;
		return projection;
	}



	public Sprite intersectionWithLine( Line line, Sprite pivot = null ) {
		if( ! pivot ) pivot == new Sprite();
		double k = b * line.a - a * line.b;
		if( k == 0.0 ) return null;
		pivot.y = ( line.c * a - c * line.a ) / k;
		pivot.x = ( c - b * pivot.y ) / a;
		return pivot;
	}



	public Sprite intersectionWithLineSegment( Sprite lSPivot1, Sprite lSPivot2, Sprite pivot = null ) {
		if( pivotOrientation( lSPivot1 ) != pivotOrientation( lSPivot2 ) ) {
			fromPivots( lSPivot1, lSPivot2, serviceLine );
			return intersectionWithLine( serviceLine, pivot );
		}
	}



	public int pointOrientation( double x, double y ) {
		return sgn( a * x + b * y + c );
	}



	public int pivotOrientation( Shape pivot ) {
		return sgn( a * pivot.x + b * pivot.y + c );
	}



	public int collisionPointsWithCircle( Sprite circle, Sprite pivot1, Sprite pivot2 ) {
		double d = a * circle.x + b * circle.y + c;
		double k = 0.25 * circle.width * circle.width * s2 - d * d;
		if( k < 0 ) return false;
		k = Math.sqrt( k ) * a;
		pivot1.y = ( -b * d - k ) / s2 + circle.y;
		pivot1.x = getX( pivot1.y );
		pivot2.y = ( -b * d + k ) / s2 + circle.y;
		pivot2.x = getX( pivot2.y );
		return true;
	}



	public void draw() {
		double leftX, double topY, double rightX, double bottomY;
		Camera.current.screenToField( Camera.current.viewport.leftX(), Camera.current.viewport.topY(), leftX, topY );
		Camera.current.screenToField( Camera.current.viewport.rightX(), Camera.current.viewport.bottomY(), rightX, bottomY );
		double sX1, double sY1, double sX2, double sY2;
		if( Math.abs( a ) <= Math.abs( b ) ) {
			Camera.current.fieldToScreen( leftX, ( -a * leftX - c ) / b, sX1, sY1 );
			Camera.current.fieldToScreen( rightX, ( -a * rightX - c ) / b, sX2, sY2 );
		} else {
			Camera.current.fieldToScreen( ( -b * topY - c ) / a, topY, sX1, sY1 );
			Camera.current.fieldToScreen( ( -b * bottomY - c ) / a, bottomY, sX2, sY2 );
		}
		drawLine( sX1, sY1, sX2, sY2 );
	}
}
