package dwlab.shapes;

//

import dwlab.base.DWLabObject;

// Digital Wizard's Lab - game development framework
// Copyright (C) 2012, Matt Merkulov
//
// All rights reserved. Use of this code is allowed under the
// Artistic License 2.0 terms, as specified in the license.txt
// file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php
//

public class Vector extends DWLabObject {
	protected double x, y;


	/**
	 * Distance to point.
	 * @return Distance from the shape center to the point with given coordinates.
	 * @see #distanceTo
	 */
	public double distanceToPoint( double pointX, double pointY ) {
		double dX = x - pointX;
		double dY = y - pointY;
		return Math.sqrt( dX * dX + dY * dY );
	}


	/**
	 * Distance to shape.
	 * @return Distance from the shape center to center of another shape.
	 * @see #distanceToPoint, #distanceToPoint example
	 */
	public double distanceTo( Vector pivot ) {
		double dX = x - pivot.x;
		double dY = y - pivot.y;
		return Math.sqrt( dX * dX + dY * dY );
	}


	public double distance2to( Vector pivot ) {
		double dX = x - pivot.x;
		double dY = y - pivot.y;
		return dX * dX + dY * dY;
	}


	/**
	 * Checks if the shape is at position of another shape.
	 * @return True if shape center has same coordinates as another shape center. 
	 * @see #x, #y, #moveTowards example
	 */
	public boolean isAtPositionOf( Vector pivot ) {
		if( pivot.x == x && pivot.y == y ) return true; else return false;
	}


	public boolean isAtPositionOfPoint( double pointX, double pointY ) {
		if( pointX == x && pointY == y ) return true; else return false;
	}


	public double getX() {
		return x;
	}
	
	
	/**
	 * Sets X coordinate of the shape.
	 * 
	 * @see SetY#
	 */
	public void setX( double newX ) {
		setCoords( newX, y );
	}


	public double getY() {
		return y;
	}


	/**
	 * Sets X coordinate of the shape.
	 * It's better to use this method instead of equating X field to new value.
	 * 
	 * @see #y, SetX#
	 */
	public void setY( double newY ) {
		setCoords( x, newY );
	}


	/**
	 * Sets coordinates of the shape.
	 * It's better to use this method instead of equating X and Y fields to new values.
	 * 
	 * @see #x, #y, #setCornerCoords, #alterCoords, #setMouseCoords
	 */
	public void setCoords( double newX, double newY ) {
		x = newX;
		y = newY;
		update();
	}



	/**
	 * Alter coordinates of the shape.
	 * Given values will be added to the coordinates. It's better to use this method instead of incrementing X and Y fields manually.
	 * 
	 * @see #setCoords, #setCornerCoords, #setMouseCoords, #clone example
	 */
	public void alterCoords( double dX, double dY ) {
		setCoords( x + dX, y + dY );
	}

	
	
	public void roundCoords() {
		setCoords( Math.round( x ), Math.round( y ) );
	}
}
