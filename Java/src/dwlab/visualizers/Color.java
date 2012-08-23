/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.visualizers;

import dwlab.base.Obj;
import dwlab.base.Service;
import dwlab.base.Sys;
import dwlab.xml.XMLObject;

public class Color extends Obj {
	public static Color black = new Color( "000000" );
	public static Color white = new Color( "FFFFFF" );
	
	/**
	 * Red color intensity for drawing.
	 * @see #setColorFromHex, #setColorFromRGB, #alterColor, #applyColor, #resetColor
	 */
	public double red;

	/**
	 * Green color intensity for drawing.
	 * @see #setColorFromHex, #setColorFromRGB, #alterColor, #applyColor, #resetColor
	 */
	public double green;

	/**
	 * Blue color intensity for drawing.
	 * @see #setColorFromHex, #setColorFromRGB, #alterColor, #applyColor, #resetColor
	 */
	public double blue;

	/**
	 * Alpha (transparency) value for drawing.
	 * #applyColor, #resetColor
	 */
	public double alpha;

	// ==================== Creating ====================

	public Color(){
		this.set( 1.0d, 1.0d, 1.0d, 1.0 );
	}
	
	/**
	 * Creates new color using given RGB components and transparency.
	 * @return New color.
	 * @see #fromHex
	 */
	public Color( double red, double green, double blue, double alpha ) {
		this.set( red, green, blue, alpha );
	}
	
	public Color( double red, double green, double blue ) {
		this.set( red, green, blue, 1.0d );
	}



	/**
	 * Creates new color using given hexadecimal representation and transparency.
	 * @return New color.
	 * @see #fromRGB
	 */
	public Color( String hexColor ) {
		this.set( hexColor );
	}

	// ==================== Setting ====================

	/**
	 * Applies color given in hex string to visualizer.
	 * @see #setColorFromRGB, #alterColor, #applyColor, #applyClsColor, #resetColor
	 */
	public final void set( String hexColor ) {
		if( hexColor.length() == 8 ) {
			alpha = Service.hexToInt( hexColor.substring( 0, 2 ) ) / 255.0;
			hexColor = hexColor.substring( 2 );
		}
		red = 1.0 * Service.hexToInt( hexColor.substring( 0, 2 ) ) / 255.0;
		green = 1.0 * Service.hexToInt( hexColor.substring( 2, 4 ) ) / 255.0;
		blue = 1.0 * Service.hexToInt( hexColor.substring( 4, 6 ) ) / 255.0;
	}


	/**
	 * Applies color given in color intensities to visualizer.
	 * Every intensity should be in range from 0.0 to 1.0.
	 * 
	 * @see #setColorFromHex, #alterColor, #applyColor, #applyClsColor, #resetColor
	 */
	public final void set( double newRed, double newGreen, double newBlue, double newAlpha ) {
		if( Sys.debug ) {
			if( newRed < 0.0 || newRed > 1.0 ) error( "Red component must be between 0.0 and 1.0 inclusive" );
			if( newGreen < 0.0 || newGreen > 1.0 ) error( "Green component must be between 0.0 and 1.0 inclusive" );
			if( newBlue < 0.0 || newBlue > 1.0 ) error( "Blue component must be between 0.0 and 1.0 inclusive" );
			if( newAlpha < 0.0 || newAlpha > 1.0 ) error( "Blue component must be between 0.0 and 1.0 inclusive" );
		}

		red = newRed;
		green = newGreen;
		blue = newBlue;
		alpha = newAlpha;
	}


	/**
	 * Sets random color.
	 * Each component is in [ 0.25, 1.0 ] range.
	 */
	public void setRandomColor() {
		set( Math.random() * 0.75d + 0.25d, Math.random() * 0.75d + 0.25d, Math.random() * 0.75d + 0.25d, alpha );
	}


	/**
	 * Alters color randomly with given increments.
	 * Every color channel will be altered by random value in D1...D2 interval (value(s) can be negative).
	 * 
	 * @see #setColorFromHex, #setColorFromRGB, #applyColor, #applyClsColor, #resetColor
	 */
	public void alterColor( double d1, double d2 ) {
		red = Service.limit( red + d1 + Math.random() * ( d2 - d1 ), 0.0d, 1.0d );
		green = Service.limit( green + d1 + Math.random() * ( d2 - d1 ), 0.0d, 1.0d );
		blue = Service.limit( blue + d1 + Math.random() * ( d2 - d1 ), 0.0d, 1.0d );
	}

	// ==================== I/O ====================

	public void copyColorTo( Color color ) {
		color.red = red;
		color.green = green;
		color.blue = blue;
		color.alpha = alpha;
	}


	@Override
	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		red = xMLObject.manageDoubleAttribute( "red", red, 1.0d );
		green = xMLObject.manageDoubleAttribute( "green", green, 1.0d );
		blue = xMLObject.manageDoubleAttribute( "blue", blue, 1.0d );
		alpha = xMLObject.manageDoubleAttribute( "alpha", alpha, 1.0d );
	}
}
