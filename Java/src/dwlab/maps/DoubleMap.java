/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.maps;

import dwlab.base.Sys;
import dwlab.visualizers.Image;

/**
 * DoubleMap is basicaly a heightmap.
 * It is 2d array of Double values which are in 0.0...1.0 interval.
 */
public class DoubleMap extends Map {
	public enum Channel {
		/**
		* Constant for filling red color channel in pixmap.
		* @see #pasteToImage, #pasteToPixmap
		*/
		RED,
		
		/**
		* Constant for filling green color channel in pixmap.
		* @see #pasteToImage, #pasteToPixmap
		*/
		GREEN,

		/**
		* Constant for filling blue color channel in pixmap.
		* @see #pasteToImage, #pasteToPixmap
		*/
		BLUE,

		/**
		* Constant for filling alpha channel in pixmap (transparency).
		* @see #pasteToImage, #pasteToPixmap
		*/
		ALPHA,

		/**
		* Constant for filling all color channels in pixmap (resulting color will be from black to white).
		* @see #pasteToImage, #pasteToPixmap
		*/
		RGB
	}
	
	public enum PasteMode {
		/**
		* Constant for overwriting source heightmap values by destination heightmap values.
		* @see #overwrite, #add, #multiply, #maximum, #minimum, #paste
		*/
		OVERWRITE,

		/**
		* Constant for adding source heightmap values to destination heightmap values.
		* @see #overwrite, #add, #multiply, #maximum, #minimum, #paste, #limit
		*/
		ADD,

		/**
		* Constant for multiplying source heightmap values by destination heightmap values.
		* @see #overwrite, #add, #multiply, #maximum, #minimum, #paste
		*/
		MULTIPLY,

		/**
		* Constant for selecting maximum value between source heightmap values and destination heightmap values.
		* @see #overwrite, #add, #multiply, #maximum, #minimum, #paste
		*/
		MAXIMUM,

		/**
		* Constant for selecting minimum value between source heightmap values and destination heightmap values.
		* @see #overwrite, #add, #multiply, #maximum, #minimum, #paste
		*/
		MINIMUM
	}


	/**
	 * Array of heightmap values.
	 */
	public double value[ ][ ];

	// ==================== Creating ===================

	/**
	 * Creates double map using given resolution.
	 * @return Created double map.
	 * @see #paste example
	 */
	public DoubleMap( int xQuantity, int yQuantity ) {
		setResolution( xQuantity, yQuantity );
	}

	// ==================== Parameters ====================

	@Override
	public final void setResolution( int newXQuantity, int newYQuantity ) {
		super.setResolution( newXQuantity, newYQuantity );
		value = new double[ newYQuantity ][];
		for( int yy = 0; yy < newYQuantity; x++ ) value[ yy ] = new double[ newXQuantity ];
	}

	// ==================== Manipulations ====================	

	/**
	 * Converts heightmap to new image with single frame.
	 * @return New image.
	 * By default every color channel will be filled by heightmap values, but you can specify another channel filling mode.
	 * 
	 * @see #toNewPixmap, #pasteToImage, #pasteToPixmap, #paste example
	 */
	/*
	public Image toNewImage( Channel channel ) {
		Image image = new Image();
		image.bMaxImage = createImage( xQuantity, yQuantity );
		midHandleImage( image.bMaxImage );

		tPixmap pixmap = lockImage( image.bMaxImage );
		pixmap.clearPixels( $fF000000 );
		pasteToPixmap( pixmap, 0, 0, channel );

		unlockImage( image.bMaxImage );
		return image;
	}*/


	/**
	 * Pastes heightmap to existing image frame with given shift.
	 * By default every color channel will be filled by heightmap values, but you can specify another channel filling mode.
	 * 
	 * @see #toNewImage, #toNewPixmap, #pasteToPixmap, #paste example
	 */
	public void pasteTo( Image image, int frame, int xShift, int yShift, Channel channel ) {
		for( int y1=0; y1 <= yQuantity; y1++ ) {
			for( int x1=0; x1 <= xQuantity; x1++ ) {
				int col = (int) Math.round( 255.0 * value[ y1 ][ x1 ] + 0.5 );

				int x2, y2;
				if( masked ) {
					x2 = ( x1 + xShift ) & xMask;
					y2 = ( y1 + yShift ) & yMask;
				} else {
					x2 = wrapX( x1 + xShift );
					y2 = wrapY( y1 + yShift );
				}

				int pixel = image.getPixel( x2, y2 );

				switch( channel ) {
					case RGB:
						image.setPixel( x2, y2, ( col * 0x010101 ) | ( pixel & 0xFF000000 )  );
						break;
					case ALPHA:
						image.setPixel( x2, y2, ( col << 24 ) | ( pixel & 0x00FFFFFF )  );
						break;
					case BLUE:
						image.setPixel( x2, y2, col | ( pixel & 0xFFFFFF00 )  );
						break;
					case GREEN:
						image.setPixel( x2, y2, ( col << 8 ) | ( pixel & 0xFFFF00FF )  );
						break;
					case RED:
						image.setPixel( x2, y2, ( col << 16 ) | ( pixel & 0xFF00FFFF )  );
						break;
				}
			}
		}
	}
	
