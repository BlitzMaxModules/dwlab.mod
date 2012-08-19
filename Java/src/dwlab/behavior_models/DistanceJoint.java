package dwlab.behavior_models;
import dwlab.shapes.Shape;
import dwlab.sprites.Sprite;
import dwlab.sprites.VectorSprite;

//
// Digital Wizard's Lab - game development framework
// Copyright (C) 2012, Matt Merkulov
//
// All rights reserved. Use of this code is allowed under the
// Artistic License 2.0 terms, as specified in the license.txt
// file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php
//

/**
 * Distance joint keeps fixed distance between parent pivot and given shape.
 */
public class DistanceJoint extends BehaviorModel {
	public Sprite parentPivot;
	public double distance;
	public int fixedAngle = true;



	/**
	 * Creates distance joint for specified parent pivot using current pivots position.
	 * @return 
	 * 
	 */
	public static DistanceJoint create( Sprite parentPivot, int fixedAngle = true ) {
		DistanceJoint joint = new DistanceJoint();
		joint.parentPivot = parentPivot;
		joint.fixedAngle = fixedAngle;
		return joint;
	}



	public void init( Shape shape ) {
		distance = parentPivot.distanceTo( shape );
	}



	public void applyTo( Shape shape ) {
		double newDistance = parentPivot.distanceTo( shape );
		if( newDistance == 0 ) {
			shape.setCoords( parentPivot.x + distance, parentPivot.y );
		} else {
			double k = distance / newDistance;
			VectorSprite vectorSprite = VectorSprite( shape );
			if( vectorSprite ) {
				double dDistance = newDistance - distance;
				vectorSprite.dX += ( parentPivot.x - shape.x ) * dDistance;
				vectorSprite.dY += ( parentPivot.y - shape.y ) * dDistance;
				if( fixedAngle ) vectorSprite.updateAngularModel();
			}
			shape.setCoords( parentPivot.x + ( shape.x - parentPivot.x ) * k, parentPivot.y + ( shape.y - parentPivot.y ) * k );
		}
	}
}
