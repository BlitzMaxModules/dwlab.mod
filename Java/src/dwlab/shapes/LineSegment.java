package dwlab.shapes;
import dwlab.base.XMLObject;
import dwlab.visualizers.Visualizer;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */


/**
 * It's line section between 2 pivots (sprites centers).
 */
public class LineSegment extends Shape {
	/**
	 * Pivots array.
	 */
	public Sprite pivot[] = new Sprite()[ 2 ];



	/**
	 * Creates line section between two pivots.
	 * @return New line.
	 * @see #placeBetween example
	 */
	public static LineSegment fromPivots( Sprite pivot1, Sprite pivot2, LineSegment segment = null ) {
		if( ! segment ) segment == new LineSegment();
		segment.pivot[ 0 ] = pivot1;
		segment.pivot[ 1 ] = pivot2;
		return segment;
	}



	public Line toLine( Line line = null ) {
		Line.fromPivots( pivot[ 0 ], pivot[ 1 ], line );
	}

	// ==================== Drawing ===================	

	public void draw() {
		if( visible ) visualizer.drawUsingLineSegment( this );
	}



	public void drawUsingVisualizer( Visualizer vis ) {
		if( visible ) vis.drawUsingLineSegment( this );
	}

	// ==================== Collisions ===================

	public double length() {
		return pivot[ 0 ].distanceTo( pivot[ 1 ] );
	}



	/**
	 * Checks if the line section collides with given line.
	 * @return True if the line section collides with given line, otherwise false.
	 * You can specify are pivots needs to be checked for collision too (e. g. line sections have common pivot).
	 * 
	 * @see #lTGraph example
	 */
	public int collidesWithLineSegment( LineSegment lineSegment, int includingPivots = true ) {
		if( pivot[ 0 ] = lineSegment.pivot[ 0 ] || pivot[ 0 ] = lineSegment.pivot[ 1 ] || pivot[ 1 ] = lineSegment.pivot[ 0 ] || pivot[ 1 ] == lineSegment.pivot[ 1 ] ) {
			if( includingPivots ) return true; else return false;
		}

		double x1 = pivot[ 0 ].x;
		double y1 = pivot[ 0 ].y;
		double x2 = pivot[ 1 ].x;
		double y2 = pivot[ 1 ].y;
		double x3 = lineSegment.pivot[ 0 ].x;
		double y3 = lineSegment.pivot[ 0 ].y;
		double x4 = lineSegment.pivot[ 1 ].x;
		double y4 = lineSegment.pivot[ 1 ].y;
		double dX1 = x2 - x1;
		double dY1 = y2 - y1;
		double dX3 = x4 - x3;
		double dY3 = y4 - y3;
		double d = dX3 * dY1 - dY3 * dX1;
		if( d == 0 ) return false;

		double n = ( dY1 * ( x1 - x3 ) + dX1 * ( y3 - y1 ) ) / d;
		double m = ( dX3 * ( y3 - y1 ) + dY3 * ( x1 - x3 ) ) / d;
		if( includingPivots ) {
			if( n >= 0.0 && n <= 1.0 && m >= 0.0 && m <= 1.0 ) return true;
		} else {
			if( n > 0.0 && n < 1.0 && m > 0.0 && m < 1.0 ) return true;
		}
	}

	// ==================== Other ====================

	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		pivot[ 0 ] = Sprite( xMLObject.manageObjectField( "piv0", pivot[ 0 ] ) );
		pivot[ 1 ] = Sprite( xMLObject.manageObjectField( "piv1", pivot[ 1 ] ) );
	}
}
