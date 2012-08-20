/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.base;

import dwlab.visualizers.Color;
import dwlab.visualizers.Image;

public class Graphics {
	public static boolean initialized() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	
	public static int getScreenWidth() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static void drawLine( double x, double y, double d, double y0 ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	
	public static void drawRectangle( double x, double y, double width, double height, double angle ){
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	
	public static void drawEmptyRectangle( double x, double y, double width, double height ) {
		width -= 1;
		height -= 1;
		drawLine( x, y, x + width, y );
		drawLine( x, y, x, y + height );
		drawLine( x + width, y, x + width, y + height );
		drawLine( x, y + height, x + width, y + height );
	}
	
	
	public static void drawOval( double x, double y, double width, double height, double angle ){
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	static void drawText( String string, double x, double y, Color color ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	static void drawText( String string, double x, double y ) {
		drawText( string, x, y, Color.black );
	}
	
	
	public static void drawImage( Image image, int frame, double x, double y, double width, double height, double angle ){
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static Image grabImage( java.awt.Image image, int x, int y, int width, int height ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	static void clearScreen() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	static void switchBuffers() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	static double textWidth( String text ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	static double textHeight() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static void setViewport( double x, double y, double width, double height ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static void resetViewport() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
}