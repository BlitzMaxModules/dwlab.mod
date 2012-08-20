/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.base;

/**
 * Class for implementing dragging operations.
 * See also #lTRasterFrame example, #lTAction example
 */
public class Drag extends Obj {
	/**
	 * Dragging state: True if this dragging operation is currently active, False otherwise.
	 */
	public boolean draggingState;



	/**
	 * Method which should return True if drag key (or other similar controller) is down.
	 * @return True is dragging key is down.
	 * Usually you should fill it with single line checking if dragging key is down.
	 */
	public boolean dragKey() {
		return false;
	}



	/**
	 * Method which should return True if all dragging conditions are met.
	 * @return True if all dragging conditions are met.
	 * Fill it with conditions.
	 */
	public boolean draggingConditions() {
		return true;
	}



	/**
	 * Dragging starting method.
	 * Will be executed once when all dragging conditions are met and dragging key has been pressed.
	 * Fill it with dragging system initialization commands.
	 */
	public void startDragging() {
	}



	/**
	 * Dragging method.
	 * Will be executed persistently during dragging process.
	 * Fill it with commands which will accompany dragging process.
	 */
	public void dragging() {
	}



	/**
	 * Dragging ending method
	 * Will be executed when dragging key will be released during dragging.
	 * Fill it with dragging operation finalization commands.
	 */
	public void endDragging() {
	}



	/**
	 * Dragging system executing method.
	 * Execute it persistently in your project Logic method or some object's Act() method.
	 */
	@Override
	public void act() {
		if( !draggingState ) {
			if( dragKey() ) {
				if( draggingConditions() ) {
					draggingState = true;
					startDragging();
				}
			}
		} else {
			if( dragKey() ) {
				dragging();
			} else {
				draggingState = false;
				endDragging();
			}
		}
	}
}
