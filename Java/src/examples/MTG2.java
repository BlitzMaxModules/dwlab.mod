package examples;

public class MTG2 {
	private enum Mana {
		WHITE,
		BLACK,
		RED,
		GREEN,
		BLUE
	}
	
	private static int totalCards = 0;
	private static Card[] cards = {
		new Card( Mana.RED, 1, 11 ), 
		new Card( Mana.RED, 2, 6 ), 
		new Card( Mana.RED, 3, 5 ), 
		new Card( Mana.RED, 4, 9 ),
		new Card( Mana.RED, 5, 3 ),
		new Card( Mana.RED, 6, 1 ),
		new Card( Mana.RED, 7, 2 )
	};

	private static class Card {
		int quantity;
		Mana mana;
		boolean isLand;
		int colorManaPrice;
		int colorlessManaPrice;

		private Card( Mana mana, int i, int i0 ) {
			throw new UnsupportedOperationException( "Not yet implemented" );
		}
	}
}
