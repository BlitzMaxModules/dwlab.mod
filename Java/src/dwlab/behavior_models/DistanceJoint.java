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
import dwlab.sprites.VectorSprite;

/**
 * Distance joint keeps fixed distance between parent pivot and given shape.
 */
public class DistanceJoint extends BehaviorModel {
	public Sprite parentPivot;
	public double distance;
	public boolean fixedAngle = true;


	/**
	 * Creates distance joint for specified parent pivot using current pivots position.
	 * @return 
	 * 
	 */
	public DistanceJoint( Sprite parentPivot, boolean fixedAngle ) {
		this.parentPivot = parentPivot;
		this.fixedAngle = fixedAngle;
	}


	@Override
	public void init( Shape shape ) {
		distance = parentPivot.distanceTo( shape );
	}


	@Override
	public void applyTo( Shape shape ) {
		double newDistance = parentPivot.distanceTo( shape );
		if( newDistance == 0 ) {
			shape.setCoords( parentPivot.getX() + distance, parentPivot.getY() );
		} else {
			double k = distance / newDistance;
			VectorSprite vectorSprite = (VectorSprite) shape;
			if( vectorSprite != null ) {
				double dDistance = newDistance - distance;
				vectorSprite.dX += ( parentPivot.getX() - shape.getX() ) * dDistance;
				vectorSprite.dY += ( parentPivot.getY() - shape.getY() ) * dDistance;
				if( fixedAngle ) vectorSprite.updateAngularModel();
			}
			shape.setCoords( parentPivot.getX() + ( shape.getX() - parentPivot.getX() ) * k, parentPivot.getY() + ( shape.getY() - parentPivot.getY() ) * k );
		}
	}
}
