/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.base;

import dwlab.shapes.Vector;
import dwlab.visualizers.Color;

public class Graphics extends GraphicsTemplate {
	public static boolean initialized() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	
	/**
	* Sets graphics mode.
	* Provide width and height of screen in pixels and unit size in pixels for camera.

	* @see #parallax example
	*/
	public static void init( int width, int height, double unitSize, int colorDepth, int frequency ) {
		/*
		graphics( width, height, colorDepth, frequency );
		autoImageFlags( fILTEREDIMAGE | dYNAMICIMAGE | mIPMAPPEDIMAGE );
		setBlend( alphaBlend );

		Camera.current.viewport.setSize( width, height );
		Camera.current.viewport.setCoords( 0.5 * width, 0.5 * height );
		Camera.current.setSize( width / unitSize, height / unitSize );
		*/ 
	}
	
	
	public static double getScreenWidth() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	public static double getScreenHeight() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static void drawLine( double x1, double y1, double x2, double y2, double width, Color color ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	
	public static void drawRectangle( double x, double y, double width, double height, double angle, Color color ){
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	
	public static void drawOval( double x, double y, double width, double height, double angle, Color color ){
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static void drawLongOval( double sX, double sY, double sWidth, double sHeight, double angle, Color color ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static void startPolygon( int vertexQuantity ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static void addPolygonVertex( double x, double y ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static void drawPolygon() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	
	public static void drawText( String string, double x, double y, Color color, Color contourColor ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static void drawText( String string, double x, double y, Color color ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static void clearScreen() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static void switchBuffers() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static double textWidth( String text ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static double textHeight() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static void getViewport( Vector pivot, Vector size ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static void setViewport( double x, double y, double width, double height ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
}


