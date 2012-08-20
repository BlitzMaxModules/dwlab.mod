package dwlab.controllers;
import dwlab.base.Obj;
import dwlab.base.XMLObject;
import java.util.LinkedList;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

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



	public String getButtonNames( int withBrackets = false ) {
		String names = "";
		for( Pushable button: buttonList ) {
			if( names ) names += ", ";
			if( withBrackets ) {
				names += "{{" + button.getName() + "}}";
			} else {
				names += button.getName();
			}
		}
		return names;
	}



	/**
	 * Creates button action with given pushable object (button) and name (optional).
	 * @return New button action with one pushable object (button).
	 */
	public static ButtonAction create( Pushable button, String name = "" ) {
		ButtonAction buttonAction = new ButtonAction();
		buttonAction.name = name;
		buttonAction.buttonList.addLast( button );
		return buttonAction;
	}



	/**
	 * Adds given pushable object (button) to the button action button list.
	 */
	public void addButton( Pushable button ) {
		for( Pushable oldButton: buttonList ) {
			if( oldButton.isEqualTo( button ) ) return;
		}
		buttonList.addLast( button );
		if( maxButtons > 0 then if buttonList.count() > maxButtons ) buttonList.removeFirst();
	}




	public int define() {
		for( int code=1; code <= 255; code++ ) {
			if( keyHit( code ) ) {
				addButton( KeyboardKey.create( code ) );
				return true;
			}
		}

		for( int num=1; num <= 3; num++ ) {
			if( mouseHit( num ) ) {
				addButton( lTMouseButton.create( num ) );
				return true;
			}
		}

		if( mouseZ() ) {
			addButton( MouseWheelAction.create( sgn( mouseZ() ) ) );
			flushMouse();
			return true;
		}
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
	public int isDown() {
		for( Pushable button: buttonList ) {
			if( button.isDown() ) return true;
		}
	}



	/**
	 * Function which checks button action just-pressing state.
	 * @return True if one of pushable objects (buttons) of this action was pressed in current project cycle.
	 */
	public int wasPressed() {
		for( Pushable button: buttonList ) {
			if( button.wasPressed() ) return true;
		}
	}



	/**
	 * Function which checks button action just-unpressing state.
	 * @return True if one of pushable objects (buttons) of this action was unpressed in current project cycle.
	 */	
	public int wasUnpressed() {
		for( Pushable button: buttonList ) {
			if( button.wasUnpressed() ) return true;
		}
	}



	public static ButtonAction indexOf( LinkedList keySet, String name ) {
		for( ButtonAction buttonAction: keySet ) {
			if( buttonAction.name == name ) return buttonAction;
		}
	}



	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		xMLObject.manageStringAttribute( "name", name );
		xMLObject.manageChildList( buttonList );
	}
}
