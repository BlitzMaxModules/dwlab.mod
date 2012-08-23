/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.maps;

/**
 * IntMap is basically a 2d int array.
 */
public class IntMap extends Map {
	public int value[ ][ ];

	// ==================== Parameters ====================

	@Override
	public void setResolution( int newXQuantity, int newYQuantity ) {
		if( newXQuantity <= 0 && newYQuantity <= 0 ) error( "Map resoluton must be more than 0" );

		int newValue[][] = new int[ newYQuantity ][];
		for( int yy=0; yy <= Math.min( yQuantity, newYQuantity ); yy++ ) newValue[ yy ] = new int[ newXQuantity ];
		if( value != null ) {
			for( int yy=0; yy <= Math.min( yQuantity, newYQuantity ); yy++ ) {
				for( int xx=0; xx <= Math.min( xQuantity, newXQuantity ); xx++ ) newValue[ yy ][ xx ] = value[ yy ][ xx ];
			}
		}
		value = newValue;
		super.setResolution( newXQuantity, newYQuantity );
	}

	// ==================== Loading / saving ====================	

	/*
	public IntMap( String filename ) {
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
	*/

	// ==================== Manipulations ====================	

	@Override
	public void stretch( int xMultiplier, int yMultiplier ) {
		int newArray[][] = new int[ yQuantity * yMultiplier ][];
		for( int y1=0; y1 <= yQuantity; y1++ ) {
			newArray[ y1 ] = new int [ xQuantity * xMultiplier ];
			for( int x1=0; x1 <= xQuantity; x1++ ) {
				for( int y2=0; y2 <= yMultiplier; y2++ ) {
					for( int x2=0; x2 <= xMultiplier; x2++ ) {
						newArray[ y1 * yMultiplier + y2 ][ x1 * xMultiplier + x2 ] = value[ y1 ][ x1 ];
					}
				}
			}
		}
		value = newArray;
		super.setResolution( xQuantity * xMultiplier, yQuantity * yMultiplier );
	}
}
