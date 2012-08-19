package dwlab.gui;
import dwlab.controllers.ButtonAction;

//
// Digital Wizard's Lab - game development framework
// Copyright (C) 2012, Matt Merkulov
//
// All rights reserved. Use of this code is allowed under the
// Artistic License 2.0 terms, as specified in the license.txt
// file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php
//

/**
 * Class for button gadgets.
 * Checkbox is the button which state changes anoter way: when user clicks checkbox first time, its state will be set to True.
 * When user clicks checkbox second time, state returns to False and so on.
 */
public class CheckBox extends Button {
	public void onMouseOut() {
		focus = false;
	}



	public void onButtonPress( ButtonAction buttonAction ) {
		state = ! state;
	}



	public void onButtonDown( ButtonAction buttonAction ) {
	}



	public void onButtonUp( ButtonAction buttonAction ) {
	}
}
