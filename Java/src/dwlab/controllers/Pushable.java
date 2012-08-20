package dwlab.controllers;
import java.util.LinkedList;
import dwlab.base.Obj;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */





public LinkedList controllers = new LinkedList();

/**
 * Common class for keys, buttons and mouse wheel rolls.
 */
public class Pushable extends Obj {
	public final int justPressed = 0;
	public final int pressed = 1;
	public final int justUnpressed = 2;
	public final int unpressed = 3;

	public int state = unpressed;



	/**
	 * Name of pushable object.
	 * @return Name of object.
	 * You can use LocalizeString to get name in current language.
	 */
	public String getName() {
	}



	public void processEvent() {
	}



	public void reset() {
		switch( state ) {
			case justPressed:
				state = pressed;
			case justUnpressed:
				state = unpressed;
		}
	}



	/**
	 * Function which checks is the object pressed.
	 * @return True if pushable object is currently pressed.
	 */
	public int isDown() {
		return state = justPressed || state = pressed;
	}



	public int isEqualTo( Pushable pushable ) {
	}



	/**
	 * Function which checks was the object pressed.
	 * @return True if pushable object was presed during this project cycle.
	 */
	public int wasPressed() {
		return state = justPressed;
	}



	/**
	 * Function which checks was the object unpressed.
	 * @return True if pushable object was unpresed during this project cycle.
	 */
	public int wasUnpressed() {
		return state = justUnpressed;
	}
}
