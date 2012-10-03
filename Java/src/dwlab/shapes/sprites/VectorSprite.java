/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.shapes.sprites;
import dwlab.base.Project;
import dwlab.base.Service;
import dwlab.shapes.Shape;

/**
 * Vector sprite has horizontal and vertical velocities forming velocity vector.
 * Handy for projects with gravity, platformers for example.

 * @see #lTSprite
 */
public class VectorSprite extends Sprite {
	/**
	 * Horizontal velocity of the sprite.
	 */
	public double dX;

	/**
	 * Vertical velocity of the sprite.
	 */
	public double dY;


	public VectorSprite() {
	}
	
	public VectorSprite( ShapeType shapeType, double x, double y, double width, double height, double dX, double dY ) {
		this.setCoords( x, y );
		this.setSize( width, height );
		this.shapeType = shapeType;
		this.dX = dY;
		this.dX = dY;
	}


	@Override
	public String getClassTitle() {
		return "Vector sprite";
	}
	
	
	@Override
	public VectorSprite toVectorSprite() {
		return this;
	}


	@Override
	public void init() {
		updateFromAngularModel();
	}

	// ==================== Limiting ====================

	@Override
	public Sprite bounceInside( Sprite sprite, boolean leftSide, boolean topSide, boolean rightSide, boolean bottomSide, SpriteCollisionHandler handler ) {
		if( leftSide ) {
			if( leftX() < sprite.leftX() ) {
				x = sprite.leftX() + 0.5 * width;
				dX = Math.abs( dX );
				if( handler != null ) handler.handleCollision( this, sprite );
			}
		}
		if( topSide ) {
			if( topY() < sprite.topY() ) {
				y = sprite.topY() + 0.5 * height;
				dY = Math.abs( dY );
				if( handler != null ) handler.handleCollision( this, sprite );
			}
		}
		if( rightSide ) {
			if( rightX() > sprite.rightX() ) {
				x = sprite.rightX() - 0.5 * width;
				dX = -Math.abs( dX );
				if( handler != null ) handler.handleCollision( this, sprite );
			}
		}
		if( bottomSide ) {
			if( bottomY() > sprite.bottomY() ) {
				y = sprite.bottomY() - 0.5 * height;
				dY = -Math.abs( dY );
				if( handler != null ) handler.handleCollision( this, sprite );
			}
		}
		return this;
	}


	@Override
	public void updateFromAngularModel() {
		dX = Math.cos( angle ) * velocity;
		dY = Math.sin( angle ) * velocity;
	}


	public void updateAngularModel() {
		angle = Math.atan2( dY, dX );
		velocity = Service.distance( dX, dY );
	}


	@Override
	public Sprite moveForward() {
		setCoords( x + dX * Project.deltaTime, y + dY * Project.deltaTime );
		return this;
	}


	@Override
	public Sprite directTo( Shape shape ) {
		double vectorLength = Service.distance( dX, dY );
		dX = shape.getX() - x;
		dY = shape.getY() - y;
		if( vectorLength > 0 ) {
			double newVectorLength = Service.distance( dX, dY );
			if( newVectorLength > 0 ) {
				dX *= vectorLength / newVectorLength;
				dY *= vectorLength / newVectorLength;
			}
		}
		return this;
	}


	@Override
	public Sprite reverseDirection() {
		dX = -dX;
		dY = -dY;
		return this;
	}


	@Override
	public Shape clone() {
		VectorSprite newSprite = new VectorSprite();
		copySpriteTo( newSprite );
		return newSprite;
	}
}