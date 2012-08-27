package dwlab.base;

import dwlab.controllers.ButtonAction;
import dwlab.controllers.Pushable;
import org.lwjgl.input.Keyboard;
import org.lwjgl.input.Mouse;

public class Sys extends SysTemplate {
	public static void flushControllers() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static void flushKeys() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	public static void flushMouse() {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static boolean keyHit( int code ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	public static int getChar() {
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

	static void processEvents( Project project ) {
		Event ev =Event.;
		
		while ( Keyboard.next() ) {
			for( ButtonAction controller: controllers ) {
				for( Pushable pushable : controller.buttonList ) {
					pushable.processKeyboardEvent();
					project.onKeyboardEvent();
				}
			}
		}
		
		while ( Mouse.next() ) {
			for( ButtonAction controller: controllers ) {
				for( Pushable pushable : controller.buttonList ) {
					pushable.processEvent();
				}
			}
		}
		while( true ) {
			switch( eventID() ) {
				case event_WindowClose:
					onCloseButton();
				case event_WindowSize:
					onWindowResize();
				case 0:
					exit;
			}
		}
	}
}
