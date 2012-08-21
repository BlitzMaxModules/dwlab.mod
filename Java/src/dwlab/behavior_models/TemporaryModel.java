/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.behavior_models;

import dwlab.base.Project;
import dwlab.base.Service;
import dwlab.shapes.Shape;

public class TemporaryModel extends ChainedModel {
	public double startingTime;
	public double period;


	@Override
	public void activate( Shape shape ) {
		startingTime = Project.current.time;
	}


	@Override
	public void applyTo( Shape shape ) {
		if( Project.current.time > startingTime + period ) remove( shape );
	}


	@Override
	public String info( Shape shape ) {
		return "" + Service.trim( Project.current.time - startingTime ) + " of " + Service.trim( period );
	}
}
