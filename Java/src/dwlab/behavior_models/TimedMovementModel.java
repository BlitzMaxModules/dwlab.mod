package dwlab.behavior_models;
import dwlab.shapes.Shape;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php


public class TimedMovementModel extends TemporaryModel {
	public double initialX, double initialY;
	public double destinationX, double destinationY;



	public static TimedMovementModel create( double time, double destinationX, double destinationY ) {
		TimedMovementModel model = new TimedMovementModel();
		model.period = time;
		model.destinationX = destinationX;
		model.destinationY = destinationY;
		return model;
	}



	public void init( Shape shape ) {
		initialX = shape.x;
		initialY = shape.y;
	}



	public void applyTo( Shape shape ) {
		double k = ( currentProject.time - startingTime ) / period;
		shape.setCoords( initialX + k * ( destinationX - initialX ), initialY + k * ( destinationY - initialY ) );
		super.applyTo( shape );
	}
}
