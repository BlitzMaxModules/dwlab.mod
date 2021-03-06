/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.controllers;

import dwlab.base.Project;
import dwlab.base.Sys;
import dwlab.base.XMLObject;
import org.lwjgl.input.Mouse;

/**
 * Class for mouse wheel rollings.
 */
public class MouseWheel extends Pushable {
	public int z;
	public int direction;


	@Override
	public String getName() {
		switch( direction ) {
			case -1:
				return "Mouse wheel down";
			case 1:
				return "Mouse wheel up";
			default:
				return "";
		}
	}

	
	@Override
	MouseWheel getMouseWheel() {
		return this;
	}


	@Override
	public boolean isEqualTo( Pushable pushable ) {
		MouseWheel wheel = pushable.getMouseWheel();
		if( wheel != null ) return direction == wheel.direction; else return false;
	}


	@Override
	public void processMouseEvent() {
		int dWheel =Mouse.getEventDWheel();
		if( dWheel != 0 ) {
			if( direction == dWheel ) state = State.JUST_PRESSED;
		}
	}

	/**
	 * Creates mouse wheel roll action object.
	 * @return New object of mouse wheel roll action of given direction.
	 */	
	public static MouseWheel create( int direction ) {
		if( Math.abs( direction ) != 1 ) error( "Invalid mouse wheel direction" );

		MouseWheel wheelAction = new MouseWheel();
		wheelAction.direction = direction;
		
		for( ButtonAction action: Project.controllers ) {
			for( Pushable pushable: action.buttonList ) {
				if( pushable.isEqualTo( wheelAction ) ) return wheelAction;
			}
		}

		return wheelAction;
	}


	@Override
	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		direction = xMLObject.manageIntAttribute( "direction", direction );
	}
}
