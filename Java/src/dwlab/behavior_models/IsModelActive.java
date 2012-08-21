/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.behavior_models;

import dwlab.shapes.Shape;

/**
 * This model checks if model active and attaches corresponding lists of models to the shape.
 * If model is active, models from TrueModels list will be attached to the shape, otherwise models from FalseModels list will be attached.
 * This conditional model will be removed from shape instantly after doing its job.

 * @see #lTBehaviorModel example.
 */
public class IsModelActive extends ConditionalModel {
	public BehaviorModel model;


	public IsModelActive( BehaviorModel model ) {
		this.model = model;
	}


	@Override
	public boolean condition( Shape shape ) {
		if( model != null ) return model.active; else return false;
	}
}
