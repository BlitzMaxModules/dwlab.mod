package dwlab.sprites;

/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

public enum ShapeType {
	/**
	 * Type of the sprite shape: pivot. It's a point on game field with (X, Y) coordinates.
	 */
	PIVOT,
	
	/**
	 * Type of the sprite shape: oval which is inscribed in shape's rectangle.
	 */
	OVAL,
	
	/**
	 * Type of the sprite shape: rectangle.
	 */
	RECTANGLE,
	
	/**
	 * Type of the sprite shape: ray which starts in (X, Y) and directed as Angle.
	 */
	RAY,
	
	/**
	 * Type of the sprite shape: right triangle which is inscribed in shape's rectangle and have right angle situated in corresponding corner.
	 */
	TOP_LEFT_TRIANGLE,
	TOP_RIGHT_TRIANGLE,
	BOTTOM_LEFT_TRIANGLE,
	BOTTOM_RIGHT_TRIANGLE,

	/**
	 * Type of the sprite shape: mask of raster image which is inscribed in shape's rectangle.
	 */
	RASTER
}