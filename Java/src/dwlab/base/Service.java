package dwlab.base;
import java.util.LinkedList;
import java.lang.Math;
import dwlab.shapes.Shape;
import dwlab.visualizers.Visualizer;

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
 * Transfers hex string value to Int.
 */
public static int hexToInt( String hexString ) {
	int value = 0;
	hexString = hexString.toUpperCase().trim();
	for( int n=0; n <= len( hexString ); n++ ) {
		if( hexString[ n ] <= asc( "9" ) ) {
			value = value * 16 + ( hexString[ n ] - asc( "0" ) );
		} else {
			value = value * 16 + ( hexString[ n ] - asc( "A" ) + 10 );
		}
	}
	return value;
}





/**
 * Draws empty rectangle.
 * @see #drawMARect
 */
public static void drawEmptyRect( double x, double y, double width, double height ) {
	width -= 1;
	height -= 1;
	drawLine( x, y, x + width, y );
	drawLine( x, y, x, y + height );
	drawLine( x + width, y, x + width, y + height );
	drawLine( x, y + height, x + width, y + height );
}





/**
 * Deletes list.
 */
public static void deleteList( LinkedList list ) {
	list.clear();
	list._head._pred = null;
	list._head._succ = null;
}





/**
 * Trims trailing zeroes of Double value and cuts all digits after given quantity (off by default) after point.
 */
public static String trimDouble ( double val, int digitsAfterDot = -1 ) {
	String strVal, int n;
	if( digitsAfterDot >=0 ) {
		strVal = String( val ) + "00000000000000";
		n = strVal.indexOf( "." ) + 1 + digitsAfterDot;
	} else {
		strVal = String( val );
		n = strVal.length;
	}

	while( true ) {
		n -= 1;
		switch( strVal[ n ] ) {
			case asc( "0" ):
			case asc( "." ):
				return strVal[ ..n ];
			default:
				return strVal[ ..n + 1 ];
		}
	}
}





/**
 * Adds zeroes to Int value to make resulting string length equal to given.
 * @return String with zeroes equal to Int value.
 */
public static String firstZeroes( int value, int totalDigits ) {
	String stringValue = value;
	int length = len( stringValue );
	if( length < totalDigits ) {
		return symbols( "0", totalDigits - length ) + stringValue;
	} else {
		return stringValue;
	}
}





/**
 * Returns string made from given string repeated given number of times.
 * @return String consisting of repeated given string.
 */
public static String symbols( String symbol, int times ) {
	String symbols = "";
	for( int n=1; n <= times; n++ ) {
		symbols += symbol;
	}
	return symbols;
}





/**
 * Limits Double value with inerval defined by two Double values.
 * @return Limited Double value.

 * <ul>
 * <li> If Value is less than FromValue then function returns FromValue.
 * <li> If Value is more than ToValue then function returns ToValue.
 * <li> Otherwise function returns Value.
 * </ul>

 * @see #l_LimitInt
 */
public static double limitDouble( double value, double fromValue, double toValue ) {
	 if( fromValue > toValue ) error( "FromValue must be less than ToValue" );
	if( value < fromValue ) {
		return fromValue;
	} else if( value > toValue ) {
		return toValue;
	} else {
		return value;
	}
}





/**
 * Limits Int value with inerval defined by two Int values.
 * @return Limited Int value.

 * <ul>
 * <li> If Value is less than FromValue then function returns FromValue.
 * <li> If Value is more than ToValue then function returns ToValue.
 * <li> Otherwise function returns Value.
 * </ul>

 * @see #l_LimitDouble, #l_IntInLimits
 */
public static int limitInt( int value, int fromValue, int toValue ) {
	if( fromValue > toValue ) error( "FromValue must be less than ToValue" );
	if( value < fromValue ) {
		return fromValue;
	} else if( value > toValue ) {
		return toValue;
	} else {
		return value;
	}
}





/**
 * Checks if given value is the power of 2.
 * @return True is given value is power of 2 otherwise False.
 * @see #l_ToPowerOf2
 */
public static int isPowerOf2( int value ) {
	if( value + ( value - 1 ) == value ~ ( value - 1 ) ) return true;
}





/**
 * Wraps Int value using given size.
 * @return Wrapped Int value.
 * Function returns Value which will be kept in 0...Size - 1 interval.

 * @see #l_WrapInt2, #l_WrapDouble
 */
public static int wrapInt( int value, int size ) {
	return value - size * Math.floor( 1.0 * value / size );
}





/**
 * Wraps Int value using given interval defined by two given Int values.
 * @return Wrapped Int value.
 * Function returns Value which will be kept in FromValue...ToValue - 1 interval.

 * @see #l_WrapInt, #l_WrapDouble
 */
public static int wrapInt2( int value, int fromValue, int toValue ) {
	int size = toValue - fromValue;
	return value - Math.floor( 1.0 * ( value - fromValue ) / size ) * size;
}





