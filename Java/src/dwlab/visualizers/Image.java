package dwlab.visualizers;
import java.util.HashMap;
import dwlab.base.XMLObject;
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

public int loadImages = 1;



/**
 * Image class.
 */
public class Image extends DWLabObject {
	public tImage bMaxImage;
	public String filename;
	public int xCells = 1;
	public int yCells = 1;

	public HashMap bitmaps = new HashMap();



	/**
	 * Creates new image from file with specified cell quantities for splitting.
	 * @return New image (LTImage).
	 */
	public static Image fromFile( String filename, int xCells = 1, int yCells = 1 ) {
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



	/**
	 * Initializes image.
	 * Splits image by XCells x YCells grid. Will be executed after loading image object from XML file.
	 */
	public void init() {
		tPixmap pixmap = loadPixmap( incbin + filename );
		if( ! pixmap ) error( incbin + filename + " cannot be loaded or not found." );
		//?debug
		//If PixmapWidth( BMaxImage ) Mod XCells != 0 Or PixmapHeight( BMaxImage ) Mod YCells != 0 Then L_Error( "Incorrect cells quantity for splitting" )
		//?
		if( xCells < 0 ) xCells == pixmapWidth( pixmap ) / -xCells;
		if( yCells < 0 ) yCells == pixmapHeight( pixmap ) / -yCells;

		int cellWidth = pixmapWidth( pixmap ) / xCells;
		int cellHeight = pixmapHeight( pixmap ) / yCells;

		tImage bitmap = tImage( bitmaps.get( filename ) );
		if( bitmap then if cellWidth != imageWidth( bitmap ) || cellHeight != imageHeight( bitmap ) ) bitmap == null;
		if( bitmap ) {
			bMaxImage = bitmap;
		} else {
			bMaxImage = loadAnimImage( pixmap, cellWidth, cellHeight, 0, xCells * yCells );
			midHandleImage( bMaxImage );
			bitmaps.put( filename, bitmap );
		}
	}



	/**
	 * Sets handle of image.
	 * Values should be in 0.0...1.0 interval.
	 */
	public void setHandle( double x, double y ) {
		setImageHandle( bMaxImage, x * imageWidth( bMaxImage ), y * imageHeight( bMaxImage ) );
	}



	/**
	 * Returns frames quantity of given image.
	 * @return Frames quantity of given image.
	 */
	public int framesQuantity() {
		return bMaxImage.frames.dimensions()[ 0 ];
	}



	/**
	 * Returns width of image.
	 * @return Width of image in pixels.
	 */
	public double width() {
		return imageWidth( bMaxImage );
	}



	/**
	 * Returns height of image.
	 * @return Height of image in pixels.
	 */
	public double height() {
		return imageHeight( bMaxImage );
	}



	/**
	 * Draws image using given coordinates and size.
	 */
	public void draw( double x, double y, double width, double height, int frame ) {
		setScale( width / imageWidth( bMaxImage ), height / imageHeight( bMaxImage ) );
		drawImage( bMaxImage, x, y, frame );
	}



	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );

		xMLObject.manageStringAttribute( "filename", filename );
		xMLObject.manageIntAttribute( "xcells", xCells, 1 );
		xMLObject.manageIntAttribute( "ycells", yCells, 1 );

		//If Not L_EditorData.Images.Contains( Self ) L_EditorData.Images.AddLast( Self )

		if( XML.mode == XMLMode.GET && loadImages ) init();
	}
}
