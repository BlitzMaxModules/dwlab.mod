package dwlab.visualizers;
import dwlab.base.Obj;
import dwlab.base.Sys;
import dwlab.base.Graphics;
import java.util.HashMap;
import xml.XMLMode;
import xml.XMLObject;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

/**
 * Image class.
 */
public class Image extends Obj {
	public static boolean loadImages = true;
	private static HashMap bitmaps = new HashMap();

	private java.awt.Image[] javaImage;
	private String filename;
	private int xCells = 1;
	private int yCells = 1;

	
	public Image( int frames ) {
		javaImage = new java.awt.Image[ frames ];
	}
	
	
	public Image( int frames, int width, int height ) {
		javaImage = new java.awt.Image[ frames ];
		for( int n = 0; n < frames; n++ ) {
			javaImage[ n ] = new Image( width, height );
		}
	}


	/**
	 * Creates new image from file with specified cell quantities for splitting.
	 * @return New image (LTImage).
	 */
	public static Image fromFile( String filename, int xCells, int yCells ) {
		//?debug
		//If XCells <= 0 Or YCells <= 0 Then L_Error( "Cells quantity must be 1 or more" )
		//?

		Image image = new Image();
		image.filename = filename;
		image.xCells = xCells;
		image.yCells = yCells;
		image.init();

		return image;
	}

	public static Image fromFile( String filename ) {
		return fromFile( filename, 1, 1 );
	}


	/**
	 * Initializes image.
	 * Splits image by XCells x YCells grid. Will be executed after loading image object from XML file.
	 */
	public void init() {
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

		//If Not L_EditorData.Images.Contains( Self ) L_EditorData.Images.AddLast( Self )

		if( Sys.xMLGetMode() && loadImages ) init();
	}
	

	public Image grab( int frame, int x, int y, int width, int height ) {
		return Graphics.grabImage( javaImage[ frame ], x, y, width, height );
	}
	

	public Image grab( int x, int y, int width, int height ) {
		return Graphics.grabImage( javaImage[ 0 ], x, y, width, height );
	}
	

	public int getPixel( int frame, int x, int y ) {
		return Graphics.getImagePixel( javaImage[ frame ], x, y );
	}
	

	public int getPixel( int x, int y ) {
		return Graphics.getImagePixel( javaImage[ 0 ], x, y );
	}

	public void setPixel( int x, int y, int color ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
}