/**
 * Wraps Double value using given size.
 * @return Wrapped Double value.
 * Function returns Value which will be kept in 0...Size interval excluding Size.

 * @see #l_WrapInt
 */
public static double wrapDouble( double value, double size ) {
	return value - size * Math.floor( value / size );
}





/**
 * Searches for the file with given filename and one of extensions.
 * @return Filename of found file or empty string if file is not found.
 * Filename without extension will be also checked.
 */
public static String tryExtensions( String filename, String extensions[] ) {
	if( fileType( filename ) == 1 ) return filename;

	for( String extension: extensions ) {
		String newFilename = filename + "." + extension;
		if( fileType( newFilename ) == 1 ) return newFilename;
	}
}





/**
 * Clears pixmap with given color and alpha values.
 */
public static void clearPixmap( tPixmap pixmap, double red = 0.0, double green = 0.0, double blue = 0.0, double alpha = 1.0 ) {
	int col = int( 255.0 * red ) + int( 255.0 * green ) shl 8 + int( 255.0 * blue ) shl 16 + int( 255.0 * alpha ) shl 16;
	pixmap.clearPixels( col );
}





/**
 * Rounds double value to nearest integer.
 * @return Rounded value.
 * Faster than Int().
 */
public static int round( double value ) {
	return int( value + 0.double 5 * sgn( value ) );
}




public static double distance( double dX, double dY ) {
	return Math.sqrt( dX * dX + dY * dY );
}




public static double distance2( double dX, double dY ) {
	return dX * dX + dY * dY;
}





public static double cathetus( double aB, double bC ) {
	return Math.sqrt( aB * aB - bC * bC );
}





/**
 * Converts full path to path relative to current directory.
 */
