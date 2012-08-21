package dwlab.maps;
import java.lang.Math;
import dwlab.visualizers.Image;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */


/**
 * DoubleMap is basicaly a heightmap.
 * It is 2d array of Double values which are in 0.0...1.0 interval.
 */
public class DoubleMap extends Map {
	/**
	 * Constant for filling red color channel in pixmap.
	 * @see #pasteToImage, #pasteToPixmap
	 */
	public final int red = 0;

	/**
	 * Constant for filling green color channel in pixmap.
	 * @see #pasteToImage, #pasteToPixmap
	 */
	public final int green = 1;

	/**
	 * Constant for filling blue color channel in pixmap.
	 * @see #pasteToImage, #pasteToPixmap
	 */
	public final int blue = 2;

	/**
	 * Constant for filling alpha channel in pixmap (transparency).
	 * @see #pasteToImage, #pasteToPixmap
	 */
	public final int alpha = 3;

	/**
	 * Constant for filling all color channels in pixmap (resulting color will be from black to white).
	 * @see #pasteToImage, #pasteToPixmap
	 */
	public final int rGB = 4;


	/**
	 * Constant for overwriting source heightmap values by destination heightmap values.
	 * @see #overwrite, #add, #multiply, #maximum, #minimum, #paste
	 */
	public final int overwrite = 0;

	/**
	 * Constant for adding source heightmap values to destination heightmap values.
	 * @see #overwrite, #add, #multiply, #maximum, #minimum, #paste, #limit
	 */
	public final int add = 1;

	/**
	 * Constant for multiplying source heightmap values by destination heightmap values.
	 * @see #overwrite, #add, #multiply, #maximum, #minimum, #paste
	 */
	public final int multiply = 2;

	/**
	 * Constant for selecting maximum value between source heightmap values and destination heightmap values.
	 * @see #overwrite, #add, #multiply, #maximum, #minimum, #paste
	 */
	public final int maximum = 3;

	/**
	 * Constant for selecting minimum value between source heightmap values and destination heightmap values.
	 * @see #overwrite, #add, #multiply, #maximum, #minimum, #paste
	 */
	public final int minimum = 4;

	/**
	 * 2D array of heightmap values.
	 */
	public double value[ , ] = new double()[ 1, 1 ];

	// ==================== Creating ===================

	/**
	 * Creates double map using given resolution.
	 * @return Created double map.
	 * @see #paste example
	 */
	public static DoubleMap create( int xQuantity, int yQuantity ) {
		DoubleMap doubleMap = new DoubleMap();
		doubleMap.setResolution( xQuantity, yQuantity );
		return doubleMap;
	}

	// ==================== Parameters ====================

	public void setResolution( int newXQuantity, int newYQuantity ) {
		super.setResolution( newXQuantity, newYQuantity );
		value = new double()[ newXQuantity, newYQuantity ];
	}

	// ==================== Manipulations ====================	

	/**
	 * Converts heightmap to new image with single frame.
	 * @return New image.
	 * By default every color channel will be filled by heightmap values, but you can specify another channel filling mode.
	 * 
	 * @see #toNewPixmap, #pasteToImage, #pasteToPixmap, #paste example
	 */
	public Image toNewImage( int channel = rGB ) {
		Image image = new Image();
		image.bMaxImage = createImage( xQuantity, yQuantity );
		midHandleImage( image.bMaxImage );

		tPixmap pixmap = lockImage( image.bMaxImage );
		pixmap.clearPixels( $fF000000 );
		pasteToPixmap( pixmap, 0, 0, channel );

		unlockImage( image.bMaxImage );
		return image;
	}



	/**
	 * Converts heightmap to new pixmap.
	 * @return New pixmap.
	 * By default every color channel will be filled by heightmap values, but you can specify another channel filling mode.
	 * 
	 * @see #toNewImage, #pasteToImage, #pasteToPixmap, #perlinNoise example
	 */
	public tPixmap toNewPixmap( int channel = rGB ) {
		tPixmap pixmap = createPixmap( xQuantity, yQuantity, pF_RGBA8888 );
		pixmap.clearPixels( $fF000000 );
		pasteToPixmap( pixmap, 0, 0, channel );
		return pixmap;
	}



	/**
	 * Pastes heightmap to existing image frame with given shift.
	 * By default every color channel will be filled by heightmap values, but you can specify another channel filling mode.
	 * 
	 * @see #toNewImage, #toNewPixmap, #pasteToPixmap, #paste example
	 */
	public void pasteToImage( Image image, int xShift = 0, int yShift = 0, int frame = 0, int channel = rGB ) {
		pasteToPixmap( lockImage( image.bMaxImage, frame ), xShift, yShift, channel );
		unlockImage( image.bMaxImage );
	}



