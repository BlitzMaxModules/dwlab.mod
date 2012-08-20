package dwlab.controllers;
import dwlab.base.XMLObject;
import java.lang.Math;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php


/**
 * Class for mouse wheel rollings.
 */
public class MouseWheelAction extends Pushable {
	public int z;
	public int direction;



	public String getName() {
		switch( direction ) {
			case -1:
				return "Mouse wheel down";
			case 1:
				return "Mouse wheel up";
		}
	}



	public int isEqualTo( Pushable pushable ) {
		MouseWheelAction wheel = MouseWheelAction( pushable );
		if( wheel ) return direction == wheel.direction;
	}



	public void processEvent() {
		if( eventID() == event_MouseWheel ) {
			if( direction * ( mouseZ() - z ) > 0 ) {
				state = justPressed;
				z = mouseZ();
			}
		}
	}



	/**
	 * Creates mouse wheel roll action object.
	 * @return New object of mouse wheel roll action of given direction.
	 */	
	public static MouseWheelAction create( int direction ) {
		if( Math.abs( direction ) != 1 ) error( "Invalid mouse wheel direction" );

		for( MouseWheelAction wheelAction: controllers ) {
			if( wheelAction.direction == direction ) return wheelAction;
		}

		MouseWheelAction wheelAction = new MouseWheelAction();
		wheelAction.direction = direction;
		controllers.addLast( wheelAction );
		return wheelAction;
	}



	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		xMLObject.manageIntAttribute( "direction", direction );
		if( DWLabSystem.xMLMode == XMLMode.GET ) controllers.addLast( this );
	}
}
