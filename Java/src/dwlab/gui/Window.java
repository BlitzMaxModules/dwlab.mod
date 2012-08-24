/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */


package dwlab.gui;

import dwlab.base.Project;
import dwlab.base.Sys;
import dwlab.controllers.ButtonAction;
import dwlab.controllers.KeyboardKey;
import dwlab.controllers.MouseButton;
import dwlab.controllers.MouseWheelAction;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.layers.World;
import dwlab.shapes.Shape;
import dwlab.shapes.sprites.Camera;
import java.util.HashSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.lwjgl.input.Keyboard;

/**
 * Class for GUI window.
 */
public class Window extends Layer {
	public static Window current;
	public static TextField activeTextField;
	
	public static ButtonAction select = ButtonAction.create( MouseButton.create( 1 ) );
	public static ButtonAction pan = ButtonAction.create( MouseButton.create( 3 ) );
	public static ButtonAction scaleUp = ButtonAction.create( MouseWheelAction.create( 1 ) );
	public static ButtonAction scaleDown = ButtonAction.create( MouseWheelAction.create( -1 ) );

	public static ButtonAction establish = ButtonAction.create( KeyboardKey.create( Keyboard.KEY_RETURN ) );
	public static ButtonAction abort = ButtonAction.create( KeyboardKey.create( Keyboard.KEY_ESCAPE ) );

	public static ButtonAction moveCursorLeft = ButtonAction.create( KeyboardKey.create( Keyboard.KEY_LEFT ) );
	public static ButtonAction moveCursorRight = ButtonAction.create( KeyboardKey.create( Keyboard.KEY_RIGHT ) );
	public static ButtonAction deletePreviousCharacter = ButtonAction.create( KeyboardKey.create( Keyboard.KEY_BACK ) );
	public static ButtonAction deleteNextCharacter = ButtonAction.create( KeyboardKey.create( Keyboard.KEY_DELETE ) );

	public World world;
	public GUIProject project;
	public HashSet mouseOver = new HashSet();
	public boolean modal;


	@Override
	public void draw() {
		if( ! visible ) return;
		if( modal ) Camera.current.darken( 0.6 );
		current = this;
		super.draw();
	}


	@Override
	public void act() {
		if( !active ) return;

		current = this;

		for( Shape shape: children ) {
			Gadget gadget = (Gadget) shape;
			if( gadget == null || !gadget.active ) continue;

			if( gadget.collidesWithSprite( Project.cursor ) ) {
				if( !mouseOver.contains( gadget ) ) {
					onMouseOver( gadget );
					gadget.onMouseOver();
					mouseOver.add( gadget );
				}

				for( ButtonAction buttonAction: Project.controllers ) {
					if( buttonAction.wasPressed() ) {
						onButtonPress( gadget, buttonAction );
						gadget.onButtonPress( buttonAction );
					}
					if( buttonAction.wasUnpressed() ) {
						onButtonUnpress( gadget, buttonAction );
						gadget.onButtonUnpress( buttonAction );
					}
					if( buttonAction.isDown() ) {
						onButtonDown( gadget, buttonAction );
						gadget.onButtonDown( buttonAction );
					} else {
						onButtonUp( gadget, buttonAction );
						gadget.onButtonUp( buttonAction );
					}
				}
			} else if( mouseOver.contains( gadget ) ) {
				gadget.onMouseOut();
				onMouseOut( gadget );
				mouseOver.remove( gadget );
			}
		}

		if( establish.wasPressed() ) {
			for( Shape shape: children ) {
				Gadget gadget = (Gadget) shape;
				if( gadget.getParameter( "action" ).substring( 0, 4 ).equals( "save" ) ) {
					onButtonPress( gadget, select );
					onButtonUnpress( gadget, select );
				}
			}
		} else if( abort.wasPressed() ) {
			for( Shape shape: children ) {
				Gadget gadget = (Gadget) shape;
				if( gadget.getParameter( "action" ).equals( "close" ) ) {
					onButtonPress( gadget, select );
					onButtonUnpress( gadget, select );
				}
			}
		}

		if( activeTextField != null ) {
			if( activeTextField.active ) {
				String leftPart = activeTextField.leftPart;
				String rightPart = activeTextField.rightPart;
				if( !leftPart.isEmpty() ) {
					if( moveCursorLeft.wasPressed() ) {
						activeTextField.rightPart = leftPart.substring( leftPart.length() - 1) + rightPart;
						activeTextField.leftPart = leftPart.substring( 0, leftPart.length() - 1 );
					}
					if( deletePreviousCharacter.wasPressed() ) activeTextField.leftPart = leftPart.substring( 0, leftPart.length() - 1 );
				}
				if( !rightPart.isEmpty() ) {
					if( moveCursorRight.wasPressed() ) {
						activeTextField.leftPart = leftPart + rightPart.substring( 0, 1 );
						activeTextField.rightPart = rightPart.substring( 1 );
					}
					if( deleteNextCharacter.wasPressed() ) activeTextField.rightPart = rightPart.substring( 1 );
				}
				int key = Sys.getChar();
				if( key >= 32 && ( activeTextField.maxSymbols == 0 || ( activeTextField.leftPart + activeTextField.rightPart ).length() < activeTextField.maxSymbols ) ) {
					activeTextField.leftPart += ( (char) key );
				}
				activeTextField.text = activeTextField.leftPart + activeTextField.rightPart;
			}
		}

		super.act();
	}


