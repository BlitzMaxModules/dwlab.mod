package dwlab.behavior_models;
import dwlab.shapes.Shape;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php\r\n */


public class ResizingModel extends ValueChangingModel {
	public static ResizingModel create( double time, double destinationSize ) {
		ResizingModel model = new ResizingModel();
		model.period = time;
		model.destinationValue = destinationSize;
		return model;
	}



	public void init( Shape shape ) {
		initialValue = shape.getDiameter();
	}



	public void changeValue( Shape shape, double newValue ) {
		shape.setDiameter( newValue );
	}
}
