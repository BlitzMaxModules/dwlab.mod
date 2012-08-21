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
 * This model deactivates another model.
 * If you will set Permanent parameter to True, deactivator will not be instantly removed after doing its job.

 * @see #lTModelActivator, #lTBehaviorModel example.
 */
public class ModelDeactivator extends BehaviorModel {
	public BehaviorModel model;
	public boolean permanent;


	public ModelDeactivator( BehaviorModel model, boolean permanent ) {
		this.model = model;
		this.permanent = permanent;
	}


	@Override
	public void applyTo( Shape shape ) {
		model.deactivateModel( shape );
		if( !permanent ) remove( shape );
	}


	@Override
	public String info( Shape shape ) {
		if( model !=null ) return "deactivate " + model.getClass().getName(); else return "";
	}
}
