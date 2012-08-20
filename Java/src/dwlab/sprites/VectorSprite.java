package dwlab.sprites;
import java.lang.Math;
import dwlab.shapes.Shape;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php




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



	public static VectorSprite fromShapeAndVector( double x, double y, double width = 1.0, double height = 1.0, int shapeType = Sprite.rectangle, double dX = 0.0, double dY = 0.0 ) {
		VectorSprite sprite = new VectorSprite();
		sprite.setCoords( x, y );
		sprite.setSize( width, height );
		sprite.shapeType = shapeType;
		sprite.dX = dY;
		sprite.dX = dY;
		return sprite;
	}



	public String getClassTitle() {
		return "Vector sprite";
	}



	public void init()	 {
		updateFromAngularModel();
	}

	// ==================== Limiting ====================

	public void bounceInside( Shape shape, int leftSide = true, int topSide = true, int rightSide = true, int bottomSide = true ) {
		if( leftSide ) {
			if( leftX() < shape.leftX() ) {
				x = shape.leftX() + 0.5 * width;
				dX = Math.abs( dX );
			}
		}
		if( topSide ) {
			if( topY() < shape.topY() ) {
				y = shape.topY() + 0.5 * height;
				dY = Math.abs( dY );
			}
		}
		if( rightSide ) {
			if( rightX() > shape.rightX() ) {
				x = shape.rightX() - 0.5 * width;
				dX = -Math.abs( dX );
			}
		}
		if( bottomSide ) {
			if( bottomY() > shape.bottomY() ) {
				y = shape.bottomY() - 0.5 * height;
				dY = -Math.abs( dY );
			}
		}
	}



	public void updateFromAngularModel() {
		dX = Math.cos( angle ) * velocity;
		dY = Math.sin( angle ) * velocity;
	}



	public void updateAngularModel() {
		angle = Math.atan2( dY, dX );
		velocity = distance( dX, dY );
	}



	public void moveForward() {
		setCoords( x + dX * deltaTime, y + dY * deltaTime );
	}



	public void directTo( Shape shape ) {
		double vectorLength = distance( dX, dY );
		dX = shape.x - x;
		dY = shape.y - y;
		if( vectorLength ) {
			double newVectorLength = distance( dX, dY );
			if( newVectorLength ) {
				dX *= vectorLength / newVectorLength;
				dY *= vectorLength / newVectorLength;
			}
		}
	}



	public void reverseDirection() {
		dX = -dX;
		dY = -dY;
	}



	public Shape clone() {
		VectorSprite newSprite = new VectorSprite();
		copySpriteTo( newSprite );
		return newSprite;
	}
}
