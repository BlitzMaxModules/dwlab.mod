package dwlab.gui;
import dwlab.controllers.ButtonAction;
import dwlab.base.Align;
import dwlab.visualizers.Visualizer;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

/**
 * Class for text fields for entering text.
 * If window has text fields, one will be set as active. User can select active text field by clicking on another text field.
 */
public class TextField extends Gadget {
	public String text;
	public String leftPart;
	public String rightPart;
	public int maxSymbols = 0;


	@Override
	public void init() {
		super.init();
		Window.activeTextField = this;
		maxSymbols = getIntegerParameter( "max" );
	}


	@Override
	public void draw() {
		if( ! visible ) return;
		super.draw();
		if( Window.activeTextField == this ) {
			printText( " " + leftPart + "_" + rightPart, textSize, visualizer, Align.TO_LEFT, Align.TO_CENTER );
		} else {
			printText( " " + text, textSize, visualizer, Align.TO_LEFT, Align.TO_CENTER );
		}
	}


	@Override
	public String getClassTitle() {
		return "Text field";
	}


	@Override
	public void onButtonPress( ButtonAction buttonAction ) {
		if( buttonAction != Window.select ) return;
		Window.activeTextField = this;
		leftPart = text;
		rightPart = "";
	}
}
