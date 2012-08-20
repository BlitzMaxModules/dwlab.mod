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
 * Revolute joint moves angular sprite if parent pivot moves or rotates, but the sprite can be rotated freely.
 * @see #lTFixedJoint
 */
public class RevoluteJoint extends BehaviorModel {
	public Sprite parentPivot;
	public double angle;
	public double distance;
	public double dX, double dY;



	/**
	 * Creates revolute joint for specified parent pivot using current pivots position.
	 * @return 
	 * 
	 */
	public static RevoluteJoint create( Sprite parentPivot, double dX = 0, double dY = 0 ) {
		RevoluteJoint joint = new RevoluteJoint();
		joint.parentPivot = parentPivot;
		joint.dX = dX;
		joint.dY = dY;
		return joint;
	}



	public void init( Shape shape ) {
		Sprite sprite = Sprite( shape );
		double angle2 = Math.atan2( dY, dX );
		double distance2 = distance( dX * sprite.width, dY * sprite.height );
		double x = sprite.x + Math.cos( angle2 + sprite.angle ) * distance2;
		double y = sprite.y + Math.sin( angle2 + sprite.angle ) * distance2;
		angle = parentPivot.directionToPoint( x, y ) - parentPivot.angle;
		distance = parentPivot.distanceToPoint( x, y );
	}



	public void applyTo( Shape shape ) {
		Sprite sprite = Sprite( shape );
		double angle2 = Math.atan2( dY, dX );
		double distance2 = distance( dX * sprite.width, dY * sprite.height );
		double dDX = Math.cos( angle2 + sprite.angle ) * distance2;
		double dDY = Math.sin( angle2 + sprite.angle ) * distance2;
		sprite.setCoords( parentPivot.x + Math.cos( angle + parentPivot.angle ) * distance - dDX, parentPivot.y + Math.sin( angle + parentPivot.angle ) * distance - dDY );
	}
}
