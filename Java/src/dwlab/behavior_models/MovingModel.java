/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.behavior_models;

import dwlab.shapes.Shape;
import dwlab.shapes.sprites.Sprite;

public class MovingModel extends ChainedModel {
	public double x, y;


	public MovingModel( double x, double y ) {
		this.x = x;
		this.y = y;
	}


	@Override
	public void applyTo( Shape shape ) {
		( (Sprite) shape ).moveTowardsPoint( x, y, ( (Sprite) shape ).velocity );
		if( shape.isAtPositionOfPoint( x, y ) ) remove( shape );
	}
}
