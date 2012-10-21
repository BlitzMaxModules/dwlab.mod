package examples;

import dwlab.base.Service;


public class AddItemToIntArrayExample {
	public static void main(String[] argv) {
		int[] array = { 1, 2, 3, 4, 5 };
		printArray( "Source ", array );
		array = Service.removeItemFrom( array, 3 );
		array = Service.removeItemFrom( array, 2 );
		array = Service.addItemTo( array, 8 );
		array = Service.addItemTo( array, 9 );
		printArray( "Result ", array );
	}

	public static void printArray( String prefix, int[] array ) {
		for( int value : array ) {
			prefix += value + ", ";
		}
		System.out.println( prefix.substring( 0, prefix.length() ) );
	}
}
