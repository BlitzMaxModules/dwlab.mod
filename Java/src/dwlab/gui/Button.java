package dwlab.gui;
import dwlab.controllers.ButtonAction;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php




/**
 * Class for button gadgets.
 * If button visualizer's image have more than 1 frames, they will be used following way:
 * <ul><li>2 frames: first frame will be used for normal button, second - for pressed button.
 * <li>4 or more frames: same as above, but 3rd frame will be used for normal button with focus.
 * and 4th - for pressed button with focus</ul>
 */
public class Button extends Label {
	/**
	 * State of button
	 * State is changed to True when users press left mouse button on the button.
	 */
	public int state;

	/**
	 * Focus of button
	 * Focus is changed to True when mouse cursor is over the button.
	 */
	public int focus;

	public double pressingDX, double pressingDY;



	public void init() {
		super.init();

		if( parameterExists( "pressing_shift" ) ) {
			pressingDX = getParameter( "pressing_shift" ).toDouble();
			pressingDY = pressingDX;
		}

		pressingDX = getParameter( "pressing_dx" ).toDouble();
		pressingDY = getParameter( "pressing_dy" ).toDouble();
	}



	public void draw() {
		if( ! visible ) return;
		setFrame( this );
		//If Icon Then SetFrame( Icon.Visualizer )
		super.draw();
	}

	public void setFrame( Sprite sprite ) {
		if( ! sprite.visualizer.image ) return;
		int quantity = sprite.visualizer.image.framesQuantity();
		if( quantity == 2 ) {
			sprite.frame = state;
		} else if( quantity >= 4 then ) {
			sprite.frame = int( frame / 4 ) * 4 + state + focus * 2;
		}
	}



	public double getDX() {
		return state * pressingDX;
	}

	public double getDY() {
		return state * pressingDY;
	}



	public String getClassTitle() {
		return "Button";
	}



	public void onMouseOver() {
		focus = true;
	}



	public void onMouseOut() {
		focus = false;
		state = false;
	}



	public void onButtonDown( ButtonAction buttonAction ) {
		if( buttonAction = leftMouseButton ) state == true;
	}



	public void onButtonUp( ButtonAction buttonAction ) {
		if( buttonAction = leftMouseButton ) state == false;
	}
}
