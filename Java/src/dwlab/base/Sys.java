package dwlab.base;

import dwlab.controllers.ButtonAction;
import dwlab.controllers.KeyboardKey;
import dwlab.controllers.MouseButton;
import dwlab.controllers.MouseWheel;
import java.util.LinkedList;
import org.lwjgl.input.Keyboard;
import org.lwjgl.input.Mouse;

public class Sys {
	static LinkedList<Integer> keys = new LinkedList<Integer>();
	
	public static String version = "1.4.24";
	
	public static final boolean debug = true;
	
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
		flushKeyboard();
		flushMouse();
	}

	public static void flushKeyboard() {
		while ( Keyboard.next() ) {}
	}
	
	public static void flushMouse() {
		while ( Mouse.next() ) {}
	}

	public static int getChar() {
		if( keys.isEmpty() ) return 0;
		int code = keys.getFirst();
		keys.removeFirst();
		return code;
	}

	public static boolean mouseHit( int num ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	public static int mouseX() {
		return Mouse.getX();
	}
	
	public static int mouseY() {
		return Graphics.getScreenHeight() - Mouse.getY();
	}

	public static boolean getPushable( ButtonAction action ) {
		while ( Keyboard.next() ) {
			if( Keyboard.getEventKeyState() ) {
				action.addButton( KeyboardKey.create( Keyboard.getEventKey() ) );
				return true;
			}
		}
		
		while ( Mouse.next() ) {
			if( Mouse.getEventButtonState() ) {
				action.addButton( MouseButton.create( Mouse.getEventButton() ) );
				return true;
			}
			
			int dWheel = Mouse.getEventDWheel();
			if( dWheel !=0 ) {
				action.addButton( MouseWheel.create( dWheel ) );
				return true;
			}
		}
		
		return false;
	}
}
