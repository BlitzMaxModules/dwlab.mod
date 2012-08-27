/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.base;

import dwlab.base.Image;
import dwlab.base.XMLObject;
import dwlab.visualizers.Color;

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
	public RasterFrame( String fileName, int xCells, int yCells, int leftBorder, int topBorder, int rightBorder, int bottomBorder ) {
		this.leftBorder = leftBorder;
		this.topBorder = topBorder;
		this.rightBorder = rightBorder;
		this.bottomBorder = bottomBorder;
		
		this.fileName = fileName;
		this.xCells = xCells;
		this.yCells = yCells;
		this.init();
	}

	public RasterFrame( String fileName, int leftBorder, int topBorder, int rightBorder, int bottomBorder ) {
		this.leftBorder = leftBorder;
		this.topBorder = topBorder;
		this.rightBorder = rightBorder;
		this.bottomBorder = bottomBorder;
		
		this.fileName = fileName;
		this.xCells = 1;
		this.yCells = 1;
		this.init();
	}
	
	
	/**
	 * Initialization function.
	 * Main image will be splitted into 9 images and put into array for using.
	 */
	@Override
	public void draw( int frame, double x, double y, double width, double height, double angle, Color color ){
		double currentY = y - 0.5 * height;
		if( proportional ) {
			double currentX = x - 0.5 * width;
			if( topBorder != 0 || bottomBorder != 0 ) {
				double currentHeight;
				int currentTHeight;
				int currentTY = 0;
				for( int n = 0; n <= 2 ; n++ ) {
					switch( n ) {
						case 0:
							currentHeight = topBorder;
							currentTHeight = topBorder;
							break;
						case 1:
							currentHeight = height - topBorder - bottomBorder;
							currentTHeight = getHeight() - topBorder - bottomBorder;
							break;
						default:
							currentHeight = bottomBorder;
							currentTHeight = bottomBorder;
							break;
					}
					
					draw( frame, currentX, currentY, width, currentHeight, 0, currentTY, frameWidth, currentTY + currentTHeight, color );
					
					currentY += currentHeight;
					currentTY += currentTHeight;
				}
			} else if( leftBorder != 0 || rightBorder != 0 ) {
				double currentWidth;
				int currentTWidth;
				int currentTX = 0;
				for( int m = 0; m <= 2; m++ ) {
					switch( m ) {
						case 0:
							currentWidth = leftBorder;
							currentTWidth = leftBorder;
							break;
						case 1:
							currentWidth = width - leftBorder - rightBorder;
							currentTWidth = getWidth() - leftBorder - rightBorder;
							break;
						default:
							currentWidth = rightBorder;
							currentTWidth = rightBorder;
							break;
					}

					draw( frame, currentX, currentY, currentWidth, 0, currentTX, 0, currentTX+ currentTWidth, frameHeight, color );

					currentX += currentWidth;
					currentTX += currentTWidth;
				}
			}
		} else {
			double currentWidth, currentHeight;
			int currentTWidth, currentTHeight;
			int currentTY = 0;
			for( int n = 0; n <= 2 ; n++ ) {
				switch( n ) {
					case 0:
						currentHeight = topBorder;
						currentTHeight = topBorder;
						break;
					case 1:
						currentHeight = height - topBorder - bottomBorder;
						currentTHeight = getHeight() - topBorder - bottomBorder;
						break;
					default:
						currentHeight = bottomBorder;
						currentTHeight = bottomBorder;
						break;
				}
				double currentX = x - 0.5 * width;
				int currentTX = 0;
				for( int m = 0; m <= 2; m++ ) {
					switch( m ) {
						case 0:
							currentWidth = leftBorder;
							currentTWidth = leftBorder;
							break;
						case 1:
							currentWidth = width - leftBorder - rightBorder;
							currentTWidth = getWidth() - leftBorder - rightBorder;
							break;
						default:
							currentWidth = rightBorder;
							currentTWidth = rightBorder;
							break;
					}

					draw( frame, currentX, currentY, currentWidth, currentHeight, currentTX, currentTY, currentTX+ currentTWidth, currentTY + currentTHeight, color );

					currentX += currentWidth;
					currentTX += currentTWidth;
				}
				currentY += currentHeight;
				currentTY += currentTHeight;
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
