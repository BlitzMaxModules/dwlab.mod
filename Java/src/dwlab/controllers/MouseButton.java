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
import dwlab.base.Sys;
import dwlab.base.XMLObject;

/**
 * Class for mouse buttons.
 */
public class MouseButton extends Pushable {
	private int num;


	/**
	 * Creates mouse button object.
	 * @return New object of mouse button with given number.
	 */	
	public static MouseButton create( int num ) {
		if( num <= 0 || num > 3 ) error( "Invalid mouse button number" );

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
			case 1:
				return "Left mouse button";
			case 2:
				return "Right mouse button";
			case 3:
				return "Middle mouse button";
			default:
				return "";
		}
	}


	@Override
	public boolean isEqualTo( Pushable pushable ) {
		MouseButton button = (MouseButton) pushable;
		if( button != null ) return num == button.num;
		return false;
	}


	@Override
	public void processEvent() {
		/*if( eventData() != num ) return;
		switch( eventID() ) {
			case event_MouseDown:
				state = justPressed;
			case event_MouseUp:
				state = justUnpressed;
		}*/
	}


	@Override
	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		xMLObject.manageIntAttribute( "num", num );
	}
}
