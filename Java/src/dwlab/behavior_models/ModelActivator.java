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
 * This model activates another model.
 * If you will set Permanent parameter to True, activator will not be instantly removed after doing its job.

 * @see #lTModelDeactivator, #lTBehaviorModel example.
 */
public class ModelActivator extends BehaviorModel {
	public BehaviorModel model;
	public boolean permanent;


	public ModelActivator( BehaviorModel model, boolean permanent ) {
		this.model = model;
		this.permanent = permanent;
	}


	public ModelActivator( BehaviorModel model ) {
		this.model = model;
		this.permanent = false;
	}


	@Override
	public void applyTo( Shape shape ) {
		model.activateModel( shape );
		if( !permanent ) remove( shape );
	}


	@Override
	public String info( Shape shape ) {
		if( model !=null ) return "activate " + model.getClass().getName(); else return "";
	}
}