public static String chopFilename( String filename ) {
	String dir = currentDir();
	String slash = "/";
	slash = "\";
	dir = dir.replaceAll( "/", "\" );
	filename = filename.replaceAll( "/", "\" );
	dir += slash;
	for( int n=0; n <= len( dir ); n++ ) {
		if( n ==> len( filename ) ) return filename;
		if( dir[ n ] != filename[ n ] ) {
			if( n == 0 ) return filename;
			int slashPos = n - 1;
			filename = filename[ n.. ];
			while( true ) {
				slashPos = dir.indexOf( slash, slashPos + 1 );
				if( slashPos == -1 ) exit;
				filename = ".." + slash + filename;
			}
			return filename;
		}
	}
	return filename[ len( dir ).. ];
}





/**
 * Adds Int value to Int array.
 * @see #l_RemoveItemFromintArray
 */
public static void addItemToIntArray( int array[] var, int item ) {
	int quantity = array.dimensions()[ 0 ];
	int newArray[] = new int()[ quantity + 1 ];
	for( int n=0; n <= quantity; n++ ) {
		newArray[ n ] = array[ n ];
	}
	newArray[ quantity ] = item;
	array = newArray;
}





/**
 * Removes item with given index from Int array.
 * @see #l_AddItemToIntArray
 */
public static void removeItemFromIntArray( int array[] var, int index ) {
	int quantity = array.dimensions()[ 0 ];
	if( quantity == 1 ) {
		array = null;
	} else {
		int newArray[] = new int()[ quantity - 1 ];
		for( int n=0; n <= quantity; n++ ) {
			if( n < index ) {
				newArray[ n ] = array[ n ];
			} else if( n > index then ) {
				newArray[ n - 1 ] = array[ n ];
			}
		}
		array = newArray;
	}
}





/**
 * Checks if Int value is in the interval between FromValue and ToValue.
 * @return True if Value is in FromValue...ToValue interval.
 * @see #l_LimitInt
 */
public static int intInLimits( int value, int fromValue, int toValue ) {
	if( value >= fromValue && value <= toValue ) return true;
}





/**
 * Checks if Double value is in the interval between FromValue and ToValue.
 * @return True if Value is in FromValue...ToValue interval.
 * @see #l_IntInLimits
 */
public static double doubleInLimits( double value, double fromValue, double toValue) {
	if( value >= fromValue && value <= toValue ) return true;
}




/**
 * Returns TypeID for given class name.
 * @return TypeID for given class name.
 * If class is not found then error will occur.
 */
public static tTypeId getTypeID( String typeName ) {
	if( ! typeName ) return null;
	tTypeId typeID = tTypeID.forName( typeName );

	if( ! typeID ) error( "Type name \"" + typeName + "\" not found" );

	return typeID;
}





/**
 * Returns nearest power of 2.
 * @return Lowest power of 2 which is more than or equal to Value.
 * @see #l_IsPowerOf2
 */
public double log2 = Math.log( 2 );

public static int toPowerOf2( int value ) {
	return 2 ^ Math.ceil( Math.log( value ) / log2 );
}





public static void getEscribedRectangle( double leftMargin, double rightMargin, double topMargin, double bottomMargin, .. {
		double minX var, double minY var, double maxX var, double maxY var );
	double x00, double y00, double x01, double y01;
	double x10, double y10, double x11, double y11;
	Shape viewport = Camera.current.viewport;
	Camera.current.screenToField( viewport.leftX(), viewport.topY(), x00, y00 );
	Camera.current.screenToField( viewport.rightX(), viewport.topY(), x10, y10 );
	Camera.current.screenToField( viewport.leftX(), viewport.bottomY(), x01, y01 );
	Camera.current.screenToField( viewport.rightX(), viewport.bottomY(), x11, y11 );
	minX = Math.min( Math.min( x00 - leftMargin, x10 + rightMargin ), Math.min( x01 - leftMargin, x11 + rightMargin ) );
	minY = Math.min( Math.min( y00 - topMargin, y10 - topMargin ), Math.min( y01 + bottomMargin, y11 + bottomMargin ) );
	maxX = Math.max( Math.max( x00 - leftMargin, x10 + rightMargin ), Math.max( x01 - leftMargin, x11 + rightMargin ) );
	maxY = Math.max( Math.max( y00 - topMargin, y10 - topMargin ), Math.max( y01 + bottomMargin, y11 + bottomMargin ) );
}





public static String uTF8toASCII( int charNum ) {
	int additionalBytes = 0;
	int mask = 0;
	String code = "";
	if( charNum < $00000080 ) {
		return chr( charNum );
	} else if( charNum < $00000800 then ) {
		additionalBytes = 1;
		mask = %11000000;
	} else if( charNum < $00000800 then ) {
		additionalBytes = 2;
		mask = %11100000;
	} else if( charNum < $00010000 then ) {
		additionalBytes = 3;
		mask = %11110000;
	} else if( charNum < $00200000 then ) {
		additionalBytes = 4;
		mask = %11111000;
	} else if( charNum < $04000000 then ) {
		additionalBytes = 5;
		mask = %11111100;
	} else {
		additionalBytes = 6;
		mask = %11111110;
	}
	for( int n=1; n <= additionalBytes; n++ ) {
		code = chr( %10000000 | ( charNum & %111111 ) ) + code;
		charNum = charNum shr 6;
	}
	return chr( mask | charNum ) + code;
}





public static String aSCIIToUTF8( String text, int pos var ) {
	int header = text[ pos ];
	if( header < 128 ) return chr( header );

	int code = 0;
	int headerShift = 0;
	header = header & %01111111;
	int bitMask = %01000000;
	while( true ) {
		if( !( header & bitMask ) ) exit;
		header = header ~ bitMask;
		pos += 1;
		code = ( code shl 6 ) + text[ pos ] & %111111;
		bitMask = bitMask shr 1;
		headerShift += 6;
	}
	return chr( ( header shl headerShift ) + code );
}





public static void printText( String text, double x, double y, int horizontalAlign = Align.toCenter, int verticalAlign = Align.toCenter, int contour = false ) {
	double sX, double sY;
	Camera.current.fieldToScreen( x, y, sX, sY );

	double width = textWidth( text );
	double height = textHeight( text );

	switch( horizontalAlign ) {
		case Align.toCenter:
			sX -= 0.5 * width;
		case Align.toRight:
			sX -= width;
	}

	switch( verticalAlign ) {
		case Align.toCenter:
			sY -= 0.5 * height;
		case Align.toBottom:
			sY -= height;
	}

	if( contour ) {
		drawTextWithContour( text, sX, sY );
	} else {
		drawText( text, sX, sY );
	}
}





public static void drawTextWithContour( String text, int sX, int sY ) {
	setColor( 0, 0, 0 );
	for( int dY=-1; dY <= 1; dY++ ) {
		for( int dX=Math.abs( dY ) - 1; dX <= 1 - Math.abs( dY ); dX++ ) {
			drawText( text, sX + dX, sY + dY );
		}
	}
	Visualizer.resetColor();
	drawText( text, sX, sY );
}





public static int versionToInt( String version, int totalChunks = 4 ) {
	String versions[] = version.split( "." );
	int intVersion = 0;
	for( int n=0; n <= totalChunks; n++ ) {
		intVersion = intVersion * 100;
		if( n < versions.length ) intVersion += versions[ n ].toInt();
	}
	return intVersion;
}





public double log80 = Math.log( 80 );

public static int getChunkLength( int quantity ) {
	return Math.max( 1, Math.ceil( Math.log( quantity ) / log80 ) );
}





public static String encode( int value, int chunkLength ) {
	String chunk = "";
	for( int n=1; n <= chunkLength; n++ ) {
		chunk = chr( 48 + ( value mod 80 ) ) + chunk;
		value = Math.floor( value / 80 );
	}
	return chunk;
}





public static int decode( String chunk ) {
	int value = 0;
	for( int n=0; n <= chunk.length; n++ ) {
		value = value * 80 + chunk[ n ] - 48;
	}
	return value;
}