	/**
	 * Pastes heightmap to existing pixmap with given shift.
	 * By default every color channel will be filled by heightmap values, but you can specify another channel filling mode.
	 * 
	 * @see #toNewImage, #toNewPixmap, #pasteToImage
	 */
	public void pasteToPixmap( tPixmap pixmap, int xShift = 0, int yShift = 0, int channel = rGB ) {
		for( int y=0; y <= yQuantity; y++ ) {
			for( int x=0; x <= xQuantity; x++ ) {
				int col = int( 255.0 * value[ x, y ] + 0.5 );

				int xX, int yY;
				if( masked ) {
					xX = ( x + xShift ) & xMask;
					yY = ( y + yShift ) & yMask;
				} else {
					xX = wrapX( x + xShift );
					yY = wrapY( y + yShift );
				}

				int pixel = readPixel( pixmap, xX, yY );

				switch( channel ) {
					case rGB:
						writePixel( pixmap, xX, yY, ( col * $010101 ) | ( pixel & $fF000000 )  );
					case alpha:
						writePixel( pixmap, xX, yY, ( col shl 24 ) | ( pixel & $00fFFFFF )  );
					case blue:
						writePixel( pixmap, xX, yY, col | ( pixel & $fFFFFF00 )  );
					case green:
						writePixel( pixmap, xX, yY, ( col shl 8 ) | ( pixel & $fFFF00FF )  );
					case red:
						writePixel( pixmap, xX, yY, ( col shl 16 ) | ( pixel & $fF00FFFF )  );
				}
			}
		}
	}



	/**
	 * Pastes one heightmap over another.
	 * You can change coordinate shift and pasting mode.
	 * All parts of source heightmap which will be outside destination pixmap will be wrapped around destination pixmap.
	 * 
	 * @see #overwrite, #add, #multiply, #maximum, #minimum
	 */
	public void paste( DoubleMap sourceMap, int x = 0, int y = 0, int mode = overwrite ) {
		for( int y0=0; y0 <= sourceMap.yQuantity; y0++ ) {
			for( int x0=0; x0 <= sourceMap.xQuantity; x0++ ) {
				int xX, int yY;

				if( masked ) {
					xX = ( x + x0 ) & xMask;
					yY = ( y + y0 ) & yMask;
				} else {
					xX = wrapX( x + xX );
					yY = wrapY( y + yY );
				}

			switch( mode ) {
					case overwrite:
						value[ xX, yY ] = sourceMap.value[ x0, y0 ];
					case add:
						value[ xX, yY ] = value[ xX, yY ] + sourceMap.value[ x0, y0 ];
					case multiply:
						value[ xX, yY ] = value[ xX, yY ] * sourceMap.value[ x0, y0 ];
					case maximum:
						value[ xX, yY ] = Math.max( value[ xX, yY ], sourceMap.value[ x0, y0 ] );
					case minimum:
						value[ xX, yY ] = Math.min( value[ xX, yY ], sourceMap.value[ x0, y0 ] );
				}
			}
		}
	}



	/**
	 * Extracts slice of heightmap to the tilemap.
	 * Areas of Tilemap with corresponding heightmap values between VFrom and VTo will be filled with TileNum tile index.
	 * Tilemap and heightmap must have same resolution.
	 * 
	 * @see #enframe example
	 */
	public void extractTo( IntMap tileMap, double vFrom, double vTo, int tileNum ) {
		if( tileMap.xQuantity != xQuantity || tileMap.yQuantity != yQuantity ) error( "Sizes of source heightmap and resulting tilemap are different." );

		for( int x=0; x <= xQuantity; x++ ) {
			for( int y=0; y <= yQuantity; y++ ) {
				if( value[ x, y ] >= vFrom && value[ x, y ] < vTo ) tileMap.value[ x, y ]  == tileNum; ;
			}
		}
	}



	/**
	 * Blurs the heightmap with simple 3x3 filter.
	 * @see #perlinNoise, #drawCircle example
	 */
	public void blur() {
		double newArray[ xQuantity, yQuantity ];

		for( int x=0; x <= xQuantity; x++ ) {
			for( int y=0; y <= yQuantity; y++ ) {
				double sum = 0;
				for( int xX=-1; xX <= 1; xX++ ) {
					for( int yY=-1; yY <= 1; yY++ ) {
						if( masked ) {
							sum += value[ ( x + xX ) & xMask, ( y + yY ) & yMask ];
						} else {
							sum += value[ wrapX( x ), wrapY( y ) ];
						}
					}
				}
				newArray[ x, y ] = ( sum + value[ x, y ] * 7.0 ) / 16.0;
			}
		}
		value = newArray;
	}



