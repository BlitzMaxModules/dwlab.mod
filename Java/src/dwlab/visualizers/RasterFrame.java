package dwlab.visualizers;
import dwlab.base.XMLObject;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */


/**
 * Special image subclass to display raster frame.
 * After creating this LTImage sub-class you have to load image. This image should consist of 9 images aligned by 3x3 grid.
 * When raster frame have been drawn as the rectangular shape which represents sprite on the screen, this shape will be constructed following
 * way: corner images will be put in corners of the shape, side images will be stretched horizontaly or vertically to fit side bars between them and center
 * image will be stretched in both direction to fully cover remaining center rectangle.
 */
public class RasterFrame extends Image {
	public tImage images[ , , ];

	/**
	 * Width of the left column of 3x3 grid part which will be used for left frame side.
	 */
	public int leftBorder = 1;

	/**
	 * Width of the right column of 3x3 grid which will be used for right frame side.
	 */
	public int rightBorder = 1;

	/**
	 * Width of the top row of 3x3 grid which will be used for frame's top.
	 */
	public int topBorder = 1;

	/**
	 * Width of the bottom row of 3x3 grid which will be used for frame's bottom.
	 */
	public int bottomBorder = 1;

	/**
	 * Flag which switches to another frame displaying algorhytm.
	 */
	public int proportional;


	/**
	 * Raster frame creation function.
	 * You should provide image file name and 4 values for borders (optional, 1 by default).
	 */
	public static RasterFrame fromFileAndBorders( String fileName, int leftBorder = 1, int topBorder = 1, int rightBorder = 1, int bottomBorder = 1 ) {
		RasterFrame frame = new RasterFrame();
		frame.filename = fileName;
		frame.leftBorder = leftBorder;
		frame.topBorder = topBorder;
		frame.rightBorder = rightBorder;
		frame.bottomBorder = bottomBorder;
		frame.init();
		return frame;
	}



	/**
	 * Initialization function.
	 * Main image will be splitted into 9 images and put into array for using.
	 */
	public void init() {
		super.init();
		int quantity = bMaxImage.pixmaps.dimensions()[ 0 ];
		images = new tImage()[ quantity, 3, 3 ];
		for( int n=0; n <= quantity; n++ ) {
			tPixmap pixmap = bMaxImage.pixmaps[ n ];
			int totalWidth = pixmapWidth( pixmap );
			int totalHeight = pixmapHeight( pixmap );
			int y = 0;
			for( int yN=0; yN <= 2	; yN++ ) {
				int height;
				switch( yN ) {
					case 0: height = topBorder;
					case 1: height = totalHeight - topBorder - bottomBorder;
					case 2: height = bottomBorder;
				}
				int x = 0;
				for( int xN=0; xN <= 2; xN++ ) {
					int width;
					switch( xN ) {
						case 0: width = leftBorder;
						case 1: width = totalWidth - leftBorder - rightBorder;
						case 2: width = rightBorder;
					}
					images[ n, xN, yN ] = createImage( width, height );
					if( width > 0 && height > 0 ) {
						if( x + width <= totalWidth && y + height <= totalHeight ) {
							images[ n, xN, yN ].pixmaps[ 0 ] = pixmap.window( x, y, width, height );
						}
					}
					x += width;
				}
				y += height;
			}
		}
	}



	public void draw( double x, double y, double totalWidth, double totalHeight, int frame ) {
		setRotation( 0.0 );
		double width, double height;
		double startX = x - 0.5 * totalWidth;
		double startY = y - 0.5 * totalHeight;
		if( proportional ) {
			if( imageWidth( images[ frame, 0, 1 ] ) == 0 ) {
				double scale = 1.0 * totalWidth / imageWidth( images[ frame, 1, 1 ] );
				setScale scale, scale;
				if( images[ frame, 1, 0 ] ) drawImage( images[ frame, 1, 0 ], startX, startY );
				if( images[ frame, 2, 2 ] ) drawImage( images[ frame, 1, 2 ], startX, startY + totalHeight - scale * imageHeight( images[ frame, 1, 2 ] ) );
				setScale scale, 1.0 * ( totalHeight - scale * ( imageHeight( images[ frame, 1, 0 ] ) + imageHeight( images[ frame, 1, 2 ] ) ) ) / ..;
						imageHeight( images[ frame, 1, 1 ] );
				drawImage( images[ frame, 1, 1 ], startX, startY + scale * imageHeight( images[ frame, 1, 0 ] ) );
			} else {
				double scale = 1.0 * totalHeight / imageHeight( images[ frame, 1, 1 ] );
				setScale scale, scale;
				if( images[ frame, 0, 1 ] ) drawImage( images[ frame, 0, 1 ], startX, startY );
				if( images[ frame, 2, 1 ] ) drawImage( images[ frame, 2, 1 ], startX + totalWidth - scale * imageWidth( images[ frame, 2, 1 ] ), startY );
				setScale ( totalWidth - scale * ( imageWidth( images[ frame, 0, 1 ] ) + imageWidth( images[ frame, 2, 1 ] ) ) ) / ..;
						imageWidth( images[ frame, 1, 1 ] ), scale;
				drawImage( images[ frame, 1, 1 ], startX + scale * imageWidth( images[ frame, 0, 1 ] ), startY );
			}
		} else {
			float xX = startX;
			for( int xN=0; xN <= 2; xN++ ) {
				switch( xN ) {
					case 0: width = imageWidth( images[ frame, 0, 0 ] );
					case 1: width = totalWidth - imageWidth( images[ frame, 0, 0 ] ) - imageWidth( images[ frame, 2, 2 ] );
					case 2: width = imageWidth( images[ frame, 2, 2 ] );
				}

				if( width == 0 ) continue;

				float yY = startY;
				for( int yN=0; yN <= 2; yN++ ) {
					switch( yN ) {
						case 0: height = imageHeight( images[ frame, 0, 0 ] );
						case 1: height = totalHeight - imageHeight( images[ frame, 0, 0 ] ) - imageHeight( images[ frame, 2, 2 ] );
						case 2: height = imageHeight( images[ frame, 2, 2 ] );
					}

					if( height == 0 ) continue;

					setScale 1.0 * width / imageWidth( images[ frame, xN, yN ] ), 1.0 * height / imageHeight( images[ frame, xN, yN ] );
					drawImage( images[ frame, xN, yN ], xX, yY );

					yY += height;
				}
				xX += width;
			}
		}
		setScale 1.0, 1.0;
	}



	public void xMLIO( XMLObject xMLObject ) {
		xMLObject.manageIntAttribute( "left", leftBorder, 1 );
		xMLObject.manageIntAttribute( "right", rightBorder, 1 );
		xMLObject.manageIntAttribute( "top", topBorder, 1 );
		xMLObject.manageIntAttribute( "bottom", bottomBorder, 1 );
		xMLObject.manageIntAttribute( "proportional", proportional );

		super.xMLIO( xMLObject );
	}
}
