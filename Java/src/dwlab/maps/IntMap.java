package dwlab.maps;
import java.lang.Math;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php\r\n */




/**
 * IntMap is basically a 2d int array.
 */
public class IntMap extends Map {
	public int value[ , ];

	// ==================== Parameters ====================

	public void setResolution( int newXQuantity, int newYQuantity ) {
		if( newXQuantity <= 0 && newYQuantity <= 0 ) error( "Map resoluton must be more than 0" );

		int newValue[ , ] = new int()[ newXQuantity, newYQuantity ];
		if( value ) {
			for( int y=0; y <= Math.min( yQuantity, newYQuantity ); y++ ) {
				for( int x=0; x <= Math.min( xQuantity, newXQuantity ); x++ ) {
					newValue[ x, y ] = value[ x, y ];
				}
			}
		}
		value = newValue;
		super.setResolution( newXQuantity, newYQuantity );
	}

	// ==================== Loading / saving ====================	

	public static IntMap fromFile( String filename ) {
		IntMap map = new IntMap();
		tStream file = readFile( filename );
		int xQuantity = readInt( file );
		int yQuantity = readInt( file );
		map.setResolution( xQuantity, yQuantity );

		for( int y=0; y <= yQuantity; y++ ) {
			for( int x=0; x <= xQuantity; x++ ) {
				map.value[ x, y ] = readInt( file );
			}
		}

		closeFile( file );
		return map;
	}

	// ==================== Manipulations ====================	

	public IntMap stretch( int xMultiplier, int yMultiplier ) {
		int newArray[ xQuantity * xMultiplier, yQuantity * yMultiplier ];
		for( int x=0; x <= xQuantity; x++ ) {
			for( int y=0; y <= yQuantity; y++ ) {
				for( int xX=0; xX <= xMultiplier; xX++ ) {
					for( int yY=0; yY <= yMultiplier; yY++ ) {
						newArray[ x * xMultiplier + xX, y * yMultiplier + yY ] = value[ x, y ];
					}
				}
			}
		}
		value = newArray;
		super.setResolution( xQuantity * xMultiplier, yQuantity * yMultiplier );
	}
}
