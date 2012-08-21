package dwlab.behavior_models;
import dwlab.shapes.Shape;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */


public class ResizingModel extends ValueChangingModel {
	public ResizingModel( double time, double destinationSize ) {
		this.period = time;
		this.destinationValue = destinationSize;
	}


	@Override
	public void init( Shape shape ) {
		initialValue = shape.getDiameter();
	}


	@Override
	public void changeValue( Shape shape, double newValue ) {
		shape.setDiameter( newValue );
	}
}
