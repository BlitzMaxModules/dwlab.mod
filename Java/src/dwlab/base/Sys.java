package dwlab.base;

import dwlab.controllers.*;
import dwlab.controllers.Pushable.State;
import java.util.LinkedList;
import org.lwjgl.input.Keyboard;
import org.lwjgl.input.Mouse;
import org.lwjgl.opengl.Display;

public class Sys extends SysTemplate {
	private static LinkedList<Integer> keys = new LinkedList<Integer>();
	
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
		return Mouse.getY();
	}

	public static void processEvents( Project project ) {
		while ( Keyboard.next() ) {
			for( ButtonAction controller: Project.controllers ) {
				for( Pushable pushable : controller.buttonList ) {
					pushable.processKeyboardEvent();
					project.onKeyboardEvent();
					if( Keyboard.getEventKeyState() ) keys.add( Keyboard.getEventKey() );
				}
			}
		}
		
		while ( Mouse.next() ) {
			for( ButtonAction controller: Project.controllers ) {
				for( Pushable pushable : controller.buttonList ) {
					pushable.processMouseEvent();
					project.onMouseEvent();
				}
			}
		}
		
		if( Display.isCloseRequested() ) project.onCloseButton();
	}
	

	public static void processKeyboardKeyEvent( KeyboardKey key ) {
		if( Keyboard.getEventKey() == key.code ) {
			if( Keyboard.getEventKeyState() ) {
				key.state = State.JUST_PRESSED;
			} else {
				key.state = State.JUST_UNPRESSED;
			}
		}
	}

	public static void processMouseButtonEvent( MouseButton button ) {
		if( Mouse.getEventButton() == button.num ) {
			if( Mouse.getEventButtonState() ) {
				button.state = State.JUST_PRESSED;
			} else {
				button.state = State.JUST_UNPRESSED;
			}
		}
	}

	public static void processMouseWheelEvent( MouseWheel wheel ) {
		int dWheel =Mouse.getEventDWheel();
		if( dWheel != 0 ) {
			if( wheel.direction == dWheel ) wheel.state = State.JUST_PRESSED;
		}
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
