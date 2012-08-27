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
import org.lwjgl.opengl.GL11;

public abstract class GraphicsTemplate {
	static Color currentColor = Color.white.clone();
	static Color currentClearingColor = Color.black.clone();
	static double lineWidth = 1.0d;
	static int width, height;
	static int viewportX, viewportY;
	static int viewportWidth, viewportHeight;
	
	
	public static boolean initialized() {
		return width == 0 ? false : true;
	}
	
	public static int getScreenWidth() {
		return width;
	}
	
	public static int getScreenHeight() {
		return height;
	}
	
	
	public void setColor( double red, double green, double blue, double alpha ) {
		currentColor.set( red, green, blue, alpha );
	}
	
	public void setClearingColor( double red, double green, double blue, double alpha ) {
		currentClearingColor.set( red, green, blue, alpha );
	}
	
	public void setLineWidth( double width ) {
		lineWidth = width;
	}
	

	public static void drawLine( double x1, double y1, double x2, double y2, double width, Color color ) {
	}
	
	public static void drawLine( double x1, double y1, double x2, double y2 ) {
		drawLine( x1, y1, x2, y2, lineWidth, currentColor );
	}
	
	
	public static void drawRectangle( double x, double y, double width, double height, double angle, Color color, boolean empty ){
		width *= 0.5d ;
		height *= 0.5d ;
		GL11.glRectd( x - width, y - height, x + width, y + height );
	}
	
	public static void drawRectangle( double x, double y, double width, double height ){
		drawRectangle( x, y, width, height, 0d, currentColor, false );
	}
	
	public static void drawEmptyRectangle( double x, double y, double width, double height ){
		drawRectangle( x, y, width, height, 0d, currentColor, true );
	}
	
	
	public static void drawOval( double x, double y, double width, double height, double angle, Color color, boolean empty ){
		int vertexQuantity = 8;
		double step = 360d / vertexQuantity;
		startPolygon( vertexQuantity, color, empty );
		for( double ang = 0d; ang < 360d; ang += step ) addPolygonVertex( x + width * Math.cos( ang ), y + height * Math.sin( ang ) );
		drawPolygon();
	}
	
	public static void drawOval( double x, double y, double width, double height, double angle ){
		drawOval( x, y, width, height, angle, currentColor, false );
	}
	
	public static void drawEmptyOval( double x, double y, double width, double height, double angle ){
		drawOval( x, y, width, height, angle, currentColor, true );
	}
	
	public static void drawOval( double x, double y, double width, double height ){
		drawOval( x, y, width, height, 0d, currentColor, false );
	}
	
	public static void drawEmptyOval( double x, double y, double width, double height ){
		drawOval( x, y, width, height, 0d, currentColor, true );
	}
	

	public static void drawLongOval( double sX, double sY, double sWidth, double sHeight, double angle, Color color, boolean empty ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static void startPolygon( int vertexQuantity, Color color, boolean empty ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static void addPolygonVertex( double x, double y ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static void drawPolygon() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	
	public static void drawText( String string, double x, double y, Color color, Color contourColor ) {
	}

	public static void drawText( String string, double x, double y, Color color ) {
	}
	
	public static void drawText( String string, double x, double y ) {
		drawText( string, x, y, currentColor );
	}
	

	public static void clearScreen() {
		clearScreen( currentClearingColor );
	}
	
	public static void clearScreen( Color color ) {
	}
	

	public static void getViewport( Vector pivot, Vector size ) {
		pivot.x = viewportX;
		pivot.y = viewportY;
		size.x = viewportWidth;
		size.y = viewportHeight;
	}

	public static void setViewport( int x, int y, int width, int height ) {
		viewportX = x;
		viewportY = y;
		viewportWidth = width;
		viewportHeight = height;
	}

	public static void setViewport( Vector pivot, Vector size ) {
		setViewport( Service.round( pivot.x ), Service.round( pivot.y ), Service.round( size.x ), Service.round( size.y ) );
	}

	public static void resetViewport() {
		setViewport( getScreenWidth() / 2, getScreenHeight() / 2, getScreenWidth(), getScreenHeight() );
	}
}