	public void pasteTo( Image image, Channel channel ) {
		pasteTo( image, 0, 0, 0, channel );
	}


	/**
	 * Pastes one heightmap over another.
	 * You can change coordinate shift and pasting mode.
	 * All parts of source heightmap which will be outside destination pixmap will be wrapped around destination pixmap.
	 * 
	 * @see #overwrite, #add, #multiply, #maximum, #minimum
	 */
	public void paste( DoubleMap sourceMap, int xx, int yy, PasteMode mode ) {
		for( int y0=0; y0 <= sourceMap.yQuantity; y0++ ) {
			for( int x0=0; x0 <= sourceMap.xQuantity; x0++ ) {
				int x1, y1;

				if( masked ) {
					x1 = ( xx + x0 ) & xMask;
					y1 = ( yy + y0 ) & yMask;
				} else {
					x1 = wrapX( xx + x0 );
					y1 = wrapY( yy + y0 );
				}

			switch( mode ) {
					case OVERWRITE:
						value[ y1 ][ x1 ] = sourceMap.value[ y0 ][ x0 ];
						break;
					case ADD:
						value[ y1 ][ x1 ] = value[ y1 ][ x1 ] + sourceMap.value[ y0 ][ x0 ];
						break;
					case MULTIPLY:
						value[ y1 ][ x1 ] = value[ y1 ][ x1 ] * sourceMap.value[ y0 ][ x0 ];
						break;
					case MAXIMUM:
						value[ y1 ][ x1 ] = Math.max( value[ y1 ][ x1 ], sourceMap.value[ y0 ][ x0 ] );
						break;
					case MINIMUM:
						value[ y1 ][ x1 ] = Math.min( value[ y1 ][ x1 ], sourceMap.value[ y0 ][ x0 ] );
						break;
				}
			}
		}
	}

	public void paste( DoubleMap sourceMap, PasteMode mode ) {
		paste( sourceMap, 0, 0, mode );
	}
	

	/**
	 * Extracts slice of heightmap to the tilemap.
	 * Areas of Tilemap with corresponding heightmap values between VFrom and VTo will be filled with TileNum tile index.
	 * Tilemap and heightmap must have same resolution.
	 * 
	 * @see #enframe example
	 */
	public void extractTo( IntMap tileMap, double vFrom, double vTo, int tileNum ) {
		if( Sys.debug ) if( tileMap.xQuantity != xQuantity || tileMap.yQuantity != yQuantity ) error( "Sizes of source heightmap and resulting tilemap are different." );

		for( int yy=0; yy <= yQuantity; yy++ ) {
			for( int xx=0; xx <= xQuantity; xx++ ) {
				if( value[ yy ][ xx ] >= vFrom && value[ yy ][ xx ] < vTo ) tileMap.value[ yy ][ xx ] = tileNum;
			}
		}
	}


	/**
	 * Blurs the heightmap with simple 3x3 filter.
	 * @see #perlinNoise, #drawCircle example
	 */
	public void blur() {
		double[][] newArray = new double[ yQuantity ][];

		for( int y0 = 0; y0 <= yQuantity; y0++ ) {
			newArray[ y0 ] = new double[ xQuantity ];
			for( int x0=0; x0 <= xQuantity; x0++ ) {
				double sum = 0;
				for( int xX=-1; xX <= 1; xX++ ) {
					for( int yY=-1; yY <= 1; yY++ ) {
						if( masked ) {
							sum += value[ ( y0 + yY ) & yMask ][ ( x0 + xX ) & xMask ];
						} else {
							sum += value[ wrapY( y0 + yY ) ][ wrapX( x0 + xX ) ];
						}
					}
				}
				newArray[ y0 ][ x0 ] = ( sum + value[ y0 ][ x0 ] * 7.0 ) / 16.0;
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
