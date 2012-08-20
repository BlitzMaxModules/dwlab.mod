package dwlab.gui;
import java.util.HashMap;
import dwlab.controllers.ButtonAction;
import dwlab.layers.Layer;
import dwlab.layers.World;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php


/**
 * Class for GUI window.
 */
public class Window extends Layer {
	public World world;
	public GUIProject project;
	public HashMap mouseOver = new HashMap();
	public int modal;



	public void draw() {
		if( ! visible ) return;
		if( modal ) Camera.current.darken( 0.6 );
		window = this;
		super.draw();
	}



	public void act() {
		if( ! active ) return;

		window = this;

		for( Gadget gadget: children ) {
			if( ! gadget.active ) continue;

			if( gadget.collidesWithSprite( cursor ) ) {
				if( ! mouseOver.contains( gadget ) ) {
					onMouseOver( gadget );
					gadget.onMouseOver();
					mouseOver.put( gadget, null );
				}

				for( ButtonAction buttonAction: gUIButtons ) {
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
			} else if( mouseOver.contains( gadget ) then ) {
				gadget.onMouseOut();
				onMouseOut( gadget );
				mouseOver.remove( gadget );
			}
		}

		if( enter.wasPressed() ) {
			for( Gadget gadget: children ) {
				if( gadget.getParameter( "action" )[ ..4 ].equals( save ) ) {
					onButtonPress( gadget, leftMouseButton );
					onButtonUnpress( gadget, leftMouseButton );
				}
			}
		} else if( esc.wasPressed() then ) {
			for( Gadget gadget: children ) {
				if( gadget.getParameter( "action" ).equals( close ) ) {
					onButtonPress( gadget, leftMouseButton );
					onButtonUnpress( gadget, leftMouseButton );
				}
			}
		}

		if( activeTextField ) {
			if( activeTextField.active ) {
				String leftPart = activeTextField.leftPart;
				String rightPart = activeTextField.rightPart;
				if( leftPart ) {
					if( characterLeft.wasPressed() ) {
						activeTextField.rightPart = leftPart[ leftPart.length - 1.. ] + rightPart;
						activeTextField.leftPart = leftPart[ ..leftPart.length - 1 ];
					}
					if( deletePreviousCharacter.wasPressed() ) activeTextField.leftPart == leftPart[ ..leftPart.length - 1 ];
				}
				if( rightPart ) {
					if( characterRight.wasPressed() ) {
						activeTextField.leftPart = leftPart + rightPart[ ..1 ];
						activeTextField.rightPart = rightPart[ 1.. ];
					}
					if( deleteNextCharacter.wasPressed() ) activeTextField.rightPart == rightPart[ 1.. ];
				}
				int key = getChar();
				if( key >= 32 && ( activeTextField.maxSymbols == 0 || len( activeTextField.leftPart + activeTextField.rightPart ) < activeTextField.maxSymbols ) ) {
					activeTextField.leftPart += chr( key );
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
		tLink link = project.windows.findLink( this );
		switch( gadget.getParameter( "action" ) ) {
			case "save":
				save();
			case "save_and_close":
				save();
				onClose();
				if( link ) project.closeWindow( Window( link.value() ) );
			case "close":
				onClose();
				if( link ) project.closeWindow( Window( link.value() ) );
			case "save_and_end":
				save();
				onClose();
				project.exiting = true;
			case "end":
				onClose();
				project.exiting = true;
		}

		String name = gadget.getParameter( "window" );
		if( name ) {
			project.loadWindow( world, , name ) ;
		} else {
			String class = gadget.getParameter( "window_class" );
			if( class ) project.loadWindow( world, class ) ;
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



	public void deInit() {
	}
}