	/**
	 * Fills heightmap with perlin noise.
	 * @see #blur, #enframe example
	 */
	public void perlinNoise( int startingXFrequency, double startingYFrequency, double startingAmplitude, double dAmplitude, int layersQuantity ) {
		int xFrequency = startingXFrequency;
		int yFrequency = startingYFrequency;
		double amplitude = startingAmplitude;

		for( double x=0.0; x <= xQuantity; x++ ) {
			for( double y=0.0; y <= yQuantity; y++ ) {
				value[ x, y ] = 0.5;
			}
		}

		for( int n=1; n <= layersQuantity; n++ ) {
			double array[ , ] = new double()[ xFrequency, yFrequency ];

			for( int aX=0; aX <= xFrequency; aX++ ) {
				for( int aY=0; aY <= yFrequency; aY++ ) {
					array[ aX, aY ] = Math.random( -amplitude, amplitude );
				}
			}

			int fXMask = xFrequency - 1;
			int fYMask = yFrequency - 1;

			double kX = 1.0 * xFrequency / xQuantity;
			double kY = 1.0 * yFrequency / yQuantity;

			for( double x=0.0; x <= xQuantity; x++ ) {
				for( double y=0.0; y <= yQuantity; y++ ) {
					double xK = x * kX;
					double yK = y * kY;
					int arrayX = Math.floor( xK );
					int arrayY = Math.floor( yK );

					xK = ( 1.0 - Math.cos( 180.0 * ( xK - arrayX ) ) ) * 0.5;
					yK = ( 1.0 - Math.cos( 180.0 * ( yK - arrayY ) ) ) * 0.5;

					double z00 = array[ arrayX, arrayY ] ;
					double z10 = array[ ( arrayX + 1 ) & fXMask, arrayY ] ;
					double z01 = array[ arrayX, ( arrayY + 1 ) & fYMask ] ;
					double z11 = array[ ( arrayX + 1 ) & fXMask, ( arrayY + 1 ) & fYMask ] ;

					double z0 = z00 + ( z10 - z00 ) * xK;
					double z1 = z01 + ( z11 - z01 ) * xK;

					value[ x, y ] = value[ x, y ] + z0 + ( z1 - z0 ) * yK;
				}
			}

			xFrequency = 2 * xFrequency;
			yFrequency = 2 * yFrequency;
			amplitude = amplitude * dAmplitude;
		}

		limit();
	}



	public final double circleBound = 0.707107;

	/**
	 * Draws anti-aliased circle on the heightmap.
	 * Parts of circle which will be ouside the heightmap, will be wrapped around.
	 * 
	 * @see #paste example
	 */
	public void drawCircle( double xCenter, double yCenter, double radius, double color = 1.0 ) {
		for( int y=Math.floor( yCenter - radius ); y <= Math.ceil( yCenter + radius ); y++ ) {
			for( int x=Math.floor( xCenter - radius ); x <= Math.ceil( xCenter + radius ); x++ ) {
				int xX, int yY;
				if( masked ) {
					xX = x & xMask;
					yY = y & yMask;
				} else {
					xX = wrapX( x );
					yY = wrapY( y );
				}

				double dist = radius - Math.sqrt( ( x - xCenter ) * ( x - xCenter ) + ( y - yCenter ) * ( y - yCenter ) );

				if( dist > circleBound ) {
					value[ xX, yY ] = color;
				} else if( dist < -circleBound then ) {
				} else {
					double dist00 = radius - Math.sqrt( ( x - 0.5 - xCenter ) * ( x - 0.5 - xCenter ) + ( y - 0.5 - yCenter ) * ( y - 0.5 - yCenter ) );
					double dist01 = radius - Math.sqrt( ( x - 0.5 - xCenter ) * ( x - 0.5 - xCenter ) + ( y + 0.5 - yCenter ) * ( y + 0.5 - yCenter ) );
					double dist10 = radius - Math.sqrt( ( x + 0.5 - xCenter ) * ( x + 0.5 - xCenter ) + ( y - 0.5 - yCenter ) * ( y - 0.5 - yCenter ) );
					double dist11 = radius - Math.sqrt( ( x + 0.5 - xCenter ) * ( x + 0.5 - xCenter ) + ( y + 0.5 - yCenter ) * ( y + 0.5 - yCenter ) );
					double k = limitDouble( 0.125 / circleBound * ( dist00 + dist01 + dist10 + dist11 ) + 0.5, 0.0, 1.0 );
					value[ xX, yY ] = value[ xX, yY ] * ( 1 - k ) + k * color;
				}
			}
		}
	}



	/**
	 * Limits the heightmap values by standard interval.
	 * @return 
	 * This method will force heighmap values to be in 0.0...1.0 interval.
	 * Use this method after applying unsafe operations on heightmap, for example adding another heightmap to it.
	 * 
	 * @see #paste example
	 */
	public void limit() {
		for( int x=0; x <= xQuantity; x++ ) {
			for( int y=0; y <= yQuantity; y++ ) {
				if( value[ x, y ] < 0.0 ) value[ x, y ] == 0.0;
				if( value[ x, y ] > 1.0 ) value[ x, y ] == 1.0;
			}
		}
	}
}
