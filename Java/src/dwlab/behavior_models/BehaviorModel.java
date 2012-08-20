/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.behavior_models;

import dwlab.base.Obj;
import dwlab.shapes.Shape;
import java.util.ListIterator;

/**
 * Behavior model is the object which can be attached to the shape and affect its state.
 */
public class BehaviorModel extends Obj {
	public boolean active;
	public ListIterator<BehaviorModel> iterator;


	/**
	 * Initialization method.
	 * It will be executed when model will be attached to shape.
	 * Fill it with model initialization commands. 
	 */
	public void init( Shape shape ) {
	}


	/**
	 * Activation method.
	 * It will be executed when model will be activated (and when attached too if you didn't set activation flag to False).
	 * 
	 * @see #deactivate, #activateAllModels, #deactivateAllModels, #activateModel, #deactivateModel
	 */
	public void activate( Shape shape ) {
	}


	/**
	 * Deactivation method.
	 * It will be executed when model will be activated (and when removed too if it was active).
	 * 
	 * @see #activate, #activateAllModels, #deactivateAllModels, #activateModel, #deactivateModel
	 */
	public void deactivate( Shape shape ) {
	}


	/**
	 * Watching method.
	 * This method will be executed by shape default Act() method if the model will be inactive.
	 * Fill it with commands which will check certain conditions and activate model.
	 * 
	 * @see #applyTo, #act
	 */
	public void watch( Shape shape ) {
	}


	/**
	 * Model applying method.
	 * This method will be executed by shape default Act() method if the model will be active.
	 * Fill it with commands which are affect shape in the way of corresponding behavior.
	 * 
	 * @see #watch, #act
	 */
	public void applyTo( Shape shape ) {
	}


	/**
	 * Activates behavior model.
	 * For use inside model's methods.
	 * 
	 * @see #activate, #deactivate, #activateAllModels, #deactivateAllModels, #deactivateModel
	 */
	public final void activateModel( Shape shape ) {
		if( ! active ) {
			activate( shape );
			active = true;
		}
	}


	/**
	 * Deactivates behavior model.
	 * For use inside model's methods.
	 * 
	 * @see #activate, #deactivate, #activateAllModels, #deactivateAllModels, #activateModel
	 */
	public final void deactivateModel( Shape shape ) {
		if( active ) {
			deactivate( shape );
			active = false;
		}
	}


	/**
	 * Removes behavior model.
	 * Model will be deactivated before removal.
	 * 
	 * @see #deactivate
	 */
	public final void remove( Shape shape ) {
		if( active ) deactivateModel( shape );
		if( iterator != null ) iterator.remove();
	}


	/**
	 * Removes every other behavior model of same type from shape's behavior models.
	 * @see #remove
	 */
	public final void removeSame( Shape shape ) {
		Class modelClass = this.getClass();
		for( BehaviorModel model: shape.behaviorModels ) {
			if( model.getClass() == modelClass && model != this ) model.remove( shape );
		}
	}


	public String info( Shape shape ) {
		return "";
	}
}
