/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.gui;

import dwlab.controllers.ButtonAction;
import dwlab.sprites.Sprite;

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
	public boolean state;

	/**
	 * Focus of button
	 * Focus is changed to True when mouse cursor is over the button.
	 */
	public boolean focus;

	public double pressingDX, pressingDY;


	@Override
	public void init() {
		super.init();

		if( parameterExists( "pressing_shift" ) ) {
			pressingDX = getDoubleParameter( "pressing_shift" );
			pressingDY = pressingDX;
		}

		pressingDX = getDoubleParameter( "pressing_dx" );
		pressingDY = getDoubleParameter( "pressing_dy" );
	}


	@Override
	public void draw() {
		if( ! visible ) return;
		setFrame( this );
		//If Icon Then SetFrame( Icon.Visualizer )
		super.draw();
	}
	

	public void setFrame( Sprite sprite ) {
		if( sprite.visualizer.image == null ) return;
		int quantity = sprite.visualizer.image.framesQuantity();
		if( quantity == 2 ) {
			sprite.frame = state ? 0 : 1;
		} else if( quantity >= 4 ) {
			sprite.frame = (int) Math.floor( frame / 4 ) * 4 + ( state ? 0 : 1 ) + ( focus ? 0 : 2 );
		}
	}


	@Override
	public double getDX() {
		return state ? 0 : pressingDX;
	}

	@Override
	public double getDY() {
		return state ? 0 : pressingDY;
	}


	@Override
	public String getClassTitle() {
		return "Button";
	}


	@Override
	public void onMouseOver() {
		focus = true;
	}


	@Override
	public void onMouseOut() {
		focus = false;
		state = false;
	}


	@Override
	public void onButtonDown( ButtonAction buttonAction ) {
		if( buttonAction == Window.select ) state = true;
	}


	@Override
	public void onButtonUp( ButtonAction buttonAction ) {
		if( buttonAction == Window.select ) state = false;
	}
}
