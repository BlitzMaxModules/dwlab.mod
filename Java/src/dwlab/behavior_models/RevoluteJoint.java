/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.behavior_models;

import dwlab.base.Service;
import dwlab.shapes.Shape;
import dwlab.shapes.sprites.Sprite;

/**
 * Revolute joint moves angular sprite if parent pivot moves or rotates, but the sprite can be rotated freely.
 * @see #lTFixedJoint
 */
public class RevoluteJoint extends BehaviorModel {
	public Sprite parentPivot;
	public double angle;
	public double distance;
	public double dX, dY;


	/**
	 * Creates revolute joint for specified parent pivot using current pivots position.
	 * @return 
	 * 
	 */
	public RevoluteJoint( Sprite parentPivot, double dX, double dY ) {
		this.parentPivot = parentPivot;
		this.dX = dX;
		this.dY = dY;
	}


	@Override
	public void init( Shape shape ) {
		Sprite sprite = (Sprite) shape;
		double angle2 = Math.atan2( dY, dX );
		double distance2 = Service.distance( dX * sprite.getWidth(), dY * sprite.getHeight() );
		double x = sprite.getX() + Math.cos( angle2 + sprite.angle ) * distance2;
		double y = sprite.getY() + Math.sin( angle2 + sprite.angle ) * distance2;
		angle = parentPivot.directionToPoint( x, y ) - parentPivot.angle;
		distance = parentPivot.distanceToPoint( x, y );
	}


	@Override
	public void applyTo( Shape shape ) {
		Sprite sprite = (Sprite) shape;
		double angle2 = Math.atan2( dY, dX );
		double distance2 = Service.distance( dX * sprite.getWidth(), dY * sprite.getHeight() );
		double dDX = Math.cos( angle2 + sprite.angle ) * distance2;
		double dDY = Math.sin( angle2 + sprite.angle ) * distance2;
		sprite.setCoords( parentPivot.getX() + Math.cos( angle + parentPivot.angle ) * distance - dDX,
				parentPivot.getY() + Math.sin( angle + parentPivot.angle ) * distance - dDY );
	}
}
