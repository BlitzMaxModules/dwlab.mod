package examples;

public class Fool2 {
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
		new Card( Suit.CLUBS, 4 ), 
		new Card( Suit.DIAMONDS, 4 ), 
		new Card( Suit.HEARTS, 4 ), 
		new Card( Suit.SPADES, 4 ), 
	};
	
	private static int[] array = new int[ cards.length ];
	
	private static int totalCombinations = 0;
	
	public static void main(String[] argv) {
		System.out.println( "Total cards: " + totalCards );
		array[ 0 ] = 4;
		array[ 1 ] = 2;
		while( checkCombinations() );
		System.out.println( "Total combinations: " + totalCombinations );
	}

	private static int combinationWeight;
	
	private static boolean checkCombinations() {
		combinationWeight = 1;
		for( int n = 0; n < cards.length; n++ ) {
			for( int m = cards[ n ].quantity; m > cards[ n ].quantity - array[ n ]; m-- ) combinationWeight *= m;
		}
		
		processCombination();
		totalCombinations += combinationWeight;
		for( int n = 1; n < cards.length; n++ ) {
			if( array[ n - 1 ] > 0 && array[ n ] < cards[ n ].quantity ) {
				array[ n - 1 ]--;
				array[ n ]++;
				return true;
			} else if( n + 1 < cards.length && array[ n ] > 0 && array[ n + 1 ] < cards[ n + 1 ].quantity ) {
				int sum = array[ n ] - 1;
				array[ n ] = 0;
				for( int m = 0; m < cards.length; m++ ) {
					if( array[ m ] + sum <= cards[ m ].quantity ) {
						array[ m ] += sum;
						break;
					} else {
						sum -= cards[ m ].quantity - array[ m ];
						array[ m ] = cards[ m ].quantity;
						if( sum == 0 ) break;
					}
				}
				array[ n + 1 ]++;
				return true;
			}
		}
		return false;
	}

	private static void processCombination() {
		String string = "";
		for( int n : array ) string += ", " + n;
		System.out.println( string.substring( 2 ) + ": " + combinationWeight );
	}
}
