package dwlab.behavior_models;
import dwlab.shapes.Shape;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php


public class ColorChangingModel extends TemporaryModel {
	public double initialRed, double initialGreen, double initialBlue;
	public double destinationRed, double destinationGreen, double destinationBlue;



	public static ColorChangingModel create( double time, double destinationRed, double destinationGreen, double destinationBlue ) {
		ColorChangingModel model = new ColorChangingModel();
		model.period = time;
		model.destinationRed = destinationRed;
		model.destinationGreen = destinationGreen;
		model.destinationBlue = destinationBlue;
		return model;
	}



	public void init( Shape shape ) {
		initialRed = shape.visualizer.red;
		initialBlue = shape.visualizer.blue;
		initialGreen = shape.visualizer.green;
	}



	public void applyTo( Shape shape ) {
		double k = ( currentProject.time - startingTime ) / period;
		shape.visualizer.red = initialRed + k * ( destinationRed - initialRed );
		shape.visualizer.green = initialGreen + k * ( destinationGreen - initialGreen );
		shape.visualizer.blue = initialBlue + k * ( destinationBlue - initialBlue );
		super.applyTo( shape );
	}
}
