/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.shapes.maps;

import dwlab.base.Service;
import dwlab.base.Sys;
import dwlab.shapes.Shape;
import dwlab.base.XMLObject;

/**
 * Common object for maps
 * Map is object with 2d array.
 */
public class Map extends Shape {
	/**
	 * Dimensions of the array
	 */
	public int xQuantity, yQuantity;

	public int xMask, yMask;
	public boolean masked;



	/**
	 * Sets resolution of the map.
	 * For some objects resolutions which are powers of 2 are necessary or will work faster.
	 */
	public void setResolution( int newXQuantity, int newYQuantity ) {
		if( Sys.debug ) if( newXQuantity <= 0 || newYQuantity <= 0 ) error( "Map resoluton must be more than 0" );

		xQuantity = newXQuantity;
		yQuantity = newYQuantity;
		if( Service.isPowerOf2( xQuantity ) && Service.isPowerOf2( yQuantity ) ) {
			xMask = xQuantity - 1;
			yMask = yQuantity - 1;
			masked = true;
		} else {
			xMask = 0;
			yMask = 0;
			masked = false;
		}
	}



	/**
	 * Wrapping first index.
	 * @return Wrapped first index of the map
	 * Wrapping means to keep index in the dimension limits.
	 * For example, if you will wrap index "5" for map with resolution ( 4x4 ) it will be keeped in 0...3 interval and turned to 1 as 5 + 4 * ( -1 ) = 1.
	 * If you wrap index "-2" for the same map, you will get 2 as -2 + 4 * 1 = 2.
	 * 
	 * @see #wrapY
	 */
	public int wrapX( int value ) {
		if( masked ) {
			return value & xMask;
		} else {
			return value - xQuantity * ( (int) Math.floor( 1.0 * value / xQuantity ) );
		}
	}


	/**
	 * Wrapping second map index.
	 * @return Wrapped second index of the map.
	 * @see #wrapX
	 */
	public int wrapY( int value ) {
		if( masked ) {
			return value & yMask;
		} else {
			return value - yQuantity * ( (int) Math.floor( 1.0d * value / yQuantity ) );
		}
	}



	/**
	 * Stretches the map by integer values.
	 */
	public void stretch( int xMultiplier, int yMultiplier ) {
	}



	@Override
	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageIntAttribute( "xquantity", xQuantity );
		xMLObject.manageIntAttribute( "yquantity", yQuantity );

		if( Sys.xMLGetMode() ) setResolution( xQuantity, yQuantity );
	}
}
