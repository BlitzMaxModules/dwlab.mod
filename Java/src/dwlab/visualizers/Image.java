/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.visualizers;

import dwlab.base.Graphics;
import dwlab.base.Obj;
import dwlab.base.Sys;
import dwlab.xml.XMLObject;
import java.awt.image.BufferedImage;
import java.util.HashMap;

/**
 * Image class.
 */
public class Image extends Obj {
	public static boolean loadImages = true;
	private static HashMap bitmaps = new HashMap();

	BufferedImage[] javaImage;
	String filename;
	int xCells = 1;
	int yCells = 1;

	
	public Image() {
	}
	
	public Image( int frames ) {
		javaImage = new BufferedImage[ frames ];
	}
	
	public Image( int width, int height ) {
		javaImage = new BufferedImage[ 1 ];
		javaImage[ 0 ] = new BufferedImage( width, height, BufferedImage.TYPE_3BYTE_BGR );
	}
	
	public Image( int frames, int width, int height ) {
		javaImage = new BufferedImage[ frames ];
		for( int n = 0; n < frames; n++ ) {
			javaImage[ n ] = new BufferedImage( width, height, BufferedImage.TYPE_3BYTE_BGR );
		}
	}

	/**
	 * Creates new image from file with specified cell quantities for splitting.
	 * @return New image (LTImage).
	 */
	public Image( String filename, int xCells, int yCells ) {
		if( Sys.debug ) if( xCells <= 0 || yCells <= 0 ) error( "Cells quantity must be 1 or more" );

		this.filename = filename;
		this.xCells = xCells;
		this.yCells = yCells;
		this.init();
	}

	public Image( String filename ) {
		this.filename = filename;
		this.xCells = 1;
		this.yCells = 1;
		this.init();
	}


	/**
	 * Initializes image.
	 * Splits image by XCells x YCells grid. Will be executed after loading image object from XML file.
	 */
	public final void initImage() {
		/*
		tPixmap pixmap = loadPixmap( incbin + filename );
		if( ! pixmap ) error( incbin + filename + " cannot be loaded or not found." );
		//?debug
		//If PixmapWidth( javaImage ) Mod XCells != 0 Or PixmapHeight( javaImage ) Mod YCells != 0 Then L_Error( "Incorrect cells quantity for splitting" )
		//?
		if( xCells < 0 ) xCells == pixmapWidth( pixmap ) / -xCells;
		if( yCells < 0 ) yCells == pixmapHeight( pixmap ) / -yCells;

		int cellWidth = pixmapWidth( pixmap ) / xCells;
		int cellHeight = pixmapHeight( pixmap ) / yCells;

		Image bitmap = tImage( bitmaps.get( filename ) );
		if( bitmap then if cellWidth != imageWidth( bitmap ) || cellHeight != imageHeight( bitmap ) ) bitmap == null;
		if( bitmap ) {
			javaImage = bitmap;
		} else {
			javaImage = loadAnimImage( pixmap, cellWidth, cellHeight, 0, xCells * yCells );
			bitmaps.put( filename, bitmap );
		}
		*/
	}


	/**
	 * Returns frames quantity of given image.
	 * @return Frames quantity of given image.
	 */
	public int framesQuantity() {
		return javaImage.length;
	}


	/**
	 * Returns width of image.
	 * @return Width of image in pixels.
	 */
	public int getWidth() {
		return javaImage[ 0 ].getWidth( null );
	}


	/**
	 * Returns height of image.
	 * @return Height of image in pixels.
	 */
	public int getHeight() {
		return javaImage[ 0 ].getHeight( null );
	}

	
	public int getXCells() {
		return xCells;
	}

	
	public int getYCells() {
		return yCells;
	}


	@Override
	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		filename = xMLObject.manageStringAttribute( "filename", filename );
		xCells = xMLObject.manageIntAttribute( "xcells", xCells, 1 );
		yCells = xMLObject.manageIntAttribute( "ycells", yCells, 1 );

		if( Sys.xMLGetMode() && loadImages ) initImage();
	}
	

	public void grab( int frame, int x, int y, int width, int height ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	
	public static Image grab( int x, int y, int width, int height ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public int getPixel( int frame, int x, int y ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	

	public int getPixel( int x, int y ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public void setPixel( int x, int y, int color ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	
	public void draw( int frame, double x, double y, double width, double height, double angle, Color color ){
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	public void draw( int frame, double x, double y, double width, double height, double angle ){
		draw( frame, x, y, width, height, angle, Color.white );
	}
	
	public void draw( int frame, double x, double y, double width, double height ){
		draw( frame, x, y, width, height, 0d, Color.white );
	}
	
	public void draw( int frame, double x, double y ){
		draw( frame, x, y, getWidth(), getHeight(), 0, Color.white );
	}
	
	public void draw( double x, double y ){
		draw( 0, x, y, getWidth(), getHeight(), 0, Color.white );
	}
	

	public void drawAsLine( int frame, double x1, double y1, double x2, double y2, Color color ) {
		draw( frame, 0.5d * ( x1 + x2 ), 0.5d * ( y1 + y2 ), getWidth(), getHeight(), Math.atan2( y2 - y1, x2 - x1 ), color );
	}
	
	public void drawAsLine( double x1, double y1, double x2, double y2 ) {
		draw( 0, 0.5d * ( x1 + x2 ), 0.5d * ( y1 + y2 ), getWidth(), getHeight(), Math.atan2( y2 - y1, x2 - x1 ), Color.white );
	}

	
	public boolean collides( int frame1, double x1, double y1, Image image2, int frame2, double x2, double y2 ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	public boolean collides( int frame1, double x1, double y1, double width1, double height1,
			Image image2, int frame2, double x2, double y2, double width2, double height2 ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public boolean collides( int frame1, double x1, double y1, double width1, double height1, double angle1,
			Image image2, int frame2, double x2, double y2, double width2, double height2, double angle2 ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
}
