/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.base;

import dwlab.shapes.sprites.Camera;
import dwlab.visualizers.Color;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.lwjgl.LWJGLException;
import org.lwjgl.input.Mouse;
import org.lwjgl.opengl.GL11;

public class Graphics extends GraphicsTemplate {
	/**
	* Sets graphics mode.
	* Provide width and height of screen in pixels and unit size in pixels for camera.

	* @see #parallax example
	*/
	public static void init( int newWidth, int newHeight, double unitSize, int colorDepth, int frequency ) {
		width =newWidth;
		height = newHeight;
		
		GL11.glMatrixMode( GL11.GL_PROJECTION) ;
		GL11.glLoadIdentity();
		GL11.glOrtho( 0d, width, 0d, height, 1d, -1d );
		GL11.glMatrixMode( GL11.GL_MODELVIEW) ;
		GL11.glShadeModel( GL11.GL_SMOOTH );
		resetViewport();

		try {
			Mouse.create();
		} catch ( LWJGLException ex ) {
			Logger.getLogger( Graphics.class.getName() ).log( Level.SEVERE, null, ex );
		}
		
		Camera.current.viewport.setCoords( 0.5d * width, 0.5d * height );
		Camera.current.viewport.setSize( width, height );
		Camera.current.setSize( width / unitSize, height / unitSize );
	}
	

	public static void drawLine( double x1, double y1, double x2, double y2, double width, Color color ) {
		GL11.glColor4d( color.red, color.green, color.blue, color.alpha );
		GL11.glBegin( GL11.GL_LINES );
			GL11.glVertex2d(	x1, y1 );
			GL11.glVertex2d(	x2, y2 );
		GL11.glEnd();		
	}
	

	public static void startPolygon( int vertexQuantity, Color color, boolean empty ) {
		GL11.glColor4d( color.red, color.green, color.blue, color.alpha );
		if( empty ) GL11.glBegin( GL11.GL_LINE_LOOP ); else GL11.glBegin( GL11.GL_POLYGON );
	}

	public static void addPolygonVertex( double x, double y ) {
		GL11.glVertex2d(	x, y );
	}

	public static void drawPolygon() {
		GL11.glEnd();
	}
	
	
	public static void drawText( String string, double x, double y, Color color, Color contourColor ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static void drawText( String string, double x, double y, Color color ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static double textWidth( String text ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public static double textHeight() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static void setViewport( int x, int y, int width, int height ) {
		GraphicsTemplate.setViewport( x, y, width, height );
		GL11.glViewport( x - width / 2, y - height / 2, width, height );
	}
	
	
	public static void clearScreen( Color color ) {
		GL11.glClearColor( (float) color.red, (float) color.green, (float) color.blue, 1.0f );
		GL11.glClear( GL11.GL_COLOR_BUFFER_BIT | GL11.GL_DEPTH_BUFFER_BIT );
		GL11.glLoadIdentity(); 
	}
	

	public static void switchBuffers() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
}


