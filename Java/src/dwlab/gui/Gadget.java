/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.gui;
import dwlab.controllers.ButtonAction;
import dwlab.controllers.KeyboardKey;
import dwlab.controllers.MouseButton;
import dwlab.controllers.MouseWheelAction;
import dwlab.sprites.Sprite;
import org.lwjgl.input.Keyboard;

/**
 * Class for GUI gagdet for placing on window.
 */
public class Gadget extends Sprite {
	public static double defaultTextSize = 0.5d;
	
	public static ButtonAction select = new ButtonAction( MouseButton.create( 1 ) );
	public static ButtonAction pan = new ButtonAction( MouseButton.create( 3 ) );
	public static ButtonAction scaleUp = new ButtonAction( MouseWheelAction.create( 1 ) );
	public static ButtonAction scaleDown = new ButtonAction( MouseWheelAction.create( -1 ) );

	public static ButtonAction establish = new ButtonAction( KeyboardKey.create( Keyboard.KEY_RETURN ) );
	public static ButtonAction abort = new ButtonAction( KeyboardKey.create( Keyboard.KEY_ESCAPE ) );

	public static ButtonAction moveCursorLeft = new ButtonAction( KeyboardKey.create( Keyboard.KEY_LEFT ) );
	public static ButtonAction moveCursorRight = new ButtonAction( KeyboardKey.create( Keyboard.KEY_RIGHT ) );
	public static ButtonAction deletePreviousCharacter = new ButtonAction( KeyboardKey.create( Keyboard.KEY_BACK ) );
	public static ButtonAction deleteNextCharacter = new ButtonAction( KeyboardKey.create( Keyboard.KEY_DELETE ) );

	public enum Orientaion {
		HORIZONTAL,
		VERTICAL
	}
	
	public double textSize = defaultTextSize;
	

	/**
	 * Gadget initialization method.
	 * Called after loading window with this gadget.
	 */
	@Override
	public void init() {
		if( parameterExists( "text_size" ) ) textSize = getDoubleParameter( "text_size" );
	}


	/**
	 * Button pressing event method.
	 * Called when button just being pressed on the gadget.
	 * 
	 * @see #onButtonUnpress, #onButtonDown, #onButtonUp, #onMouseOver, #onMouseOut
	 */
	public void onButtonPress( ButtonAction buttonAction ) {
	}


	/**
	 * Button unpressing event method
	 * Called when button just being unpressed on gadget.
	 * 
	 * @see #onButtonPress, #onButtonDown, #onButtonUp, #onMouseOver, #onMouseOut
	 */
	public void onButtonUnpress( ButtonAction buttonAction ) {
	}


	/**
	 * Button down event method.
	 * Called when button is currently pressed and cursor is over gadget.
	 * 
	 * @see #onButtonPress, #onButtonUnpress, #onButtonUp, #onMouseOver, #onMouseOut
	 */	
	public void onButtonDown( ButtonAction buttonAction ) {
	}


	/**
	 * Button up event method.
	 * Called when button is currently released and cursor is over gadget.
	 * 
	 * @see #onButtonPress, #onButtonUnpress, #onButtonUp, #onMouseOver, #onMouseOut
	 */	
	public void onButtonUp( ButtonAction buttonAction ) {
	}


	/**
	 * Mouse cursor entering gadget event method.
	 * Called when mouse is just entered gadget area.
	 * 
	 * @see #onButtonPress, #onButtonUnpress, #onButtonDown, #onButtonUp, #onMouseOut
	 */
	public void onMouseOver() {
	}


	/**
	 * Mouse cursor leaving gadget event method.
	 * Called when mouse is just left gadget area.
	 * 
	 * @see #onButtonPress, #onButtonUnpress, #onButtonDown, #onButtonUp, #onMouseOver
	 */
	public void onMouseOut() {
	}
}