	/**
	 * Button pressing event method.
	 * Called when button just being pressed on window's gadget.
	 * 
	 * @see #onButtonUnpress, #onButtonDown, #onButtonUp, #onMouseOver, #onMouseOut
	 */
	public void onButtonPress( Gadget gadget, ButtonAction buttonAction ) {
	}


	/**
	 * Button unpressing event method
	 * Called when button just being unpressed on window's gadget.
	 * Some standard commands are available (can be set in editor in "action" parameter):
	 * <ul><li>"save" - executes window's Save() method. Intended for saving data changed by window.
	 * <lI>"close" - closes the window.
	 * <li>"end" - forces exit from current project.
	 * <li>"window" - opens a window with given name
	 * <li>"window_class" - opens a window of given class
	 * <li>"save_and_close" - performs "save" and "close" actions
	 * <li>"save_and_end" - performs "save" and "end" actions</ul>
	 * 
	 * @see #onButtonPress, #onButtonDown, #onButtonUp, #onMouseOver, #onMouseOut
	 */
	public void onButtonUnpress( Gadget gadget, ButtonAction buttonAction ) {
		String action = gadget.getParameter( "action" );
		if( action.equals( "save" ) ) {
			save();
		} else if( action.equals( "save_and_close" ) ) {
			save();
			onClose();
			project.closeWindow( this );
		} else if( action.equals( "close" ) ) {
			onClose();
			project.closeWindow( this );
		} else if( action.equals( "save_and_end" ) ) {
			save();
			onClose();
			project.exiting = true;
		} else if( action.equals( "end" ) ) {
			onClose();
			project.exiting = true;
		}

		String name = gadget.getParameter( "window" );
		if( !name.isEmpty() ) {
			project.loadWindow( world, null, name, false ) ;
		} else if( parameterExists( "window_class" ) ) {
			try {
				project.loadWindow( world, Class.forName( gadget.getParameter( "window_class" ) ), null, false );
			} catch ( ClassNotFoundException ex ) {
				Logger.getLogger( Window.class.getName() ).log( Level.SEVERE, null, ex );
			}
		}
	}


	/**
	 * Button down event method.
	 * Called when button is currently pressed and cursor is over window's gadget.
	 * 
	 * @see #onButtonPress, #onButtonUnpress, #onButtonUp, #onMouseOver, #onMouseOut
	 */
	public void onButtonDown( Gadget gadget, ButtonAction buttonAction ) {
	}


	/**
	 * Button up event method.
	 * Called when button is currently released and cursor is over window's gadget.
	 * 
	 * @see #onButtonPress, #onButtonUnpress, #onButtonUp, #onMouseOver, #onMouseOut
	 */
	public void onButtonUp( Gadget gadget, ButtonAction buttonAction ) {
	}


	/**
	 * Mouse cursor entering gadget event method.
	 * Called when mouse is just entered window's gadget area.
	 * 
	 * @see #onButtonPress, #onButtonUnpress, #onButtonDown, #onButtonUp, #onMouseOut
	 */
	public void onMouseOver( Gadget gadget ) {
	}


	/**
	 * Mouse cursor leaving gadget event method.
	 * Called when mouse is just left window's gadget area.
	 * 
	 * @see #onButtonPress, #onButtonUnpress, #onButtonDown, #onButtonUp, #onMouseOver
	 */
	public void onMouseOut( Gadget gadget ) {
	}


	/**
	 * Window closing event method.
	 * Called when window is closed.
	 */
	public void onClose() {
	}


	/**
	 * Window data saving method.
	 * Can be executed via window gadget using standard command.
	 * Usually being executed before closing of the window.
	 * 
	 * @see #onButtonUnpress
	 */
	public void save() {
	}
}
