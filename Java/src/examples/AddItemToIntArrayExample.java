package examples;

superStrict // Skip




int array[] = [ 1, 2, 3, 4, 5 ];
printArray( " Source", array );

removeItemFromIntArray( array, 3 );
removeItemFromIntArray( array, 2 );
addItemToIntArray( array, 8 );
addItemToIntArray( array, 9 );
printArray( " Result", array );

public static void printArray( String prefix, int array[] ) {
	for( int value : array ) {
		prefix += value + ", ";
	}
	print prefix[ ..len( prefix ) - 2 ];
}
