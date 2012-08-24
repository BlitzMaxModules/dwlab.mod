/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.shapes;

import dwlab.visualizers.Visualizer;
import dwlab.shapes.sprites.Sprite;
import dwlab.xml.XMLObject;

/**
 * It's line section between 2 pivots (sprites centers).
 */
public class LineSegment extends Shape {
	/**
	 * Pivots array.
	 */
	public Sprite[] pivot = new Sprite[ 2 ];



	/**
	 * Creates line section between two pivots.
	 * @return New line.
	 * @see #placeBetween example
	 */
	public LineSegment( Sprite pivot1, Sprite pivot2 ) {
		this.pivot[ 0 ] = pivot1;
		this.pivot[ 1 ] = pivot2;
	}

	public void usePivots( Sprite pivot1, Sprite pivot2 ) {
		pivot[ 0 ] = pivot1;
		pivot[ 1 ] = pivot2;
	}


	public void toLine( Line line ) {
		line.usePivots( pivot[ 0 ], pivot[ 1 ] );
	}
	
	public Line toLine() {
		return new Line( pivot[ 0 ], pivot[ 1 ] );
	}

	// ==================== Drawing ===================	

	@Override
	public void draw() {
		if( visible ) visualizer.drawUsingLineSegment( this );
	}


	@Override
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
	public boolean collidesWithLineSegment( LineSegment lineSegment, boolean includingPivots ) {
		if( pivot[ 0 ].isAtPositionOf( lineSegment.pivot[ 0 ] ) || pivot[ 0 ].isAtPositionOf( lineSegment.pivot[ 1 ] ) || pivot[ 1 ].isAtPositionOf( lineSegment.pivot[ 0 ] ) 
				|| pivot[ 1 ].isAtPositionOf( lineSegment.pivot[ 1 ] ) ) {
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
		
		return false;
	}

	// ==================== Other ====================

	@Override
	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		pivot[ 0 ] = xMLObject.manageObjectField( "piv0", pivot[ 0 ] );
		pivot[ 1 ] = xMLObject.manageObjectField( "piv1", pivot[ 1 ] );
	}
}
