/**
 * Digital Wizard's Lab - game development framework
 * Copyright (C) 2010, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http//www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.controllers;

import dwlab.base.Project;
import dwlab.base.XMLObject;
import org.lwjgl.input.Mouse;

/**
 * Class for mouse buttons.
 */
public class MouseButton extends Pushable {
	public static final int LEFT_BUTTON = 0;
	public static final int RIGHT_BUTTON = 1;
	public static final int MIDDLE_BUTTON = 2;

	public int num;
	

	/**
	 * Creates mouse button object.
	 * @return New object of mouse button with given number.
	 */	
	public static MouseButton create( int num ) {
		if( num < LEFT_BUTTON || num > MIDDLE_BUTTON ) error( "Invalid mouse button number" );

		MouseButton button = new MouseButton();
		button.num = num;

		for( ButtonAction action: Project.controllers ) {
			for( Pushable pushable: action.buttonList ) {
				if( pushable.isEqualTo( button ) ) return button;
			}
		}
		
		return button;
	}


	@Override
	public String getName() {
		switch( num ) {
			case LEFT_BUTTON:
				return "Left mouse button";
			case RIGHT_BUTTON:
				return "Right mouse button";
			case MIDDLE_BUTTON:
				return "Middle mouse button";
			default:
				return "";
		}
	}

	
	@Override
	MouseButton getMouseButton() {
		return this;
	}


	@Override
	public boolean isEqualTo( Pushable pushable ) {
		MouseButton button = pushable.getMouseButton();
		if( button != null ) return num == button.num;
		return false;
	}


	@Override
	public void processMouseEvent() {
		if( Mouse.getEventButton() == num ) {
			if( Mouse.getEventButtonState() ) {
				state = State.JUST_PRESSED;
			} else {
				state = State.JUST_UNPRESSED;
			}
		}
	}


	@Override
	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		xMLObject.manageIntAttribute( "num", num );
	}
}
