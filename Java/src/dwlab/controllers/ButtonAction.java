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
import dwlab.base.Project;
import dwlab.base.Sys;
import dwlab.base.XMLObject;
import java.util.LinkedList;
import org.lwjgl.input.Mouse;

/**
 * Class for action which can be triggered by activating pushable object (presing a key, mouse button, etc).
 * Key can be binded to several actions and several keys can be binded to one action.
 */	
public class ButtonAction extends Obj {
	public String name;
	public LinkedList<Pushable> buttonList = new LinkedList();

	/**
	 * Maximum quantity of buttons in button list (0 means unlimited).
	 */	
	public int maxButtons = 3;


	/**
	 * Creates button action with given pushable object (button) and name (optional).
	 * @return New button action with one pushable object (button).
	 */
	public static ButtonAction create( Pushable button, String name ) {
		ButtonAction action = new ButtonAction();
		action.name = name;
		action.buttonList.addLast( button );
		Project.controllers.add( action );
		return action;
	}
	
	public static ButtonAction create( Pushable button ) {
		ButtonAction action = new ButtonAction();
		action.buttonList.addLast( button );
		Project.controllers.add( action );
		return action;
	}


	public String getButtonNames( boolean withBrackets ) {
		String names = "";
		for( Pushable button: buttonList ) {
			if( !names.isEmpty() ) names += ", ";
			if( withBrackets ) {
				names += "{{" + button.getName() + "}}";
			} else {
				names += button.getName();
			}
		}
		return names;
	}
	
	public String getButtonNames() {
		return getButtonNames( false );
	}


	/**
	 * Adds given pushable object (button) to the button action button list.
	 */
	public void addButton( Pushable button ) {
		for( Pushable oldButton: buttonList ) {
			if( oldButton.isEqualTo( button ) ) return;
		}
		buttonList.addLast( button );
		if( maxButtons > 0 ) if( buttonList.size() > maxButtons ) buttonList.removeFirst();
	}


	public boolean define() {
		for( int code=1; code <= 255; code++ ) {
			if( Sys.keyHit( code ) ) {
				addButton( KeyboardKey.create( code ) );
				return true;
			}
		}

		for( int num=1; num <= 3; num++ ) {
			if( Mouse.isButtonDown( num ) ) {
				addButton( MouseButton.create( num ) );
				return true;
			}
		}

		int dWheel = Mouse.getDWheel();
		if( dWheel != 0 ) {
			addButton( MouseWheelAction.create( dWheel ) );
			Sys.flushMouse();
			return true;
		}
		
		return false;
	}



	/**
	 * Removes all pushable objects (buttons) of the button action.
	 */
	public void clear() {
		buttonList.clear();
	}



	/**
	 * Function which checks button action pressing state.
	 * @return True if one of pushable objects (buttons) of this action is currently pressed.
	 */
	public boolean isDown() {
		for( Pushable button: buttonList ) {
			if( button.isDown() ) return true;
		}
		return false;
	}



	/**
	 * Function which checks button action just-pressing state.
	 * @return True if one of pushable objects (buttons) of this action was pressed in current project cycle.
	 */
	public boolean wasPressed() {
		for( Pushable button: buttonList ) {
			if( button.wasPressed() ) return true;
		}
		return false;
	}



	/**
	 * Function which checks button action just-unpressing state.
	 * @return True if one of pushable objects (buttons) of this action was unpressed in current project cycle.
	 */	
	public boolean wasUnpressed() {
		for( Pushable button: buttonList ) {
			if( button.wasUnpressed() ) return true;
		}
		return false;
	}



	@Override
	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		name = xMLObject.manageStringAttribute( "name", name );
		xMLObject.manageChildList( buttonList );
		if( Sys.xMLGetMode() ) Project.controllers.add( this );
	}
}
