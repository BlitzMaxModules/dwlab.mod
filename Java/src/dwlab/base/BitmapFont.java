package dwlab.base;
import dwlab.shapes.Shape;
import dwlab.shapes.Vector;
import dwlab.sprites.Camera;
import java.awt.Image;
import org.lwjgl.opengl.GL11;

//
// Digital Wizard's Lab - game development framework
// Copyright (C) 2012, Matt Merkulov
//
// All rights reserved. Use of this code is allowed under the
// Artistic License 2.0 terms, as specified in the license.txt
// file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php
//


/**
 * Bitmap font class.
 */
public class BitmapFont extends DWLabObject {
	private static Vector servicePivot = new Vector();
	
	public int letterLength[];
	public int fromNum;
	public int toNum;
	public Image javaImage;



	/**
	 * Prints text using bitmap font.
	 * You should specify text, coordinates, font height and alignment.
	 * 
	 * @see #lTAlign, #printInShape
	 */
	public void print( String text, double x, double y, double fontHeightInUnits, Align horizontalAlignment, Align verticalAlignment ) {
		Camera.current.fieldToScreen( x, y, servicePivot );

		double scale = Camera.current.k * fontHeightInUnits / height();
		
		switch( horizontalAlignment ) {
			case TO_CENTER:
				servicePivot.setX( 0.5 * width( text ) * scale );
			case TO_RIGHT:
				servicePivot.setX( width( text ) * scale );
		}

		switch( verticalAlignment ) {
			case TO_CENTER:
				servicePivot.setY( 0.5 * height() * scale );
			case TO_BOTTOM:
				servicePivot.setY( height() * scale );
		}

		GL11.glVertex2d( x, y )
		Graphics.class;
		setScale scale, scale;
		for( int n=0; n <= text.length(); n++ ) {
			if( text.charAt( n ) < fromNum || text.charAt( n ) > toNum ) error( "String contains letter that is out of font range" );

			drawImage( javaImage, sX, sY, text[ n ] - fromNum );
			sX += scale * letterLength[ text[ n ] - fromNum ];
		}
		setScale 1.0, 1.0;
	}

	public void print( String text, double x, double y, double fontHeightInUnits ) {
		print( String text, x, y, fontHeightInUnits ) {
	}


	/**
	 * Prints text inside given shape using bitmap font.
	 * You should specify text, shape and alignment.
	 * 
	 * @see #lTAlign, #print
	 */
	public void printInShape( String text, Shape shape, double fontHeightInUnits, int horizontalAlignment = Align.toLeft, int verticalAlignment = Align.TO_TOP ) {
		double x, double y;

		switch( horizontalAlignment ) {
			case Align.TO_LEFT:
				x = shape.leftX();
			case Align.TO_CENTER:
				x = shape.x;
			case Align.TO_RIGHT:
				x = shape.rightX();
		}

		switch( verticalAlignment ) {
			case Align.TO_TOP:
				y = shape.topY();
			case Align.TO_CENTER:
				y = shape.y;
			case Align.TO_RIGHT:
				y = shape.bottomY();
		}

		print( text, x, y, fontHeightInUnits, horizontalAlignment, verticalAlignment );
	}



	/**
	 * Returns text width in pixels.
	 * @return Text width in pixels for current bitmap font.
	 */
	public int width( String text ) {
		int x = 0;
		for( int n=0; n <= len( text ); n++ ) {
			if( text[ n ] < fromNum || text[ n ] > toNum ) error( "String contains letter that is out of font range" );

			x += letterLength[ text[ n ] - fromNum ];
		}
		if( x mod 2 ) x += 1;
		return x;
	}



	public int height() {
		return imageHeight( javaImage );
	}



	/**
	 * Creates bitmap font from file.
	 * @return New bitmap font.
	 * You should specify image with letters file name, interval of symbols which are in the image, letter images per row.
	 * VariableLength flag should be set to true if you want to use letters with variable lengths and have file with letter lengths with ".lfn"
	 * extension and same name as image file.
	 */
	public static BitmapFont fromFile( String fileName, int fromNum = 32, int toNum = 255, int symbolsPerRow = 16, int variableLength = false ), int toNum = 255, int symbolsPerRow = 16, int variableLength = false ) {
		BitmapFont font = new BitmapFont();
		font.fromNum = fromNum;
		font.toNum = toNum;

		tPixmap pixmap = loadPixmap( incbin + filename );
		int symbolsQuantity = font.toNum - font.fromNum + 1;
		int symbolWidth = pixmapWidth( pixmap ) / symbolsPerRow;
		//debugstop
		font.javaImage = loadAnimImage( pixmap, symbolWidth, pixmapHeight( pixmap ) * symbolsPerRow / symbolsQuantity, 0, symbolsQuantity );

		font.letterLength = new int()[ symbolsQuantity ];
		if( variableLength ) {
			tStream file = readFile( incbin + stripExt( fileName ) + ".lfn" );
			if( ! file ) error( "Symbol length file for font is not found " + fileName );
			for( int n=0; n <= symbolsQuantity; n++ ) {
				if( eof( file ) ) error( "Not enough symbol length lines in file for font " + fileName );
				font.letterLength[ n ] = readLine( file )[ 2.. ].toInt();
			}
		} else {
			for( int n=0; n <= symbolsQuantity; n++ ) {
				font.letterLength[ n ] = symbolWidth;
			}
		}

		return font;
	}
}
