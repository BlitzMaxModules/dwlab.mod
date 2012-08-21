/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.behavior_models;

import dwlab.shapes.Shape;
import java.util.LinkedList;

/**
 * Model stack consists of several models and executes first active model in list.
 * Usually it is used for animation stack for shape because only one animation can be played for shape at every moment.
 * This way you can set the priorities of animations. Use Add() method to add models to the stack.

 * @see #lTAnimationModel, #lTBehaviorModel example.
 */
public class ModelStack extends BehaviorModel {
	public LinkedList<BehaviorModel> models = new LinkedList<BehaviorModel>();


	@Override
	public void applyTo( Shape shape ) {
		for( BehaviorModel model: models ) {
			if( model.active ) {
				model.applyTo( shape );
				break;
			}
		}
	}


	public void add( BehaviorModel model, boolean activate ) {
		model.init( null );
		models.addLast( model );
		model.iterator = models.listIterator();
		model.iterator.previous();
		if( activate ) {
			model.activate( null );
			model.active = true;
		}
	}


	@Override
	public String info( Shape shape ) {
		int n = 1;
		for( BehaviorModel model: models ) {
			if( model.active ) return "" + n + "th of " + models.size() + " models is active" + model.info( shape );
			n += 1;
		}
		return "no active models of " + models.size();
	}
}
