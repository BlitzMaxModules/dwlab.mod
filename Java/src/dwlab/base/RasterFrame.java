/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.base;

import dwlab.base.Image;
import dwlab.base.XMLObject;

/**
 * Special image subclass to display raster frame.
 * After creating this LTImage sub-class you have to load image. This image should consist of 9 images aligned by 3x3 grid.
 * When raster frame have been drawn as the rectangular shape which represents sprite on the screen, this shape will be constructed following
 * way: corner images will be put in corners of the shape, side images will be stretched horizontaly or vertically to fit side bars between them and center
 * image will be stretched in both direction to fully cover remaining center rectangle.
 */
public class RasterFrame extends Image {
	public Image images[][];

	/**
	 * Width of the left column of 3x3 grid part which will be used for left frame side.
	 */
	public int leftBorder;

	/**
	 * Width of the right column of 3x3 grid which will be used for right frame side.
	 */
	public int rightBorder;

	/**
	 * Width of the top row of 3x3 grid which will be used for frame's top.
	 */
	public int topBorder;

	/**
	 * Width of the bottom row of 3x3 grid which will be used for frame's bottom.
	 */
	public int bottomBorder;

	/**
	 * Flag which switches to another frame displaying algorhytm.
	 */
	public boolean proportional;


	/**
	 * Raster frame creation function.
	 * You should provide image file name and 4 values for borders (optional, 1 by default).
	 */
	public RasterFrame( String fileName, int leftBorder, int topBorder, int rightBorder, int bottomBorder ) {
		this.filename = fileName;
		this.leftBorder = leftBorder;
		this.topBorder = topBorder;
		this.rightBorder = rightBorder;
		this.bottomBorder = bottomBorder;
		this.initRasterFrame();
	}


	/**
	 * Initialization function.
	 * Main image will be splitted into 9 images and put into array for using.
	 */
	public final void initRasterFrame() {
		/*
		super.init();
		int quantity = this.framesQuantity();
		for( int n=0; n <= quantity; n++ ) {
			int totalWidth = (int) getWidth();
			int totalHeight = (int) getHeight();
			int y = 0;
			for( int yN=0; yN <= 2 ; yN++ ) {
				if( n == 0 ) images = new Image[ 3 ][];
				int height = 0;
				switch( yN ) {
					case 0:
						height = topBorder;
						break;
					case 1:
						height = totalHeight - topBorder - bottomBorder;
						break;
					case 2:
						height = bottomBorder;
						break;
				}
				int x = 0;
				for( int xN=0; xN <= 2; xN++ ) {
					if( n == 0 ) images[ yN ] = new Image[ 3 ];
					int width = 0;
					switch( xN ) {
						case 0:
							width = leftBorder;
							break;
						case 1:
							width = totalWidth - leftBorder - rightBorder;
							break;
						case 2:
							width = rightBorder;
							break;
					}
					images[ yN ][ xN ] = new Image( quantity );
					if( width > 0 && height > 0 ) {
						if( x + width <= totalWidth && y + height <= totalHeight ) images[ yN ][ xN ].grab( n, x, y, width, height );
					}
					x += width;
				}
				y += height;
			}
		}
		*/
	}


	public void draw( double x, double y, double totalWidth, double totalHeight, int frame ) {
		double width, height;
		double startX = x - 0.5 * totalWidth;
		double startY = y - 0.5 * totalHeight;
		if( proportional ) {
			/*
			if( imageWidth( images[ frame, 0, 1 ] ) == 0 ) {
				double scale = 1.0 * totalWidth / imageWidth( images[ frame, 1, 1 ] );
				setScale scale, scale;
				if( images[ frame, 1, 0 ] ) draw( images[ frame, 1, 0 ], startX, startY );
				if( images[ frame, 2, 2 ] ) draw( images[ frame, 1, 2 ], startX, startY + totalHeight - scale * imageHeight( images[ frame, 1, 2 ] ) );
				setScale scale, 1.0 * ( totalHeight - scale * ( imageHeight( images[ frame, 1, 0 ] ) + imageHeight( images[ frame, 1, 2 ] ) ) ) / ..;
						imageHeight( images[ frame, 1, 1 ] );
				images[ frame, 1, 1 ].draw( startX, startY + scale * imageHeight( images[ frame, 1, 0 ] ) );
			} else {
				double scale = 1.0 * totalHeight / imageHeight( images[ frame, 1, 1 ] );
				setScale scale, scale;
				if( images[ 1 ][ 0 ] != null ) images[ 1 ][ 0 ].draw( frame, startX, startY );
				if( images[ 1 ][ 2 ] != null ) images[ 1 ][ 2 ].draw( frame, startX + totalWidth - scale * images[ 1 ][ 2 ].getWidth(), startY );
				setScale ( totalWidth - scale * ( imageWidth( images[ frame, 0, 1 ] ) + imageWidth( images[ frame, 2, 1 ] ) ) ) / ..;
						imageWidth( images[ frame, 1, 1 ] ), scale;
				draw( images[ frame, 1, 1 ], startX + scale * imageWidth( images[ frame, 0, 1 ] ), startY );
			}
			*/
		} else {
			double xX = startX;
			for( int xN=0; xN <= 2; xN++ ) {
				switch( xN ) {
					case 0:
						width = images[ 0 ][ 0 ].getWidth();
						break;
					case 1:
						width = totalWidth - images[ 0 ][ 0 ].getWidth() - images[ 2 ][ 2 ].getWidth();
						break;
					default:
						width = images[ 2 ][ 2 ].getWidth();
						break;
				}

				if( width == 0d ) continue;

				double yY = startY;
				for( int yN=0; yN <= 2; yN++ ) {
					switch( yN ) {
						case 0:
							height = images[ 0 ][ 0 ].getHeight();
							break;
						case 1:
							height = totalHeight - images[ 0 ][ 0 ].getHeight() - images[ 2 ][ 2 ].getHeight();
							break;
						default:
							height = images[ 2 ][ 2 ].getHeight();
							break;
					}

					if( height == 0 ) continue;

					//setScale 1.0 * width / imageWidth( images[ frame, xN, yN ] ), 1.0 * height / imageHeight( images[ frame, xN, yN ] );
					images[ yN ][ xN ].draw( frame, xX, yY );

					yY += height;
				}
				xX += width;
			}
		}
	}


	@Override
	public void xMLIO( XMLObject xMLObject ) {
		leftBorder = xMLObject.manageIntAttribute( "left", leftBorder, 1 );
		rightBorder = xMLObject.manageIntAttribute( "right", rightBorder, 1 );
		topBorder = xMLObject.manageIntAttribute( "top", topBorder, 1 );
		bottomBorder = xMLObject.manageIntAttribute( "bottom", bottomBorder, 1 );
		proportional = xMLObject.manageBooleanAttribute( "proportional", proportional );

		super.xMLIO( xMLObject );
	}
}
