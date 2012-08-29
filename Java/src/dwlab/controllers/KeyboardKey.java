/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.controllers;

import dwlab.base.Project;
import dwlab.base.Sys;
import dwlab.base.XMLObject;

/**
 * Class for keyboard keys.
 */
public class KeyboardKey extends Pushable {
	public int code;
	

	@Override
	public String getName() {
		/*
		switch( code ) {
			case kEY_BACKSPACE:
				return "Backspace";
			case kEY_TAB:
				return "Tab";
			case kEY_CLEAR:
			case kEY_ENTER:
				return "Enter";
			case kEY_ESCAPE:
				return "Esc";
			case kEY_SPACE:
				return "Space";
			case kEY_PAGEUP:
				return "Page up";
			case kEY_PAGEDOWN:
				return "Page down";
			case kEY_END:
				return "End";
			case kEY_HOME:
				return "Home";
			case kEY_LEFT:
				return "Left arrow";
			case kEY_UP:
				return "Up arrow";
			case kEY_RIGHT:
				return "Right arrow";
			case kEY_DOWN:
				return "Down arrow";
			case kEY_SELECT:
				return "Select";
			case kEY_PRINT:
				return "Print";
			case kEY_EXECUTE:
				return "Execute";
			case kEY_SCREEN:
				return "Screen";
			case kEY_INSERT:
				return "Insert";
			case kEY_DELETE:
				return "Delete";
			case kEY_0:
				return "0";
			case kEY_1:
				return "1";
			case kEY_2:
				return "2";
			case kEY_3:
				return "3";
			case kEY_4:
				return "4";
			case kEY_5:
				return "5";
			case kEY_6:
				return "6";
			case kEY_7:
				return "7";
			case kEY_8:
				return "8";
			case kEY_9:
				return "9";
			case kEY_A:
				return "A";
			case kEY_B:
				return "B";
			case kEY_C:
				return "C";
			case kEY_D:
				return "D";
			case kEY_E:
				return "E";
			case kEY_F:
				return "F";
			case kEY_G:
				return "G";
			case kEY_H:
				return "H";
			case kEY_I:
				return "I";
			case kEY_J:
				return "J";
			case kEY_K:
				return "K";
			case kEY_L:
				return "L";
			case kEY_M:
				return "M";
			case kEY_N:
				return "N";
			case kEY_O:
				return "O";
			case kEY_P:
				return "P";
			case kEY_Q:
				return "Q";
			case kEY_R:
				return "R";
			case kEY_S:
				return "S";
			case kEY_T:
				return "T";
			case kEY_U:
				return "U";
			case kEY_V:
				return "V";
			case kEY_W:
				return "W";
			case kEY_X:
				return "X";
			case kEY_Y:
				return "Y";
			case kEY_Z:
				return "Z";
			case kEY_NUM0:
				return "Num 0";
			case kEY_NUM1:
				return "Num 1";
			case kEY_NUM2:
				return "Num 2";
			case kEY_NUM3:
				return "Num 3";
			case kEY_NUM4:
				return "Num 4";
			case kEY_NUM5:
				return "Num 5";
			case kEY_NUM6:
				return "Num 6";
			case kEY_NUM7:
				return "Num 7";
			case kEY_NUM8:
				return "Num 8";
			case kEY_NUM9:
				return "Num 9";
			case kEY_NUMMULTIPLY:
				return "Num *";
			case kEY_NUMADD:
				return "Num +";
			case kEY_NUMSUBTRACT:
				return "Num -";
			case kEY_NUMDECIMAL:
				return "Num .";
			case kEY_NUMDIVIDE:
				return "Num /";
			case kEY_F1:
				return "F1";
			case kEY_F2:
				return "F2";
			case kEY_F3:
				return "F3";
			case kEY_F4:
				return "F4";
			case kEY_F5:
				return "F5";
			case kEY_F6:
				return "F6";
			case kEY_F7:
				return "F7";
			case kEY_F8:
				return "F8";
			case kEY_F9:
				return "F9";
			case kEY_F10:
				return "F10";
			case kEY_F11:
				return "F11";
			case kEY_F12:
				return "F12";
			case kEY_TILDE:
				return "~~";
			case kEY_MINUS:
				return "-";
			case kEY_EQUALS:
				return "=";
			case kEY_OPENBRACKET:
				return "[";
			case kEY_CLOSEBRACKET:
				return "]";
			case kEY_BACKSLASH:
				return "\";
			case kEY_SEMICOLON:
				return ";";
			case kEY_QUOTES:
				return "\"";
			case kEY_COMMA:
				return ",";
			case kEY_PERIOD:
				return ".";
			case kEY_SLASH:
				return "/";
			case kEY_LSHIFT:
				return "Left Shift";
			case kEY_RSHIFT:
				return "Right Shift";
			case kEY_LCONTROL:
				return "Left Ctrl";
			case kEY_RCONTROL:
				return "Right Ctrl";
			case kEY_LALT:
				return "Left Alt";
			case kEY_RALT:
				return "Right Alt";
		}
		*/
		return "";
	}

	
	@Override
	KeyboardKey getKeyboardKey() {
		return this;
	}


	@Override
	public boolean isEqualTo( Pushable pushable ) {
		KeyboardKey key = pushable.getKeyboardKey();
		if( key != null ) return code == key.code;
		return false;
	}
	

	@Override
	public void processKeyboardEvent() {
		Sys.processKeyboardKeyEvent( this );
	}
	

	/**
	 * Creates keyboard key object.
	 * @return New object of keyboard key with given code.
	 */	
	public static KeyboardKey create( int code, Modifiers modifier ) {
		KeyboardKey key = new KeyboardKey();
		key.code = code;
		
		for( ButtonAction action: Project.controllers ) {
			for( Pushable pushable: action.buttonList ) {
				if( pushable.isEqualTo( key ) ) return key;
			}
		}

		return key;
	}

	public static KeyboardKey create( int code ) {
		return create( code, Modifiers.NO );
	}
	

	@Override
	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		code = xMLObject.manageIntAttribute( "code", code );
	}
}
