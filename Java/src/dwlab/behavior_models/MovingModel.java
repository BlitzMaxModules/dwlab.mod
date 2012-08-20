package dwlab.behavior_models;
import dwlab.shapes.Shape;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php\r\n */


public class MovingModel extends ChainedModel {
	public double x, double y;



	public static MovingModel create( double x, double y ) {
		MovingModel model = new MovingModel();
		model.x = x;
		model.y = y;
		return model;
	}



	public void applyTo( Shape shape ) {
		Sprite( shape ).moveTowardsPoint( x, y, Sprite( shape ).velocity );
		if( shape.isAtPositionOfPoint( x, y ) ) remove( shape );
	}
}
