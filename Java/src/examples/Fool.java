package examples;

public class Fool {
	private enum Suit {
		HEARTS,
		DIAMONDS,
		CLUBS,
		SPADES
	}
	
	private static int totalCards = 0;

	private static class Card {
		Suit suit;
		int quantity;

		private Card( Suit suit, int quantity ) {
			this.suit = suit;
			this.quantity = quantity;
			totalCards += quantity;
		}
	}
	
	private static Card[] cards = {
		new Card( Suit.CLUBS, 9 ), 
		new Card( Suit.DIAMONDS, 9 ), 
		new Card( Suit.HEARTS, 9 ), 
		new Card( Suit.SPADES, 9 ), 
	};
	
	private static int[] array = new int[ cards.length ];
	
	public static void main(String[] argv) {
		System.out.println( "Total cards: " + totalCards );
		array[ 0 ] = 6;
		while( checkCombinations() );
	}
	
	private static boolean checkCombinations() {
		processCombination();

		for( int n = 1; n < cards.length; n++ ) {
			if( array[ n - 1 ] > 0 ) {
				array[ n - 1 ]--;
				array[ n ]++;
				return true;
			} else if( n + 1 < cards.length && array[ n ] > 0 ) {
				array[ 0 ] = array[ n ] - 1;
				array[ n ] = 0;
				array[ n + 1 ]++;
				return true;
			}
		}
		return false;
	}

	private static void processCombination() {
		String string = "";
		for( int n : array ) string += ", " + n;
		System.out.println( string.substring( 2 ) );
	}
}
