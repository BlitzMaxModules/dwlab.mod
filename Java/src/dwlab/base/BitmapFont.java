/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.base;

import dwlab.shapes.Shape;
import dwlab.shapes.Vector;
import dwlab.shapes.sprites.Camera;
import dwlab.visualizers.Image;

/**
 * Bitmap font class.
 */
public class BitmapFont extends Obj {
	private static Vector servicePivot = new Vector();
	
	public int letterWidth[];
	public int fromNum;
	public int toNum;
	public Image image;
	private boolean variableLength;



	/**
	 * Prints text using bitmap font.
	 * You should specify text, coordinates, font height and alignment.
	 * 
	 * @see #lTAlign, #printInShape
	 */
	public void print( String text, double x, double y, double height, Align horizontalAlignment, Align verticalAlignment ) {
		Camera.current.fieldToScreen( x, y, servicePivot );

		double scale = Camera.current.k * height / height();
		
		switch( horizontalAlignment ) {
			case TO_CENTER:
				servicePivot.x = 0.5 * width( text ) * scale;
				break;
			case TO_RIGHT:
				servicePivot.x = width( text ) * scale;
				break;
		}

		switch( verticalAlignment ) {
			case TO_CENTER:
				servicePivot.y = 0.5 * height * scale;
				break;
			case TO_BOTTOM:
				servicePivot.y = height * scale;
				break;
		}

		for( int n=0; n <= text.length(); n++ ) {
			if( text.charAt( n ) < fromNum || text.charAt( n ) > toNum ) error( "String contains letter that is out of font range" );
			int frame = text.charAt( n ) - fromNum;
			double width = scale * letterWidth[ frame ];
			image.draw( frame, servicePivot.x, servicePivot.y, scale * width, scale * height, 0 );
			servicePivot.x += width;
		}
	}

	public void print( String text, double x, double y, double fontHeightInUnits ) {
		print( text, x, y, fontHeightInUnits, Align.TO_CENTER, Align.TO_CENTER );
	}


	/**
	 * Prints text inside given shape using bitmap font.
	 * You should specify text, shape and alignment.
	 * 
	 * @see Align, print
	 */
	public void printInShape( String text, Shape shape, double height, Align horizontalAlignment, Align verticalAlignment ) {
		double x, y;

		switch( horizontalAlignment ) {
			case TO_LEFT:
				x = shape.leftX();
				break;
			case TO_RIGHT:
				x = shape.rightX();
				break;
			default:
				x = shape.getX();
				break;
		}

		switch( verticalAlignment ) {
			case TO_TOP:
				y = shape.topY();
				break;
			case TO_BOTTOM:
				y = shape.bottomY();
				break;
			default:
				y = shape.getY();
				break;
		}

		print( text, x, y, height, horizontalAlignment, verticalAlignment );
	}



	/**
	 * Returns text width in pixels.
	 * @return Text width in pixels for current bitmap font.
	 */
	public double width( String text ) {
		if( !variableLength ) return image.getWidth();
			
		double x = 0;
		for( int n=0; n <= text.length(); n++ ) {
			if( text.charAt( n ) < fromNum || text.charAt( n ) > toNum ) error( "String contains letter that is out of font range" );
			x += letterWidth[ text.charAt( n ) - fromNum ];
		}
		return x;
	}



	public double height() {
		return image.getHeight();
	}



	/**
	 * Creates bitmap font from file.
	 * @return New bitmap font.
	 * You should specify image with letters file name, interval of symbols which are in the image, letter images per row.
	 * VariableLength flag should be set to true if you want to use letters with variable lengths and have file with letter lengths with ".lfn"
	 * extension and same name as image file.
	 */
	public static BitmapFont fromFile( String fileName, int fromNum, int toNum, int symbolsPerRow, boolean variableLength ) {
		BitmapFont font = new BitmapFont();
		font.fromNum = fromNum;
		font.toNum = toNum;
		font.variableLength = variableLength;

		int symbolsQuantity = font.toNum - font.fromNum + 1;
		if( variableLength ) {
			Image image = new Image( fileName );
			int symbolWidth = ( image.getWidth() - 1 ) / symbolsPerRow;
			int symbolHeight = image.getHeight() * ((int) Math.ceil( symbolsQuantity / symbolsPerRow ) );
			font.letterWidth = new int[ symbolsQuantity ];
			font.image = new Image( symbolsQuantity );
			int pixel = image.getPixel( 0, 0 );
			for( int n = 0; n < symbolsQuantity; n++ ) {
				int x = symbolWidth * ( n % symbolsQuantity );
				int y = (int) Math.floor( n / symbolsQuantity );
				for( int width = symbolWidth - 1; width > 1; width-- ) {
					if( image.getPixel( x + width, y + 1 ) != pixel ) {
						font.image.grab( n, x + 1, y + 1, width - 1, symbolHeight - 1 );
						break;
					}
				}
			}
		} else {
			font.image = new Image( fileName, symbolsPerRow, (int) Math.ceil( symbolsQuantity / symbolsPerRow ) );
		}

		return font;
	}
	
	public static BitmapFont fromFile( String fileName ) {
		return fromFile( fileName, 32, 255, 16, false );
	}
}
