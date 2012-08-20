package dwlab.behavior_models;
import java.lang.Math;
import dwlab.shapes.Shape;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php


/**
 * Fixed joint moves and rotates angular sprite as parent angular sprite moves or rotates.
 * @see #lTRevoluteJoint
 */
public class FixedJoint extends BehaviorModel {
	public Sprite parentPivot;
	public double angle;
	public double distance;
	public double dAngle;



	/**
	 * Creates fixed joint for specified parent pivot using current pivots position.
	 * @return New fixed joint
	 */
	public static FixedJoint create( Sprite parentPivot ) {
		FixedJoint joint = new FixedJoint();
		joint.parentPivot = parentPivot;
		return joint;
	}



	public void init( Shape shape ) {
		Sprite sprite = Sprite( shape );
		angle = parentPivot.directionTo( sprite ) - parentPivot.angle;
		distance = parentPivot.distanceTo( sprite );
		dAngle = sprite.angle - parentPivot.angle;
	}



	public void applyTo( Shape shape ) {
		Sprite sprite = Sprite( shape );
		sprite.setCoords( parentPivot.x + Math.cos( angle + parentPivot.angle ) * distance, parentPivot.y + Math.sin( angle + parentPivot.angle ) * distance );
		sprite.angle = parentPivot.angle + dAngle;
	}
}
