package dwlab.behavior_models;
import java.util.LinkedList;
import dwlab.shapes.Shape;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php





public class ConditionalModel extends BehaviorModel {
	public LinkedList trueModels = new LinkedList();
	public LinkedList falseModels = new LinkedList();



	public int condition( Shape shape ) {
	}



	public void applyTo( Shape shape ) {
		remove( shape );
		if( condition( shape ) ) {
			shape.attachModels( trueModels );
		} else {
			shape.attachModels( falseModels );
		}
	}
}
