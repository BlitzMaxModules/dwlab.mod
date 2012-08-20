package dwlab.behavior_models;
import dwlab.shapes.Shape;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php\r\n */









public class TemporaryModel extends ChainedModel {
	public double startingTime;
	public double period;



	public void activate( Shape shape ) {
		startingTime = currentProject.time;
	}



	public void applyTo( Shape shape ) {
		if( currentProject.time > startingTime + period ) remove( shape );
	}



	public String info( Shape shape ) {
		return "" + trimDouble( currentProject.time - startingTime ) + " of " + trimDouble( period );
	}
}
