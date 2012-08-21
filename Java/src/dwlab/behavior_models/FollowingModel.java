/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.behavior_models;

import dwlab.shapes.Shape;
import dwlab.sprites.Sprite;

public class FollowingModel extends ChainedModel {
	public Shape destinationShape;
	public boolean removeWhenStop;


	public FollowingModel( Shape destinationShape, boolean removeWhenStop ) {
		this.destinationShape = destinationShape;
		this.removeWhenStop = removeWhenStop;
	}


	@Override
	public void applyTo( Shape shape ) {
		( (Sprite) shape ).moveTowards( destinationShape, ( (Sprite) shape ).velocity );
		if( removeWhenStop ) if ( shape.isAtPositionOf( destinationShape ) ) remove( shape );
	}
}
