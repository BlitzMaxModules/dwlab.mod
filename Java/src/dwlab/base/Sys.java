package dwlab.base;

public class Sys {
	public static String version = "1.4.24";
	
	public enum XMLMode {
		GET,
		SET
	}
	
	public static XMLMode xMLMode;

	public static boolean xMLGetMode() {
		return xMLMode == XMLMode.GET;
	}

	public static boolean xMLSetMode() {
		return xMLMode == XMLMode.SET;
	}

	public static void flushControllers() {
		throw new UnsupportedOperationException( "Not yet implemented" );

	public static void flushKeys() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	}
	
	public static void flushMouse() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static boolean keyHit( int code ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static boolean mouseHit( int num ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	public static int mouseX() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	public static int mouseY() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static int mouseZ() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
}
