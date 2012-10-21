package examples;

public class MTG {
	private enum Mana {
		WHITE,
		BLACK,
		RED,
		GREEN,
		BLUE
	}
	
	private static int totalCards = 0;
	
	private static Card[] cards = {
		new Card( true, 25 ), 
		new Card( false, 35 ), 
	};

	private static class Card {
		int quantity;
		boolean isLand;
		
		private Card( boolean isLand, int quantity ) {
			this.isLand = isLand;
			this.quantity = quantity;
		}
	}
	
	private static int[] array = new int[ cards.length ];
	
	public static void main(String[] argv) {
		System.out.println( "Total cards: " + totalCards );
		array[ 0 ] = 7;
		while( checkCombinations() );
		//System.out.println( "Total combinations: " + totalCombinations );
		//System.out.println( "Bad combinations: " + ( 100f * combinations / totalCombinations ) + "%" );
		//System.out.println( "All-suit combinations: " + ( 100f * combinations / totalCombinations ) + "%" );
	}

	private static long totalCombinations = 0;
	
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
	}
}
