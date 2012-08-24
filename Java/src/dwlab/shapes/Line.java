/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.shapes;

import dwlab.base.Graphics;
import dwlab.base.Service;
import dwlab.base.Sys;
import dwlab.shapes.sprites.Camera;
import dwlab.shapes.sprites.Sprite;

/**
 * Line is represented by A B and C values in Ax + Bx + C = 0 equation.
 */
public class Line extends Shape {
	public double a, b, c;
	public double s, s2;

	public Line serviceLine = new Line();


	public Line( double x1, double y1, double x2, double y2 ) {
		usePoints( x1, y1, x2, y2 );
	}
	
	public Line() {
		a = 1.0;
	}


	public Line( Shape pivot1, Shape pivot2 ) {
		usePivots( pivot1, pivot2 );
	}


	public final void usePoints( double x1, double y1, double x2, double y2 ) {
		if( Sys.debug ) if( x1 == x2 && y1 == y2 ) error( "Line cannot be formed from two equal points" );
		a = y2 - y1;
		b = x1 - x2;
		c = -a * x1 - b * y1;
		calculateS();
	}


	public final void usePivots( Shape pivot1, Shape pivot2 ) {
		if( Sys.debug ) if( pivot1.x == pivot2.x && pivot1.y == pivot2.y ) error( "Line cannot be formed from two equal pivots" );
		a = pivot2.y - pivot1.y;
		b = pivot1.x - pivot2.x;
		c = -a * pivot1.x - b * pivot1.y;
		calculateS();
	}


	public void calculateS() {
		s2 = a * a + b * b;
		s = Math.sqrt( s2 );
	}


	public double getX( double y ) {
		return ( -b * y - c ) / a;
	}


	public double getY( double x ) {
		return ( -a * x - c ) / b;
	}


	@Override
	public double distanceTo( Shape shape ) {
		return Math.abs( a * shape.x + b * shape.y ) / s;
	}


	@Override
	public double distanceToPoint( double pointX, double pointY ) {
		return Math.abs( a * pointX + b * pointY ) / s;
	}


	public Sprite pivotProjection( Sprite pivot, Sprite projection ) {
		projection.y = ( ( a * pivot.y - b * pivot.x ) * a - c * b ) / s2;
		projection.x = ( -c - b * projection.y ) / a;
		return projection;
	}
	
	public Sprite pivotProjection( Sprite pivot ) {
		return pivotProjection( pivot, new Sprite() );
	}


	public Sprite intersectionWithLine( Line line, Sprite pivot ) {
		double k = b * line.a - a * line.b;
		if( k == 0.0 ) return null;
		pivot.y = ( line.c * a - c * line.a ) / k;
		pivot.x = ( c - b * pivot.y ) / a;
		return pivot;
	}
	
	public Sprite intersectionWithLine( Line line ) {
		return intersectionWithLine( line, new Sprite() );
	}


	public Sprite intersectionWithLineSegment( Sprite lSPivot1, Sprite lSPivot2, Sprite pivot ) {
		if( pivotOrientation( lSPivot1 ) != pivotOrientation( lSPivot2 ) ) {
			serviceLine.usePivots( lSPivot1, lSPivot2 );
			return intersectionWithLine( serviceLine, pivot );
		}
		return null;
	}
	
	public Sprite intersectionWithLineSegment( Sprite lSPivot1, Sprite lSPivot2 ) {
		return intersectionWithLineSegment( lSPivot1, lSPivot2, new Sprite() );
	}


	public int pointOrientation( double x, double y ) {
		return Service.signum( a * x + b * y + c );
	}


	public int pivotOrientation( Shape pivot ) {
		return Service.signum( a * pivot.x + b * pivot.y + c );
	}


	public boolean collisionPointsWithCircle( Sprite circle, Sprite pivot1, Sprite pivot2 ) {
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


	private static Vector serviceVector1 = new Vector();
	private static Vector serviceVector2 = new Vector();
	private static Vector serviceVector3 = new Vector();
	private static Vector serviceVector4 = new Vector();
	
	@Override
	public void draw() {
		double leftX, topY, rightX, bottomY;
		Camera.current.screenToField( Camera.current.viewport.leftX(), Camera.current.viewport.topY(), serviceVector1 );
		Camera.current.screenToField( Camera.current.viewport.rightX(), Camera.current.viewport.bottomY(), serviceVector2 );
		if( Math.abs( a ) <= Math.abs( b ) ) {
			Camera.current.fieldToScreen( serviceVector1.x, ( -a * serviceVector1.x - c ) / b, serviceVector3 );
			Camera.current.fieldToScreen( serviceVector2.x, ( -a * serviceVector2.x - c ) / b, serviceVector4 );
		} else {
			Camera.current.fieldToScreen( ( -b * serviceVector1.y - c ) / a, serviceVector1.y, serviceVector3 );
			Camera.current.fieldToScreen( ( -b * serviceVector2.y - c ) / a, serviceVector2.y, serviceVector4 );
		}
		Graphics.drawLine( serviceVector3.x, serviceVector3.y, serviceVector4.x, serviceVector4.y );
	}
}
