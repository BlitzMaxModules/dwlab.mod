/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.base;

import dwlab.base.Service.Margins;
import dwlab.shapes.Vector;
import dwlab.visualizers.Color;
import dwlab.visualizers.Image;

public class Graphics {
	private static Color currentColor = new Color();
	private static double lineWidth = 1.0d;
	
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
	
	public static void drawLine( double x1, double y1, double x2, double y2 ) {
		drawLine( x1, y1, x2, y2, 1d, currentColor );
	}
	
	
	public static void drawRectangle( double x, double y, double width, double height, double angle, Color color ){
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	public static void drawRectangle( double x, double y, double width, double height ){
		drawRectangle( x, y, width, height, 0d, currentColor );
	}

	
	public static void drawEmptyRectangle( double x, double y, double width, double height, double angle, double lineWidth, Color color ) {
		width -= 1;
		height -= 1;
		drawLine( x, y, x + width, y );
		drawLine( x, y, x, y + height );
		drawLine( x + width, y, x + width, y + height );
		drawLine( x, y + height, x + width, y + height );
	}
	
	public static void drawEmptyRectangle( double x, double y, double width, double height ) {
		drawEmptyRectangle( x, y, width, height, 0d, 1d, currentColor );
	}
	
	
	public static void drawOval( double x, double y, double width, double height, double angle, Color color ){
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	public static void drawOval( double x, double y, double width, double height, double angle ){
		drawOval( x, y, width, height, angle, currentColor );
	}
	
	public static void drawOval( double x, double y, double width, double height ){
		drawOval( x, y, width, height, 0d, currentColor );
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
	
	public static void drawText( String string, double x, double y ) {
		drawText( string, x, y, currentColor );
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

	public static void setViewport( Vector pivot, Vector size ) {
		setViewport( pivot.x, pivot.y, size.x, size.y );
	}

	public static void resetViewport() {
		setViewport( 0.5d * getScreenWidth(), 0.5d * getScreenHeight() , getScreenWidth(), getScreenHeight() );
	}
}


