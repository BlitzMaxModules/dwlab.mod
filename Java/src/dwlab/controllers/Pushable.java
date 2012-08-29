/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.controllers;

import dwlab.base.Obj;

/**
 * Common class for keys, buttons and mouse wheel rolls.
 */
public abstract class Pushable extends Obj {
	public enum State {
		JUST_PRESSED,
		PRESSED,
		JUST_UNPRESSED,
		UNPRESSED
	}

	public enum Modifiers {
		NO,
		SHIFT,
		CONTROL,
		CONTROL_SHIFT,
		CONTROL_ALT,
		ALT,
		ALT_SHIFT
	}

	public State state = State.UNPRESSED;


	/**
	 * Name of pushable object.
	 * @return Name of object.
	 * You can use LocalizeString to get name in current language.
	 */
	public String getName() {
		return "";
	}

	
	KeyboardKey getKeyboardKey() {
		return null;
	}

	
	MouseButton getMouseButton() {
		return null;
	}

	
	MouseWheel getMouseWheel() {
		return null;
	}
	

	public void processKeyboardEvent() {
		
	}
	
	public void processMouseEvent() {
		
	}


	public void reset() {
		switch( state ) {
			case JUST_PRESSED:
				state = State.PRESSED;
			case JUST_UNPRESSED:
				state = State.UNPRESSED;
		}
	}


	/**
	 * Function which checks is the object pressed.
	 * @return True if pushable object is currently pressed.
	 */
	public boolean isDown() {
		return state == State.JUST_PRESSED || state == State.PRESSED;
	}


	public boolean isEqualTo( Pushable pushable ) {
		return false;
	}


	/**
	 * Function which checks was the object pressed.
	 * @return True if pushable object was presed during this project cycle.
	 */
	public boolean wasPressed() {
		return state == State.JUST_PRESSED;
	}


	/**
	 * Function which checks was the object unpressed.
	 * @return True if pushable object was unpresed during this project cycle.
	 */
	public boolean wasUnpressed() {
		return state == State.JUST_UNPRESSED;
	}
}
