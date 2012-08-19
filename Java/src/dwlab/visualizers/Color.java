package dwlab.visualizers;
import dwlab.base.XMLObject;
import java.lang.Math;
import dwlab.base.DWLabObject;

//
// Digital Wizard's Lab - game development framework
// Copyright (C) 2012, Matt Merkulov
//
// All rights reserved. Use of this code is allowed under the
// Artistic License 2.0 terms, as specified in the license.txt
// file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php
//



public class Color extends DWLabObject {
	/**
	 * Red color intensity for drawing.
	 * @see #setColorFromHex, #setColorFromRGB, #alterColor, #applyColor, #resetColor
	 */
	public double red = 1.0;

	/**
	 * Green color intensity for drawing.
	 * @see #setColorFromHex, #setColorFromRGB, #alterColor, #applyColor, #resetColor
	 */
	public double green = 1.0;

	/**
	 * Blue color intensity for drawing.
	 * @see #setColorFromHex, #setColorFromRGB, #alterColor, #applyColor, #resetColor
	 */
	public double blue = 1.0;

	/**
	 * Alpha (transparency) value for drawing.
	 * #applyColor, #resetColor
	 */
	public double alpha = 1.0;

	// ==================== Creating ====================

	/**
	 * Creates new color using given RGB components and transparency.
	 * @return New color.
	 * @see #fromHex
	 */
	public static Color fromRGB( double red, double green, double blue, double alpha = 1.0 ) {
		Color color = new Color();
		color.setColorFromRGB( red, green, blue );
		color.alpha = alpha;
		return color;
	}



	/**
	 * Creates new color using given hexadecimal representation and transparency.
	 * @return New color.
	 * @see #fromRGB
	 */
	public static Color fromHex( String hexColor = "FFFFFF", double alpha = 1.0 ) {
		Color color = new Color();
		color.alpha = alpha;
		color.setColorFromHex( hexColor );
		return color;
	}

	// ==================== Setting ====================

	/**
	 * Applies color given in hex string to visualizer.
	 * @see #setColorFromRGB, #alterColor, #applyColor, #applyClsColor, #resetColor
	 */
	public void setColorFromHex( String s ) {
		if( s.length == 8 ) {
			alpha = hexToInt( s[ 0..2 ] ) / 255.0;
			s = s[ 2.. ];
		}
		red = 1.0 * hexToInt( s[ 0..2 ] ) / 255.0;
		green = 1.0 * hexToInt( s[ 2..4 ] ) / 255.0;
		blue = 1.0 * hexToInt( s[ 4..6 ] ) / 255.0;
	}



	/**
	 * Applies color given in color intensities to visualizer.
	 * Every intensity should be in range from 0.0 to 1.0.
	 * 
	 * @see #setColorFromHex, #alterColor, #applyColor, #applyClsColor, #resetColor
	 */
	public void setColorFromRGB( double newRed, double newGreen, double newBlue ) {
		if( newRed < 0.0 || newRed > 1.0 ) error( "Red component must be between 0.0 and 1.0 inclusive" );
		if( newGreen < 0.0 || newGreen > 1.0 ) error( "Green component must be between 0.0 and 1.0 inclusive" );
		if( newBlue < 0.0 || newBlue > 1.0 ) error( "Blue component must be between 0.0 and 1.0 inclusive" );

		red = newRed;
		green = newGreen;
		blue = newBlue;
	}



	/**
	 * Sets random color.
	 * Each component is in [ 0.25, 1.0 ] range.
	 */
	public void setRandomColor() {
		setColorFromRGB( Math.random( 0.25, 1 ), Math.random( 0.25, 1 ), Math.random( 0.25, 1 ) );
	}



	/**
	 * Alters color randomly with given increments.
	 * Every color channel will be altered by random value in D1...D2 interval (value(s) can be negative).
	 * 
	 * @see #setColorFromHex, #setColorFromRGB, #applyColor, #applyClsColor, #resetColor
	 */
	public void alterColor( double d1, double d2 ) {
		red = limitDouble( red + Math.random( d1, d2 ), 0.0, 1.0 );
		green = limitDouble( green + Math.random( d1, d2 ), 0.0, 1.0 );
		blue = limitDouble( blue + Math.random( d1, d2 ), 0.0, 1.0 );
	}



	/**
	 * Sets this color as drawing color.
	 * @see #applyClsColor, #setColorFromHex, #setColorFromRGB, #alterColor, #resetColor
	 */
	public void applyColor() {
		setColor( 255.0 * red, 255.0 * green, 255.0 * blue );
		setAlpha( alpha );
	}



	/**
	 * Sets the color of visualizer as screen clearing color.
	 * @see #applyColor, #setColorFromHex, #setColorFromRGB, #alterColor, #resetColor
	 */
	public void applyClsColor() {
		setClsColor( 255.0 * red, 255.0 * green, 255.0 * blue );
	}



	/**
	 * Resets drawing color to solid white.
	 * @see #setColorFromHex, #setColorFromRGB, #alterColor, #applyColor, #applyClsColor
	 */
	public static void resetColor() {
		setColor( 255, 255, 255 );
		setAlpha( 1.0 );
	}

	// ==================== I/O ====================

	public void copyColorTo( Color color ) {
		color.red = red;
		color.green = green;
		color.blue = blue;
		color.alpha = alpha;
	}



	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageDoubleAttribute( "red", red, 1.0 );
		xMLObject.manageDoubleAttribute( "green", green, 1.0 );
		xMLObject.manageDoubleAttribute( "blue", blue, 1.0 );
		xMLObject.manageDoubleAttribute( "alpha", alpha, 1.0 );
	}
}
